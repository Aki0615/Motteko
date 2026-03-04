import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

/// 利用規約画面
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

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
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 2, color: Colors.black),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go('/settings'),
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFB9BFC9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '利用規約',
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

            const SizedBox(height: 24),

            // ============================================================
            // 利用規約バージョンカード
            // ============================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Container(
                width: double.infinity,
                height: 70,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2, color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0xFF000000),
                      blurRadius: 0,
                      offset: Offset(2, 3),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    // オレンジアイコンボックス
                    Container(
                      width: 40,
                      height: 40,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFF7B00),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1.50, color: Colors.black),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0xFF000000),
                            blurRadius: 0,
                            offset: Offset(2, 3),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.description_outlined,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // バージョン情報
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '利用規約 ver 1.0.0',
                          style: GoogleFonts.zenMaruGothic(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            height: 1.20,
                          ),
                        ),
                        Text(
                          '最終更新： 2026年1月1日',
                          style: GoogleFonts.zenMaruGothic(
                            color: const Color(0xFFB9BFC9),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            height: 1.53,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ============================================================
            // 利用規約本文
            // ============================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2, color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0xFF000000),
                      blurRadius: 0,
                      offset: Offset(2, 3),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 第1条
                    _buildArticleTitle('第1条 サービスの概要'),
                    const SizedBox(height: 8),
                    _buildArticleBody(
                      '本アプリ「Motteko」は、IoTセンサーを活用した忘れ物防止サービスです。ユーザーは本規約に同意した上でサービスをご利用ください。',
                    ),
                    const SizedBox(height: 16),

                    // 第2条
                    _buildArticleTitle('第2条 アカウント'),
                    const SizedBox(height: 8),
                    _buildArticleBody(
                      'アカウントの登録・管理はユーザー自身の責任で行なってください。第三者への譲渡・貸与は禁止します。',
                    ),
                    const SizedBox(height: 16),

                    // 第3条
                    _buildArticleTitle('第3条 禁止事項'),
                    const SizedBox(height: 8),
                    _buildArticleBody(
                      '不正アクセス・逆アンセブル・サービスの商用利用・他社への迷惑行為は固く禁じます。',
                    ),
                    const SizedBox(height: 16),

                    // 第4条
                    _buildArticleTitle('第4条 免責事項'),
                    const SizedBox(height: 8),
                    _buildArticleBody(
                      '本サービスの利用により生じた損害について、私たちは一切の責任を負いません。',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  // 条文タイトル
  Widget _buildArticleTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.zenMaruGothic(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w900,
        height: 1.20,
      ),
    );
  }

  // 条文本文
  Widget _buildArticleBody(String body) {
    return Text(
      body,
      style: GoogleFonts.zenMaruGothic(
        color: Colors.black,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        height: 1.53,
      ),
    );
  }
}
