import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const Color _primaryOrange = Color(0xFFFF7B00);
  static const Color _peach = Color(0xFFFFDAC4);
  static const Color _gray = Color(0xFFAAACB4);
  static const Color _black = Color(0xFF000000);
  static const Color _white = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primaryOrange,
      body: Stack(
        children: [
          // Decorative circles in the orange header area
          const _DecorativeCircles(),
          Column(
            children: [
              // Orange header section with logo
              Expanded(
                flex: 3,
                child: _buildHeader(),
              ),
              // Peach card section
              Expanded(
                flex: 5,
                child: _buildCard(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          // App icon
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: _white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.inventory_2_rounded,
              size: 56,
              color: _primaryOrange,
            ),
          ),
          const SizedBox(height: 12),
          // App name
          const Text(
            'Motteko',
            style: TextStyle(
              fontFamily: 'ZenMaruGothic',
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: _white,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _peach,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        border: Border(
          top: BorderSide(color: _black, width: 2),
          left: BorderSide(color: _black, width: 2),
          right: BorderSide(color: _black, width: 2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 48),
            // Tagline
            const Text(
              'もう忘れない！',
              style: TextStyle(
                fontFamily: 'ZenMaruGothic',
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: _black,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            const Text(
              '毎朝を自信満々に',
              style: TextStyle(
                fontFamily: 'ZenMaruGothic',
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: _black,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            // Sign-in button
            _MottekoButton(
              label: 'サインイン→',
              backgroundColor: _primaryOrange,
              textColor: _white,
              onTap: () {
                context.push('/sign-in'); // Change to go or push
              },
            ),
            const SizedBox(height: 32),
            // Divider with label
            Row(
              children: [
                const Expanded(child: Divider(color: _gray, thickness: 1)),
                const SizedBox(width: 8),
                const Text(
                  'すでにアカウントをお持ちの方',
                  style: TextStyle(
                    fontFamily: 'ZenMaruGothic',
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: _gray,
                    height: 1.2,
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(child: Divider(color: _gray, thickness: 1)),
              ],
            ),
            const SizedBox(height: 20),
            // Login button
            _MottekoButton(
              label: 'ログイン→',
              backgroundColor: _white,
              textColor: _black,
              onTap: () {
                context.go('/login-form'); // Change to go instead of login (login form is more appropriate for UI path)
              },
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

class _DecorativeCircles extends StatelessWidget {
  const _DecorativeCircles();

  static const Color _darkOrange = Color(0xFFFF820D);
  static const Color _orangeStroke = Color(0xFFFF942F);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Large circle (bottom-right of header)
        Positioned(
          right: -20,
          top: 130,
          child: _circle(158, _darkOrange, _orangeStroke),
        ),
        // Small circle (right side, upper)
        Positioned(
          right: 40,
          top: 60,
          child: _circle(59, _darkOrange, _orangeStroke),
        ),
        // Medium circle (left side)
        Positioned(
          left: -20,
          top: 20,
          child: _circle(94, _darkOrange, _orangeStroke),
        ),
      ],
    );
  }

  Widget _circle(double size, Color fill, Color stroke) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fill,
        border: Border.all(color: stroke, width: 1),
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

  static const Color _black = Color(0xFF000000);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(22.5),
          border: Border.all(color: _black, width: 2.25),
          boxShadow: const [
            BoxShadow(
              color: _black,
              offset: Offset(3, 4.5),
              blurRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'ZenMaruGothic',
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: textColor,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
