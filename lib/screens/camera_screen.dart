import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  String? _deviceId;
  int _timestamp = DateTime.now().millisecondsSinceEpoch;

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

  void _refreshImage() {
    setState(() {
      _timestamp = DateTime.now().millisecondsSinceEpoch;
    });
  }

  /// Firestoreに撮影リクエストを送信
  Future<void> _sendTakePhotoCommand(BuildContext context) async {
    try {
      // commands/camera_request ドキュメントを更新（なければ作成）
      await FirebaseFirestore.instance
          .collection('commands')
          .doc('camera_request')
          .set({
        'is_requested': true,
        'timestamp': FieldValue.serverTimestamp(), // 念のためタイムスタンプも更新
      }, SetOptions(merge: true));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('📸 撮影リクエストを送信しました！'),
            backgroundColor: Color(0xFF22C55E),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('エラーが発生しました: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // AppStateは引き続き使用するが、画像表示のメインはFirestoreストリームになる
    // final appState = context.watch<AppState>();

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
                      fontFamily: 'Zen Maru Gothic',
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
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('commands')
                      .doc('camera_request')
                      .snapshots(),
                  builder: (context, snapshot) {
                    bool isRequested = false;

                    if (snapshot.hasData && snapshot.data!.exists) {
                      final data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      isRequested = data['is_requested'] ?? false;
                    }

                    return Column(
                      children: [
                        const SizedBox(height: 20),

                        // カメラプレビューエリア（画像または状態表示）
                        Container(
                          width: double.infinity,
                          height: 250,
                          // padding: const EdgeInsets.all(16), // パディングを削除して画像を一杯に表示
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
                          alignment: Alignment.center, // コンテンツを中央寄せ
                          child: _buildCameraContent(isRequested),
                        ),

                        const SizedBox(height: 32),

                        // 写真を撮影ボタン
                        GestureDetector(
                          onTap: isRequested
                              ? null // リクエスト中は押せないようにする
                              : () {
                                  _sendTakePhotoCommand(context);
                                },
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            decoration: ShapeDecoration(
                              color: isRequested
                                  ? const Color(0xFF9CA3AF) // 無効時はグレー
                                  : const Color(0xFFFF7B00),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  isRequested ? '撮影中...' : '写真を撮影',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Zen Maru Gothic',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // 更新ボタン
                        GestureDetector(
                          onTap: _refreshImage,
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            decoration: ShapeDecoration(
                              color: const Color(0xFF6B7280),
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
                                  '最新の画像を読み込む',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Zen Maru Gothic',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraContent(bool isRequested) {
    if (isRequested) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16),
          Text(
            'カメラ起動中...',
            style: TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 14,
              fontFamily: 'Zen Maru Gothic',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );
    }

    if (_deviceId == null) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.device_unknown,
            size: 48,
            color: Color(0xFF6B7280),
          ),
          SizedBox(height: 16),
          Text(
            'デバイスが登録されていません\nWi-Fi設定から登録してください',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
              fontFamily: 'Zen Maru Gothic',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );
    }

    // デバイスIDに基づくURL (キャッシュバスティングのためtimestampを付与)
    final imageUrl =
        'https://firebasestorage.googleapis.com/v0/b/matsuriba-max.firebasestorage.app/o/inbox%2F$_deviceId.jpg?alt=media&t=$_timestamp';

    return Stack(
      fit: StackFit.expand,
      children: [
        // 画像
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.broken_image, size: 48, color: Color(0xFF6B7280)),
                  SizedBox(height: 8),
                  Text(
                    'まだ画像がありません',
                    style: TextStyle(color: Color(0xFF6B7280)),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
