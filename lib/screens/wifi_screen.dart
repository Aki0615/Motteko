import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_colors.dart';
import '../services/ble_config_service.dart';

/// Wi-Fi設定画面（SSID・パスワード手入力方式）
class WifiScreen extends StatefulWidget {
  const WifiScreen({super.key});

  @override
  State<WifiScreen> createState() => _WifiScreenState();
}

class _WifiScreenState extends State<WifiScreen> {
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final BleConfigService _bleService = BleConfigService();
  bool _obscurePassword = true;
  bool _isConnecting = false;

  @override
  void dispose() {
    _ssidController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _sendWifiConfig() async {
    final ssid = _ssidController.text.trim();
    final password = _passwordController.text;

    if (ssid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('SSIDを入力してください'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('パスワードを入力してください'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isConnecting = true);

    try {
      await _bleService.sendWifiInfo(ssid, password);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wi-Fi設定を送信しました！'),
            backgroundColor: Colors.green,
          ),
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
      if (mounted) {
        setState(() => _isConnecting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 40),
              const Center(
                child: Icon(Icons.wifi, size: 96, color: Color(0xFF26A5FF)),
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: 280,
                  child: Text(
                    'M5Stackに接続するWi-Fiの\nSSIDとパスワードを入力してください。',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.zenMaruGothic(
                      color: AppColors.gray500,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.40,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildSsidField(),
              const SizedBox(height: 20),
              _buildPasswordField(),
              const SizedBox(height: 40),
              _buildSubmitButton(),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.only(top: 48),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 2, color: Colors.black)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.go('/settings'),
            child: Container(
              width: 35,
              height: 35,
              decoration: ShapeDecoration(
                color: const Color(0xFFB9BFC9),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
              ),
              child: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Wi-Fi',
            style: GoogleFonts.zenMaruGothic(
              color: AppColors.primary700,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              height: 0.90,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSsidField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 57),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SSID（ネットワーク名）',
            style: GoogleFonts.zenMaruGothic(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              height: 1.20,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.gray200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _ssidController,
              style: GoogleFonts.zenMaruGothic(fontSize: 16, fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                hintText: '例: MyWiFi_5G',
                hintStyle: GoogleFonts.zenMaruGothic(
                  color: const Color(0xFFB9BFC9),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 57),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'パスワード',
            style: GoogleFonts.zenMaruGothic(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              height: 1.20,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.gray200,
              borderRadius: BorderRadius.circular(8),
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
                        color: const Color(0xFFB9BFC9),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
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
                      size: 24,
                      color: const Color(0xFFB9BFC9),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 57),
      child: GestureDetector(
        onTap: _isConnecting ? null : _sendWifiConfig,
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: ShapeDecoration(
            color: _isConnecting ? Colors.grey : AppColors.primary700,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 2, color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            shadows: const [
              BoxShadow(color: Color(0xFF000000), blurRadius: 0, offset: Offset(2, 3)),
            ],
          ),
          child: Center(
            child: _isConnecting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                  )
                : Text(
                    'M5Stackに送信',
                    style: GoogleFonts.zenMaruGothic(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      height: 1.20,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
