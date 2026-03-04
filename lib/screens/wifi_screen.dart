import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

/// Wi-Fi設定画面
class WifiScreen extends StatelessWidget {
  const WifiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
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
                      onTap: () => context.go('/settings'),
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
                    // 「Wi-Fi」テキスト
                    Text(
                      'Wi-Fi',
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
              // 接続済みWi-Fiカード
              // ============================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Container(
                  width: double.infinity,
                  height: 88,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFA9FFC8),
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
                      const SizedBox(width: 16),
                      // 緑アイコンボックス
                      Container(
                        width: 40,
                        height: 40,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF22C55E),
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
                        child: const Icon(Icons.wifi,
                            size: 24, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      // Wi-Fi名と接続状態
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '接続済み',
                            style: GoogleFonts.zenMaruGothic(
                              color: const Color(0xFF22C55E),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              height: 1.29,
                            ),
                          ),
                          Text(
                            'Mywifi_5G',
                            style: GoogleFonts.zenMaruGothic(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
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
              // ほかのネットワーク セクション
              // ============================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'ほかのネットワーク',
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
                child: Container(
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildNetworkItem('Mywifi_5G', context),
                      _buildDivider(),
                      _buildNetworkItem('Mywifi_5G', context),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  // ネットワークアイテム
  Widget _buildNetworkItem(String name, BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.go('/wifi-password?name=${Uri.encodeComponent(name)}');
      },
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            Icon(Icons.wifi, size: 24, color: Colors.black54),
            const SizedBox(width: 16),
            Text(
              name,
              style: GoogleFonts.zenMaruGothic(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                height: 1.20,
              ),
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
