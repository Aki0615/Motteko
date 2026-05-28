import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../providers/app_state.dart';
import '../core/constants/app_colors.dart';
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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            left: -85,
            top: -215,
            width: 360,
            height: 346.5,
            child: SvgPicture.asset(
              'assets/icons/items_bg_decoration.svg',
              fit: BoxFit.fill,
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          _buildStreakCard(appState),
                          const SizedBox(height: 18),
                          _buildCalendarCard(),
                        ],
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(26, 0, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'カレンダー',
            style: GoogleFonts.zenMaruGothic(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              height: 1.20,
            ),
          ),
          Text(
            '毎日の記録で、忘れ物をゼロに',
            style: GoogleFonts.zenMaruGothic(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(AppState appState) {
    final streak = appState.consecutiveDaysWithoutForgetting;

    return Container(
      width: double.infinity,
      height: 216,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.primary700,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -30,
            width: 126,
            height: 128,
            child: SvgPicture.asset(
              'assets/icons/calendar_streak_box.svg',
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 11, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.white, AppColors.primary400],
                        ),
                        borderRadius: BorderRadius.circular(31.5),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/calendar_streak_icon.svg',
                        width: 30,
                        height: 31,
                      ),
                    ),
                    const SizedBox(width: 22),
                    Text(
                      '連続記録',
                      style: GoogleFonts.zenMaruGothic(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        height: 1.20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 177,
                  child: Column(
                    children: [
                      Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: streak.toString().padLeft(3, '0'),
                            style: GoogleFonts.zenMaruGothic(
                              color: Colors.white,
                              fontSize: 64,
                              fontWeight: FontWeight.w900,
                              height: 1.0,
                            ),
                          ),
                          TextSpan(
                            text: '日',
                            style: GoogleFonts.zenMaruGothic(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              height: 1.0,
                            ),
                          ),
                        ]),
                        textAlign: TextAlign.center,
                      )
                          .animate(onPlay: (c) => c.forward())
                          .scale(
                            begin: const Offset(0.8, 0.8),
                            end: const Offset(1.0, 1.0),
                            duration: 600.ms,
                            curve: Curves.elasticOut,
                          ),
                      Text(
                        streak > 0 ? '連続忘れ物なし！！' : '今日から記録スタート！',
                        style: GoogleFonts.zenMaruGothic(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 1.20,
                        ),
                        textAlign: TextAlign.center,
                      )
                          .animate()
                          .fadeIn(duration: 500.ms, delay: 200.ms),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
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
          Positioned.fill(
            top: 96,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCalendarHeader(),
              _buildWeekdayRow(),
              const SizedBox(height: 8),
              _buildDateGrid(),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 96,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Color(0xFFF3F4F6)),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_currentMonth.year}年 ${_currentMonth.month}月',
                style: GoogleFonts.zenMaruGothic(
                  color: AppColors.gray900, fontSize: 16, fontWeight: FontWeight.w900, height: 1.20,
                ),
              ),
              Row(
                children: [
                  _buildMonthNavButton(Icons.chevron_left, _previousMonth),
                  const SizedBox(width: 8),
                  _buildMonthNavButton(Icons.chevron_right, _nextMonth),
                ],
              ),
            ],
          ),
          const Spacer(),
          _buildWeekdayLabels(),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildWeekdayLabels() {
    final dayLabels = ['日', '月', '火', '水', '木', '金', '土'];
    final dayLabelColors = [
      const Color(0xFFEF4444),
      AppColors.gray500,
      AppColors.gray500,
      AppColors.gray500,
      AppColors.gray500,
      AppColors.gray500,
      const Color(0xFF3B82F6),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {
        return Expanded(
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
    );
  }

  Widget _buildMonthNavButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: ShapeDecoration(
          color: const Color(0xFFFFDAC3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Center(child: Icon(icon, color: AppColors.primary700, size: 20)),
      ),
    );
  }

  Widget _buildWeekdayRow() {
    return const SizedBox.shrink();
  }

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

  Widget _buildDateCell(int day,
      {required bool isCurrentMonth,
      bool isSuccess = false,
      bool connectedLeft = false,
      bool connectedRight = false}) {
    Color textColor = isCurrentMonth ? Colors.black : const Color(0xFFB9C0C9);

    if (isSuccess) {
      textColor = Colors.white;
      if (!connectedLeft && !connectedRight) {
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
                  colors: [Color(0xFFFF6200), Color(0xFFFF9E64)],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80),
                ),
              ),
              child: Center(
                child: Text(
                  '$day',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.zenMaruGothic(
                    color: textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    height: 1.20,
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        return Container(
          height: 35,
          decoration: BoxDecoration(
            color: AppColors.primary700,
            borderRadius: BorderRadius.horizontal(
              left: connectedLeft ? Radius.zero : const Radius.circular(17.5),
              right: connectedRight ? Radius.zero : const Radius.circular(17.5),
            ),
          ),
          child: Center(
            child: Text(
              '$day',
              textAlign: TextAlign.center,
              style: GoogleFonts.zenMaruGothic(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                height: 1.20,
              ),
            ),
          ),
        );
      }
    } else {
      return SizedBox(
        height: 35,
        child: Center(
          child: Text(
            '$day',
            textAlign: TextAlign.center,
            style: GoogleFonts.zenMaruGothic(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              height: 1.20,
            ),
          ),
        ),
      );
    }
  }
}
