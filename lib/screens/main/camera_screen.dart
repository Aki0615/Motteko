import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  String? _deviceId;
  bool _isChecking = false;

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
      body: Stack(
        children: [
          Positioned(
            left: -85,
            top: -215,
            width: 360,
            height: 346.5,
            child: SvgPicture.asset(
              'assets/icons/common/items_bg_decoration.svg',
              fit: BoxFit.fill,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 54),
                    _buildCameraCard(),
                    const SizedBox(height: 15),
                    _buildDetectionResultCard(),
                    const SizedBox(height: 15),
                    _buildCheckButton(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'カメラ',
          style: GoogleFonts.zenMaruGothic(
            color: AppColors.black1000,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            height: 1.20,
          ),
        ),
        Text(
          '持ち物をアプリから確認',
          style: GoogleFonts.zenMaruGothic(
            color: AppColors.black1000,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.20,
          ),
        ),
      ],
    );
  }

  Widget _buildCameraCard() {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: AppColors.black1000,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 24,
            top: 16,
            right: 24,
            bottom: 0,
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _buildCameraContent(),
                  ),
                ),
              ],
            ),
          ),
          if (_isChecking)
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: Center(
                child: Container(
                  height: 20,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.34),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '持ち物を確認中...',
                      style: GoogleFonts.zenMaruGothic(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCameraContent() {
    if (_deviceId == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/common/camera_off.png',
              width: 48,
              height: 48,
            ),
            const SizedBox(height: 8),
            Text(
              'カメラは停止しています',
              style: GoogleFonts.zenMaruGothic(
                color: AppColors.gray500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    final imageUrl =
        'https://firebasestorage.googleapis.com/v0/b/matsuriba-max.firebasestorage.app/o/inbox%2F$_deviceId.jpg?alt=media&t=${DateTime.now().millisecondsSinceEpoch}';

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/common/camera_off.png',
                width: 48,
                height: 48,
              ),
              const SizedBox(height: 8),
              Text(
                'カメラは停止しています',
                style: GoogleFonts.zenMaruGothic(
                  color: AppColors.gray500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetectionResultCard() {
    // TODO: デモ用ダミーデータ（本番では削除してStreamBuilderに戻す）
    return _buildResultCard(
      message: '4つのアイテムを確認しました',
      subMessage: '下記の持ち物があります',
      items: ['財布', '鍵', 'イヤホン', '定期'],
      isSuccess: true,
    );
  }

  Widget _buildResultCard({
    required String message,
    required String subMessage,
    required List<String> items,
    required bool isSuccess,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF5F0EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F35291E),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              _buildStatusIcon(isSuccess),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: GoogleFonts.zenMaruGothic(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.20,
                      ),
                    ),
                    Text(
                      subMessage,
                      style: GoogleFonts.zenMaruGothic(
                        color: AppColors.gray500,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        height: 1.20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (items.isNotEmpty) ...[
            const SizedBox(height: 11),
            Wrap(
              spacing: 15,
              runSpacing: 8,
              children: items
                  .map((item) => _buildItemChip(item))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusIcon(bool isSuccess) {
    return SizedBox(
      width: 30,
      height: 30,
      child: Stack(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: isSuccess
                  ? AppColors.success
                  : const Color(0xFFFFA600),
              shape: BoxShape.circle,
            ),
          ),
          const Center(
            child: Icon(
              Icons.check,
              size: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEF7200)),
      ),
      child: Text(
        label,
        style: GoogleFonts.zenMaruGothic(
          color: AppColors.black1000,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildCheckButton() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 250),
        child: GestureDetector(
        onTap: _isChecking ? null : _checkItems,
        child: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: _isChecking
                ? AppColors.primary700.withValues(alpha: 0.6)
                : AppColors.primary700,
            borderRadius: BorderRadius.circular(999999),
          ),
          child: Center(
            child: Text(
              _isChecking ? '確認中...' : '持ち物を確認する',
              style: GoogleFonts.zenMaruGothic(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.20,
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }

  Future<void> _checkItems() async {
    if (_deviceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'デバイスが接続されていません',
            style: GoogleFonts.zenMaruGothic(),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _isChecking = true);

    try {
      await FirebaseFirestore.instance.collection('commands').add({
        'command': 'take_photo',
        'device_id': _deviceId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '撮影リクエストを送信しました',
              style: GoogleFonts.zenMaruGothic(),
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      }

      await Future.delayed(const Duration(seconds: 3));
      if (mounted) setState(() => _isChecking = false);
    } catch (e) {
      debugPrint('Error checking items: $e');
      if (mounted) setState(() => _isChecking = false);
    }
  }
}
