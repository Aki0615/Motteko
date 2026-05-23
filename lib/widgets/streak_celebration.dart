import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import '../core/constants/app_colors.dart';

class StreakCelebrationDialog extends StatefulWidget {
  final int milestone;
  final VoidCallback onDismiss;

  const StreakCelebrationDialog({
    super.key,
    required this.milestone,
    required this.onDismiss,
  });

  @override
  State<StreakCelebrationDialog> createState() =>
      _StreakCelebrationDialogState();

  static void show(BuildContext context, int milestone) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'celebration',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return StreakCelebrationDialog(
          milestone: milestone,
          onDismiss: () => Navigator.of(context).pop(),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        final curve = CurvedAnimation(parent: anim1, curve: Curves.elasticOut);
        return ScaleTransition(scale: curve, child: child);
      },
    );
  }
}

class _StreakCelebrationDialogState extends State<StreakCelebrationDialog> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  String _milestoneEmoji(int days) {
    if (days >= 365) return '👑';
    if (days >= 100) return '🏆';
    if (days >= 50) return '⭐';
    if (days >= 30) return '🔥';
    if (days >= 14) return '💪';
    if (days >= 7) return '🎉';
    return '✨';
  }

  String _milestoneTitle(int days) {
    if (days >= 365) return '1年達成！';
    if (days >= 100) return '100日達成！';
    if (days >= 50) return '50日達成！';
    if (days >= 30) return '1ヶ月達成！';
    if (days >= 14) return '2週間達成！';
    if (days >= 7) return '1週間達成！';
    return '3日達成！';
  }

  String _milestoneMessage(int days) {
    if (days >= 100) return 'あなたは忘れ物マスターです！\nこの調子で記録を伸ばしましょう！';
    if (days >= 30) return '素晴らしい習慣が身についています！\nこれからも一緒に頑張りましょう！';
    if (days >= 7) return '忘れ物ゼロの習慣が\nできてきましたね！';
    return '良いスタートです！\nこの調子でいきましょう！';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Confetti
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: pi / 2,
            blastDirectionality: BlastDirectionality.explosive,
            maxBlastForce: 20,
            minBlastForce: 8,
            emissionFrequency: 0.05,
            numberOfParticles: 25,
            gravity: 0.1,
            colors: const [
              AppColors.primary700,
              Color(0xFFFF9E64),
              Color(0xFFFFDAC4),
              Color(0xFFFF6100),
              Colors.white,
              Color(0xFFFFC107),
            ],
          ),
        ),
        // Dialog
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 2, color: Colors.black),
                borderRadius: BorderRadius.circular(24),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0xFF000000),
                  blurRadius: 0,
                  offset: Offset(4, 5),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _milestoneEmoji(widget.milestone),
                  style: const TextStyle(fontSize: 56),
                ),
                const SizedBox(height: 12),
                Text(
                  _milestoneTitle(widget.milestone),
                  style: GoogleFonts.zenMaruGothic(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.milestone}日連続忘れ物なし',
                  style: GoogleFonts.zenMaruGothic(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _milestoneMessage(widget.milestone),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.zenMaruGothic(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.onDismiss,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'やったー！',
                      style: GoogleFonts.zenMaruGothic(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class StreakBrokenDialog extends StatelessWidget {
  final int previousStreak;
  final int maxStreak;
  final VoidCallback onDismiss;

  const StreakBrokenDialog({
    super.key,
    required this.previousStreak,
    required this.maxStreak,
    required this.onDismiss,
  });

  static void show(
      BuildContext context, int previousStreak, int maxStreak) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'streak-broken',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return StreakBrokenDialog(
          previousStreak: previousStreak,
          maxStreak: maxStreak,
          onDismiss: () => Navigator.of(context).pop(),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(opacity: anim1, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 2, color: Colors.black),
            borderRadius: BorderRadius.circular(24),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0xFF000000),
              blurRadius: 0,
              offset: Offset(4, 5),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('💪', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            Text(
              'また1日目から！',
              style: GoogleFonts.zenMaruGothic(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.primary700,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '前回の記録: ',
                        style: GoogleFonts.zenMaruGothic(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        '$previousStreak日',
                        style: GoogleFonts.zenMaruGothic(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '最高記録: ',
                        style: GoogleFonts.zenMaruGothic(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        '$maxStreak日 🏆',
                        style: GoogleFonts.zenMaruGothic(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '大丈夫、誰でも忘れることはあります！\nまた一緒にがんばりましょう！',
              textAlign: TextAlign.center,
              style: GoogleFonts.zenMaruGothic(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onDismiss,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 2, color: Colors.black),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'よし、がんばる！',
                  style: GoogleFonts.zenMaruGothic(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
