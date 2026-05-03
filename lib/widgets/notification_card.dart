import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

/// Firestore検出データから通知カードを表示する共通Widget。
/// home_screenとnotifications_screenの両方から使用される。
class NotificationCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const NotificationCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final String message = data['message'] as String? ?? '通知';
    final Timestamp? timestamp = data['timestamp'] as Timestamp?;
    final String formattedTime = timestamp != null
        ? DateFormat('yyyy/MM/dd HH:mm:ss').format(timestamp.toDate())
        : '';
    final List<dynamic> missingItems =
        data['missing_items'] as List<dynamic>? ?? [];
    final String? imageUrl = data['image_url'] as String?;

    // 優先度: 忘れ物あり(警告) > センサー検知(情報) > それ以外(成功)
    final badge = _determineBadgeStyle(message, missingItems);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1.50, color: Colors.black),
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
              Image.asset(badge.iconAsset, width: 32, height: 32),
              const SizedBox(width: 16),
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
                    const SizedBox(height: 4),
                    if (formattedTime.isNotEmpty)
                      Text(
                        formattedTime,
                        style: GoogleFonts.zenMaruGothic(
                          color: const Color(0xFF374151),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1.20,
                        ),
                      ),
                    const SizedBox(height: 8),
                    _buildBadge(badge),
                  ],
                ),
              ),
            ],
          ),
          if (imageUrl != null && imageUrl.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildDetectionImage(imageUrl),
          ],
        ],
      ),
    );
  }

  /// 通知の種別をメッセージ内容から判定し、バッジスタイルを返す
  static _BadgeStyle _determineBadgeStyle(
      String message, List<dynamic> missingItems) {
    if (missingItems.isNotEmpty || message.contains('忘れ物')) {
      return const _BadgeStyle(
        backgroundColor: Color(0xFFFFEFB2),
        textColor: Color(0xFFFFA500),
        label: '警告',
        iconAsset: 'assets/icons/warning_icon.png',
      );
    }
    if (message.contains('検知')) {
      return const _BadgeStyle(
        backgroundColor: Color(0xFFC1E5FF),
        textColor: Color(0xFF26A5FF),
        label: '情報',
        iconAsset: 'assets/icons/info_icon.png',
      );
    }
    return const _BadgeStyle(
      backgroundColor: Color(0xFFBEFFD6),
      textColor: Color(0xFF22C55E),
      label: '成功',
      iconAsset: 'assets/icons/success_icon.png',
    );
  }

  Widget _buildBadge(_BadgeStyle badge) {
    return Container(
      height: 16,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: ShapeDecoration(
        color: badge.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            badge.label,
            style: GoogleFonts.zenMaruGothic(
              color: badge.textColor,
              fontSize: 8,
              fontWeight: FontWeight.w900,
              height: 1.20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectionImage(String imageUrl) {
    return ClipRRect(
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
    );
  }
}

class _BadgeStyle {
  final Color backgroundColor;
  final Color textColor;
  final String label;
  final String iconAsset;

  const _BadgeStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.label,
    required this.iconAsset,
  });
}
