import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../services/ble_config_service.dart';

class WifiPasswordScreen extends StatefulWidget {
  final String networkName;

  const WifiPasswordScreen({super.key, required this.networkName});

  @override
  State<WifiPasswordScreen> createState() => _WifiPasswordScreenState();
}

class _WifiPasswordScreenState extends State<WifiPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final BleConfigService _bleService = BleConfigService();
  bool _obscurePassword = true;
  bool _isConnecting = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            left: -85,
            top: -215,
            width: 360,
            height: 346.5,
            child: SvgPicture.asset(
              'assets/icons/common/items_bg_decoration.svg',
              fit: BoxFit.fill,
            ),
          ),
          SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: _buildHeader(),
                    ),
                    const SizedBox(height: 90),
                    const Center(
                      child: Icon(Icons.wifi, size: 96, color: Color(0xFF508DFF)),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        '"${widget.networkName}"に接続',
                        style: GoogleFonts.zenMaruGothic(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          height: 1.20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: SizedBox(
                        width: 258,
                        child: Text(
                          'このWi-Fiネットワークに接続するには、パスワードを入力してください。',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.zenMaruGothic(
                            color: AppColors.gray500,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            height: 1.20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 46),
                      child: _buildPasswordInput(),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 46),
                      child: _buildConnectButton(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Wi-Fi接続',
          style: GoogleFonts.zenMaruGothic(
            color: AppColors.black1000,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            height: 1.20,
          ),
        ),
        Text(
          'ネットワークに接続',
          style: GoogleFonts.zenMaruGothic(
            color: AppColors.black1000,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.20,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'パスワード',
          style: GoogleFonts.zenMaruGothic(
            color: AppColors.gray500,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.20,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: GoogleFonts.zenMaruGothic(fontSize: 16, fontWeight: FontWeight.w700),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    hintText: 'パスワードを入力',
                    hintStyle: GoogleFonts.zenMaruGothic(
                      color: const Color(0xFFB9C0C9),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    size: 20,
                    color: const Color(0xFFB9C0C9),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConnectButton() {
    return GestureDetector(
      onTap: _isConnecting ? null : _handleConnect,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: _isConnecting ? Colors.grey : AppColors.black1000,
          borderRadius: BorderRadius.circular(99999),
        ),
        child: Center(
          child: _isConnecting
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                )
              : Text(
                  '接続',
                  style: GoogleFonts.zenMaruGothic(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    height: 1.20,
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _handleConnect() async {
    final password = _passwordController.text;
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('パスワードを入力してください'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isConnecting = true);
    try {
      await _bleService.sendWifiInfo(widget.networkName, password);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('設定を送信しました！'), backgroundColor: Colors.green),
        );
        context.push('/device-id-input');
      }
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
      if (mounted) setState(() => _isConnecting = false);
    }
  }
}
