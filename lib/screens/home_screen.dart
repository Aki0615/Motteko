import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

/// ホーム画面
/// アプリのメイン画面で、統計情報と最近の通知を表示します。
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          // === 背景グラデーションヘッダー ===
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            height: screenHeight * 0.5, // 画面の約50%
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.83, 0.13),
                  end: Alignment(0.84, 0.90),
                  colors: [
                    Color(0xFFFF7B00),
                    Color(0xFFFF9A40),
                    Color(0xFFFFB870),
                    Color(0xFFFFDAC4),
                  ],
                  stops: [0.0, 0.35, 0.65, 1.0],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
          ),

          // === ヘッダータイトル「ホーム」 ===
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      // 中央のタイトル
                      const Expanded(
                        child: Center(
                          child: Text(
                            'ホーム',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontFamily: 'LINESeedJP',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // === 統計円エリア ===
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // 大きな円（連続日数）
                Container(
                  width: 112.5,
                  height: 112.5,
                  decoration: const ShapeDecoration(
                    color: Colors.white,
                    shape: OvalBorder(),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '連続日数',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'LINESeedJP',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '${appState.consecutiveDaysWithoutForgetting}',
                        style: const TextStyle(
                          color: Color(0xFFFF7B00),
                          fontSize: 25,
                          fontFamily: 'LINESeedJP',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // 小さな統計円（3つ横並び）
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 登録
                      _buildSmallStatsCircle(
                        label: '登録',
                        value: '${appState.items.length}',
                        unit: '個',
                      ),
                      // 確認（少し下にオフセット）
                      Transform.translate(
                        offset: const Offset(0, 30),
                        child: _buildSmallStatsCircle(
                          label: '確認',
                          value:
                              '${appState.items.where((i) => i.isRequired).length}',
                          unit: '件',
                        ),
                      ),
                      // センサー
                      _buildSensorCircle(appState),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // === 最近の通知セクション ===
          Positioned(
            top: screenHeight * 0.52,
            left: 24,
            right: 24,
            bottom: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // タイトル行
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '最近の通知',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'LINESeedJP',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // すべて表示のアクション
                      },
                      child: const Text(
                        'すべて表示',
                        style: TextStyle(
                          color: Color(0xFF3A55AE),
                          fontSize: 16,
                          fontFamily: 'LINESeedJP',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // 通知リスト
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: appState.notifications.isEmpty
                        ? [
                            _buildEmptyNotification(),
                            _buildEmptyNotification(),
                            _buildEmptyNotification(),
                          ]
                        : appState.notifications
                            .take(3)
                            .map((n) => _buildNotificationCard(n))
                            .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 小さな統計円を構築するヘルパーメソッド
  Widget _buildSmallStatsCircle({
    required String label,
    required String value,
    required String unit,
  }) {
    return Container(
      width: 90,
      height: 90,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: OvalBorder(),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: 'LINESeedJP',
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFFF7B00),
              fontSize: 20,
              fontFamily: 'LINESeedJP',
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            unit,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: 'LINESeedJP',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  /// センサー状態の円
  Widget _buildSensorCircle(AppState appState) {
    final isDetected = appState.sensorStatus.isPersonPresent;
    return Container(
      width: 90,
      height: 90,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: OvalBorder(),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'センサー',
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: 'LINESeedJP',
              fontWeight: FontWeight.w400,
            ),
          ),
          Icon(
            isDetected ? Icons.person : Icons.person_off_outlined,
            size: 24,
            color:
                isDetected ? const Color(0xFF22C55E) : const Color(0xFF6B7280),
          ),
          Text(
            isDetected ? '検知中' : '未検知',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: 'LINESeedJP',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  /// 空の通知カードを構築するヘルパーメソッド
  Widget _buildEmptyNotification() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFFE5E7EB),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              '通知はありません',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 14,
                fontFamily: 'LINESeedJP',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 通知カードを構築するヘルパーメソッド
  Widget _buildNotificationCard(dynamic notification) {
    Color badgeBgColor;
    Color badgeTextColor;
    String badgeText;
    String iconAsset; // 画像アセットのパス

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
      iconAsset = 'assets/icons/warning_icon.png'; // 画像アセットを使用
      // それ以外は情報
    } else {
      badgeBgColor = const Color(0xFFC1E5FF);
      badgeTextColor = const Color(0xFF26A5FF);
      badgeText = '情報';
      iconAsset = 'assets/icons/info_icon.png';
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
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
    return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }
}
