import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item_model.dart';
import '../models/sensor_status.dart';
import '../models/notification_model.dart';
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

  // カメラの状態
  bool _isCameraActive = false;

  // ゲッター
  List<ItemModel> get items => _items;
  SensorStatus get sensorStatus => _sensorStatus;
  List<NotificationModel> get notifications => _notifications;
  int get consecutiveDaysWithoutForgetting => _consecutiveDaysWithoutForgetting;
  bool get isCameraActive => _isCameraActive;

  AppState() {
    _loadData();
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

  // === 持ち物管理 ===

  void addItem(ItemModel item) {
    _items.add(item);
    _saveData();
    notifyListeners();
  }

  void updateItem(String id, ItemModel updatedItem) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index] = updatedItem;
      _saveData();
      notifyListeners();
    }
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    _saveData();
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
