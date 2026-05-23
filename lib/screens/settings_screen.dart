import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_colors.dart';
import '../services/auth_service.dart';

/// 設定画面
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
    final nickname = user?.displayName ?? '未設定';
    final email = user?.email ?? '未設定';
    final userInitial = nickname.isNotEmpty ? nickname[0] : '?';

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================================================
            // ヘッダー
            // ============================================================
            Container(
              width: double.infinity,
              height: 60,
              margin: const EdgeInsets.only(top: 48),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 2, color: Colors.black),
                ),
              ),
              child: Row(
                children: [
                  // 戻るボタン
                  GestureDetector(
                    onTap: () => context.go('/'),
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFB9BFC9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 「設定」テキスト
                  Text(
                    '設定',
                    style: GoogleFonts.zenMaruGothic(
                      color: AppColors.primary700,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      height: 0.90,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ============================================================
            // プロフィールカード
            // ============================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Container(
                width: double.infinity,
                height: 88,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2, color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0xFF000000),
                      blurRadius: 0,
                      offset: Offset(2, 3),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 13),
                    // アバター
                    Container(
                      width: 70,
                      height: 70,
                      decoration: ShapeDecoration(
                        color: AppColors.primary700,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.circular(45),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0xFF000000),
                            blurRadius: 0,
                            offset: Offset(3, 4.50),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          userInitial,
                          style: GoogleFonts.zenMaruGothic(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // 名前・メール
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nickname,
                          style: GoogleFonts.zenMaruGothic(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            height: 1.20,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: GoogleFonts.zenMaruGothic(
                            color: AppColors.gray500,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            height: 1.20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ============================================================
            // デバイス・接続セクション
            // ============================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'デバイス・接続',
                style: GoogleFonts.zenMaruGothic(
                  color: AppColors.gray500,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1.20,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: _buildSettingsCard(
                children: [
                  _buildSettingsItem(
                    context: context,
                    iconColor: const Color(0xFF26A5FF),
                    icon: Icons.wifi,
                    label: 'Wi-Fi',
                    onTap: () => context.go('/wifi'),
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    iconColor: const Color(0xFF26A5FF),
                    icon: Icons.bluetooth,
                    label: 'Bluetooth',
                    onTap: () => context.go('/bluetooth'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ============================================================
            // 通知・プライバシーセクション
            // ============================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: _buildSettingsCard(
                children: [
                  _buildSettingsItem(
                    iconColor: AppColors.primary700,
                    icon: Icons.description_outlined,
                    label: '利用規約',
                    onTap: () => context.go('/terms-of-service'),
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    iconColor: const Color(0xFFF44F4F),
                    icon: Icons.notifications_outlined,
                    label: '通知',
                    onTap: () => context.go('/notification-settings'),
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    iconColor: const Color(0xFF26A5FF),
                    icon: Icons.shield_outlined,
                    label: 'プライバシー',
                    onTap: () => context.go('/privacy-settings'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ============================================================
            // ログアウト
            // ============================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: Text(
                          'ログアウト',
                          style: GoogleFonts.zenMaruGothic(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        content: Text(
                          '本当にログアウトしますか？',
                          style: GoogleFonts.zenMaruGothic(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            child: Text(
                              'キャンセル',
                              style: GoogleFonts.zenMaruGothic(
                                color: const Color(0xFFB9BFC9),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(dialogContext).pop();
                              await AuthService().signOut();
                              if (context.mounted) context.go('/login');
                            },
                            child: Text(
                              'ログアウト',
                              style: GoogleFonts.zenMaruGothic(
                                color: AppColors.error,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 64,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side:
                          BorderSide(width: 2, color: AppColors.error),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    shadows: [
                      BoxShadow(
                        color: AppColors.error,
                        blurRadius: 0,
                        offset: Offset(2, 3),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout,
                        size: 24,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ログアウト',
                        style: GoogleFonts.zenMaruGothic(
                          color: AppColors.error,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          height: 1.20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  // 設定カード（外枠）
  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2, color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        shadows: [
          BoxShadow(
            color: Color(0xFF000000),
            blurRadius: 0,
            offset: Offset(2, 3),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  // 設定アイテム（アイコン + ラベル）
  Widget _buildSettingsItem({
    BuildContext? context,
    required Color iconColor,
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap ?? () {},
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            // カラーアイコンボックス
            Container(
              width: 40,
              height: 40,
              decoration: ShapeDecoration(
                color: iconColor,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.50, color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0xFF000000),
                    blurRadius: 0,
                    offset: Offset(2, 3),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Icon(icon, size: 24, color: Colors.white),
            ),
            const SizedBox(width: 16),
            // ラベル
            Text(
              label,
              style: GoogleFonts.zenMaruGothic(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                height: 1.20,
              ),
            ),
            const Spacer(),
            // 矢印
            Icon(
              Icons.chevron_right,
              size: 24,
              color: const Color(0xFFB9BFC9),
            ),
          ],
        ),
      ),
    );
  }

  // 区切り線
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        width: double.infinity,
        height: 2,
        color: const Color(0xFFB9BFC9),
      ),
    );
  }
}
