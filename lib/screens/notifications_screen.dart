import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ヘッダー部分
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(28, 24, 24, 20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 2,
                    color: Colors.black,
                  ),
                ),
              ),
              child: Text(
                '通知履歴',
                style: GoogleFonts.zenMaruGothic(
                  color: const Color(0xFFFF7B00),
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  height: 0.90,
                ),
              ),
            ),

            // メインコンテンツエリア
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('detections')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('エラーが発生しました: ${snapshot.error}'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 100),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      return _buildNotificationCard(data);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F6F7),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black,
                width: 1.50,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFF000000),
                  blurRadius: 0,
                  offset: Offset(2, 3),
                  spreadRadius: 0,
                )
              ],
            ),
            child: const Icon(
              Icons.notifications_none,
              size: 40,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '通知はありません',
            style: GoogleFonts.zenMaruGothic(
              color: const Color(0xFF6B7280),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

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
