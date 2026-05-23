import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_colors.dart';

/// 通知設定画面
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
  bool _sensorDetectionEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================================================
            // ヘッダー
            // ============================================================
            Container(
              width: double.infinity,
              height: 60,
              margin: const EdgeInsets.only(top: 48),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 2, color: Colors.black),
                ),
              ),
              child: Row(
                children: [
                  // 戻るボタン
                  GestureDetector(
                    onTap: () => context.go('/settings'),
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFB9BFC9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 「通知」テキスト
                  Text(
                    '通知',
                    style: GoogleFonts.zenMaruGothic(
                      color: AppColors.primary700,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      height: 0.90,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ============================================================
            // プッシュ通知セクション
            // ============================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Text(
                'プッシュ通知',
                style: GoogleFonts.zenMaruGothic(
                  color: AppColors.gray500,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1.20,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Container(
                width: double.infinity,
                height: 76,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2, color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0xFF000000),
                      blurRadius: 0,
                      offset: Offset(2, 3),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      // 赤アイコンボックス
                      Container(
                        width: 40,
                        height: 40,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF44F4F),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1.50, color: Colors.black),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0xFF000000),
                              blurRadius: 0,
                              offset: Offset(2, 3),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: const Icon(Icons.notifications_outlined,
                            size: 24, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      // テキスト
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '通知を許可',
                              style: GoogleFonts.zenMaruGothic(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                height: 1.20,
                              ),
                            ),
                            Text(
                              '全ての通知のオン/オフ',
                              style: GoogleFonts.zenMaruGothic(
                                color: const Color(0xFFB9BFC9),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                height: 1.53,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // トグルスイッチ
                      Switch(
                        value: _notificationsEnabled,
                        onChanged: (value) {
                          setState(() {
                            _notificationsEnabled = value;
                          });
                        },
                        activeColor: Colors.white,
                        activeTrackColor: AppColors.primary700,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: const Color(0xFFB9BFC9),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ============================================================
            // 通知の種類セクション
            // ============================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 29),
              child: Text(
                '通知の種類',
                style: GoogleFonts.zenMaruGothic(
                  color: AppColors.gray500,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1.20,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2, color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0xFF000000),
                      blurRadius: 0,
                      offset: Offset(2, 3),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 忘れ物無し通知
                    _buildNotificationTypeItem(
                      iconColor: AppColors.success,
                      icon: Icons.check,
                      label: '忘れ物無し通知',
                      description: '全ての通知のオン/オフ',
                      value: _noForgottenItemsEnabled,
                      onChanged: (v) =>
                          setState(() => _noForgottenItemsEnabled = v),
                    ),
                    _buildDivider(),
                    // 忘れ物警告
                    _buildNotificationTypeItem(
                      iconColor: const Color(0xFFFFECA0),
                      icon: Icons.warning_amber_rounded,
                      iconIconColor: const Color(0xFFD97706),
                      label: '忘れ物警告',
                      description: '全ての通知のオン/オフ',
                      value: _forgottenWarningEnabled,
                      onChanged: (v) =>
                          setState(() => _forgottenWarningEnabled = v),
                    ),
                    _buildDivider(),
                    // センサー検知
                    _buildNotificationTypeItem(
                      iconColor: const Color(0xFFC1E5FF),
                      icon: Icons.sensors,
                      iconIconColor: const Color(0xFF2563EB),
                      label: 'センサー検知',
                      description: '全ての通知のオン/オフ',
                      value: _sensorDetectionEnabled,
                      onChanged: (v) =>
                          setState(() => _sensorDetectionEnabled = v),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  // 通知種類アイテム
  Widget _buildNotificationTypeItem({
    required Color iconColor,
    required IconData icon,
    Color? iconIconColor,
    required String label,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          // カラーアイコンボックス
          Container(
            width: 40,
            height: 40,
            decoration: ShapeDecoration(
              color: iconColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.50, color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0xFF000000),
                  blurRadius: 0,
                  offset: Offset(2, 3),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Icon(icon, size: 20, color: iconIconColor ?? Colors.white),
          ),
          const SizedBox(width: 16),
          // テキスト
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
                    color: const Color(0xFFB9BFC9),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    height: 1.53,
                  ),
                ),
              ],
            ),
          ),
          // トグルスイッチ
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: AppColors.primary700,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFB9BFC9),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  // 区切り線
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        width: double.infinity,
        height: 2,
        color: const Color(0xFFB9BFC9),
      ),
    );
  }
}
