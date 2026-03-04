import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

/// Wi-Fiパスワード入力画面
class WifiPasswordScreen extends StatefulWidget {
  final String networkName;

  const WifiPasswordScreen({super.key, required this.networkName});

  @override
  State<WifiPasswordScreen> createState() => _WifiPasswordScreenState();
}

class _WifiPasswordScreenState extends State<WifiPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

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
                    onTap: () => context.go('/wifi'),
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

            const SizedBox(height: 40),

            // ============================================================
            // Wi-Fiアイコン
            // ============================================================
            Center(
              child: Icon(
                Icons.wifi,
                size: 96,
                color: const Color(0xFF26A5FF),
              ),
            ),

            const SizedBox(height: 24),

            // ============================================================
            // 説明テキスト
            // ============================================================
            Center(
              child: SizedBox(
                width: 258,
                child: Text(
                  'このWi-Fiネットワークに接続するには、パスワードを入力してください。',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.zenMaruGothic(
                    color: const Color(0xFF6B7280),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.20,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ============================================================
            // パスワード入力フィールド
            // ============================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 57),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'パスワード',
                    style: GoogleFonts.zenMaruGothic(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      height: 1.20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 50,
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
                        Expanded(
                          child: TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: GoogleFonts.zenMaruGothic(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              hintText: 'パスワードを入力',
                              hintStyle: GoogleFonts.zenMaruGothic(
                                color: const Color(0xFFB9BFC9),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 24,
                              color: const Color(0xFFB9BFC9),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ============================================================
            // 接続ボタン
            // ============================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 57),
              child: GestureDetector(
                onTap: () {
                  // TODO: Wi-Fi接続処理
                  context.go('/wifi');
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFF7B00),
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
                      '接続',
                      style: GoogleFonts.zenMaruGothic(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        height: 1.20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
