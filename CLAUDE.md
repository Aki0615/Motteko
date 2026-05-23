# Motteko

IoT忘れ物防止アプリ。ESP32-S3 CAMで玄関の持ち物をAI画像認識し、忘れ物があればスマホに通知する。

## Tech Stack

- **Frontend**: Flutter/Dart (iOS/Android)
- **Backend**: Firebase (Auth, Firestore, Cloud Messaging)
- **IoT**: ESP32-S3 CAM (Wi-Fi切断トリガーで撮影→解析)
- **通知バックエンド**: Python (notification-backend/)

## Project Structure

```
lib/
├── core/           # テーマ(app_theme)、ルーティング(app_router)
├── models/         # ItemModel, NotificationModel, SensorStatus
├── providers/      # AppState (ChangeNotifier + Provider)
├── screens/        # 各画面 (welcome, login_form, sign_in, home, items, camera, calendar, etc.)
├── services/       # AuthService, NotificationService, DetectionService, BleConfigService, ApiService
├── widgets/        # 共通ウィジェット (item_card, streak_celebration, etc.)
└── main.dart       # エントリポイント
```

## Architecture

- **状態管理**: Provider + ChangeNotifier (`AppState`)
- **ルーティング**: GoRouter。ShellRouteでボトムナビゲーション付き画面を管理
- **認証**: Firebase Auth (メール/パスワード)
- **データ**: Firestore (`users`, `detections` コレクション)。ローカルキャッシュは SharedPreferences
- **通知**: FCM (プッシュ通知) + flutter_local_notifications (ローカル通知)
- **BLE**: flutter_blue_plus でESP32デバイスのWi-Fi設定を送信

## Key Patterns

- `NotificationService` はシングルトン
- Firestore購読は `authStateChanges` でガードし、未認証時のpermission-deniedを防止
- `runApp()` は通知初期化の前に呼ぶ（白画面防止）
- バックグラウンドメッセージハンドラはトップレベル関数 (`@pragma('vm:entry-point')`)

## Design System

- **フォント**: Zen Maru Gothic (Google Fonts)
- **カラー**: Primary Orange `#FF7B00`, Dark Text `#373735`, Icon BG `#FFE9C9`, Card BG `#FFF6E8`, Gray `#6B7280`
- **装飾**: 左上にクリーム色の大丸+オレンジ小丸、右下にオレンジ大丸+ダーク小丸（180度回転）
- **ボタン**: ダーク(`#373735`)のピル型、角丸999
- **入力欄**: 背景`#F9FAFB`、ボーダー`#D1D5DB`、角丸10px、高さ35px

## Commands

```bash
flutter run                    # デバッグ実行
flutter run -d <device-id>     # 特定デバイスで実行
flutter analyze                # 静的解析
flutter pub get                # 依存関係取得
flutter clean && flutter pub get  # ビルドキャッシュクリア
```

## Firestore Security Rules

認証済みユーザーのみアクセス可能にする:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Notes

- iOS実機テストにはApple Developer Programが必要
- シミュレーター初回ビルドは `flutter clean` 後に5分程度かかる
- `notification-backend/` にPython製の通知バックエンドがある（venv使用）
