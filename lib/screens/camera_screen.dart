import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  String? _deviceId;

  @override
  void initState() {
    super.initState();
    _loadDeviceId();
  }

  Future<void> _loadDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _deviceId = prefs.getString('motteko_device_id');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ============================================================
              // ヘッダー「カメラ」
              // ============================================================
              Container(
                width: double.infinity,
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 2, color: Colors.black),
                  ),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  'カメラ',
                  style: GoogleFonts.zenMaruGothic(
                    color: const Color(0xFFFF7B00),
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ============================================================
              // カメラプレビュー領域
              // ============================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  height: 250,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF1F2937),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 0,
                        offset: Offset(3, 4.5),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: _buildCameraContent(),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ============================================================
              // 撮影ボタン & 画像更新ボタン
              // ============================================================
              Column(
                children: [
                  GestureDetector(
                    onTap: _takePhoto,
                    child: Container(
                      height: 48,
                      width: 200, // Figmaデザインに合わせた横幅
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFF7B00),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.circular(24), // 丸みを強く
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 0,
                            offset: Offset(3, 4.5),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '写真を撮影',
                        style: GoogleFonts.zenMaruGothic(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // _timestampは未使用になったため、直接setState内では何もしなくてもbuildが走る。
                        // 画像URLのタイムスタンプ部分は DateTime.now().millisecondsSinceEpoch で再生成される。
                      });
                    },
                    child: Container(
                      height: 48,
                      width: 280, // 少し幅広のグレーボタン
                      decoration: ShapeDecoration(
                        color: const Color(0xFF6B7280), // グレー
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 0,
                            offset: Offset(3, 4.5),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '最新の画像を読み込む',
                        style: GoogleFonts.zenMaruGothic(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 48),

              // ============================================================
              // 判定ステータス表示
              // ============================================================
              _buildDetectionStatus(),

              const SizedBox(height: 100), // ボトムナビゲーション用の余白
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _takePhoto() async {
    if (_deviceId == null) return;

    try {
      // Firestoreの commands コレクションに take_photo 命令を追加
      await FirebaseFirestore.instance.collection('commands').add({
        'command': 'take_photo',
        'device_id': _deviceId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('撮影リクエストを送信しました'),
            duration: Duration(seconds: 1),
          ),
        );
      }

      // buildを再実行して画像URLのタイムスタンプを更新し、キャッシュを回避する
      setState(() {});
    } catch (e) {
      debugPrint('Error taking photo: $e');
    }
  }

  Widget _buildCameraContent() {
    if (_deviceId == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/camera_off.png',
            width: 48,
            height: 48,
          ),
          const SizedBox(height: 8),
          Text(
            'カメラは停止しています',
            style: GoogleFonts.zenMaruGothic(
              color: const Color(0xFF6B7280),
              fontSize: 14,
            ),
          ),
        ],
      );
    }

    final imageUrl =
        'https://firebasestorage.googleapis.com/v0/b/matsuriba-max.firebasestorage.app/o/inbox%2F$_deviceId.jpg?alt=media&t=${DateTime.now().millisecondsSinceEpoch}';

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/camera_off.png',
              width: 48,
              height: 48,
            ),
            const SizedBox(height: 8),
            Text(
              'カメラは停止しています',
              style: GoogleFonts.zenMaruGothic(
                color: const Color(0xFF6B7280),
                fontSize: 14,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetectionStatus() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('detections')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        bool hasMissingItem = false;
        String messageStr = '現在、カメラ内に物はない！偉い！';
        bool isLoading = !snapshot.hasData;

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          final data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
          final missingItems = data['missing_items'] as List<dynamic>? ?? [];
          final message = data['message'] as String? ?? '';

          if (missingItems.isNotEmpty || message.contains('忘れ物')) {
            hasMissingItem = true;
            messageStr = message.isNotEmpty ? message : '忘れ物があります！気をつけて！';
          }
        }

        if (isLoading) {
          return const SizedBox(height: 32);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: hasMissingItem
                  ? const Color(0xFFFEF3C7) // 薄いオレンジ（Figmaに合わせて調整）
                  : const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(60), // Figmaに合わせて丸みを強く
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: hasMissingItem
                        ? const Color(0xFFFDE68A) // アイコン背面の円
                        : const Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    hasMissingItem ? Icons.warning_amber_rounded : Icons.check,
                    color: hasMissingItem
                        ? const Color(0xFFF59E0B) // 濃いオレンジ
                        : Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    messageStr,
                    style: GoogleFonts.zenMaruGothic(
                      color: const Color(0xFF374151), // 少し濃いめのグレー
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
