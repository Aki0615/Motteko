import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/app_state.dart';
import '../widgets/notification_card.dart';
import '../widgets/streak_celebration.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasCheckedEvents = false;

  void _checkStreakEvents(AppState appState) {
    if (_hasCheckedEvents) return;
    _hasCheckedEvents = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final milestone = appState.achievedMilestone;
      if (milestone != null) {
        StreakCelebrationDialog.show(context, milestone);
      } else if (appState.isStreakBroken) {
        StreakBrokenDialog.show(
          context,
          appState.previousStreak,
          appState.maxStreak,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    _checkStreakEvents(appState);

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
            left: 140.0,
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
                  )
                      .animate(onPlay: (c) => c.forward())
                      .scale(
                        begin: const Offset(0.7, 0.7),
                        end: const Offset(1.0, 1.0),
                        duration: 600.ms,
                        curve: Curves.elasticOut,
                      ),
                ],
              ),
            ),
          ),

          // 登録バブル（小）
          Positioned(
            left: 45, // 等間隔に配置
            top: 250, // 大バブルの下に配置（被らないようにする）
            child: _buildSmallStatBubble(
              label: '登録',
              value: '${appState.items.length}',
              unit: '個',
            ),
          ),

          // 通知バブル（小）
          Positioned(
            left: 150, // 等間隔に配置
            top: 250, // 大バブルの下に配置
            child: _buildSmallStatBubble(
              label: '通知',
              value: '${appState.notificationCount}',
              unit: '件',
            ),
          ),

          // センサーバブル（小）
          Positioned(
            left: 255, // 等間隔に配置
            top: 250, // 大バブルの下に配置
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
                        onTap: () {
                          // 通知画面へ遷移
                          context.go('/notifications');
                        },
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
                  _buildNotificationsList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Center(
          child: Text(
            'ログインすると通知が表示されます',
            style: GoogleFonts.zenMaruGothic(
              color: const Color(0xFF6B7280),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
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
            return NotificationCard(data: data);
          }).toList(),
        );
      },
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
}
