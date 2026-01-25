import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SensorIndicator extends StatelessWidget {
  final bool isActive;
  final String label;
  final VoidCallback? onTap;

  const SensorIndicator({
    super.key,
    required this.isActive,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indicatorColor = isActive ? Colors.green : Colors.grey;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: indicatorColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // アニメーション付きインジケーター
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: indicatorColor.withOpacity(0.2),
                border: Border.all(
                  color: indicatorColor,
                  width: 3,
                ),
              ),
              child: Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: indicatorColor,
                  ),
                )
                    .animate(
                      onPlay: (controller) => controller.repeat(),
                    )
                    .fadeIn(
                      duration: 1000.ms,
                    )
                    .then()
                    .fadeOut(
                      duration: 1000.ms,
                    ),
              ),
            ),
            const SizedBox(height: 16),
            // ラベル
            Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // 状態テキスト
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: indicatorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isActive ? '検知中' : '未検知',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: indicatorColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
