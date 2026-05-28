import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const Color _accentOrange = Color(0xFFFF8C00);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 左上の装飾（クリーム色の大丸＋オレンジの小丸）
          Positioned(
            left: -85,
            top: -215,
            child: SizedBox(
              width: 360,
              height: 347,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 346.5,
                      height: 346.5,
                      decoration: const BoxDecoration(
                        color: AppColors.primary400,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 276,
                    top: 236,
                    child: Container(
                      width: 84,
                      height: 84,
                      decoration: const BoxDecoration(
                        color: AppColors.primary700,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 右下の装飾（オレンジの大丸＋ダークの小丸、180度回転）
          Positioned(
            right: -85,
            bottom: -215,
            child: Transform.rotate(
              angle: 3.14159,
              child: SizedBox(
                width: 360,
                height: 347,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 346.5,
                        height: 346.5,
                        decoration: const BoxDecoration(
                          color: AppColors.primary700,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 290.7,
                      top: 250.7,
                      child: Container(
                        width: 54.6,
                        height: 54.6,
                        decoration: const BoxDecoration(
                          color: AppColors.primary400,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // メインコンテンツ
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 52),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAppIcon(),
                      const SizedBox(height: 7),
                      Text(
                        'Motteko',
                        style: GoogleFonts.zenMaruGothic(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: AppColors.black1000,
                          height: 0.6,
                        ),
                      ),
                      const SizedBox(height: 53),
                      Text(
                        '忘れ物を減らす。',
                        style: GoogleFonts.zenMaruGothic(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black1000,
                          height: 0.9,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '毎日の持ち物を、もっと自然に。',
                        style: GoogleFonts.zenMaruGothic(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black1000,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 25),
                      _buildIllustration(),
                      const SizedBox(height: 25),
                      _buildStartButton(context),
                      const SizedBox(height: 20),
                      _buildLoginLink(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppIcon() {
    return SizedBox(
      width: 71,
      height: 70,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 69,
            height: 69,
            decoration: BoxDecoration(
              color: AppColors.primary400,
              borderRadius: BorderRadius.circular(35),
            ),
            child: Center(
              child: Image.asset(
                'assets/icons/Motteko_rogo2.png',
                width: 40,
                height: 40,
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 2,
            child: Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(
                color: _accentOrange,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    return SizedBox(
      width: 228,
      height: 175,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset(
            'assets/images/welcome/illustration.png',
            width: 228,
            height: 175,
            fit: BoxFit.contain,
          ),
          Positioned(
            left: 3,
            top: 92,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: _accentOrange,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 2,
            top: 51,
            child: Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(
                color: _accentOrange,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () => context.push('/sign-in'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.black1000,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          elevation: 0,
        ),
        child: Text(
          'はじめる',
          style: GoogleFonts.zenMaruGothic(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/login-form'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.gray500, width: 1),
          ),
        ),
        child: Text(
          'ログインはこちら',
          style: GoogleFonts.zenMaruGothic(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.gray500,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
