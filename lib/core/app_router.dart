// =============================================================================
// app_router.dart
// =============================================================================
// アプリのルーティング（画面遷移）を管理するファイル。
// go_routerパッケージを使用して、各画面へのナビゲーションを設定しています。
//
// 【このファイルの役割】
// - 画面のURL（パス）とウィジェットの対応付け
// - ボトムナビゲーションバーの表示と制御
// - 画面遷移時のアニメーション管理
//
// 【主要なクラス】
// - AppRouter: ルーティング設定を保持するクラス
// - ScaffoldWithBottomNavBar: 全画面共通のレイアウト（ナビゲーションバー付き）
// =============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

// 各画面のインポート
import '../screens/home_screen.dart';
import '../screens/items_screen.dart';
import '../screens/camera_screen.dart';
import '../screens/calendar_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/login_screen.dart';
import '../screens/login_form_screen.dart';
import '../screens/sign_in_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/wifi_screen.dart';
import '../screens/wifi_password_screen.dart';
import '../screens/bluetooth_screen.dart';
import '../screens/notification_settings_screen.dart';
import '../screens/privacy_settings_screen.dart';
import '../screens/terms_of_service_screen.dart';
import '../screens/device_id_input_screen.dart';

// =============================================================================
// グローバル変数
// =============================================================================

/// ルートナビゲーターのキー
///
/// アプリ全体のナビゲーション状態を管理するために使用します。
/// ダイアログを表示したり、ナビゲーション履歴にアクセスする際に必要です。
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

// =============================================================================
// AppRouter クラス
// =============================================================================

/// アプリのルーティング設定を管理するクラス
///
/// 使用例（main.dartで）:
/// ```dart
/// MaterialApp.router(
///   routerConfig: AppRouter.router,
/// )
/// ```
class AppRouter {
  /// GoRouterのインスタンス（アプリのルーティング設定）
  ///
  /// ShellRouteを使用することで、ボトムナビゲーションバーを
  /// 全ての画面で共通して表示できます。
  static final router = GoRouter(
    // ナビゲーターのキー設定
    navigatorKey: _rootNavigatorKey,

    // アプリ起動時に最初に表示する画面のパス
    initialLocation: '/login',

    // ルート（画面）の定義
    routes: [
      // -----------------------------------------------------------------------
      // ログイン画面（ナビゲーションバーなし）
      // -----------------------------------------------------------------------
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      // -----------------------------------------------------------------------
      // ログインフォーム画面（ナビゲーションバーなし）
      // -----------------------------------------------------------------------
      GoRoute(
        path: '/login-form',
        builder: (context, state) => const LoginFormScreen(),
      ),

      // -----------------------------------------------------------------------
      // サインイン（新規登録）画面（ナビゲーションバーなし）
      // -----------------------------------------------------------------------
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInScreen(),
      ),

      // -----------------------------------------------------------------------
      // ShellRoute: 共通レイアウト（ボトムナビゲーションバー）を持つルート群
      // -----------------------------------------------------------------------
      // ShellRouteの子ルートは全て、ScaffoldWithBottomNavBarでラップされます。
      // これにより、画面を切り替えてもナビゲーションバーは常に表示されます。
      ShellRoute(
        // 共通レイアウトのビルダー
        // child には各画面のウィジェットが渡されます
        builder: (context, state, child) {
          return ScaffoldWithBottomNavBar(child: child);
        },

        // 各画面のルート定義
        routes: [
          // ホーム画面（メイン画面）
          // パス: /
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
          ),

          // 持ち物一覧画面
          // パス: /items
          GoRoute(
            path: '/items',
            builder: (context, state) => const ItemsScreen(),
          ),

          // カメラ画面（持ち物撮影用）
          // パス: /camera
          GoRoute(
            path: '/camera',
            builder: (context, state) => const CameraScreen(),
          ),

          // カレンダー画面（連続記録・カレンダー表示）
          // パス: /calendar
          GoRoute(
            path: '/calendar',
            builder: (context, state) => const CalendarScreen(),
          ),

          // 通知画面（通知履歴の表示）
          // パス: /notifications
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
        ],
      ),

      // 設定画面（タブバーなし）
      // パス: /settings
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),

      // Wi-Fi設定画面（タブバーなし）
      // パス: /wifi
      GoRoute(
        path: '/wifi',
        builder: (context, state) => const WifiScreen(),
      ),

      // Wi-Fiパスワード入力画面（タブバーなし）
      // パス: /wifi-password
      GoRoute(
        path: '/wifi-password',
        builder: (context, state) {
          final networkName = state.uri.queryParameters['name'] ?? '';
          return WifiPasswordScreen(networkName: networkName);
        },
      ),

      // ユーザー情報設定画面（仮）
      GoRoute(
        path: '/profile-setup',
        builder: (context, state) {
          // TODO: プロフィール設定画面を実装する
          return const Scaffold(body: Center(child: Text('プロフィール設定画面')));
        },
      ),

      // デバイスID入力画面（タブバーなし）
      // パス: /device-id-input
      GoRoute(
        path: '/device-id-input',
        builder: (context, state) => const DeviceIdInputScreen(),
      ),

      // Bluetooth設定画面（タブバーなし）
      // パス: /bluetooth
      GoRoute(
        path: '/bluetooth',
        builder: (context, state) => const BluetoothScreen(),
      ),

      // 通知設定画面（タブバーなし）
      // パス: /notification-settings
      GoRoute(
        path: '/notification-settings',
        builder: (context, state) => const NotificationSettingsScreen(),
      ),

      // プライバシー設定画面（タブバーなし）
      // パス: /privacy-settings
      GoRoute(
        path: '/privacy-settings',
        builder: (context, state) => const PrivacySettingsScreen(),
      ),

      // 利用規約画面（タブバーなし）
      // パス: /terms-of-service
      GoRoute(
        path: '/terms-of-service',
        builder: (context, state) => const TermsOfServiceScreen(),
      ),
    ],
  );
}

// =============================================================================
// ScaffoldWithBottomNavBar クラス
// =============================================================================

/// ボトムナビゲーションバー付きの共通レイアウトウィジェット
///
/// 全ての画面で共通して表示されるボトムナビゲーションバーを提供します。
/// 各タブをタップすると、対応する画面に遷移します。
///
/// 【タブ構成】
/// 0: ホーム（/）
/// 1: 持ち物（/items）
/// 2: カメラ（/camera）
/// 3: カレンダー（/calendar）
/// 4: 通知（/notifications）
class ScaffoldWithBottomNavBar extends StatelessWidget {
  /// 表示するメインコンテンツ（各画面のウィジェット）
  final Widget child;

  /// コンストラクタ
  const ScaffoldWithBottomNavBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // 現在選択されているタブのインデックスを計算
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // メインコンテンツ（各画面のウィジェット）
      body: Stack(
        children: [
          child,
          // フローティングナビゲーションバー
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: SafeArea(
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 1.5,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0xFF000000),
                      blurRadius: 0,
                      offset: Offset(3, 4.5),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // ホームタブ
                    _buildNavItem(
                      context: context,
                      index: 0,
                      selectedIndex: selectedIndex,
                      icon: Icons.home_outlined,
                      selectedIcon: Icons.home,
                      label: 'ホーム',
                    ),
                    // 持ち物タブ
                    _buildNavItem(
                      context: context,
                      index: 1,
                      selectedIndex: selectedIndex,
                      icon: Icons.work_outline,
                      selectedIcon: Icons.work,
                      label: '持ち物',
                    ),
                    // カメラタブ
                    _buildNavItem(
                      context: context,
                      index: 2,
                      selectedIndex: selectedIndex,
                      icon: Icons.videocam_outlined,
                      selectedIcon: Icons.videocam,
                      label: 'カメラ',
                    ),
                    // カレンダータブ
                    _buildNavItem(
                      context: context,
                      index: 3,
                      selectedIndex: selectedIndex,
                      icon: Icons.calendar_today_outlined,
                      selectedIcon: Icons.calendar_today,
                      label: 'カレンダー',
                    ),
                    // 通知タブ
                    _buildNavItem(
                      context: context,
                      index: 4,
                      selectedIndex: selectedIndex,
                      icon: Icons.notifications_outlined,
                      selectedIcon: Icons.notifications,
                      label: '通知',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // プライベートメソッド
  // ---------------------------------------------------------------------------

  /// ナビゲーションアイテム（タブ）のウィジェットを構築
  ///
  /// [context] - BuildContext
  /// [index] - このアイテムのインデックス（0〜4）
  /// [selectedIndex] - 現在選択されているインデックス
  /// [icon] - 非選択時に表示するアイコン
  /// [selectedIcon] - 選択時に表示するアイコン
  /// [label] - アイコン下に表示するラベル
  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required int selectedIndex,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
  }) {
    // このアイテムが選択されているかどうか
    final isSelected = index == selectedIndex;

    // タップ可能なウィジェット
    return GestureDetector(
      // タップ時に対応する画面に遷移
      onTap: () => _onItemTapped(index, context),

      // タップ領域を広げる（見えない部分もタップ可能に）
      behavior: HitTestBehavior.opaque,

      child: Container(
        width: 52,
        height: 52,
        decoration: isSelected
            ? const ShapeDecoration(
                color: Color(0xFFFF7B00),
                shape: CircleBorder(),
              )
            : const BoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? Colors.white : const Color(0xFF6B7280),
              size: 20,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.zenMaruGothic(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? Colors.white : const Color(0xFF6B7280),
                height: 1.20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 現在のURLから選択されているタブのインデックスを計算
  ///
  /// [context] - BuildContext
  /// 戻り値: 選択されているタブのインデックス（0〜4）
  static int _calculateSelectedIndex(BuildContext context) {
    // 現在のURLを取得
    final String location = GoRouterState.of(context).uri.toString();

    // URLに基づいてインデックスを返す
    if (location.startsWith('/items')) return 1; // 持ち物画面
    if (location.startsWith('/camera')) return 2; // カメラ画面
    if (location.startsWith('/calendar')) return 3; // カレンダー画面
    if (location.startsWith('/notifications')) return 4; // 通知画面
    return 0; // デフォルトはホーム画面
  }

  /// タブがタップされた時の処理
  ///
  /// [index] - タップされたタブのインデックス
  /// [context] - BuildContext（画面遷移に必要）
  void _onItemTapped(int index, BuildContext context) {
    // インデックスに対応するパスに遷移
    switch (index) {
      case 0:
        context.go('/'); // ホーム画面
        break;
      case 1:
        context.go('/items'); // 持ち物画面
        break;
      case 2:
        context.go('/camera'); // カメラ画面
        break;
      case 3:
        context.go('/calendar'); // カレンダー画面
        break;
      case 4:
        context.go('/notifications'); // 通知画面
        break;
    }
  }
}
