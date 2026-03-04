import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// デバイスID登録画面
class DeviceIdInputScreen extends StatefulWidget {
  const DeviceIdInputScreen({super.key});

  @override
  State<DeviceIdInputScreen> createState() => _DeviceIdInputScreenState();
}

class _DeviceIdInputScreenState extends State<DeviceIdInputScreen> {
  final TextEditingController _idController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================================================
            // ヘッダー
            // ============================================================
            Container(
              width: double.infinity,
              height: 60,
              margin: const EdgeInsets.only(top: 48),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 2, color: Colors.black),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'デバイス登録',
                    style: GoogleFonts.zenMaruGothic(
                      color: const Color(0xFFFF7B00),
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      height: 0.90,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // ============================================================
            // アイコン
            // ============================================================
            const Center(
              child: Icon(
                Icons.important_devices,
                size: 96,
                color: Color(0xFF26A5FF),
              ),
            ),

            const SizedBox(height: 24),

            // ============================================================
            // 説明テキスト
            // ============================================================
            Center(
              child: SizedBox(
                width: 280,
                child: Text(
                  'Mottekoデバイスの画面に表示されているIDを入力してください。',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.zenMaruGothic(
                    color: const Color(0xFF6B7280),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.20,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ============================================================
            // ID入力フィールド
            // ============================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'デバイスID (MACアドレス)',
                    style: GoogleFonts.zenMaruGothic(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      height: 1.20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0xFF000000),
                          blurRadius: 0,
                          offset: Offset(2, 3),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: TextField(
                      controller: _idController,
                      style: GoogleFonts.zenMaruGothic(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        hintText: '例: A1B2C3D4E5F6',
                        hintStyle: GoogleFonts.zenMaruGothic(
                          color: const Color(0xFFB9BFC9),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // ============================================================
            // 登録ボタン
            // ============================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: GestureDetector(
                onTap: () async {
                  final deviceId = _idController.text.trim();
                  if (deviceId.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('デバイスIDを入力してください。'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  // SharedPreferencesに保存
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('motteko_device_id', deviceId);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('デバイスを登録しました！'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    // ホーム画面へ戻る
                    context.go('/');
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFF7B00),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0xFF000000),
                        blurRadius: 0,
                        offset: Offset(2, 3),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '登録して設定を完了',
                      style: GoogleFonts.zenMaruGothic(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        height: 1.20,
                      ),
                    ),
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
