import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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

          // ヘッダー「ホーム」テキスト + 挨拶 + アイコン
          Positioned(
            left: 24,
            top: 54,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // テキスト部分
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ホーム',
                      style: GoogleFonts.zenMaruGothic(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        height: 0.80,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (appState.userName.isNotEmpty)
                      Text(
                        'こんにちは、${appState.userName}さん',
                        style: GoogleFonts.zenMaruGothic(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    if (appState.currentMode.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          appState.currentMode == '外出'
                              ? '🚶‍ いってらっしゃい！'
                              : '🏠 おかえりなさい！',
                          style: GoogleFonts.zenMaruGothic(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ],
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
              value: '${appState.notificationCount}',
              unit: '件',
            ),
          ),

          // センサーバブル（小）
          Positioned(
            left: 224,
            top: 222,
            child: _buildSensorBubble(appState),
          ),

          // 必須アイテム ＆ 最近の通知セクション
          Positioned(
            left: 40,
            top: 397,
            right: 40,
            bottom: 100,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 必須アイテム
                  if (appState.essentialItemNames.isNotEmpty) ...[
                    Text(
                      '必須アイテム',
                      style: GoogleFonts.zenMaruGothic(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        height: 1.20,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: appState.essentialItemNames.map((name) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 2, color: Colors.black),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            name,
                            style: GoogleFonts.zenMaruGothic(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // 最近の通知 タイトル行
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

                  // 最近の通知 リスト部分 (データがある場合のみ表示)
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('detections')
                        .orderBy('timestamp', descending: true)
                        .limit(4)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError ||
                          snapshot.connectionState == ConnectionState.waiting ||
                          !snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32.0),
                          child: Center(
                            child: Text(
                              '通知はありません',
                              style: GoogleFonts.zenMaruGothic(
                                color: const Color(0xFF6B7280),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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

  // 通知カード（実データ）
  Widget _buildNotificationCard(Map<String, dynamic> data) {
    // データから各種情報を取得
    final String message = data['message'] as String? ?? '通知';
    final Timestamp? timestamp = data['timestamp'] as Timestamp?;
    final String timestampStr = timestamp != null
        ? DateFormat('yyyy/MM/dd HH:mm:ss').format(timestamp.toDate())
        : '';
    final List<dynamic> missingItems =
        data['missing_items'] as List<dynamic>? ?? [];

    // 通知メッセージに基づいてタイプを判定
    Color badgeBgColor;
    Color badgeTextColor;
    String badgeText;
    String iconAsset;

    // 1. missing_itemsがある、またはメッセージに「忘れ物」を検知した場合は警告
    if (missingItems.isNotEmpty || message.contains('忘れ物')) {
      badgeBgColor = const Color(0xFFFFEFB2);
      badgeTextColor = const Color(0xFFFFA500);
      badgeText = '警告';
      iconAsset = 'assets/icons/warning_icon.png';
    }
    // 2. センサーによる情報など
    else if (message.contains('検知')) {
      badgeBgColor = const Color(0xFFC1E5FF);
      badgeTextColor = const Color(0xFF26A5FF);
      badgeText = '情報';
      iconAsset = 'assets/icons/info_icon.png';
    }
    // 3. それ以外（成功など）
    else {
      badgeBgColor = const Color(0xFFBEFFD6);
      badgeTextColor = const Color(0xFF22C55E);
      badgeText = '成功';
      iconAsset = 'assets/icons/success_icon.png';
    }

    final String? imageUrl = data['image_url'] as String?;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1.50,
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0xFF000000),
            blurRadius: 0,
            offset: Offset(2, 3),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // アイコン
              Image.asset(
                iconAsset,
                width: 32,
                height: 32,
              ),
              const SizedBox(width: 16),
              // テキストエリア
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // メッセージ
                    Text(
                      message,
                      style: GoogleFonts.zenMaruGothic(
                        color: const Color(0xFF374151),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // 日時
                    if (timestampStr.isNotEmpty)
                      Text(
                        timestampStr,
                        style: GoogleFonts.zenMaruGothic(
                          color: const Color(0xFF374151),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1.20,
                        ),
                      ),
                    const SizedBox(height: 8),
                    // バッジ
                    Container(
                      height: 16,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: ShapeDecoration(
                        color: badgeBgColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            badgeText,
                            style: GoogleFonts.zenMaruGothic(
                              color: badgeTextColor,
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                              height: 1.20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // 画像があれば表示
          if (imageUrl != null && imageUrl.isNotEmpty) ...[
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 200,
                    color: Colors.grey[100],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
