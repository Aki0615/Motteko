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

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          // === 背景グラデーションヘッダー ===
          // 左上から右下への斜めグラデーション（デザイン画像に合わせて）
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            height: 420, // 円のエリアをカバーするために下まで拡張
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFF7B00), // 左上のオレンジ
                    Color(0xFFFFAB60), // 右下の明るいピーチオレンジ
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
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
              child: Container(
                height: 60, // 他のセクションと同じ高さ
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 中央揃えのタイトル
                    const Center(
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
                    // 右側のアイコン
                    Positioned(
                      right: 0,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const ShapeDecoration(
                          color: Color(0xFFF4F6F7),
                          shape: OvalBorder(),
                          shadows: [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: const Icon(
                          Icons.download,
                          size: 20,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // === メイン統計円 ===
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            height: 320,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // 大きな円（連続日数）
                Positioned(
                  top: 20,
                  child: Container(
                    width: 141,
                    height: 141,
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
                            color: Color(0xFF6B7280),
                            fontSize: 14,
                            fontFamily: 'LINESeedJP',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '${appState.consecutiveDaysWithoutForgetting}日',
                          style: const TextStyle(
                            color: Color(0xFFFF7B00),
                            fontSize: 32,
                            fontFamily: 'LINESeedJP',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // 小さな円（左）- 登録アイテム
                Positioned(
                  top: 185,
                  left: screenWidth * 0.5 - 135,
                  child: _buildSmallStatsCircle(
                    label: '登録',
                    value: '${appState.items.length}',
                    unit: '個',
                    color: const Color(0xFF3A55AE),
                  ),
                ),
                // 小さな円（中央）- 今日の確認
                Positioned(
                  top: 215,
                  child: _buildSmallStatsCircle(
                    label: '確認',
                    value:
                        '${appState.items.where((i) => i.isRequired).length}',
                    unit: '件',
                    color: const Color(0xFF10B981),
                  ),
                ),
                // 小さな円（右）- センサー
                Positioned(
                  top: 185,
                  left: screenWidth * 0.5 + 53,
                  child: Container(
                    width: 82,
                    height: 82,
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
                            color: Color(0xFF6B7280),
                            fontSize: 10,
                            fontFamily: 'LINESeedJP',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Icon(
                          appState.sensorStatus.isPersonPresent
                              ? Icons.person
                              : Icons.person_off,
                          color: appState.sensorStatus.isPersonPresent
                              ? const Color(0xFF10B981)
                              : const Color(0xFF6B7280),
                          size: 24,
                        ),
                        Text(
                          appState.sensorStatus.isPersonPresent ? '検知中' : '未検知',
                          style: TextStyle(
                            color: appState.sensorStatus.isPersonPresent
                                ? const Color(0xFF10B981)
                                : const Color(0xFF6B7280),
                            fontSize: 12,
                            fontFamily: 'LINESeedJP',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // === 最近の通知セクション ===
          Positioned(
            top: 430,
            left: 24,
            right: 24,
            bottom: 100, // ScaffoldWithBottomNavBarのナビバー用スペース確保
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
                    TextButton(
                      onPressed: () {
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
                const SizedBox(height: 10),
                // 通知リスト
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: appState.notifications.isEmpty
                        ? [
                            _buildEmptyNotification(),
                            const SizedBox(height: 10),
                            _buildEmptyNotification(),
                            const SizedBox(height: 10),
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

          // カスタムナビゲーションバーはScaffoldWithBottomNavBarで提供されるため、ここでは不要
        ],
      ),
    );
  }

  /// 小さな統計円を構築するヘルパーメソッド
  Widget _buildSmallStatsCircle({
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Container(
      width: 82,
      height: 82,
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
              color: Color(0xFF6B7280),
              fontSize: 10,
              fontFamily: 'LINESeedJP',
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontFamily: 'LINESeedJP',
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            unit,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 10,
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
      height: 66,
      decoration: ShapeDecoration(
        color: const Color(0xFFDFE3E9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  /// 通知カードを構築するヘルパーメソッド（通知セクションと同じスタイル）
  Widget _buildNotificationCard(dynamic notification) {
    // 通知タイプに応じた色とバッジ設定
    Color badgeBgColor;
    Color badgeTextColor;
    String badgeText;
    IconData iconData;

    final message = notification.message as String;
    if (message.contains('忘れ物なし') || message.contains('成功')) {
      // 成功タイプ
      badgeBgColor = const Color(0xFFBEFFD6);
      badgeTextColor = const Color(0xFF22C55E);
      badgeText = '成功';
      iconData = Icons.check_circle_outline;
    } else if (message.contains('忘れ物') || message.contains('警告')) {
      // 警告タイプ
      badgeBgColor = const Color(0xFFFFEFB2);
      badgeTextColor = const Color(0xFFFFA500);
      badgeText = '警告';
      iconData = Icons.warning_amber_outlined;
    } else {
      // 情報タイプ
      badgeBgColor = const Color(0xFFC1E5FF);
      badgeTextColor = const Color(0xFF26A5FF);
      badgeText = '情報';
      iconData = Icons.info_outline;
    }

    return Container(
      width: double.infinity,
      height: 80,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // アイコン
          Icon(
            iconData,
            size: 20,
            color: badgeTextColor,
          ),
          const SizedBox(width: 12),
          // テキストとバッジ
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF374151),
                    fontSize: 14,
                    fontFamily: 'LINESeedJP',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
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
                        child: Text(
                          badgeText,
                          style: TextStyle(
                            color: badgeTextColor,
                            fontSize: 8,
                            fontFamily: 'LINESeedJP',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 日時
                    Text(
                      _formatDateTime(notification.timestamp as DateTime),
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 10,
                        fontFamily: 'LINESeedJP',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.month}/${dateTime.day} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
