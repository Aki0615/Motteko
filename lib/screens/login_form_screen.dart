// =============================================================================
// login_form_screen.dart
// =============================================================================
// Figmaデザインに基づいたログインフォーム画面。
// メールアドレスとパスワードの入力フィールド、ログインボタン、
// Google/Appleログイン、新規登録へのリンクを配置しています。
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ログインフォーム画面ウィジェット
///
/// Figmaデザインを忠実に再現したログインフォーム画面。
/// メールアドレス・パスワード入力、ログインボタン、
/// Google/Apple認証ボタン、新規登録リンクを配置しています。
class LoginFormScreen extends StatelessWidget {
  const LoginFormScreen({super.key});

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
              // 「パスワードを忘れた方はこちら」テキスト
              // -----------------------------------------------------------------
              Positioned(
                left: 137,
                top: 514,
                child: SizedBox(
                  width: 225,
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
              ),

              // -----------------------------------------------------------------
              // 「アカウントがない方は新規登録」テキスト
              // -----------------------------------------------------------------
              Positioned(
                left: 46,
                right: 46,
                top: 767,
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
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // -----------------------------------------------------------------
              // メールアドレス入力フィールド
              // -----------------------------------------------------------------
              Positioned(
                left: 46,
                top: 334,
                child: Container(
                  width: 301,
                  height: 60,
                  decoration: ShapeDecoration(
                    color: Colors.white,
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
                ),
              ),

              // -----------------------------------------------------------------
              // パスワード入力フィールド
              // -----------------------------------------------------------------
              Positioned(
                left: 46,
                top: 446,
                child: Container(
                  width: 301,
                  height: 60,
                  decoration: ShapeDecoration(
                    color: Colors.white,
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
                ),
              ),

              // -----------------------------------------------------------------
              // 「パスワード」ラベル
              // -----------------------------------------------------------------
              Positioned(
                left: 46,
                top: 414,
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
              // 「おかえり！また会えたね」テキスト
              // -----------------------------------------------------------------
              Positioned(
                left: 46,
                top: 184,
                child: Text.rich(
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
              ),

              // -----------------------------------------------------------------
              // Googleログインボタン
              // -----------------------------------------------------------------
              Positioned(
                left: 46,
                top: 682,
                child: Container(
                  width: 150,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 2.25, color: Colors.black),
                    borderRadius: BorderRadius.circular(22.50),
                    boxShadow: [
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
                      Text(
                        'G',
                        style: TextStyle(
                          color: const Color(0xFFFF7B00),
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Google',
                        style: GoogleFonts.zenMaruGothic(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          height: 1.20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // -----------------------------------------------------------------
              // Appleログインボタン
              // -----------------------------------------------------------------
              Positioned(
                left: 217,
                top: 682,
                child: Container(
                  width: 150,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 2.25, color: Colors.black),
                    borderRadius: BorderRadius.circular(22.50),
                    boxShadow: [
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
                      Icon(
                        Icons.apple,
                        color: Colors.black,
                        size: 22,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Apple',
                        style: GoogleFonts.zenMaruGothic(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          height: 1.20,
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
                top: 302,
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
              // 「ログイン」タイトル
              // -----------------------------------------------------------------
              Positioned(
                left: 27,
                top: 75,
                child: Text(
                  'ログイン',
                  style: GoogleFonts.zenMaruGothic(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    height: 0.90,
                  ),
                ),
              ),

              // -----------------------------------------------------------------
              // ログインボタン
              // -----------------------------------------------------------------
              Positioned(
                left: 88,
                top: 558,
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
                        'ログイン→',
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

              // -----------------------------------------------------------------
              // 「または」区切り線
              // -----------------------------------------------------------------
              Positioned(
                left: 24,
                top: 649.12,
                child: Container(
                  width: 345,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 2,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: const Color(0xFFB9BFC9),
                      ),
                    ),
                  ),
                ),
              ),

              // -----------------------------------------------------------------
              // 「または」テキスト（区切り線上）
              // -----------------------------------------------------------------
              Positioned(
                left: 171,
                top: 641,
                child: Container(
                  width: 50,
                  height: 18,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(color: const Color(0xFFFFDAC4)),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: -2,
                        child: SizedBox(
                          width: 50,
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
                      ),
                    ],
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
}
