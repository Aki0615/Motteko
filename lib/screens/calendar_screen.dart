import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/app_state.dart';
import '../widgets/streak_celebration.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _currentMonth;
  bool _hasCheckedEvents = false;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  }

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

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    _checkStreakEvents(appState);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFFF7B00),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // ヘッダー: 連続記録
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  '連続記録',
                  style: GoogleFonts.zenMaruGothic(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    height: 0.80,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // メインコンテンツ
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    children: [
                      // 連続記録カード
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: _buildStreakCard(),
                      ),
                      const SizedBox(height: 24),

                      // 下部: カレンダー部分の背景（白）
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                          child: _buildCalendarCard(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 連続記録カード
  Widget _buildStreakCard() {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final streak = appState.consecutiveDaysWithoutForgetting;
        final maxStreak = appState.maxStreak;

        return Container(
          width: double.infinity,
          height: 216,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/icons/streak_card_bg.png',
                  fit: BoxFit.fill,
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          streak.toString().padLeft(3, '0'),
                          style: GoogleFonts.zenMaruGothic(
                            color: Colors.black,
                            fontSize: 64,
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                          ),
                        )
                            .animate(
                              onPlay: (c) => c.forward(),
                            )
                            .scale(
                              begin: const Offset(0.8, 0.8),
                              end: const Offset(1.0, 1.0),
                              duration: 600.ms,
                              curve: Curves.elasticOut,
                            ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            '日',
                            style: GoogleFonts.zenMaruGothic(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      streak > 0 ? '連続忘れ物なし！！' : '今日から記録スタート！',
                      style: GoogleFonts.zenMaruGothic(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        height: 1.20,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 200.ms),
                    if (maxStreak > 0 && maxStreak > streak) ...[
                      const SizedBox(height: 4),
                      Text(
                        '🏆 最高記録: $maxStreak日',
                        style: GoogleFonts.zenMaruGothic(
                          color: Colors.black54,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 500.ms, delay: 400.ms),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // カレンダーカード
  Widget _buildCalendarCard() {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0xFF000000),
            blurRadius: 0,
            offset: Offset(3.5, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Stack(
        children: [
          // 背景のbox_icon2（下部に大きく散らして配置）
          Positioned(
            left: -20,
            bottom: -10,
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/icons/box_icon2.png',
                width: 140,
                height: 140,
              ),
            ),
          ),
          Positioned(
            left: 80,
            bottom: 30,
            child: Opacity(
              opacity: 0.18,
              child: Image.asset(
                'assets/icons/box_icon2.png',
                width: 120,
                height: 120,
              ),
            ),
          ),
          Positioned(
            right: -10,
            bottom: -20,
            child: Opacity(
              opacity: 0.22,
              child: Image.asset(
                'assets/icons/box_icon2.png',
                width: 150,
                height: 150,
              ),
            ),
          ),
          Positioned(
            right: 60,
            bottom: 80,
            child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                'assets/icons/box_icon2.png',
                width: 100,
                height: 100,
              ),
            ),
          ),
          Positioned(
            left: 40,
            bottom: 100,
            child: Opacity(
              opacity: 0.12,
              child: Image.asset(
                'assets/icons/box_icon2.png',
                width: 90,
                height: 90,
              ),
            ),
          ),
          // カレンダー本体
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // カレンダーヘッダー
              _buildCalendarHeader(),
              // 曜日の行
              _buildWeekdayRow(),
              const SizedBox(height: 8),
              // 日付グリッド
              _buildDateGrid(),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }

  // カレンダーヘッダー（年月 + 前後ボタン）
  Widget _buildCalendarHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_currentMonth.year}年 ${_currentMonth.month}月',
            style: GoogleFonts.zenMaruGothic(
              color: const Color(0xFF111827),
              fontSize: 16,
              fontWeight: FontWeight.w900,
              height: 1.20,
            ),
          ),
          Row(
            children: [
              // 前月ボタン
              GestureDetector(
                onTap: _previousMonth,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFFDAC3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.chevron_left,
                      color: Color(0xFFFF7B00),
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // 次月ボタン
              GestureDetector(
                onTap: _nextMonth,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFFDAC4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.chevron_right,
                      color: Color(0xFFFF7B00),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 曜日の行
  Widget _buildWeekdayRow() {
    final dayLabels = ['日', '月', '火', '水', '木', '金', '土'];
    // 日曜=赤、土曜=青、平日=グレーの配色
    final dayLabelColors = [
      const Color(0xFFEF4444), // 日: 赤
      const Color(0xFF6B7280), // 月: グレー
      const Color(0xFF6B7280), // 火
      const Color(0xFF6B7280), // 水
      const Color(0xFF6B7280), // 木
      const Color(0xFF6B7280), // 金
      const Color(0xFF3B82F6), // 土: 青
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (index) {
          return SizedBox(
            width: 40,
            child: Text(
              dayLabels[index],
              textAlign: TextAlign.center,
              style: GoogleFonts.zenMaruGothic(
                color: dayLabelColors[index],
                fontSize: 16,
                fontWeight: FontWeight.w900,
                height: 1.20,
              ),
            ),
          );
        }),
      ),
    );
  }

  // 日付グリッド
  Widget _buildDateGrid() {
    final daysInMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstDayWeekday =
        DateTime(_currentMonth.year, _currentMonth.month, 1).weekday % 7;
    final prevMonthDays =
        DateTime(_currentMonth.year, _currentMonth.month, 0).day;

    return Consumer<AppState>(
      builder: (context, appState, child) {
        final successDates = appState.successDates;

        List<Widget> rows = [];
        int dayCounter = 1;
        int nextMonthDay = 1;

        for (int week = 0; week < 6; week++) {
          List<Map<String, dynamic>> weekDays = [];

          for (int day = 0; day < 7; day++) {
            final cellIndex = week * 7 + day;

            if (cellIndex < firstDayWeekday) {
              final prevDay = prevMonthDays - firstDayWeekday + cellIndex + 1;
              weekDays.add({
                'day': prevDay,
                'isCurrentMonth': false,
                'isSuccess': false
              });
            } else if (dayCounter <= daysInMonth) {
              final date =
                  DateTime(_currentMonth.year, _currentMonth.month, dayCounter);
              final isSuccess = successDates
                  .contains(DateTime(date.year, date.month, date.day));
              weekDays.add({
                'day': dayCounter,
                'isCurrentMonth': true,
                'isSuccess': isSuccess
              });
              dayCounter++;
            } else {
              weekDays.add({
                'day': nextMonthDay,
                'isCurrentMonth': false,
                'isSuccess': false
              });
              nextMonthDay++;
            }
          }

          List<Widget> cells = [];
          for (int i = 0; i < 7; i++) {
            final info = weekDays[i];
            bool currentIsSuccess = info['isSuccess'];
            bool connectedLeft = i > 0 && weekDays[i - 1]['isSuccess'];
            bool connectedRight = i < 6 && weekDays[i + 1]['isSuccess'];

            cells.add(Expanded(
              child: _buildDateCell(
                info['day'],
                isCurrentMonth: info['isCurrentMonth'],
                isSuccess: currentIsSuccess,
                connectedLeft: connectedLeft,
                connectedRight: connectedRight,
              ),
            ));
          }

          rows.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: cells,
              ),
            ),
          );

          if (dayCounter > daysInMonth) break;
        }

        return Column(children: rows);
      },
    );
  }

  // 個別の日付セル
  Widget _buildDateCell(int day,
      {required bool isCurrentMonth,
      bool isSuccess = false,
      bool connectedLeft = false,
      bool connectedRight = false}) {
    Color textColor = isCurrentMonth ? Colors.black : const Color(0xFFB9BFC9);

    if (isSuccess) {
      textColor = Colors.white;
      if (!connectedLeft && !connectedRight) {
        // 単独の成功日（丸いアイコン）
        return SizedBox(
          height: 35,
          child: Center(
            child: Container(
              width: 35,
              height: 35,
              decoration: ShapeDecoration(
                gradient: const LinearGradient(
                  begin: Alignment(1.00, 0.51),
                  end: Alignment(0.00, 0.51),
                  colors: [Color(0xFFFF6100), Color(0xFFFF9E64)],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0xFFEDB38E),
                    blurRadius: 0,
                    offset: Offset(2, 2.5),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Center(
                child: Text(
                  '$day',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.zenMaruGothic(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    height: 1.20,
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        // 連続成功日（繋がったピル型の背景）
        return Container(
          height: 35,
          decoration: BoxDecoration(
            color: const Color(0xFFFF7B00),
            borderRadius: BorderRadius.horizontal(
              left: connectedLeft ? Radius.zero : const Radius.circular(17.5),
              right: connectedRight ? Radius.zero : const Radius.circular(17.5),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFFEDB38E),
                blurRadius: 0,
                offset: Offset(2, 2.5),
                spreadRadius: 0,
              )
            ],
          ),
          child: Center(
            child: Text(
              '$day',
              textAlign: TextAlign.center,
              style: GoogleFonts.zenMaruGothic(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                height: 1.20,
              ),
            ),
          ),
        );
      }
    } else {
      // 通常の日付テキスト
      return SizedBox(
        height: 35,
        child: Center(
          child: Text(
            '$day',
            textAlign: TextAlign.center,
            style: GoogleFonts.zenMaruGothic(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              height: 1.20,
            ),
          ),
        ),
      );
    }
  }
}
