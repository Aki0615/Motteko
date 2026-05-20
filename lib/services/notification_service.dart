import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timezone/data/latest.dart' as tz;
import '../core/app_router.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('バックグラウンド通知受信: ${message.messageId}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        final String? payload = notificationResponse.payload;
        if (payload != null && payload.isNotEmpty) {
          AppRouter.router.go(payload);
        }
      },
    );

    // FCM権限リクエスト
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // iOSフォアグラウンド通知表示設定
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
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

    // FCMトークン取得・保存
    await saveFCMToken();

    // トークンリフレッシュ時の更新
    _firebaseMessaging.onTokenRefresh.listen(_updateFCMTokenInFirestore);

    _isInitialized = true;
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('フォアグラウンド通知受信: ${message.notification?.title}');

    final notification = message.notification;
    if (notification == null) return;

    await showNotification(
      id: message.hashCode,
      title: notification.title ?? '',
      body: notification.body ?? '',
      payload: message.data['route'],
    );
  }

  void _handleNotificationOpen(RemoteMessage message) {
    debugPrint('通知タップ: ${message.data}');
    final route = message.data['route'] as String?;
    if (route != null) {
      AppRouter.router.go(route);
    }
  }

  Future<void> saveFCMToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      if (token != null) {
        debugPrint('FCMトークン: $token');
        await _updateFCMTokenInFirestore(token);
      }
    } catch (e) {
      debugPrint('FCMトークン取得エラー: $e');
    }
  }

  Future<void> _updateFCMTokenInFirestore(String token) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'fcm_token': token});
    } catch (e) {
      debugPrint('FCMトークン保存エラー: $e');
    }
  }

  // 権限のリクエスト（Android 13+ / iOS）
  Future<bool> requestPermissions() async {
    if (!_isInitialized) await initialize();

    bool? isGranted = false;

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      isGranted = await androidImplementation.requestNotificationsPermission();
    }

    return isGranted ?? false;
  }

  // 即時通知を表示
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) await initialize();

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'default_channel_id',
      '忘れん坊防止通知',
      channelDescription: '忘れ物防止アプリからの通知です',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: payload,
    );
  }

  // 画像付き通知を表示
  Future<void> showBigPictureNotification({
    required int id,
    required String title,
    required String body,
    required String imageUrl,
    String? payload,
  }) async {
    if (!_isInitialized) await initialize();

    try {
      final http.Response response = await http.get(Uri.parse(imageUrl));
      final ByteArrayAndroidBitmap bigPicture =
          ByteArrayAndroidBitmap(response.bodyBytes);

      final BigPictureStyleInformation bigPictureStyleInformation =
          BigPictureStyleInformation(
        bigPicture,
        largeIcon: bigPicture,
        contentTitle: title,
        summaryText: body,
        htmlFormatContentTitle: true,
        htmlFormatSummaryText: true,
      );

      final AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'default_channel_id',
        '忘れん坊防止通知',
        channelDescription: '忘れ物防止アプリからの通知です',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: bigPictureStyleInformation,
      );

      final NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);

      await flutterLocalNotificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Error showing big picture notification: $e');
      await showNotification(
          id: id, title: title, body: body, payload: payload);
    }
  }
}
