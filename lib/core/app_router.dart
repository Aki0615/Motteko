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

// 各画面のインポート
import '../screens/home_screen.dart';
import '../screens/items_screen.dart';
import '../screens/camera_screen.dart';
import '../screens/sensors_screen.dart';
import '../screens/notifications_screen.dart';

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
    initialLocation: '/',

    // ルート（画面）の定義
    routes: [
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

          // センサー画面（人感センサーの状態表示）
          // パス: /sensors
          GoRoute(
            path: '/sensors',
            builder: (context, state) => const SensorsScreen(),
          ),

          // 通知画面（通知履歴の表示）
          // パス: /notifications
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
        ],
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
/// 3: センサー（/sensors）
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
                      width: 1,
                      color: Color(0xFFE8EEF4),
                    ),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
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
                      icon: Icons.inventory_2_outlined,
                      selectedIcon: Icons.inventory_2,
                      label: '持ち物',
                    ),
                    // カメラタブ
                    _buildNavItem(
                      context: context,
                      index: 2,
                      selectedIndex: selectedIndex,
                      icon: Icons.photo_camera_outlined,
                      selectedIcon: Icons.photo_camera,
                      label: 'カメラ',
                    ),
                    // センサータブ
                    _buildNavItem(
                      context: context,
                      index: 3,
                      selectedIndex: selectedIndex,
                      icon: Icons.sensors_outlined,
                      selectedIcon: Icons.sensors,
                      label: 'センサー',
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
        decoration: ShapeDecoration(
          // 選択時: オレンジ背景、非選択時: 透明
          color: isSelected ? const Color(0xFFFFDAC4) : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              // 選択時: 塗りつぶしアイコン、非選択時: 線画アイコン
              isSelected ? selectedIcon : icon,
              // 選択時: オレンジ、非選択時: グレー
              color: isSelected
                  ? const Color(0xFFFF7B00)
                  : const Color(0xFF6B7280),
              size: 18,
            ),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'LINESeedJP',
                fontSize: 9,
                fontWeight: FontWeight.w400,
                // 選択時: オレンジ、非選択時: グレー
                color: isSelected
                    ? const Color(0xFFFF7B00)
                    : const Color(0xFF6B7280),
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
    if (location.startsWith('/sensors')) return 3; // センサー画面
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
        context.go('/sensors'); // センサー画面
        break;
      case 4:
        context.go('/notifications'); // 通知画面
        break;
    }
  }
}
