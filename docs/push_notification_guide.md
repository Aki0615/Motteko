# プッシュ通知 実装手順書

現在のコードベースの状態を踏まえた、FCM（Firebase Cloud Messaging）リモートプッシュ通知の実装手順です。

---

## 前提：現在の実装状況

| 項目 | 状態 |
|------|------|
| ローカル通知 (`flutter_local_notifications`) | 実装済み |
| Firebase Core / Auth / Firestore | 設定済み |
| Firestore `users` コレクションの `fcm_token` フィールド | 定義済み（空文字） |
| FCM (`firebase_messaging`) | **未実装** ← 今回やること |

---

## Step 1: パッケージの追加

### 1-1. `pubspec.yaml` に追加

```yaml
dependencies:
  # ... 既存のパッケージ ...
  firebase_auth: ^5.7.0
  firebase_messaging: ^15.2.4  # ← これを追加
```

### 1-2. インストール

```bash
flutter pub get
```

---

## Step 2: iOS 側の設定

### 2-1. Xcode でプッシュ通知を有効化

1. `ios/Runner.xcworkspace` を Xcode で開く
2. Runner ターゲット → **Signing & Capabilities** タブ
3. **+ Capability** → **Push Notifications** を追加
4. **+ Capability** → **Background Modes** を追加し、以下にチェック:
   - [x] **Background fetch**
   - [x] **Remote notifications**

### 2-2. APNs Key の設定（Firebase Console）

1. [Apple Developer](https://developer.apple.com) → **Certificates, Identifiers & Profiles** → **Keys**
2. APNs 用の Key を作成（.p8 ファイルをダウンロード）
3. [Firebase Console](https://console.firebase.google.com) → **プロジェクト設定** → **Cloud Messaging** タブ
4. **Apple app configuration** に APNs Key (.p8)、Key ID、Team ID を登録

### 2-3. Pod の更新

```bash
cd ios && pod install && cd ..
```

---

## Step 3: バックグラウンドハンドラの作成

### 3-1. `notification_service.dart` にトップレベル関数を追加

FCM のバックグラウンドハンドラは**トップレベル関数**（クラスの外）である必要があります。
`notification_service.dart` のファイル先頭（class の外）に追加してください。

```dart
// ファイル先頭に import を追加
import 'package:firebase_messaging/firebase_messaging.dart';

// class NotificationService の「外側」に定義する
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('バックグラウンド通知受信: ${message.messageId}');
  // 必要に応じてローカル通知を表示する処理をここに書く
}
```

> **なぜトップレベル？**
> バックグラウンドでは別の Isolate で実行されるため、クラスのインスタンスメソッドは使えません。

---

## Step 4: `main.dart` に FCM 初期化を追加

### 4-1. import の追加

```dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'services/notification_service.dart'; // 既にある
```

### 4-2. `main()` 関数の更新

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ★ バックグラウンドハンドラの登録（Firebase.initializeApp の直後）
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // 通知サービスの初期化と権限リクエスト（既存）
  final notificationService = NotificationService();
  await notificationService.initialize();
  await notificationService.requestPermissions();

  // 監視サービスの開始（既存）
  final detectionService = DetectionService();
  detectionService.startListening();

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const MyApp(),
    ),
  );
}
```

---

## Step 5: NotificationService に FCM 機能を追加

`notification_service.dart` の `NotificationService` クラスに以下を追加します。

### 5-1. フィールドの追加

```dart
class NotificationService {
  // ... 既存のフィールド ...

  // ★ 追加
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
```

### 5-2. `initialize()` メソッドの末尾に FCM 初期化を追加

```dart
Future<void> initialize() async {
  if (_isInitialized) return;

  // ... 既存のローカル通知初期化コード ...

  // ★ ここから追加 ===================================

  // FCM 権限リクエスト
  await _firebaseMessaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // iOS フォアグラウンド通知表示設定
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // フォアグラウンド通知受信リスナー
  FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

  // 通知タップでアプリが開かれた時
  FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpen);

  // アプリ終了状態から通知タップで起動した場合
  final initialMessage = await _firebaseMessaging.getInitialMessage();
  if (initialMessage != null) {
    _handleNotificationOpen(initialMessage);
  }

  // FCM トークン取得・保存
  await _saveFCMToken();

  // トークンリフレッシュ時の更新
  _firebaseMessaging.onTokenRefresh.listen(_updateFCMTokenInFirestore);

  // ★ ここまで追加 ===================================

  _isInitialized = true;
}
```

### 5-3. 新しいメソッドを追加

```dart
/// フォアグラウンドで FCM メッセージを受信した時
Future<void> _handleForegroundMessage(RemoteMessage message) async {
  debugPrint('フォアグラウンド通知受信: ${message.notification?.title}');

  final notification = message.notification;
  if (notification == null) return;

  // ローカル通知として表示（既存の showNotification を再利用）
  await showNotification(
    id: message.hashCode,
    title: notification.title ?? '',
    body: notification.body ?? '',
    payload: message.data['route'],  // 通知データに route があれば画面遷移用に渡す
  );
}

/// 通知タップでアプリが開かれた時
void _handleNotificationOpen(RemoteMessage message) {
  debugPrint('通知タップ: ${message.data}');
  final route = message.data['route'] as String?;
  if (route != null) {
    // ★ app_router.dart の import が必要:
    //   import '../core/app_router.dart';
    AppRouter.router.go(route);
  }
}

/// FCM トークンを取得して Firestore に保存
Future<void> _saveFCMToken() async {
  try {
    final token = await _firebaseMessaging.getToken();
    if (token != null) {
      debugPrint('FCM トークン: $token');
      await _updateFCMTokenInFirestore(token);
    }
  } catch (e) {
    debugPrint('FCM トークン取得エラー: $e');
  }
}

/// Firestore の users ドキュメントにトークンを保存
Future<void> _updateFCMTokenInFirestore(String token) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'fcm_token': token});
  } catch (e) {
    debugPrint('FCM トークン保存エラー: $e');
  }
}
```

### 5-4. 通知タップ時の TODO を実装

既存の `onDidReceiveNotificationResponse` コールバック（L45-51）を更新:

```dart
onDidReceiveNotificationResponse:
    (NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  if (payload != null && payload.isNotEmpty) {
    // payload をルートとして画面遷移
    AppRouter.router.go(payload);
  }
},
```

### 5-5. 必要な import を追加

```dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/app_router.dart';
```

---

## Step 6: auth_service.dart で FCM トークンを保存

ログイン時にもトークンを更新するようにします。

### 6-1. `signIn()` メソッドの末尾に追加

```dart
Future<UserCredential> signIn({
  required String email,
  required String password,
}) async {
  try {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // ★ ログイン成功後に FCM トークンを保存
    final notificationService = NotificationService();
    await notificationService.initialize(); // 未初期化の場合に備えて

    return credential;
  } on FirebaseAuthException catch (e) {
    throw Exception(_getErrorMessage(e.code));
  }
}
```

> **補足**: `NotificationService.initialize()` 内で `_saveFCMToken()` を呼んでいるため、
> ログイン後に `initialize()` を呼べばトークンは自動保存されます。
> ただし、初回のみ有効なので、明示的に保存したい場合は `_saveFCMToken()` を public にして直接呼ぶ方法もあります。

---

## Step 7: 動作確認

### 7-1. ビルド確認

```bash
flutter analyze
flutter build ios  # iOS ビルド確認
```

### 7-2. テスト方法

| テスト項目 | やること |
|-----------|---------|
| トークン取得 | アプリ起動後、コンソールに `FCM トークン: ...` が出力されるか確認 |
| Firestore保存 | Firebase Console → Firestore → `users` コレクション → `fcm_token` に値が入っているか確認 |
| フォアグラウンド通知 | Firebase Console → Cloud Messaging → テストメッセージを送信 |
| バックグラウンド通知 | アプリをバックグラウンドにしてテストメッセージを送信 |
| 通知タップ遷移 | テストメッセージの data に `{"route": "/notifications"}` を設定して画面遷移を確認 |

### 7-3. Firebase Console からテスト通知を送る手順

1. Firebase Console → **Cloud Messaging** → **新しいキャンペーン**
2. 通知テキストを入力
3. **テストメッセージを送信** → FCM トークンを貼り付け
4. 送信

---

## 完成後のファイル変更一覧

| ファイル | 変更内容 |
|---------|---------|
| `pubspec.yaml` | `firebase_messaging` パッケージ追加 |
| `lib/services/notification_service.dart` | FCM 初期化、トークン管理、フォアグラウンド/通知タップ処理 |
| `lib/main.dart` | バックグラウンドハンドラ登録 |
| `lib/services/auth_service.dart` | ログイン時の FCM トークン保存（任意） |
| Xcode プロジェクト | Push Notifications + Background Modes capability |

---

## 注意事項

- iOS シミュレーターではプッシュ通知を受信**できません**。実機が必要です
- APNs Key の設定を忘れると iOS でトークンが取得できません
- `@pragma('vm:entry-point')` を忘れるとリリースビルドでバックグラウンドハンドラが動きません
