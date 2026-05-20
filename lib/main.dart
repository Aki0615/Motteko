import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'core/app_theme.dart';
import 'core/app_router.dart';
import 'providers/app_state.dart';

import 'services/notification_service.dart';
import 'services/detection_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // バックグラウンドハンドラの登録
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const MyApp(),
    ),
  );

  // UI表示後に通知サービスを初期化（権限ダイアログでブロックしないように）
  final notificationService = NotificationService();
  await notificationService.initialize();
  await notificationService.requestPermissions();

  // 監視サービスの開始
  final detectionService = DetectionService();
  detectionService.startListening();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '忘れん坊防止アプリ',
      theme: AppTheme.lightTheme(),
      // TODO(2026-05): ダークテーマ対応を検討
      themeMode: ThemeMode.light,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
