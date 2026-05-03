import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item_model.dart';
import '../models/sensor_status.dart';
import '../models/notification_model.dart';
import 'package:holiday_jp/holiday_jp.dart' as holiday_jp;
import '../services/notification_service.dart';

class AppState extends ChangeNotifier {
  // 持ち物リスト
  List<ItemModel> _items = [];

  // センサー状態
  SensorStatus _sensorStatus = SensorStatus.initial();

  // 通知履歴
  List<NotificationModel> _notifications = [];

  // 連続忘れ物なし日数
  int _consecutiveDaysWithoutForgetting = 0;
  Set<DateTime> _successDates = {};

  // Firestoreのdetectionsコレクションの総件数（ローカル通知の件数ではない）
  int _notificationCount = 0;

  // カメラの状態
  bool _isCameraActive = false;

  // --- Firestore から取得するユーザーデータ ---
  String _userName = '';
  String _currentMode = '';
  List<String> _essentialItemNames = [];

  StreamSubscription<DocumentSnapshot>? _userSubscription;
  StreamSubscription<QuerySnapshot>? _detectionsSubscription;
  List<QueryDocumentSnapshot> _detectionDocs = [];

  // ゲッター
  List<ItemModel> get items => _items;
  SensorStatus get sensorStatus => _sensorStatus;
  List<NotificationModel> get notifications => _notifications;
  int get consecutiveDaysWithoutForgetting => _consecutiveDaysWithoutForgetting;
  Set<DateTime> get successDates => _successDates;
  int get notificationCount => _notificationCount;
  bool get isCameraActive => _isCameraActive;

  String get userName => _userName;
  String get currentMode => _currentMode;
  List<String> get essentialItemNames => _essentialItemNames;

  AppState() {
    _loadData();
    _initAuthListener();
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    _detectionsSubscription?.cancel();
    super.dispose();
  }

  // Authのログイン状態を監視し、Firestoreを購読する
  void _initAuthListener() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _userSubscription?.cancel();
      if (user != null) {
        _userSubscription = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots()
            .listen((snapshot) {
          if (snapshot.exists) {
            final data = snapshot.data();
            if (data != null) {
              _userName = data['name'] as String? ?? '';
              _currentMode = data['current_mode'] as String? ?? '';

              final essentials = data['essential_items'];
              if (essentials is List) {
                // Firestoreの最新データで置き換えるためローカルキャッシュを破棄
                _items.clear();

                for (var itemData in essentials) {
                  if (itemData is Map<String, dynamic>) {
                    // クラウドから詳細データ（Map）をItemModelに変換して復元
                    _items.add(ItemModel(
                      id: itemData['id'] ??
                          DateTime.now().millisecondsSinceEpoch.toString(),
                      name: itemData['name'] ?? '',
                      description: itemData['description'] ?? '',
                      isRequired: itemData['isRequired'] ?? true,
                    ));
                  } else if (itemData is String) {
                    // 古い形式（文字列のみ）で保存されていた場合の互換性対策
                    _items.add(ItemModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: itemData,
                      description: '',
                      isRequired: true,
                    ));
                  }
                }
                _saveData(); // 復元したデータをスマホのローカルにも保存
              }

              notifyListeners();
            }
          }
        });

        // 検出履歴の購読 (連続日数・成功日の計算)
        _detectionsSubscription = FirebaseFirestore.instance
            .collection('detections')
            .snapshots()
            .listen((snapshot) {
          _detectionDocs = snapshot.docs;
          _calculateStreaks();
          notifyListeners();
        });
      } else {
        // ログアウト時
        _userName = '';
        _currentMode = '';
        _essentialItemNames = [];
        _items.clear();
        _saveData();

        _successDates = {};
        _consecutiveDaysWithoutForgetting = 0;
        _notificationCount = 0;
        _detectionDocs = [];
        _detectionsSubscription?.cancel();
        notifyListeners();
      }
    });
  }

  // データの読み込み
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // 持ち物リストの読み込み
    final itemsJson = prefs.getString('items');
    if (itemsJson != null) {
      final List<dynamic> decoded = jsonDecode(itemsJson);
      _items = decoded.map((item) => ItemModel.fromJson(item)).toList();
    }

    // センサー状態の読み込み
    final sensorJson = prefs.getString('sensorStatus');
    if (sensorJson != null) {
      _sensorStatus = SensorStatus.fromJson(jsonDecode(sensorJson));
    }

    // 通知履歴の読み込み
    final notificationsJson = prefs.getString('notifications');
    if (notificationsJson != null) {
      final List<dynamic> decoded = jsonDecode(notificationsJson);
      _notifications =
          decoded.map((item) => NotificationModel.fromJson(item)).toList();
    }

    // 連続日数の読み込み
    _consecutiveDaysWithoutForgetting = prefs.getInt('consecutiveDays') ?? 0;

    notifyListeners();
  }

  // データの保存
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // 持ち物リストの保存
    final itemsJson = jsonEncode(_items.map((item) => item.toJson()).toList());
    await prefs.setString('items', itemsJson);

    // センサー状態の保存
    final sensorJson = jsonEncode(_sensorStatus.toJson());
    await prefs.setString('sensorStatus', sensorJson);

    // 通知履歴の保存
    final notificationsJson =
        jsonEncode(_notifications.map((item) => item.toJson()).toList());
    await prefs.setString('notifications', notificationsJson);

    // 連続日数の保存
    await prefs.setInt('consecutiveDays', _consecutiveDaysWithoutForgetting);
  }

  /// ローカルの持ち物リストをFirestoreに同期する。
  /// addItem/updateItem/removeItemから呼ばれ、クラウドを最新に保つ。
  Future<void> _syncEssentialItemsToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // アイテムの全情報をそのままリスト（配列）にする
        final List<Map<String, dynamic>> itemsList = _items
            .map((item) => {
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'isRequired': item.isRequired,
                  'isWeekday': item.isWeekday,
                  'isWeekend': item.isWeekend,
                })
            .toList();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'essential_items': itemsList,
        });
        debugPrint("✅ Firestoreに詳細データ付きで同期しました！");
      } catch (e) {
        debugPrint("❌ Firestore同期エラー: $e");
      }
    }
  }

  /// Firestoreの検出履歴からカレンダーの成功日と連続記録を再計算する。
  ///
  /// アルゴリズム:
  /// 1. 各検出ドキュメントを走査し、その日が「成功」かどうかを判定
  /// 2. 成功日 = 忘れ物の警告が出ていない日
  /// 3. 今日（または昨日）から遡って連続する成功日数をカウント
  void _calculateStreaks() {
    final successes = _collectSuccessDates();

    // 今日がまだ成功判定されていない場合は昨日から遡る
    // （外出前など、まだ検出が行われていないケース）
    int streak = 0;
    final today = DateTime.now();
    DateTime checkDate = DateTime(today.year, today.month, today.day);
    if (!successes.contains(checkDate)) {
      checkDate = checkDate.subtract(const Duration(days: 1));
    }
    while (successes.contains(checkDate)) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    _successDates = successes;
    _consecutiveDaysWithoutForgetting = streak;
    _notificationCount = _detectionDocs.length;
  }

  /// 検出履歴から「忘れ物なし」の日付セットを収集する
  Set<DateTime> _collectSuccessDates() {
    Set<DateTime> successes = {};
    for (var doc in _detectionDocs) {
      final data = doc.data() as Map<String, dynamic>;
      final timestamp = data['timestamp'] as Timestamp?;
      if (timestamp == null) continue;

      final missingItems = data['missing_items'] as List<dynamic>? ?? [];
      final message = data['message'] as String? ?? '';
      final dt = timestamp.toDate();

      final isWarning = _hasRequiredMissingItems(missingItems, dt) ||
          (missingItems.isEmpty && message.contains('忘れ物'));

      if (!isWarning) {
        successes.add(DateTime(dt.year, dt.month, dt.day));
      }
    }
    return successes;
  }

  /// 忘れ物リストに「その日に持つべきアイテム」が含まれているか判定する。
  ///
  /// 判定ルール:
  /// - 必須アイテム → 曜日に関係なく常に警告
  /// - 平日アイテム → 平日（祝日除く）のみ警告
  /// - 休日アイテム → 土日祝のみ警告
  /// - ローカルに定義がないアイテム → 安全側に倒して警告扱い
  ///   （アイテム削除前の古い検出記録に対応するため）
  bool _hasRequiredMissingItems(List<dynamic> missingItems, DateTime date) {
    final isRestDay = date.weekday == DateTime.saturday ||
        date.weekday == DateTime.sunday ||
        holiday_jp.isHoliday(date);

    for (var missingName in missingItems) {
      final matchingItem = _items.cast<ItemModel?>().firstWhere(
            (item) => item?.name == missingName.toString(),
            orElse: () => null,
          );

      if (matchingItem == null) return true;

      if (matchingItem.isRequired) return true;
      if (matchingItem.isWeekday && !isRestDay) return true;
      if (matchingItem.isWeekend && isRestDay) return true;
    }
    return false;
  }
  // === 持ち物管理 ===

  void addItem(ItemModel item) {
    _items.add(item);
    _saveData();
    _syncEssentialItemsToFirestore();
    _calculateStreaks();
    notifyListeners();
  }

  void updateItem(String id, ItemModel updatedItem) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index] = updatedItem;
      _saveData();
      _syncEssentialItemsToFirestore();
      _calculateStreaks();
      notifyListeners();
    }
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    _saveData();
    _syncEssentialItemsToFirestore();
    _calculateStreaks();
    notifyListeners();
  }

  // === センサー管理 ===

  void updateSensorStatus(bool isPersonPresent) {
    _sensorStatus = _sensorStatus.copyWith(
      isPersonPresent: isPersonPresent,
      lastDetectedTime: DateTime.now(),
    );
    _saveData();
    notifyListeners();
  }

  // === 通知管理 ===

  void addNotification(String message, NotificationType type) {
    final notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: message,
      timestamp: DateTime.now(),
      type: type,
    );
    _notifications.insert(0, notification); // 最新を先頭に

    // ローカル通知を表示
    NotificationService().showNotification(
      id: int.tryParse(notification.id) ?? 0, // IDはintである必要がある
      title: '忘れん坊防止アプリ',
      body: message,
    );

    // 通知を最大50件に制限
    if (_notifications.length > 50) {
      _notifications = _notifications.take(50).toList();
    }

    _saveData();
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    _saveData();
    notifyListeners();
  }

  // === 統計管理 ===

  void incrementConsecutiveDays() {
    _consecutiveDaysWithoutForgetting++;
    _saveData();
    notifyListeners();
  }

  void resetConsecutiveDays() {
    _consecutiveDaysWithoutForgetting = 0;
    _saveData();
    notifyListeners();
  }

  // === カメラ管理 ===

  void toggleCamera() {
    _isCameraActive = !_isCameraActive;
    notifyListeners();
  }

  // === デモデータ ===

  void loadDemoData() {
    _items = [
      ItemModel(
        id: '1',
        name: '財布',
        description: '毎日持ち歩く必需品',
        isRequired: true,
      ),
      ItemModel(
        id: '2',
        name: '家の鍵',
        description: '玄関とポストの鍵',
        isRequired: true,
      ),
      ItemModel(
        id: '3',
        name: 'スマートフォン',
        description: '連絡手段として必須',
        isRequired: true,
      ),
      ItemModel(
        id: '4',
        name: '傘',
        description: '雨の日用',
        isRequired: false,
      ),
    ];

    _notifications = [
      NotificationModel(
        id: '1',
        message: '今日も忘れ物なし!素晴らしいです!',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.success,
      ),
      NotificationModel(
        id: '2',
        message: '財布を忘れている可能性があります',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.warning,
      ),
      NotificationModel(
        id: '3',
        message: 'センサーが人の動きを検知しました',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        type: NotificationType.info,
      ),
    ];

    _consecutiveDaysWithoutForgetting = 7;

    _saveData();
    notifyListeners();
  }
}
