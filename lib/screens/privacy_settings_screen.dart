import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/constants/app_colors.dart';
import '../services/auth_service.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _usageSharing = true;
  bool _locationAccess = true;
  bool _cameraAccess = true;

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 60),
                    _buildSectionLabel('データ収集・利用'),
                    const SizedBox(height: 4),
                    _buildDataCollectionCard(),
                    const SizedBox(height: 34),
                    _buildPrivacyPolicyCard(),
                    const SizedBox(height: 34),
                    _buildDeleteAccountCard(context),
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
          'プライバシー',
          style: GoogleFonts.zenMaruGothic(
            color: AppColors.black1000,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            height: 1.20,
          ),
        ),
        Text(
          'データ収集と権限の管理',
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

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.zenMaruGothic(
        color: AppColors.gray500,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        height: 1.20,
      ),
    );
  }

  Widget _buildDataCollectionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F35291E),
            offset: Offset(1, 2),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildPrivacyRow(
            label: '利用状況の共有',
            description: 'アプリ改善のため匿名データを送信',
            value: _usageSharing,
            onChanged: (v) => setState(() => _usageSharing = v),
          ),
          _buildDivider(),
          _buildPrivacyRow(
            label: '位置情報',
            description: '位置情報の使用を許可',
            value: _locationAccess,
            onChanged: (v) => setState(() => _locationAccess = v),
          ),
          _buildDivider(),
          _buildPrivacyRow(
            label: 'カメラへのアクセス',
            description: '全ての通知のオン/オフ',
            value: _cameraAccess,
            onChanged: (v) => setState(() => _cameraAccess = v),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyRow({
    required String label,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.zenMaruGothic(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    height: 1.20,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.zenMaruGothic(
                    color: const Color(0xFFB9C0C9),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    height: 1.20,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.primary700,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFB9C0C9),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        width: double.infinity,
        height: 1,
        color: const Color(0xFFE5E7EB),
      ),
    );
  }

  Widget _buildPrivacyPolicyCard() {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F35291E),
            offset: Offset(1, 2),
            blurRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          'プライバシーポリシー',
          style: GoogleFonts.zenMaruGothic(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            height: 1.20,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteAccountCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDeleteAccountDialog(context),
      child: Container(
        width: double.infinity,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(color: Color(0xFFEF444D), blurRadius: 5, spreadRadius: 0),
          ],
        ),
        child: Center(
          child: Text(
            'アカウントを削除',
            style: GoogleFonts.zenMaruGothic(
              color: const Color(0xFFEF4444),
              fontSize: 24,
              fontWeight: FontWeight.w900,
              height: 1.20,
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'アカウントを削除',
            style: GoogleFonts.zenMaruGothic(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w900),
          ),
          content: Text(
            '本当にアカウントを削除しますか？この操作は取り消せません。',
            style: GoogleFonts.zenMaruGothic(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'キャンセル',
                style: GoogleFonts.zenMaruGothic(
                  color: const Color(0xFFB9C0C9), fontSize: 16, fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                try {
                  await AuthService().currentUser?.delete();
                } catch (_) {}
              },
              child: Text(
                '削除する',
                style: GoogleFonts.zenMaruGothic(
                  color: const Color(0xFFEF4444), fontSize: 16, fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
