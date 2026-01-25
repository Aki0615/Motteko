import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_state.dart';
import '../widgets/sensor_indicator.dart';

class SensorsScreen extends StatelessWidget {
  const SensorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('センサー状態'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 説明カード
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '人感センサーについて',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '玄関などに設置したセンサーで人の動きを検知します。外出時にカメラと連動して、忘れ物チェックを行います。',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // センサーインジケーター
            SensorIndicator(
              isActive: appState.sensorStatus.isPersonPresent,
              label: '人感センサー',
              onTap: () {
                appState.updateSensorStatus(
                  !appState.sensorStatus.isPersonPresent,
                );
              },
            ),
            const SizedBox(height: 24),

            // 最終検知時刻
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  child: Icon(
                    Icons.schedule,
                    color: theme.colorScheme.primary,
                  ),
                ),
                title: const Text('最終検知時刻'),
                subtitle: Text(
                  DateFormat('yyyy/MM/dd HH:mm:ss')
                      .format(appState.sensorStatus.lastDetectedTime),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 現在の状態
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: appState.sensorStatus.isPersonPresent
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  child: Icon(
                    appState.sensorStatus.isPersonPresent
                        ? Icons.person
                        : Icons.person_off,
                    color: appState.sensorStatus.isPersonPresent
                        ? Colors.green
                        : Colors.grey,
                  ),
                ),
                title: const Text('現在の状態'),
                subtitle: Text(
                  appState.sensorStatus.isPersonPresent
                      ? '人を検知しています'
                      : '人を検知していません',
                ),
                trailing: Switch(
                  value: appState.sensorStatus.isPersonPresent,
                  onChanged: (value) {
                    appState.updateSensorStatus(value);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          value ? 'センサーを検知状態にしました' : 'センサーを未検知状態にしました',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),

            // デモモード注意
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'これはデモモードです。実際のセンサーと連携するには、IoTデバイスとの接続設定が必要です。',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.orange[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 機能説明
            Card(
              color: theme.colorScheme.secondary.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '今後の予定機能',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureItem(
                      icon: Icons.bluetooth,
                      text: 'IoTセンサーとのBluetooth連携',
                    ),
                    _buildFeatureItem(
                      icon: Icons.wifi,
                      text: 'Wi-Fiネットワーク経由での接続',
                    ),
                    _buildFeatureItem(
                      icon: Icons.history,
                      text: '検知履歴の記録と分析',
                    ),
                    _buildFeatureItem(
                      icon: Icons.settings,
                      text: 'センサー感度の調整',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
