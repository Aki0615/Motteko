import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

/// プライバシー設定画面
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
                  Text(
                    'プライバシー',
                    style: GoogleFonts.zenMaruGothic(
                      color: const Color(0xFFFF7B00),
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
            // データ収集・利用セクション
            // ============================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 29),
              child: Text(
                'データ収集・利用',
                style: GoogleFonts.zenMaruGothic(
                  color: const Color(0xFF6B7280),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1.20,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
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
                    _buildPrivacyItem(
                      label: '利用状況の共有',
                      description: 'アプリ改善のため匿名データを送信',
                      value: _usageSharing,
                      onChanged: (v) => setState(() => _usageSharing = v),
                    ),
                    _buildDivider(),
                    _buildPrivacyItem(
                      label: '位置情報',
                      description: '位置情報の使用を許可',
                      value: _locationAccess,
                      onChanged: (v) => setState(() => _locationAccess = v),
                    ),
                    _buildDivider(),
                    _buildPrivacyItem(
                      label: 'カメラへのアクセス',
                      description: '全ての通知のオン/オフ',
                      value: _cameraAccess,
                      onChanged: (v) => setState(() => _cameraAccess = v),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ============================================================
            // プライバシーポリシー
            // ============================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: GestureDetector(
                onTap: () {
                  // TODO: プライバシーポリシーページへ遷移
                },
                child: Container(
                  width: double.infinity,
                  height: 64,
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
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ============================================================
            // アカウントを削除
            // ============================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: GestureDetector(
                onTap: () {
                  // TODO: アカウント削除処理
                },
                child: Container(
                  width: double.infinity,
                  height: 64,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side:
                          BorderSide(width: 2, color: const Color(0xFFEF4444)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0xFFEF4444),
                        blurRadius: 0,
                        offset: Offset(2, 3),
                        spreadRadius: 0,
                      )
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
              ),
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  // プライバシーアイテム
  Widget _buildPrivacyItem({
    required String label,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SizedBox(
      height: 52,
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
                    color: const Color(0xFFB9BFC9),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    height: 1.53,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFFFF7B00),
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
