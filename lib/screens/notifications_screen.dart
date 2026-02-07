import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ヘッダー部分
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '通知履歴',
                    style: TextStyle(
                      color: Color(0xFFFF7B00),
                      fontSize: 32,
                      fontFamily: 'LINESeedJP',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            // メインコンテンツエリア
            Expanded(
              child: appState.notifications.isEmpty
                  ? _buildEmptyState()
                  : _buildNotificationsList(appState),
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
            decoration: const BoxDecoration(
              color: Color(0xFFF4F6F7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none,
              size: 40,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '通知はありません',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 12,
              fontFamily: 'LINESeedJP',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(AppState appState) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 100),
      itemCount: appState.notifications.length,
      itemBuilder: (context, index) {
        final notification = appState.notifications[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  Widget _buildNotificationCard(dynamic notification) {
    // 通知タイプに応じた色とバッジ設定
    Color badgeBgColor;
    Color badgeTextColor;
    String badgeText;
    String iconAsset; // 画像アセットのパス

    // 通知メッセージに基づいてタイプを判定
    final message = notification.message as String;
    // 成功判定（「忘れ物なし」または「成功」を含む）
    if (message.contains('忘れ物なし') || message.contains('成功')) {
      badgeBgColor = const Color(0xFFBEFFD6);
      badgeTextColor = const Color(0xFF22C55E);
      badgeText = '成功';
      iconAsset = 'assets/icons/success_icon.png';
      // 警告判定（「忘れている」「忘れ物をしている」「可能性」「警告」を含む）
    } else if (message.contains('忘れている') ||
        message.contains('忘れ物をしている') ||
        message.contains('可能性') ||
        message.contains('警告')) {
      badgeBgColor = const Color(0xFFFFEFB2);
      badgeTextColor = const Color(0xFFFFA500);
      badgeText = '警告';
      iconAsset = 'assets/icons/warning_icon.png';
      // それ以外は情報
    } else {
      badgeBgColor = const Color(0xFFC1E5FF);
      badgeTextColor = const Color(0xFF26A5FF);
      badgeText = '情報';
      iconAsset = 'assets/icons/info_icon.png';
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFE5E7EB),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // アイコン
          Image.asset(
            iconAsset,
            width: 30,
            height: 30,
          ),
          const SizedBox(width: 12),
          // テキストエリア
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // メッセージ
                Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xFF374151),
                    fontSize: 14,
                    fontFamily: 'LINESeedJP',
                    fontWeight: FontWeight.w400,
                    height: 1.20,
                  ),
                ),
                const SizedBox(height: 4),
                // 日時
                Text(
                  _formatDateTime(notification.timestamp as DateTime),
                  style: const TextStyle(
                    color: Color(0xFF374151),
                    fontSize: 12,
                    fontFamily: 'LINESeedJP',
                    fontWeight: FontWeight.w400,
                    height: 1.20,
                  ),
                ),
                const SizedBox(height: 6),
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
                  child: Center(
                    widthFactor: 1,
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        color: badgeTextColor,
                        fontSize: 8,
                        fontFamily: 'LINESeedJP',
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                      ),
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
    return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }
}
