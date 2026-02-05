import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class SensorsScreen extends StatelessWidget {
  const SensorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ヘッダー部分
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'センサー状態',
                    style: TextStyle(
                      color: Color(0xFFFF7B00),
                      fontSize: 32,
                      fontFamily: 'LINESeedJP',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            // メインコンテンツエリア
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    // 人感センサーについての説明カード
                    Container(
                      width: double.infinity,
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
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '人感センサーについて',
                            style: TextStyle(
                              color: Color(0xFF111827),
                              fontSize: 16,
                              fontFamily: 'LINESeedJP',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            '玄関などに設置したセンサーで人の動きを検知します。外出時にカメラと連動して、忘れ物チェックを行います。',
                            style: TextStyle(
                              color: Color(0xFF374151),
                              fontSize: 14,
                              fontFamily: 'LINESeedJP',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 人感センサー状態カード
                    Container(
                      width: double.infinity,
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
                      child: Column(
                        children: [
                          // センサーアイコン
                          Container(
                            width: 100,
                            height: 100,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF4F6F7),
                              shape: OvalBorder(
                                side: BorderSide(
                                  width: 1,
                                  color: appState.sensorStatus.isPersonPresent
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFF6B7280),
                                ),
                              ),
                            ),
                            child: Center(
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: ShapeDecoration(
                                  color: appState.sensorStatus.isPersonPresent
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFD9D9D9),
                                  shape: const OvalBorder(),
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: appState.sensorStatus.isPersonPresent
                                      ? Colors.white
                                      : const Color(0xFF6B7280),
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // センサーラベル
                          const Text(
                            '人感センサー',
                            style: TextStyle(
                              color: Color(0xFF111827),
                              fontSize: 16,
                              fontFamily: 'LINESeedJP',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // 状態バッジ
                          Container(
                            height: 32,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: ShapeDecoration(
                              color: appState.sensorStatus.isPersonPresent
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFDFE3E9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                appState.sensorStatus.isPersonPresent
                                    ? '検知中'
                                    : '未検知',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'LINESeedJP',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 最終検知時刻カード
                    Container(
                      width: double.infinity,
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
                        children: [
                          // アイコン
                          Container(
                            width: 30,
                            height: 30,
                            decoration: const ShapeDecoration(
                              color: Color(0xFFDFEBFE),
                              shape: OvalBorder(),
                            ),
                            child: const Icon(
                              Icons.access_time,
                              color: Color(0xFF3A55AE),
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // テキスト
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '最終検知時刻',
                                style: TextStyle(
                                  color: Color(0xFF374151),
                                  fontSize: 12,
                                  fontFamily: 'LINESeedJP',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                _formatLastDetected(
                                    appState.sensorStatus.lastDetectedTime),
                                style: const TextStyle(
                                  color: Color(0xFF374151),
                                  fontSize: 12,
                                  fontFamily: 'LINESeedJP',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ナビゲーションバーの高さ分の余白
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatLastDetected(DateTime dateTime) {
    return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }
}
