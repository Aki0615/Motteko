// =============================================================================
// login_screen.dart
// =============================================================================
// Figmaデザインに基づいたウェルカム画面。
// サインインとログインのボタンを配置し、アプリの初回起動時に表示されます。
// =============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// ログイン画面ウィジェット
///
/// Figmaデザインを忠実に再現したログイン/サインイン画面。
/// オレンジ色の背景に、アプリロゴ、キャッチコピー、
/// サインインボタン、ログインボタンを配置しています。
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
              // 装飾用の円（右下）
              // -----------------------------------------------------------------
              Positioned(
                left: 262,
                top: 203,
                child: Container(
                  width: 158,
                  height: 158,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFF820D),
                    shape: OvalBorder(
                      side: BorderSide(
                        width: 1,
                        color: const Color(0xFFFF932F),
                      ),
                    ),
                  ),
                ),
              ),

              // -----------------------------------------------------------------
              // Rectangle1593: 画面下2/3のベージュ背景
              // -----------------------------------------------------------------
              Positioned(
                left: 0,
                right: 0,
                top: 280,
                bottom: 0,
                child: Container(
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFFDAC4),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 2,
                      color: const Color(0xFF000000)),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                  ),
                ),
              ),

              // -----------------------------------------------------------------
              // 「すでにアカウントをお持ちの方」セクションの区切り線
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
              // 区切り線上のラベル背景
              // -----------------------------------------------------------------
              Positioned(
                left: 84,
                top: 640,
                child: Container(
                  width: 224,
                  height: 18,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(color: const Color(0xFFFFDAC4)),
                ),
              ),

              // -----------------------------------------------------------------
              // 「すでにアカウントをお持ちの方」テキスト
              // -----------------------------------------------------------------
              Positioned(
                left: 80,
                top: 638,
                child: SizedBox(
                  width: 233,
                  child: Text(
                    'すでにアカウントをお持ちの方',
                    style: GoogleFonts.zenMaruGothic(
                      color: const Color(0xFFB9BFC9),
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      height: 1.20,
                    ),
                  ),
                ),
              ),

              // -----------------------------------------------------------------
              // サインインボタン
              // -----------------------------------------------------------------
              Positioned(
                left: 73,
                top: 531,
                child: GestureDetector(
                  onTap: () {
                    // サインイン処理（将来的に実装）
                    context.go('/');
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
                          'サインイン→',
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
              // ログインボタン
              // -----------------------------------------------------------------
              Positioned(
                left: 88,
                top: 678,
                child: GestureDetector(
                  onTap: () {
                    // ログインフォーム画面へ遷移
                    context.go('/login-form');
                  },
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 48),
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'ログイン→',
                          style: GoogleFonts.zenMaruGothic(
                            color: Colors.black,
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
              // キャッチコピー「もう忘れない！」
              // -----------------------------------------------------------------
              Positioned(
                left: 112,
                top: 332,
                child: Text(
                  'もう忘れない！',
                  style: GoogleFonts.zenMaruGothic(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    height: 1.20,
                  ),
                ),
              ),

              // -----------------------------------------------------------------
              // キャッチコピー「毎朝を自信満々に」
              // -----------------------------------------------------------------
              Positioned(
                left: 100,
                top: 361,
                child: Text(
                  '毎朝を自信満々に',
                  style: GoogleFonts.zenMaruGothic(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    height: 1.20,
                  ),
                ),
              ),

              // -----------------------------------------------------------------
              // 装飾用の円（右上・小）
              // -----------------------------------------------------------------
              Positioned(
                left: 282,
                top: 99,
                child: Container(
                  width: 59,
                  height: 59,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFF820D),
                    shape: OvalBorder(
                      side: BorderSide(
                        width: 1,
                        color: const Color(0xFFFF932F),
                      ),
                    ),
                  ),
                ),
              ),

              // -----------------------------------------------------------------
              // 装飾用の円（左上・大）
              // -----------------------------------------------------------------
              Positioned(
                left: 30,
                top: 58,
                child: Container(
                  width: 94,
                  height: 94,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFF820D),
                    shape: OvalBorder(
                      side: BorderSide(
                        width: 1,
                        color: const Color(0xFFFF932F),
                      ),
                    ),
                  ),
                ),
              ),

              // -----------------------------------------------------------------
              // アプリタイトル「Motteko」
              // -----------------------------------------------------------------
              Positioned(
                left: 114,
                top: 171,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 10,
                    children: [
                      Text(
                        'Motteko',
                        style: GoogleFonts.zenMaruGothic(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          height: 0.72,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // -----------------------------------------------------------------
              // アプリアイコン（白い角丸四角）
              // -----------------------------------------------------------------
              Positioned(
                left: 151,
                top: 81,
                child: Container(
                  width: 90,
                  height: 90,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19.69),
                    ),
                  ),
                  child: Image.asset(
                    'assets/icons/Motteko_rogo.png',
                    fit: BoxFit.cover,
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
