// =============================================================================
// login_form_screen.dart
// =============================================================================
// Figmaデザインに基づいたログインフォーム画面。
// メールアドレスとパスワードの入力フィールド、ログインボタン、
// Google/Appleログイン、新規登録へのリンクを配置しています。
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';

/// ログインフォーム画面ウィジェット
///
/// Figmaデザインを忠実に再現したログインフォーム画面。
/// メールアドレス・パスワード入力、ログインボタン、
/// Google/Apple認証ボタン、新規登録リンクを配置しています。
class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  bool _isLoading = false;
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF7B00),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ヘッダー部分
            Padding(
              padding: const EdgeInsets.only(
                  left: 27, right: 30, top: 20, bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'ログイン',
                    style: GoogleFonts.zenMaruGothic(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      height: 0.90,
                    ),
                  ),
                  Text(
                    'Motteko',
                    style: GoogleFonts.zenMaruGothic(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      height: 1.44,
                    ),
                  ),
                ],
              ),
            ),

            // 下部のベージュ背景フォーム
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const ShapeDecoration(
                  color: Color(0xFFFFDAC4),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 2,
                      color: Color(0xFF000000),
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 46, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 「おかえり！また会えたね」テキスト
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'おかえり！\n',
                              style: GoogleFonts.zenMaruGothic(
                                color: Colors.black,
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                height: 1.09,
                              ),
                            ),
                            TextSpan(
                              text: 'また会えたね',
                              style: GoogleFonts.zenMaruGothic(
                                color: const Color(0xFFFF6100),
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                height: 1.09,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),

                      // 「メールアドレス」ラベル
                      Text(
                        'メールアドレス',
                        style: GoogleFonts.zenMaruGothic(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          height: 1.20,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // メールアドレス入力フィールド
                      _buildInputField(
                        controller: _emailController,
                        hintText: 'メールアドレスを入力',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 24),

                      // 「パスワード」ラベル
                      Text(
                        'パスワード',
                        style: GoogleFonts.zenMaruGothic(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          height: 1.20,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // パスワード入力フィールド
                      _buildInputField(
                        controller: _passwordController,
                        hintText: 'パスワードを入力',
                        obscureText: true,
                      ),
                      const SizedBox(height: 8),

                      // 「パスワードを忘れた方はこちら」テキスト
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'パスワードを忘れた方はこちら',
                          style: GoogleFonts.zenMaruGothic(
                            color: const Color(0xFFFF6100),
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            height: 1.28,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // ログインボタン
                      Center(
                        child: GestureDetector(
                          onTap: _isLoading ? null : _handleLogin,
                          child: Container(
                            height: 60,
                            padding: const EdgeInsets.symmetric(horizontal: 48),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFFF7B00),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 2.25),
                                borderRadius: BorderRadius.circular(22.50),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0xFF000000),
                                  blurRadius: 0,
                                  offset: Offset(3, 4.50),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  _isLoading ? '接続中...' : 'ログイン→',
                                  style: GoogleFonts.zenMaruGothic(
                                    color: Colors.white,
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
                      const SizedBox(height: 32),

                      // 「または」区切り線
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 2,
                              color: const Color(0xFFB9BFC9),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'または',
                              style: GoogleFonts.zenMaruGothic(
                                color: const Color(0xFFB9BFC9),
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                height: 1.20,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 2,
                              color: const Color(0xFFB9BFC9),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Google/Appleログインボタン
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: _buildSocialButton(
                              icon: const Text(
                                'G',
                                style: TextStyle(
                                  color: Color(0xFFFF7B00),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              text: 'Google',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildSocialButton(
                              icon: const Icon(
                                Icons.apple,
                                color: Colors.black,
                                size: 22,
                              ),
                              text: 'Apple',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // 「アカウントがない方は新規登録」テキスト
                      Center(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'アカウントがない方は',
                                style: GoogleFonts.zenMaruGothic(
                                  color: const Color(0xFFB9BFC9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  height: 1.20,
                                ),
                              ),
                              TextSpan(
                                text: '新規登録',
                                style: GoogleFonts.zenMaruGothic(
                                  color: const Color(0xFFFF6100),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  height: 1.20,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context.go('/sign-in');
                                  },
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('メールアドレスとパスワードを入力してください'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authService.signIn(
        email: email,
        password: password,
      );
      if (mounted) context.go('/');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildSocialButton({required Widget icon, required String text}) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 2.25, color: Colors.black),
        borderRadius: BorderRadius.circular(22.50),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF000000),
            blurRadius: 0,
            offset: Offset(3, 4.50),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.zenMaruGothic(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              height: 1.20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Material(
        color: Colors.transparent,
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: GoogleFonts.zenMaruGothic(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.zenMaruGothic(
              color: const Color(0xFF6B7280),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22.50),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }
}
