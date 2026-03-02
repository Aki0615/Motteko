import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

/// 設定画面
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      color: const Color(0xFFFF7B00),
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
                        color: const Color(0xFFFF7B00),
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
                          '山',
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
                          '山田 太郎',
                          style: GoogleFonts.zenMaruGothic(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            height: 1.20,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'yamada1222@gmail.com',
                          style: GoogleFonts.zenMaruGothic(
                            color: const Color(0xFF6B7280),
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
                  color: const Color(0xFF6B7280),
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
                    iconColor: const Color(0xFF26A5FF),
                    icon: Icons.wifi,
                    label: 'Wi-Fi',
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    iconColor: const Color(0xFF26A5FF),
                    icon: Icons.bluetooth,
                    label: 'Bluetooth',
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
                    iconColor: const Color(0xFFF44F4F),
                    icon: Icons.notifications_outlined,
                    label: '通知',
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    iconColor: const Color(0xFF26A5FF),
                    icon: Icons.shield_outlined,
                    label: 'プライバシー',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ============================================================
            // 利用規約
            // ============================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: GestureDetector(
                onTap: () {
                  // TODO: 利用規約ページへ遷移
                },
                child: Container(
                  width: double.infinity,
                  height: 64,
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
                  child: Center(
                    child: Text(
                      '利用規約',
                      style: GoogleFonts.zenMaruGothic(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        height: 1.20,
                      ),
                    ),
                  ),
                ),
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
                  // TODO: ログアウト処理
                  context.go('/login');
                },
                child: Container(
                  width: double.infinity,
                  height: 64,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side:
                          BorderSide(width: 2, color: const Color(0xFFEF4444)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0xFFEF4444),
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
                        color: const Color(0xFFEF4444),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ログアウト',
                        style: GoogleFonts.zenMaruGothic(
                          color: const Color(0xFFEF4444),
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
    required Color iconColor,
    required IconData icon,
    required String label,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // TODO: 各設定画面への遷移
      },
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
