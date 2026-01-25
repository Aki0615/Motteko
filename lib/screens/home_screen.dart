import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_state.dart';
import '../widgets/stats_card.dart';
import '../models/notification_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
        actions: [
          // デモデータ読み込みボタン
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              appState.loadDemoData();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('デモデータを読み込みました')),
              );
            },
            tooltip: 'デモデータ読み込み',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // データのリフレッシュ(現在は何もしない)
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 挨拶メッセージ
              Text(
                _getGreeting(),
                style: theme.textTheme.displayMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '今日も忘れ物なく過ごしましょう!',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.textTheme.bodyLarge?.color?.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 24),

              // 統計情報カード
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  StatsCard(
                    icon: Icons.celebration,
                    title: '連続日数',
                    value: '${appState.consecutiveDaysWithoutForgetting}日',
                    accentColor: theme.colorScheme.secondary,
                  ),
                  StatsCard(
                    icon: Icons.backpack,
                    title: '登録アイテム',
                    value: '${appState.items.length}個',
                    accentColor: theme.colorScheme.primary,
                  ),
                  StatsCard(
                    icon: Icons.sensors,
                    title: 'センサー',
                    value:
                        appState.sensorStatus.isPersonPresent ? '検知中' : '未検知',
                    accentColor: appState.sensorStatus.isPersonPresent
                        ? Colors.green
                        : Colors.grey,
                  ),
                  StatsCard(
                    icon: Icons.notifications,
                    title: '通知',
                    value: '${appState.notifications.length}件',
                    accentColor: theme.colorScheme.tertiary,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // 最近の通知
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '最近の通知',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (appState.notifications.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        // 通知画面に遷移(既にナビゲーションバーから可能)
                      },
                      child: const Text('すべて表示'),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              if (appState.notifications.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.notifications_none,
                            size: 48,
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '通知はありません',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                ...appState.notifications.take(3).map((notification) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            _getNotificationColor(notification.type)
                                .withOpacity(0.2),
                        child: Icon(
                          _getNotificationIcon(notification.type),
                          color: _getNotificationColor(notification.type),
                        ),
                      ),
                      title: Text(notification.message),
                      subtitle: Text(
                        DateFormat('MM/dd HH:mm')
                            .format(notification.timestamp),
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'おはようございます';
    } else if (hour < 18) {
      return 'こんにちは';
    } else {
      return 'こんばんは';
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.warning:
        return Icons.warning_amber;
      case NotificationType.success:
        return Icons.check_circle;
      case NotificationType.info:
        return Icons.info;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.success:
        return Colors.green;
      case NotificationType.info:
        return Colors.blue;
    }
  }
}
