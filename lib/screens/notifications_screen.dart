import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/constants/app_colors.dart';
import '../widgets/notification_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'all';

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('detections')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('エラーが発生しました: ${snapshot.error}'),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return _buildEmptyState();
                      }

                      final allDocs = snapshot.data!.docs;
                      final filteredDocs = _filterDocs(allDocs);

                      if (filteredDocs.isEmpty) {
                        return _buildEmptyState();
                      }

                      final grouped = _groupByDate(filteredDocs);

                      return ListView(
                        padding: const EdgeInsets.fromLTRB(27, 0, 27, 100),
                        children: _buildGroupedList(grouped),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(27, 0, 27, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '通知',
            style: GoogleFonts.zenMaruGothic(
              color: AppColors.black1000,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              height: 1.20,
            ),
          ),
          Text(
            'お知らせを、見やすく',
            style: GoogleFonts.zenMaruGothic(
              color: AppColors.black1000,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.20,
            ),
          ),
          const SizedBox(height: 53),
          _buildFilterTabs(),
          const SizedBox(height: 22),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Row(
      children: [
        _buildFilterTab('all', 'すべて'),
        const SizedBox(width: 23),
        _buildFilterTab('success', '成功'),
        const SizedBox(width: 23),
        _buildFilterTab('warning', '警告'),
      ],
    );
  }

  Widget _buildFilterTab(String filter, String label) {
    final isSelected = _selectedFilter == filter;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filter),
      child: Container(
        width: 60,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary400
                  : const Color(0xFFAAAEB4),
              blurRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.zenMaruGothic(
              color: isSelected ? AppColors.primary700 : AppColors.gray500,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.20,
            ),
          ),
        ),
      ),
    );
  }

  List<QueryDocumentSnapshot> _filterDocs(List<QueryDocumentSnapshot> docs) {
    if (_selectedFilter == 'all') return docs;

    return docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final message = data['message'] as String? ?? '';
      final missingItems = data['missing_items'] as List<dynamic>? ?? [];

      if (_selectedFilter == 'warning') {
        return missingItems.isNotEmpty || message.contains('忘れ物');
      } else {
        return missingItems.isEmpty && !message.contains('忘れ物') && !message.contains('検知');
      }
    }).toList();
  }

  Map<String, List<QueryDocumentSnapshot>> _groupByDate(
      List<QueryDocumentSnapshot> docs) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sevenDaysAgo = today.subtract(const Duration(days: 7));

    final Map<String, List<QueryDocumentSnapshot>> grouped = {};

    for (final doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final timestamp = data['timestamp'] as Timestamp?;
      if (timestamp == null) continue;

      final date = timestamp.toDate();
      final dateOnly = DateTime(date.year, date.month, date.day);

      String group;
      if (dateOnly == today) {
        group = '今日';
      } else if (dateOnly.isAfter(sevenDaysAgo)) {
        group = '過去7日';
      } else {
        group = 'それ以前';
      }

      grouped.putIfAbsent(group, () => []);
      grouped[group]!.add(doc);
    }

    return grouped;
  }

  List<Widget> _buildGroupedList(
      Map<String, List<QueryDocumentSnapshot>> grouped) {
    final List<Widget> widgets = [];
    const groupOrder = ['今日', '過去7日', 'それ以前'];

    for (final group in groupOrder) {
      final docs = grouped[group];
      if (docs == null || docs.isEmpty) continue;

      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            group,
            style: GoogleFonts.zenMaruGothic(
              color: AppColors.gray500,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.20,
            ),
          ),
        ),
      );

      for (final doc in docs) {
        final data = doc.data() as Map<String, dynamic>;
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: NotificationCard(data: data),
          ),
        );
      }

      widgets.add(const SizedBox(height: 12));
    }

    return widgets;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.primary400,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none,
              size: 40,
              color: AppColors.primary700,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '通知はありません',
            style: GoogleFonts.zenMaruGothic(
              color: AppColors.gray500,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
