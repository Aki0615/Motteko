import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
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
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    _buildDescriptionCard(),
                    const SizedBox(height: 16),
                    _buildSensorStatusCard(appState),
                    const SizedBox(height: 16),
                    _buildLastDetectedCard(appState),
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

  Widget _buildHeader() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'センサー状態',
            style: TextStyle(
              color: AppColors.primary700,
              fontSize: 32,
              fontFamily: 'Zen Maru Gothic',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '人感センサーについて',
            style: TextStyle(
              color: AppColors.gray900,
              fontSize: 16,
              fontFamily: 'Zen Maru Gothic',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12),
          Text(
            '玄関などに設置したセンサーで人の動きを検知します。外出時にカメラと連動して、忘れ物チェックを行います。',
            style: TextStyle(
              color: AppColors.gray700,
              fontSize: 14,
              fontFamily: 'Zen Maru Gothic',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorStatusCard(AppState appState) {
    final isPresent = appState.sensorStatus.isPersonPresent;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        children: [
          _buildSensorIcon(isPresent),
          const SizedBox(height: 12),
          const Text(
            '人感センサー',
            style: TextStyle(
              color: AppColors.gray900,
              fontSize: 16,
              fontFamily: 'Zen Maru Gothic',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          _buildStatusBadge(isPresent),
        ],
      ),
    );
  }

  Widget _buildSensorIcon(bool isPresent) {
    return Container(
      width: 100,
      height: 100,
      decoration: ShapeDecoration(
        color: const Color(0xFFF4F6F7),
        shape: OvalBorder(
          side: BorderSide(
            width: 1,
            color: isPresent ? const Color(0xFF10B981) : AppColors.gray500,
          ),
        ),
      ),
      child: Center(
        child: Container(
          width: 50,
          height: 50,
          decoration: ShapeDecoration(
            color: isPresent ? const Color(0xFF10B981) : const Color(0xFFD9D9D9),
            shape: const OvalBorder(),
          ),
          child: Icon(
            Icons.person,
            color: isPresent ? Colors.white : AppColors.gray500,
            size: 30,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isPresent) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: ShapeDecoration(
        color: isPresent ? const Color(0xFF10B981) : const Color(0xFFDFE3E9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Center(
        child: Text(
          isPresent ? '検知中' : '未検知',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'Zen Maru Gothic',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildLastDetectedCard(AppState appState) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const ShapeDecoration(
              color: Color(0xFFDFEBFE),
              shape: OvalBorder(),
            ),
            child: const Icon(Icons.access_time, color: Color(0xFF3A55AE), size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '最終検知時刻',
                style: TextStyle(
                  color: AppColors.gray700,
                  fontSize: 12,
                  fontFamily: 'Zen Maru Gothic',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                _formatLastDetected(appState.sensorStatus.lastDetectedTime),
                style: const TextStyle(
                  color: AppColors.gray700,
                  fontSize: 12,
                  fontFamily: 'Zen Maru Gothic',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatLastDetected(DateTime dateTime) {
    return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }
}
