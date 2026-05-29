// =============================================================================
// login_screen.dart
// =============================================================================
// Figmaデザインに基づいたウェルカム画面。
// サインインとログインのボタンを配置し、アプリの初回起動時に表示されます。
// =============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

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
      backgroundColor: AppColors.primary700,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // 背景装飾（左上）
            Positioned(
              left: -20,
              top: -20,
              child: Container(
                width: 94,
                height: 94,
                decoration: const ShapeDecoration(
                  color: Color(0xFFFF820D),
                  shape: OvalBorder(
                    side: BorderSide(
                      width: 1,
                      color: Color(0xFFFF932F),
                    ),
                  ),
                ),
              ),
            ),
            // 背景装飾（右上）
            Positioned(
              right: 20,
              top: 20,
              child: Container(
                width: 59,
                height: 59,
                decoration: const ShapeDecoration(
                  color: Color(0xFFFF820D),
                  shape: OvalBorder(
                    side: BorderSide(
                      width: 1,
                      color: Color(0xFFFF932F),
                    ),
                  ),
                ),
              ),
            ),
            // 背景装飾（右下）
            Positioned(
              right: -30,
              bottom: 400,
              child: Container(
                width: 158,
                height: 158,
                decoration: const ShapeDecoration(
                  color: Color(0xFFFF820D),
                  shape: OvalBorder(
                    side: BorderSide(
                      width: 1,
                      color: Color(0xFFFF932F),
                    ),
                  ),
                ),
              ),
            ),

            Column(
              children: [
                _buildLogoSection(),
                _buildMenuSection(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Expanded(
      flex: 3,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(19.69),
                ),
              ),
              child: Image.asset('assets/icons/logo/Motteko_rogo.png', fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),
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
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Container(
        width: double.infinity,
        decoration: const ShapeDecoration(
          color: Color(0xFFFFDAC4),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2, color: Color(0xFF000000)),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 40),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(
                'もう忘れない！',
                style: GoogleFonts.zenMaruGothic(
                  color: Colors.black, fontSize: 24, fontWeight: FontWeight.w900, height: 1.20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                '毎朝を自信満々に',
                style: GoogleFonts.zenMaruGothic(
                  color: Colors.black, fontSize: 24, fontWeight: FontWeight.w900, height: 1.20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              _buildActionButton(
                onTap: () => context.push('/sign-in'),
                label: 'サインイン→',
                bgColor: AppColors.primary700,
                textColor: Colors.white,
              ),
              const SizedBox(height: 32),
              _buildDivider(),
              const SizedBox(height: 32),
              _buildActionButton(
                onTap: () => context.go('/login-form'),
                label: 'ログイン→',
                bgColor: Colors.white,
                textColor: Colors.black,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onTap,
    required String label,
    required Color bgColor,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 48),
        decoration: ShapeDecoration(
          color: bgColor,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 2.25),
            borderRadius: BorderRadius.circular(22.50),
          ),
          shadows: const [
            BoxShadow(color: Color(0xFF000000), blurRadius: 0, offset: Offset(3, 4.50)),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.zenMaruGothic(
              color: textColor, fontSize: 24, fontWeight: FontWeight.w900, height: 1.20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 2, color: const Color(0xFFB9BFC9))),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'すでにアカウントをお持ちの方',
              style: GoogleFonts.zenMaruGothic(
                color: const Color(0xFFB9BFC9), fontSize: 16, fontWeight: FontWeight.w900, height: 1.20,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Expanded(child: Container(height: 2, color: const Color(0xFFB9BFC9))),
      ],
    );
  }
}
