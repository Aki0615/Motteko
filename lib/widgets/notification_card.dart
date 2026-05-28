import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

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

    final badge = _determineBadgeStyle(message, missingItems);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 88),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F35291E),
            offset: Offset(1, 2),
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIcon(badge),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  message,
                  style: GoogleFonts.zenMaruGothic(
                    color: const Color(0xFF374151),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.20,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
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
                const SizedBox(height: 4),
                _buildBadge(badge),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(_BadgeStyle badge) {
    return SizedBox(
      width: 30,
      height: 30,
      child: Stack(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: badge.iconBgColor,
              shape: BoxShape.circle,
            ),
          ),
          Center(
            child: Icon(
              badge.iconData,
              size: badge.iconSize,
              color: badge.iconColor,
            ),
          ),
        ],
      ),
    );
  }

  static _BadgeStyle _determineBadgeStyle(
      String message, List<dynamic> missingItems) {
    if (missingItems.isNotEmpty || message.contains('忘れ物')) {
      return const _BadgeStyle(
        backgroundColor: Color(0xFFFFF0B3),
        textColor: Color(0xFFFFA600),
        label: '警告',
        iconBgColor: Color(0xFFFFF0B3),
        iconColor: Color(0xFFFFA600),
        iconData: Icons.warning_amber_rounded,
        iconSize: 20,
      );
    }
    return const _BadgeStyle(
      backgroundColor: Color(0xFFBFFFD6),
      textColor: Color(0xFF22C55E),
      label: '成功',
      iconBgColor: Color(0xFFBFFFD6),
      iconColor: Color(0xFF22C55E),
      iconData: Icons.check_circle,
      iconSize: 24,
    );
  }

  Widget _buildBadge(_BadgeStyle badge) {
    return Container(
      height: 16,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: badge.backgroundColor,
        borderRadius: BorderRadius.circular(8),
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
}

class _BadgeStyle {
  final Color backgroundColor;
  final Color textColor;
  final String label;
  final Color iconBgColor;
  final Color iconColor;
  final IconData iconData;
  final double iconSize;

  const _BadgeStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.label,
    required this.iconBgColor,
    required this.iconColor,
    required this.iconData,
    required this.iconSize,
  });
}
