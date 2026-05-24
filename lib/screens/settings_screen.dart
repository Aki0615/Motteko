import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/constants/app_colors.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
    final nickname = user?.displayName ?? '未設定';
    final email = user?.email ?? '未設定';
    final userInitial = nickname.isNotEmpty ? nickname[0] : '?';

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
                    const SizedBox(height: 51),
                    _buildProfileCard(userInitial, nickname, email),
                    const SizedBox(height: 32),
                    _buildSectionLabel('デバイス・接続'),
                    const SizedBox(height: 11),
                    _buildDeviceCard(context),
                    const SizedBox(height: 32),
                    _buildNotificationPrivacyCard(context),
                    const SizedBox(height: 32),
                    _buildTermsCard(context),
                    const SizedBox(height: 32),
                    _buildLogoutCard(context),
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
          '設定',
          style: GoogleFonts.zenMaruGothic(
            color: AppColors.black1000,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            height: 1.20,
          ),
        ),
        Text(
          'アカウントとアプリの設定を管理',
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

  Widget _buildProfileCard(String userInitial, String nickname, String email) {
    return Container(
      width: double.infinity,
      height: 88,
      padding: const EdgeInsets.only(left: 13),
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
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              color: AppColors.primary700,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Color(0x40000000), blurRadius: 2.5),
              ],
            ),
            child: Center(
              child: Text(
                userInitial,
                style: GoogleFonts.zenMaruGothic(
                  color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, height: 1,
                ),
              ),
            ),
          ),
          const SizedBox(width: 27),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nickname,
                  style: GoogleFonts.zenMaruGothic(
                    color: Colors.black, fontSize: 20, fontWeight: FontWeight.w900, height: 1.20,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: GoogleFonts.zenMaruGothic(
                    color: AppColors.gray500, fontSize: 14, fontWeight: FontWeight.w700, height: 1.20,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.zenMaruGothic(
        color: AppColors.gray500, fontSize: 14, fontWeight: FontWeight.w700, height: 1.20,
      ),
    );
  }

  Widget _buildDeviceCard(BuildContext context) {
    return _buildCard(
      height: 136,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSettingsRow(
            iconColor: const Color(0xFF508DFF),
            icon: Icons.wifi,
            label: 'Wi-Fi',
            onTap: () => context.push('/wifi'),
          ),
          _buildDivider(),
          _buildSettingsRow(
            iconColor: const Color(0xFF508DFF),
            icon: Icons.bluetooth,
            label: 'Bluetooth',
            onTap: () => context.push('/bluetooth'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationPrivacyCard(BuildContext context) {
    return _buildCard(
      height: 136,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSettingsRow(
            iconColor: const Color(0xFFEF4444),
            icon: Icons.notifications_outlined,
            label: '通知',
            onTap: () => context.push('/notification-settings'),
          ),
          _buildDivider(),
          _buildSettingsRow(
            iconColor: const Color(0xFF508DFF),
            icon: Icons.pan_tool_outlined,
            label: 'プライバシー',
            onTap: () => context.push('/privacy-settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/terms-of-service'),
      child: _buildCard(
        height: 64,
        child: Center(
          child: Text(
            '利用規約',
            style: GoogleFonts.zenMaruGothic(
              color: AppColors.black1000,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              height: 1.20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLogoutDialog(context),
      child: Container(
        width: double.infinity,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(color: Color(0xFFEF4444), blurRadius: 5),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, size: 24, color: Color(0xFFEF4444)),
            Text(
              'ログアウト',
              style: GoogleFonts.zenMaruGothic(
                color: const Color(0xFFEF4444),
                fontSize: 24,
                fontWeight: FontWeight.w900,
                height: 1.20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required double height, required Widget child}) {
    return Container(
      width: double.infinity,
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Color(0x40000000), blurRadius: 5),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSettingsRow({
    required Color iconColor,
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 24, color: Colors.white),
            ),
            const SizedBox(width: 28),
            Text(
              label,
              style: GoogleFonts.zenMaruGothic(
                color: AppColors.black1000,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                height: 1.20,
              ),
            ),
          ],
        ),
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

  void _showLogoutDialog(BuildContext context) {
    final user = AuthService().currentUser;
    final nickname = user?.displayName ?? '未設定';
    final email = user?.email ?? '未設定';
    final userInitial = nickname.isNotEmpty ? nickname[0] : '?';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 19),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 66,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.logout, size: 48, color: Colors.white),
              ),
              const SizedBox(height: 15),
              Text(
                'ログアウトしますか？',
                style: GoogleFonts.zenMaruGothic(
                  color: AppColors.black1000,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  height: 1.20,
                ),
              ),
              Text(
                'ログアウトすると、次回起動時に再度サインインが必要になります',
                textAlign: TextAlign.center,
                style: GoogleFonts.zenMaruGothic(
                  color: const Color(0xFFB9C0C9),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  height: 1.20,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: double.infinity,
                height: 88,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(color: Color(0x40000000), blurRadius: 5),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        color: AppColors.primary700,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          userInitial,
                          style: GoogleFonts.zenMaruGothic(
                            color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, height: 1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 27),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nickname,
                            style: GoogleFonts.zenMaruGothic(
                              color: AppColors.black1000, fontSize: 20, fontWeight: FontWeight.w900, height: 1.20,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            email,
                            style: GoogleFonts.zenMaruGothic(
                              color: AppColors.gray500, fontSize: 14, fontWeight: FontWeight.w700, height: 1.20,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  await AuthService().signOut();
                  if (context.mounted) context.go('/login');
                },
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(99999),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.logout, size: 24, color: Colors.white),
                      Text(
                        'ログアウト',
                        style: GoogleFonts.zenMaruGothic(
                          color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, height: 1.20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 11),
              GestureDetector(
                onTap: () => Navigator.of(sheetContext).pop(),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(99999),
                  ),
                  child: Center(
                    child: Text(
                      'キャンセル',
                      style: GoogleFonts.zenMaruGothic(
                        color: AppColors.black1000, fontSize: 24, fontWeight: FontWeight.w900, height: 1.20,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }
}
