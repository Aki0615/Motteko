import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../services/auth_service.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  static const Color _accentOrange = Color(0xFFFF8C00);
  static const Color _cardBg = Color(0xFFFFF6E8);
  static const Color _inputBg = Color(0xFFF9FAFB);
  static const Color _inputBorder = Color(0xFFD1D5DB);
  static const Color _placeholder = Color(0xFF9CA3AF);

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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 左上の装飾
          Positioned(
            left: -85,
            top: -215,
            child: SizedBox(
              width: 360,
              height: 347,
              child: Stack(
                children: [
                  Container(
                    width: 346.5,
                    height: 346.5,
                    decoration: const BoxDecoration(
                      color: AppColors.primary400,
                      shape: BoxShape.circle,
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
          // 右下の装飾
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
                    Container(
                      width: 346.5,
                      height: 346.5,
                      decoration: const BoxDecoration(
                        color: AppColors.primary700,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Positioned(
                      left: 290.7,
                      top: 250.7,
                      child: Container(
                        width: 54.6,
                        height: 54.6,
                        decoration: const BoxDecoration(
                          color: AppColors.black1000,
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
                  padding: const EdgeInsets.symmetric(horizontal: 38),
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
                      const SizedBox(height: 37),
                      _buildLoginCard(),
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
                'assets/icons/logo/Motteko_rogo2.png',
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

  Widget _buildLoginCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 35),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // タイトル
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'おかえり！\n',
                  style: GoogleFonts.zenMaruGothic(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                TextSpan(
                  text: 'また会えたね',
                  style: GoogleFonts.zenMaruGothic(
                    color: AppColors.primary700,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 23),
          // メールアドレス
          Text(
            'メールアドレス',
            style: GoogleFonts.zenMaruGothic(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 5),
          _buildInputField(
            controller: _emailController,
            hintText: 'メールアドレスを入力',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 23),
          // パスワード
          Text(
            'パスワード',
            style: GoogleFonts.zenMaruGothic(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 5),
          _buildInputField(
            controller: _passwordController,
            hintText: 'パスワードを入力',
            obscureText: true,
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'パスワードを忘れた方はこちら',
              style: GoogleFonts.zenMaruGothic(
                color: AppColors.primary700,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 23),
          // ログインボタン
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.black1000,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.black1000.withAlpha(180),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                elevation: 0,
              ),
              child: Text(
                _isLoading ? '接続中...' : 'ログイン',
                style: GoogleFonts.zenMaruGothic(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 23),
          // 新規登録リンク
          Center(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'アカウントがない方は',
                    style: GoogleFonts.zenMaruGothic(
                      color: AppColors.gray500,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                  TextSpan(
                    text: '新規登録',
                    style: GoogleFonts.zenMaruGothic(
                      color: AppColors.primary700,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => context.push('/sign-in'),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
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
      height: 35,
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
            color: _placeholder,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: _inputBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _inputBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _inputBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primary700),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 0,
          ),
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
}
