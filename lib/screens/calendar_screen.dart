import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _currentMonth;
  final int _streakDays = 0; // TODO: 実際のデータから取得

  // TODO: 実際の忘れ物なしの日付データ
  final Set<DateTime> _successDates = {};

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
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
    return Container(
      width: double.infinity,
      height: 216,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2, color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0xFF000000),
            blurRadius: 0,
            offset: Offset(3, 4.5),
            spreadRadius: 0,
          )
        ],
      ),
      child: Stack(
        children: [
          // 背景画像
          Positioned.fill(
            child: Image.asset(
              'assets/icons/streak_card_bg.png',
              fit: BoxFit.fill,
            ),
          ),
          // メインコンテンツ
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _streakDays.toString().padLeft(3, '0'),
                      style: GoogleFonts.zenMaruGothic(
                        color: Colors.black,
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                      ),
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
                  '連続忘れ物なし！！',
                  style: GoogleFonts.zenMaruGothic(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    height: 1.20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
    final weekdays = ['日', '月', '火', '水', '木', '金', '土'];
    final weekdayColors = [
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
              weekdays[index],
              textAlign: TextAlign.center,
              style: GoogleFonts.zenMaruGothic(
                color: weekdayColors[index],
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

    // 前月の日数
    final prevMonthDays =
        DateTime(_currentMonth.year, _currentMonth.month, 0).day;

    List<Widget> rows = [];

    int dayCounter = 1;
    int nextMonthDay = 1;

    // 最大6行
    for (int week = 0; week < 5; week++) {
      List<Widget> cells = [];
      for (int day = 0; day < 7; day++) {
        final cellIndex = week * 7 + day;

        if (cellIndex < firstDayWeekday) {
          // 前月の日付
          final prevDay = prevMonthDays - firstDayWeekday + cellIndex + 1;
          cells.add(_buildDateCell(prevDay, isCurrentMonth: false));
        } else if (dayCounter <= daysInMonth) {
          // 当月の日付
          final date =
              DateTime(_currentMonth.year, _currentMonth.month, dayCounter);
          final isSuccess =
              _successDates.contains(DateTime(date.year, date.month, date.day));
          cells.add(_buildDateCell(dayCounter,
              isCurrentMonth: true, isSuccess: isSuccess));
          dayCounter++;
        } else {
          // 次月の日付
          cells.add(_buildDateCell(nextMonthDay, isCurrentMonth: false));
          nextMonthDay++;
        }
      }
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: cells,
          ),
        ),
      );

      if (dayCounter > daysInMonth && week >= 3) break;
    }

    return Column(children: rows);
  }

  // 個別の日付セル
  Widget _buildDateCell(int day,
      {required bool isCurrentMonth, bool isSuccess = false}) {
    Color textColor;
    if (!isCurrentMonth) {
      textColor = const Color(0xFFB9BFC9);
    } else {
      textColor = Colors.black;
    }

    return SizedBox(
      width: 40,
      height: 40,
      child: Center(
        child: isSuccess
            ? Container(
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
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      height: 1.20,
                    ),
                  ),
                ),
              )
            : Text(
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
