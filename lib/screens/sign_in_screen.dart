// =============================================================================
// sign_in_screen.dart
// =============================================================================
// Figmaデザインに基づいたサインイン（新規登録）画面。
// メールアドレス、パスワード、パスワード確認、ニックネームの入力フィールド、
// 利用規約の同意チェックボックス、はじめるボタンを配置しています。
// =============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';

/// サインイン（新規登録）画面ウィジェット
///
/// Figmaデザインを忠実に再現したサインイン画面。
/// メールアドレス、パスワード、パスワード確認、ニックネームの入力、
/// 利用規約の同意、はじめるボタンを配置しています。
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isAgreed = false;
  bool _isLoading = false;
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _nicknameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 393,
          height: 852,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: const Color(0xFFFF7B00),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(45),
            ),
          ),
          child: Stack(
            children: [
              // -----------------------------------------------------------------
              // Rectangle1593: 画面下部のベージュ背景
              // -----------------------------------------------------------------
              Positioned(
                left: 0,
                right: 0,
                top: 140,
                bottom: 0,
                child: Container(
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFFDAC4),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 2,
                        color: const Color(0xFF000000),
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                  ),
                ),
              ),

              // -----------------------------------------------------------------
              // 「ようこそ！仲間になろう」テキスト
              // -----------------------------------------------------------------
              Positioned(
                left: 46,
                top: 184,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'ようこそ！\n',
                        style: GoogleFonts.zenMaruGothic(
                          color: Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          height: 1.09,
                        ),
                      ),
                      TextSpan(
                        text: '仲間になろう',
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
              ),

              // -----------------------------------------------------------------
              // 「メールアドレス」ラベル
              // -----------------------------------------------------------------
              Positioned(
                left: 46,
                top: 262,
                child: Text(
                  'メールアドレス',
                  style: GoogleFonts.zenMaruGothic(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    height: 1.20,
                  ),
                ),
              ),

              // -----------------------------------------------------------------
              // メールアドレス入力フィールド
              // -----------------------------------------------------------------
              Positioned(
                left: 46,
                top: 294,
                child: _buildInputField(
                  controller: _emailController,
                  hintText: 'メールアドレスを入力',
                  keyboardType: TextInputType.emailAddress,
                ),
              ),

              // -----------------------------------------------------------------
              // 「パスワード」ラベル
              // -----------------------------------------------------------------
              Positioned(
                left: 46,
                top: 375,
                child: Text(
                  'パスワード',
                  style: GoogleFonts.zenMaruGothic(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    height: 1.20,
                  ),
                ),
              ),

              // -----------------------------------------------------------------
              // パスワード入力フィールド
              // -----------------------------------------------------------------
              Positioned(
                left: 46,
                top: 410,
                child: _buildInputField(
                  controller: _passwordController,
                  hintText: 'パスワードを入力',
                  obscureText: true,
                ),
              ),

              // -----------------------------------------------------------------
              // 「パスワード(確認)」ラベル
              // -----------------------------------------------------------------
              Positioned(
                left: 46,
                top: 485,
                child: Text(
                  'パスワード(確認)',
                  style: GoogleFonts.zenMaruGothic(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    height: 1.20,
                  ),
                ),
              ),

              // -----------------------------------------------------------------
              // パスワード(確認)入力フィールド
              // -----------------------------------------------------------------
              Positioned(
                left: 46,
                top: 517,
                child: _buildInputField(
                  controller: _passwordConfirmController,
                  hintText: 'パスワードを再入力',
                  obscureText: true,
                ),
              ),

              // -----------------------------------------------------------------
              // 「ニックネーム」ラベル
              // -----------------------------------------------------------------
              Positioned(
                left: 46,
                top: 592,
                child: Text(
                  'ニックネーム',
                  style: GoogleFonts.zenMaruGothic(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    height: 1.20,
                  ),
                ),
              ),

              // -----------------------------------------------------------------
              // ニックネーム入力フィールド
              // -----------------------------------------------------------------
              Positioned(
                left: 46,
                top: 624,
                child: _buildInputField(
                  controller: _nicknameController,
                  hintText: 'ニックネームを入力',
                ),
              ),

              // -----------------------------------------------------------------
              // 利用規約チェックボックス
              // -----------------------------------------------------------------
              Positioned(
                left: 40,
                top: 695,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isAgreed = !_isAgreed;
                    });
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: ShapeDecoration(
                      color: _isAgreed ? const Color(0xFFFF7B00) : Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0xFF000000),
                          blurRadius: 0,
                          offset: Offset(2, 2),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: _isAgreed
                        ? Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          )
                        : null,
                  ),
                ),
              ),

              // -----------------------------------------------------------------
              // 「利用規約とプライバシーポリシーに同意します」テキスト
              // -----------------------------------------------------------------
              Positioned(
                left: 67,
                top: 695,
                child: SizedBox(
                  width: 301,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '利用規約',
                          style: GoogleFonts.zenMaruGothic(
                            color: const Color(0xFFFF6100),
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            height: 1.37,
                          ),
                        ),
                        TextSpan(
                          text: 'と',
                          style: GoogleFonts.zenMaruGothic(
                            color: const Color(0xFFB9BFC9),
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            height: 1.37,
                          ),
                        ),
                        TextSpan(
                          text: 'プライバシーポリシー',
                          style: GoogleFonts.zenMaruGothic(
                            color: const Color(0xFFFF6100),
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            height: 1.37,
                          ),
                        ),
                        TextSpan(
                          text: 'に同意します',
                          style: GoogleFonts.zenMaruGothic(
                            color: const Color(0xFFB9BFC9),
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            height: 1.37,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // -----------------------------------------------------------------
              // 「はじめる→」ボタン
              // -----------------------------------------------------------------
              Positioned(
                left: 88,
                top: 741,
                child: GestureDetector(
                  onTap: _isLoading
                      ? null
                      : () async {
                          // バリデーション
                          final email = _emailController.text.trim();
                          final password = _passwordController.text;
                          final passwordConfirm =
                              _passwordConfirmController.text;
                          final nickname = _nicknameController.text.trim();

                          if (email.isEmpty ||
                              password.isEmpty ||
                              passwordConfirm.isEmpty ||
                              nickname.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('すべての項目を入力してください'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          if (password != passwordConfirm) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('パスワードが一致しません'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          if (!_isAgreed) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('利用規約に同意してください'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          setState(() => _isLoading = true);
                          try {
                            await _authService.signUp(
                              email: email,
                              password: password,
                              nickname: nickname,
                            );
                            if (mounted) context.go('/');
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e
                                      .toString()
                                      .replaceFirst('Exception: ', '')),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } finally {
                            if (mounted) setState(() => _isLoading = false);
                          }
                        },
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFF7B00),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 2.25),
                        borderRadius: BorderRadius.circular(22.50),
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'はじめる→',
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

              // -----------------------------------------------------------------
              // 「サインイン」タイトル
              // -----------------------------------------------------------------
              Positioned(
                left: 27,
                top: 75,
                child: Text(
                  'サインイン',
                  style: GoogleFonts.zenMaruGothic(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    height: 0.90,
                  ),
                ),
              ),

              // -----------------------------------------------------------------
              // 「Motteko」ロゴテキスト
              // -----------------------------------------------------------------
              Positioned(
                left: 297,
                top: 83,
                child: Text(
                  'Motteko',
                  style: GoogleFonts.zenMaruGothic(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    height: 1.44,
                  ),
                ),
              ),
            ],
          ),
        ),
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
      width: 301,
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
