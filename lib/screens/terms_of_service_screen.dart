import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/constants/app_colors.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

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
              padding: const EdgeInsets.only(bottom: 120),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 53),
                    _buildVersionCard(),
                    const SizedBox(height: 27),
                    _buildTermsContent(),
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
          '利用規約',
          style: GoogleFonts.zenMaruGothic(
            color: AppColors.black1000,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            height: 1.20,
          ),
        ),
        Text(
          'サービス利用に関する規約',
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

  Widget _buildVersionCard() {
    return Container(
      width: double.infinity,
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F35291E),
            offset: Offset(1, 2),
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary700,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.description_outlined, size: 24, color: Colors.white),
          ),
          const SizedBox(width: 31),
          Expanded(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '利用規約 ver 1.0.0',
                style: GoogleFonts.zenMaruGothic(
                  color: AppColors.black1000,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  height: 1.20,
                ),
              ),
              Text(
                '最終更新： 2026年1月1日',
                style: GoogleFonts.zenMaruGothic(
                  color: const Color(0xFFB9C0C9),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  height: 1.20,
                ),
              ),
            ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F35291E),
            offset: Offset(1, 2),
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildArticle(
            '第1条 サービスの概要',
            '本アプリ「Motteko」は、IoTセンサーを活用した忘れ物防止サービスです。ユーザーは本規約に同意した上でサービスをご利用ください。',
          ),
          const SizedBox(height: 12),
          _buildArticle(
            '第2条 アカウント',
            'アカウントの登録・管理はユーザー自身の責任で行なってください。第三者への譲渡・貸与は禁止します。',
          ),
          const SizedBox(height: 12),
          _buildArticle(
            '第3条 禁止事項',
            '不正アクセス・逆アンセブル・サービスの商用利用・他社への迷惑行為は固く禁じます。',
          ),
          const SizedBox(height: 12),
          _buildArticle(
            '第4条 免責事項',
            '本サービスの利用により生じた損害について、私たちは一切の責任を負いません。',
          ),
        ],
      ),
    );
  }

  Widget _buildArticle(String title, String body) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.zenMaruGothic(
            color: AppColors.black1000,
            fontSize: 14,
            fontWeight: FontWeight.w900,
            height: 1.20,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          body,
          style: GoogleFonts.zenMaruGothic(
            color: AppColors.black1000,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            height: 1.53,
          ),
        ),
      ],
    );
  }
}
