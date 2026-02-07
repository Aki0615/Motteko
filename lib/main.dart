import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/app_theme.dart';
import 'core/app_router.dart';
import 'providers/app_state.dart';

import 'services/notification_service.dart';
import 'services/detection_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase初期化
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBahtL2My5035tHQWQkkexoB-WWslu9Hxk',
      appId: '1:404876389667:ios:2dd6c7e284ef4ffcc5b096',
      messagingSenderId: '404876389667',
      projectId: 'test-513df',
      storageBucket: 'test-513df.firebasestorage.app',
    ),
  );

  // 通知サービスの初期化と権限リクエスト
  final notificationService = NotificationService();
  await notificationService.initialize();
  await notificationService.requestPermissions();
  // 監視サービスの開始
  final detectionService = DetectionService();
  detectionService.startListening();

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '忘れん坊防止アプリ',
      theme: AppTheme.lightTheme(),
      // darkTheme: AppTheme.darkTheme(), // 将来的に対応
      themeMode: ThemeMode.light,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
