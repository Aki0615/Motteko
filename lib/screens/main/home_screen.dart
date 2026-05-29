import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/app_state.dart';
import '../../widgets/notification_card.dart';
import '../../widgets/streak_celebration.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasCheckedEvents = false;
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('users/${user.uid}/avatar.png');
      final url = await ref.getDownloadURL();
      if (mounted) setState(() => _avatarUrl = url);
    } catch (_) {}
  }

  void _checkStreakEvents(AppState appState) {
    if (_hasCheckedEvents) return;
    _hasCheckedEvents = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final milestone = appState.achievedMilestone;
      if (milestone != null) {
        StreakCelebrationDialog.show(context, milestone);
      } else if (appState.isStreakBroken) {
        StreakBrokenDialog.show(
          context,
          appState.previousStreak,
          appState.maxStreak,
        );
      }
    });
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'おはよう';
    if (hour < 17) return 'こんにちは';
    return 'こんばんは';
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    _checkStreakEvents(appState);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
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
          // メインコンテンツ
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(appState),
                  const SizedBox(height: 19),
                  _buildGreeting(appState),
                  const SizedBox(height: 19),
                  _buildStatCards(appState),
                  const SizedBox(height: 19),
                  _buildMostForgottenSection(),
                  const SizedBox(height: 19),
                  _buildRecentNotifications(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AppState appState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'ホーム',
            style: GoogleFonts.zenMaruGothic(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: AppColors.black1000,
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/settings'),
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
              clipBehavior: Clip.antiAlias,
              child: _avatarUrl != null
                  ? Image.network(
                      _avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.person, color: Colors.grey),
                    )
                  : const Icon(Icons.person, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting(AppState appState) {
    final name = appState.userName.isNotEmpty ? appState.userName : 'ゲスト';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_greeting()}、$nameさん 👋',
            style: GoogleFonts.zenMaruGothic(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2B2B2B),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '今日も忘れ物ゼロを目指そう',
            style: GoogleFonts.zenMaruGothic(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.gray500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCards(AppState appState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _buildStatCard(
            svgAsset: 'assets/icons/stat/stat_calendar.svg',
            iconBg: AppColors.primary400,
            label: '連続日数',
            value: '${appState.consecutiveDaysWithoutForgetting}',
            valueColor: AppColors.primary700,
            unit: '日',
          ),
          const SizedBox(width: 26),
          _buildStatCard(
            svgAsset: 'assets/icons/stat/stat_bell.svg',
            iconBg: const Color(0xFFD1FAE5),
            label: '通知',
            value: '${appState.notificationCount}',
            valueColor: AppColors.success,
            unit: '件',
          ),
          const SizedBox(width: 26),
          _buildStatCard(
            svgAsset: 'assets/icons/stat/stat_box.svg',
            iconBg: const Color(0xFFDBE8FF),
            label: '登録数',
            value: '${appState.items.length}',
            valueColor: AppColors.focus100,
            unit: '個',
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String svgAsset,
    required Color iconBg,
    required String label,
    required String value,
    required Color valueColor,
    required String unit,
  }) {
    return Expanded(
      child: Container(
        height: 134,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F35291E),
              offset: Offset(1, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(svgAsset, width: 22, height: 22),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.zenMaruGothic(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.zenMaruGothic(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: valueColor,
                height: 0.9,
              ),
            )
                .animate(onPlay: (c) => c.forward())
                .scale(
                  begin: const Offset(0.7, 0.7),
                  end: const Offset(1.0, 1.0),
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                ),
            Text(
              unit,
              style: GoogleFonts.zenMaruGothic(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMostForgottenSection() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox.shrink();

    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(21),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F35291E),
              offset: Offset(1, 2),
              blurRadius: 3,
            ),
          ],
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('detections')
              .where('timestamp',
                  isGreaterThan: Timestamp.fromDate(thirtyDaysAgo))
              .snapshots(),
          builder: (context, snapshot) {
            String itemName = '---';
            int itemCount = 0;

            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              final counts = <String, int>{};
              for (var doc in snapshot.data!.docs) {
                final data = doc.data() as Map<String, dynamic>;
                final missing =
                    data['missing_items'] as List<dynamic>? ?? [];
                for (var item in missing) {
                  final name = item.toString();
                  counts[name] = (counts[name] ?? 0) + 1;
                }
              }
              if (counts.isNotEmpty) {
                final top =
                    counts.entries.reduce((a, b) => a.value > b.value ? a : b);
                itemName = top.key;
                itemCount = top.value;
              }
            }

            return _buildForgottenContent(itemName, itemCount);
          },
        ),
      ),
    );
  }

  Widget _buildDashedLine({required Color color}) {
    const dashWidth = 4.0;
    const dashSpace = 3.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final count = (availableWidth / (dashWidth + dashSpace)).floor();
        return SizedBox(
          height: 1,
          child: Row(
            children: List.generate(count, (_) {
              return Padding(
                padding: const EdgeInsets.only(right: dashSpace),
                child: SizedBox(
                  width: dashWidth,
                  height: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: color),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildForgottenContent(String itemName, int itemCount) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: _buildForgottenDescription()),
        const SizedBox(width: 18),
        _buildForgottenItemBadge(itemName, itemCount),
      ],
    );
  }

  Widget _buildForgottenDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 39,
          height: 39,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0B3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFFFA600),
            size: 24,
          ),
        ),
        const SizedBox(height: 11),
        Text(
          'よく忘れるアイテム',
          style: GoogleFonts.zenMaruGothic(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF111111),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '自分の傾向を知って、\n対策できる。',
          style: GoogleFonts.zenMaruGothic(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF4B5563),
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        _buildDashedLine(color: AppColors.primary400),
        const SizedBox(height: 8),
        Text(
          '課題の可視化で、忘れ物を減らせる',
          style: GoogleFonts.zenMaruGothic(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.gray500,
          ),
        ),
      ],
    );
  }

  Widget _buildForgottenItemBadge(String itemName, int itemCount) {
    return Container(
      width: 130,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x1A000000)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              itemName,
              style: GoogleFonts.zenMaruGothic(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF222222),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            itemCount > 0 ? '$itemCount回' : '',
            style: GoogleFonts.zenMaruGothic(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.gray700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentNotifications() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '最近の通知',
                style: GoogleFonts.zenMaruGothic(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.black1000,
                ),
              ),
              GestureDetector(
                onTap: () => context.go('/notifications'),
                child: Text(
                  'すべて表示',
                  style: GoogleFonts.zenMaruGothic(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.focus100,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('detections')
                .orderBy('timestamp', descending: true)
                .limit(2)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError ||
                  snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData ||
                  snapshot.data!.docs.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text(
                      '通知はありません',
                      style: GoogleFonts.zenMaruGothic(
                        color: AppColors.gray500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return NotificationCard(data: data);
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
