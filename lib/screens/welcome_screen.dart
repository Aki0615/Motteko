import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const Color _primaryOrange = Color(0xFFFF7B00);
  static const Color _peach = Color(0xFFFFDAC4);
  static const Color _gray = Color(0xFFB9BFC9);
  static const Color _black = Color(0xFF000000);
  static const Color _white = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primaryOrange,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            const _DecorativeCircles(),
            Column(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildHeader(),
                ),
                Expanded(
                  flex: 5,
                  child: _buildCard(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: _white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(19.69),
              ),
            ),
            child: Image.asset(
              'assets/icons/Motteko_rogo.png',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Motteko',
            style: GoogleFonts.zenMaruGothic(
              color: _white,
              fontSize: 40,
              fontWeight: FontWeight.w900,
              height: 0.72,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const ShapeDecoration(
        color: _peach,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2, color: _black),
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
                color: _black,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                height: 1.20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '毎朝を自信満々に',
              style: GoogleFonts.zenMaruGothic(
                color: _black,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                height: 1.20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            _MottekoButton(
              label: 'サインイン→',
              backgroundColor: _primaryOrange,
              textColor: _white,
              onTap: () => context.push('/sign-in'),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: Container(height: 2, color: _gray),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'すでにアカウントをお持ちの方',
                    style: GoogleFonts.zenMaruGothic(
                      color: _gray,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      height: 1.20,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(height: 2, color: _gray),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _MottekoButton(
              label: 'ログイン→',
              backgroundColor: _white,
              textColor: _black,
              onTap: () => context.go('/login-form'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _DecorativeCircles extends StatelessWidget {
  const _DecorativeCircles();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: -20,
          top: -20,
          child: _circle(94),
        ),
        Positioned(
          right: 20,
          top: 20,
          child: _circle(59),
        ),
        Positioned(
          right: -30,
          bottom: 400,
          child: _circle(158),
        ),
      ],
    );
  }

  Widget _circle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const ShapeDecoration(
        color: Color(0xFFFF820D),
        shape: OvalBorder(
          side: BorderSide(width: 1, color: Color(0xFFFF932F)),
        ),
      ),
    );
  }
}

class _MottekoButton extends StatelessWidget {
  const _MottekoButton({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 48),
        decoration: ShapeDecoration(
          color: backgroundColor,
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
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.zenMaruGothic(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              height: 1.20,
            ),
          ),
        ),
      ),
    );
  }
}
