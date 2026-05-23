import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  static const Color _darkText = Color(0xFF373735);
  static const Color _gray500 = Color(0xFF6B7280);
  static const Color _iconBg = Color(0xFFFFE9C9);
  static const Color _accentOrange = Color(0xFFFF8C00);
  static const Color _primaryOrange = Color(0xFFFF7B00);
  static const Color _cardBg = Color(0xFFFFF6E8);
  static const Color _inputBg = Color(0xFFF9FAFB);
  static const Color _inputBorder = Color(0xFFD1D5DB);
  static const Color _placeholder = Color(0xFF9CA3AF);

  bool _isAgreed = false;
  bool _isLoading = false;
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
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
                      color: _iconBg,
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
                        color: _primaryOrange,
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
                        color: _primaryOrange,
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
                          color: _darkText,
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
                          color: _darkText,
                          height: 0.6,
                        ),
                      ),
                      const SizedBox(height: 37),
                      _buildSignUpCard(),
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
              color: _iconBg,
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

  Widget _buildSignUpCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
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
                  text: 'ようこそ！\n',
                  style: GoogleFonts.zenMaruGothic(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                TextSpan(
                  text: '仲間になろう',
                  style: GoogleFonts.zenMaruGothic(
                    color: _primaryOrange,
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
          const SizedBox(height: 23),
          // パスワード（確認）
          Text(
            'パスワード（確認）',
            style: GoogleFonts.zenMaruGothic(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 5),
          _buildInputField(
            controller: _passwordConfirmController,
            hintText: 'パスワードを再入力',
            obscureText: true,
          ),
          const SizedBox(height: 5),
          // 利用規約チェックボックス
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _isAgreed = !_isAgreed),
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: _isAgreed ? _primaryOrange : Colors.white,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      color: _isAgreed ? _primaryOrange : _inputBorder,
                    ),
                  ),
                  child: _isAgreed
                      ? const Icon(Icons.check, color: Colors.white, size: 12)
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '利用規約',
                        style: GoogleFonts.zenMaruGothic(
                          color: _primaryOrange,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => context.push('/terms-of-service'),
                      ),
                      TextSpan(
                        text: 'と',
                        style: GoogleFonts.zenMaruGothic(
                          color: _gray500,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: 'プライバシーポリシー',
                        style: GoogleFonts.zenMaruGothic(
                          color: _primaryOrange,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => context.push('/privacy-settings'),
                      ),
                      TextSpan(
                        text: 'に同意します',
                        style: GoogleFonts.zenMaruGothic(
                          color: _gray500,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 23),
          // サインインボタン
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleSignUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: _darkText,
                foregroundColor: Colors.white,
                disabledBackgroundColor: _darkText.withAlpha(180),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                elevation: 0,
              ),
              child: Text(
                _isLoading ? '接続中...' : 'サインイン',
                style: GoogleFonts.zenMaruGothic(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
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
            borderSide: const BorderSide(color: _primaryOrange),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 0,
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final passwordConfirm = _passwordConfirmController.text;

    if (email.isEmpty || password.isEmpty || passwordConfirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('すべての項目を入力してください'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (password != passwordConfirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('パスワードが一致しません'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (!_isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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
        nickname: '',
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
