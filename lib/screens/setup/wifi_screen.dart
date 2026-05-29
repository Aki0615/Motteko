import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../services/ble_config_service.dart';

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
  String? _connectedSsid;

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
        const SnackBar(content: Text('SSIDを入力してください'), backgroundColor: Colors.red),
      );
      return;
    }
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('パスワードを入力してください'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isConnecting = true);

    try {
      await _bleService.sendWifiInfo(ssid, password);
      if (mounted) {
        setState(() => _connectedSsid = ssid);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wi-Fi設定を送信しました！'), backgroundColor: Colors.green),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 51),
                      if (_connectedSsid != null) ...[
                        _buildConnectedCard(),
                        const SizedBox(height: 24),
                      ],
                      const SizedBox(height: 40),
                      const Center(
                        child: Icon(Icons.wifi, size: 96, color: Color(0xFF508DFF)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'M5Stackに接続するWi-Fiの\nSSIDとパスワードを入力してください。',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.zenMaruGothic(
                          color: AppColors.gray500,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 1.40,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildInputCard(),
                      const SizedBox(height: 32),
                      _buildSubmitButton(),
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

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Wi-Fi',
          style: GoogleFonts.zenMaruGothic(
            color: AppColors.black1000,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            height: 1.20,
          ),
        ),
        Text(
          'Wi-Fiネットワークの管理',
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

  Widget _buildConnectedCard() {
    return Container(
      width: double.infinity,
      height: 88,
      padding: const EdgeInsets.symmetric(horizontal: 26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Color(0xFF22C55E), blurRadius: 5),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '接続済み',
            style: GoogleFonts.zenMaruGothic(
              color: const Color(0xFF22C55E),
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.20,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            _connectedSsid!,
            style: GoogleFonts.zenMaruGothic(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              height: 1.20,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F35291E),
            offset: Offset(1, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SSID（ネットワーク名）',
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
            child: TextField(
              controller: _ssidController,
              style: GoogleFonts.zenMaruGothic(fontSize: 16, fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                hintText: '例: MyWiFi_5G',
                hintStyle: GoogleFonts.zenMaruGothic(
                  color: const Color(0xFFB9C0C9),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
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
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: _isConnecting ? null : _sendWifiConfig,
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
                  'M5Stackに送信',
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
}
