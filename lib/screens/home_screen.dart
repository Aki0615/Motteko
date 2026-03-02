import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../providers/app_state.dart';

/// ホーム画面
/// アプリのメイン画面で、統計情報と最近の通知を表示します。
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Stack(
        children: [
          // オレンジ背景ヘッダー
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            child: Container(
              height: 367,
              decoration: ShapeDecoration(
                color: const Color(0xFFFF7B00),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 2),
                ),
              ),
            ),
          ),

          // 装飾円（左下）
          Positioned(
            left: -9,
            top: 303,
            child: Container(
              width: 59,
              height: 59,
              decoration: ShapeDecoration(
                color: const Color(0x7FFFDAC4),
                shape: OvalBorder(
                  side: BorderSide(
                    width: 2,
                    color: const Color(0xFFFF932F),
                  ),
                ),
              ),
            ),
          ),

          // 装飾円（右上）
          Positioned(
            left: 307,
            top: 131,
            child: Container(
              width: 119,
              height: 119,
              decoration: ShapeDecoration(
                color: const Color(0x7FFFDAC4),
                shape: OvalBorder(
                  side: BorderSide(
                    width: 2,
                    color: const Color(0xFFFF932F),
                  ),
                ),
              ),
            ),
          ),

          // ヘッダー「ホーム」テキスト + アイコン
          Positioned(
            left: 24,
            top: 54,
            right: 24,
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 「ホーム」テキスト
                  Text(
                    'ホーム',
                    style: GoogleFonts.zenMaruGothic(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      height: 0.80,
                    ),
                  ),
                  // 設定アイコン
                  GestureDetector(
                    onTap: () {
                      context.go('/settings');
                    },
                    child: Image.asset(
                      'assets/icons/setting_icon.png',
                      width: 38,
                      height: 38,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 連続日数バブル（大）
          Positioned(
            left: 133,
            top: 119,
            child: Container(
              width: 112.50,
              height: 112.50,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 2, color: Colors.black),
                  borderRadius: BorderRadius.circular(56.25),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0xFF000000),
                    blurRadius: 0,
                    offset: Offset(3, 4.50),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '連続日数',
                    style: GoogleFonts.zenMaruGothic(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1.20,
                    ),
                  ),
                  Text(
                    '${appState.consecutiveDaysWithoutForgetting}',
                    style: GoogleFonts.zenMaruGothic(
                      color: const Color(0xFFFF7B00),
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      height: 0.80,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 登録バブル（小）
          Positioned(
            left: 62,
            top: 222,
            child: _buildSmallStatBubble(
              label: '登録',
              value: '${appState.items.length}',
              unit: '個',
            ),
          ),

          // 通知バブル（小）
          Positioned(
            left: 144,
            top: 222,
            child: _buildSmallStatBubble(
              label: '通知',
              value: '3',
              unit: '件',
            ),
          ),

          // センサーバブル（小）
          Positioned(
            left: 224,
            top: 222,
            child: _buildSensorBubble(appState),
          ),

          // 最近の通知セクション
          Positioned(
            left: 40,
            top: 397,
            right: 40,
            bottom: 100,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // タイトル行
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '最近の通知',
                        style: GoogleFonts.zenMaruGothic(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          height: 1.20,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'すべて表示',
                          style: GoogleFonts.zenMaruGothic(
                            color: const Color(0xFF3A55AE),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            height: 1.20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 通知カードリスト
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('detections')
                        .orderBy('timestamp', descending: true)
                        .limit(3)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return _buildPlaceholderNotifications();
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return _buildPlaceholderNotifications();
                      }
                      return Column(
                        children: snapshot.data!.docs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return _buildNotificationCard(data);
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 小さな統計バブル
  Widget _buildSmallStatBubble({
    required String label,
    required String value,
    required String unit,
  }) {
    return Container(
      width: 90,
      height: 90,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2, color: Colors.black),
          borderRadius: BorderRadius.circular(45),
        ),
        shadows: [
          BoxShadow(
            color: Color(0xFF000000),
            blurRadius: 0,
            offset: Offset(3, 4.50),
            spreadRadius: 0,
          )
        ],
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: GoogleFonts.zenMaruGothic(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.20,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.zenMaruGothic(
                color: const Color(0xFFFF7B00),
                fontSize: 24,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
            Text(
              unit,
              style: GoogleFonts.zenMaruGothic(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // センサーバブル
  Widget _buildSensorBubble(AppState appState) {
    final isDetected = appState.sensorStatus.isPersonPresent;
    return Container(
      width: 90,
      height: 90,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2, color: Colors.black),
          borderRadius: BorderRadius.circular(45),
        ),
        shadows: [
          BoxShadow(
            color: Color(0xFF000000),
            blurRadius: 0,
            offset: Offset(3, 4.50),
            spreadRadius: 0,
          )
        ],
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'センサー',
              style: GoogleFonts.zenMaruGothic(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.20,
              ),
            ),
            isDetected
                ? Icon(Icons.person, size: 24, color: const Color(0xFF22C55E))
                : Icon(Icons.wifi_tethering_off,
                    size: 24, color: const Color(0xFF6B7280)),
            Text(
              isDetected ? '検知中' : '未検知',
              style: GoogleFonts.zenMaruGothic(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // プレースホルダー通知
  Widget _buildPlaceholderNotifications() {
    return Column(
      children: [
        _buildPlaceholderCard(
            '今日も忘れ物なし！！',
            '2026/01/25 16:11:13',
            '成功',
            const Color(0xFFBEFFD6),
            const Color(0xFF22C55E),
            'assets/icons/success_icon.png'),
        _buildPlaceholderCard(
            '忘れ物をしている可能性があります。',
            '2026/01/25 16:11:13',
            '警告',
            const Color(0xFFFFEFB2),
            const Color(0xFFFFA500),
            'assets/icons/warning_icon.png'),
        _buildPlaceholderCard(
            'センサーが人の動きを検知しました',
            '2026/01/25 16:11:13',
            '情報',
            const Color(0xFFC1E5FF),
            const Color(0xFF26A5FF),
            'assets/icons/info_icon.png'),
      ],
    );
  }

  Widget _buildPlaceholderCard(
    String message,
    String date,
    String badge,
    Color badgeBg,
    Color badgeColor,
    String iconAsset,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
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
            offset: Offset(3, 4.50),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(iconAsset, width: 24, height: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: GoogleFonts.zenMaruGothic(
                    color: const Color(0xFF374151),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.20,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: GoogleFonts.zenMaruGothic(
                    color: const Color(0xFF374151),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.20,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 16,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: ShapeDecoration(
                    color: badgeBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    badge,
                    style: GoogleFonts.zenMaruGothic(
                      color: badgeColor,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      height: 1.20,
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

  // 通知カード（実データ）
  Widget _buildNotificationCard(Map<String, dynamic> data) {
    Color badgeBgColor;
    Color badgeTextColor;
    String badgeText;
    String iconAsset;

    final message = data['message'] as String? ?? '通知';
    final List<dynamic> missingItems =
        data['missing_items'] as List<dynamic>? ?? [];
    final Timestamp? timestamp = data['timestamp'] as Timestamp?;

    if (missingItems.isNotEmpty) {
      badgeBgColor = const Color(0xFFFFEFB2);
      badgeTextColor = const Color(0xFFFFA500);
      badgeText = '警告';
      iconAsset = 'assets/icons/warning_icon.png';
    } else {
      badgeBgColor = const Color(0xFFBEFFD6);
      badgeTextColor = const Color(0xFF22C55E);
      badgeText = '成功';
      iconAsset = 'assets/icons/success_icon.png';
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
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
            offset: Offset(3, 4.50),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(iconAsset, width: 24, height: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: GoogleFonts.zenMaruGothic(
                    color: const Color(0xFF374151),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.20,
                  ),
                ),
                const SizedBox(height: 2),
                if (timestamp != null)
                  Text(
                    _formatDateTime(timestamp.toDate()),
                    style: GoogleFonts.zenMaruGothic(
                      color: const Color(0xFF374151),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.20,
                    ),
                  ),
                const SizedBox(height: 4),
                Container(
                  height: 16,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: ShapeDecoration(
                    color: badgeBgColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    badgeText,
                    style: GoogleFonts.zenMaruGothic(
                      color: badgeTextColor,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      height: 1.20,
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

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }
}
