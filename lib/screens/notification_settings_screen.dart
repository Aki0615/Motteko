import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/constants/app_colors.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _noForgottenItemsEnabled = true;
  bool _forgottenWarningEnabled = true;

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
              'assets/icons/items_bg_decoration.svg',
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
                    const SizedBox(height: 57),
                    _buildSectionLabel('プッシュ通知'),
                    const SizedBox(height: 4),
                    _buildPushNotificationCard(),
                    const SizedBox(height: 28),
                    _buildSectionLabel('通知の種類'),
                    const SizedBox(height: 4),
                    _buildNotificationTypesCard(),
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
          '通知',
          style: GoogleFonts.zenMaruGothic(
            color: AppColors.black1000,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            height: 1.20,
          ),
        ),
        Text(
          '通知設定を管理',
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

  Widget _buildPushNotificationCard() {
    return Container(
      width: double.infinity,
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Color(0x40000000), blurRadius: 5),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF45050),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(color: Color(0x40000000), blurRadius: 2.5),
              ],
            ),
            child: const Icon(Icons.notifications_outlined, size: 24, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '通知を許可',
                  style: GoogleFonts.zenMaruGothic(
                    color: AppColors.black1000,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    height: 1.20,
                  ),
                ),
                Text(
                  '全ての通知のオン/オフ',
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
            value: _notificationsEnabled,
            onChanged: (value) => setState(() => _notificationsEnabled = value),
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

  Widget _buildNotificationTypesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Color(0x40000000), blurRadius: 5),
        ],
      ),
      child: Column(
        children: [
          _buildNotificationTypeRow(
            label: '忘れ物無し通知',
            description: '全ての通知のオン/オフ',
            value: _noForgottenItemsEnabled,
            onChanged: (v) => setState(() => _noForgottenItemsEnabled = v),
          ),
          _buildDivider(),
          _buildNotificationTypeRow(
            label: '忘れ物警告',
            description: '全ての通知のオン/オフ',
            value: _forgottenWarningEnabled,
            onChanged: (v) => setState(() => _forgottenWarningEnabled = v),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTypeRow({
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
                    color: AppColors.black1000,
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
}
