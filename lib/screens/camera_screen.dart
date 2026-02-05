import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

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
                    'カメラ監視',
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // カメラプレビューエリア
                    Container(
                      width: double.infinity,
                      height: 250,
                      padding: const EdgeInsets.all(16),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF1F2937),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            color: Color(0xFFE5E7EB),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // カメラアイコン（停止中は斜線入り）
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              appState.isCameraActive
                                  ? Icons.videocam
                                  : Icons.videocam_off_outlined,
                              size: 48,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            appState.isCameraActive
                                ? 'カメラ起動中...'
                                : 'カメラは停止しています',
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 14,
                              fontFamily: 'LINESeedJP',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 写真を撮影ボタン
                    GestureDetector(
                      onTap: () {
                        appState.toggleCamera();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              appState.isCameraActive
                                  ? 'カメラを起動しました'
                                  : 'カメラを停止しました',
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFFF7B00),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '写真を撮影',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'LINESeedJP',
                                fontWeight: FontWeight.w500,
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
          ],
        ),
      ),
    );
  }
}
