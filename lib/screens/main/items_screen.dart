import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../providers/app_state.dart';
import '../../models/item_model.dart';
import '../../widgets/item_card.dart';
import '../../core/app_theme.dart';
import '../../core/constants/app_colors.dart';

class ItemsScreen extends StatelessWidget {
  const ItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

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
                  child: appState.items.isEmpty
                      ? _buildEmptyState(context, appState)
                      : _buildItemsList(context, appState),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: appState.items.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _showItemDialog(context, appState),
              backgroundColor: AppColors.primary700,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            )
          : null,
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(26, 0, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '持ち物リスト',
            style: GoogleFonts.zenMaruGothic(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              height: 1.20,
            ),
          ),
          Text(
            '忘れ物をなくす第一歩！',
            style: GoogleFonts.zenMaruGothic(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppState appState) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: SizedBox(
          width: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildEmptyIcon(),
            const SizedBox(height: 7),
            Text(
              '持ち物が登録されていません',
              textAlign: TextAlign.center,
              style: GoogleFonts.zenMaruGothic(
                color: AppColors.black1000,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                height: 1.20,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '最初のアイテムを追加してみましょう',
              textAlign: TextAlign.center,
              style: GoogleFonts.zenMaruGothic(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.20,
              ),
            ),
            const SizedBox(height: 16),
            _buildAddButton(context, appState),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildEmptyIcon() {
    return SizedBox(
      width: 94,
      height: 92,
      child: Stack(
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: const BoxDecoration(
              color: AppColors.primary400,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/common/items_empty_box.svg',
                width: 48,
                height: 53,
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 2,
            child: Container(
              width: 19,
              height: 19,
              decoration: const BoxDecoration(
                color: AppColors.primary700,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, AppState appState) {
    return GestureDetector(
      onTap: () => _showItemDialog(context, appState),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.primary700,
          border: Border.all(color: AppColors.primary700),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, size: 16, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              '最初のアイテムを追加',
              style: GoogleFonts.zenMaruGothic(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList(BuildContext context, AppState appState) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
      itemCount: appState.items.length,
      itemBuilder: (context, index) {
        final item = appState.items[index];
        return ItemCard(
          item: item,
          onTap: () => _showItemDialog(context, appState, existingItem: item),
          onDelete: () => _showDeleteConfirmation(context, appState, item),
        );
      },
    );
  }

  void _showItemDialog(BuildContext context, AppState appState,
      {ItemModel? existingItem}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _ItemFormPage(appState: appState, existingItem: existingItem),
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, AppState appState, ItemModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('アイテムを削除'),
        content: Text('「${item.name}」を削除してもよろしいですか?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              appState.removeItem(item.id);
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.errorRed,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('削除', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemFormPage extends StatefulWidget {
  final AppState appState;
  final ItemModel? existingItem;

  const _ItemFormPage({required this.appState, this.existingItem});

  @override
  State<_ItemFormPage> createState() => _ItemFormPageState();
}

class _ItemFormPageState extends State<_ItemFormPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  late bool _isWeekday;
  late bool _isWeekend;
  late bool _isRequired;

  bool get _isEditing => widget.existingItem != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existingItem?.name ?? '');
    _descController = TextEditingController(text: widget.existingItem?.description ?? '');
    _isWeekday = widget.existingItem?.isWeekday ?? false;
    _isWeekend = widget.existingItem?.isWeekend ?? false;
    _isRequired = widget.existingItem?.isRequired ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('名前を入力してください')),
      );
      return;
    }
    final newItem = ItemModel(
      id: _isEditing
          ? widget.existingItem!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      description: _descController.text.trim(),
      isRequired: _isRequired,
      isWeekday: _isWeekday,
      isWeekend: _isWeekend,
    );
    if (_isEditing) {
      widget.appState.updateItem(widget.existingItem!.id, newItem);
    } else {
      widget.appState.addItem(newItem);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: _buildFormCard(),
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
      width: double.infinity,
      height: 60,
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Color(0x40000000), blurRadius: 2, offset: Offset(0, 4), spreadRadius: 0),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, size: 30, color: Colors.black),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              _isEditing ? 'アイテムを編集' : '新しいアイテムを追加',
              style: GoogleFonts.zenMaruGothic(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.w700, height: 1.20,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          _buildHeaderIcon(),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon() {
    return SizedBox(
      width: 35,
      height: 35,
      child: Stack(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: const BoxDecoration(
              color: AppColors.primary400,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset('assets/icons/common/items_empty_box.svg', width: 18, height: 20),
            ),
          ),
          Positioned(
            right: 0,
            top: 1,
            child: Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: AppColors.primary700,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 280),
      child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F35291E),
            offset: Offset(1, 2),
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _isEditing ? 'アイテムを編集' : '新しいアイテムを追加',
            style: GoogleFonts.zenMaruGothic(
              color: const Color(0xFF111827), fontSize: 18, fontWeight: FontWeight.w900, height: 1.20,
            ),
          ),
          const SizedBox(height: 12),
          _buildTextField(_nameController, '名前', autofocus: !_isEditing),
          const SizedBox(height: 12),
          _buildTextField(_descController, '説明'),
          const SizedBox(height: 12),
          _buildToggle(
            title: '平日',
            description: '平日は持っていくもの(連続記録が平日のみ反映される)',
            titleColor: Colors.black,
            value: _isWeekday,
            onChanged: (v) => setState(() {
              _isWeekday = v;
              if (v) _isRequired = false;
            }),
          ),
          const SizedBox(height: 6),
          _buildToggle(
            title: '休日',
            description: '土日祝に持っていくもの(連続記録が土日祝のみ反映される)',
            titleColor: Colors.black,
            value: _isWeekend,
            onChanged: (v) => setState(() {
              _isWeekend = v;
              if (v) _isRequired = false;
            }),
          ),
          const SizedBox(height: 6),
          _buildToggle(
            title: '必須アイテム',
            description: '毎日持ち歩くものは\nONにしてください',
            titleColor: AppColors.primary700,
            value: _isRequired,
            onChanged: (v) => setState(() {
              _isRequired = v;
              if (v) { _isWeekday = false; _isWeekend = false; }
            }),
          ),
          const SizedBox(height: 16),
          _buildActions(),
        ],
      ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool autofocus = false}) {
    return Container(
      width: double.infinity,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        style: GoogleFonts.zenMaruGothic(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
        cursorColor: AppColors.primary700,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.zenMaruGothic(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildToggle({
    required String title,
    required String description,
    required Color titleColor,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SizedBox(
      height: 55,
      child: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: '$title\n',
                  style: GoogleFonts.zenMaruGothic(
                    color: titleColor, fontSize: 14, fontWeight: FontWeight.w700, height: 1.20,
                  ),
                ),
                TextSpan(
                  text: description,
                  style: GoogleFonts.zenMaruGothic(
                    color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400, height: 1.20,
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 51,
            height: 31,
            child: Switch(
              value: value,
              activeTrackColor: AppColors.primary700,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFFE5E7EB),
              thumbColor: WidgetStateProperty.all(Colors.white),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(19),
              ),
              child: Center(
                child: Text(
                  'キャンセル',
                  style: GoogleFonts.zenMaruGothic(
                    color: Colors.black, fontSize: 14, fontWeight: FontWeight.w700, height: 1.20,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _handleSave,
            child: Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.primary700,
                borderRadius: BorderRadius.circular(19),
              ),
              child: Center(
                child: Text(
                  _isEditing ? '更新' : '追加',
                  style: GoogleFonts.zenMaruGothic(
                    color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700, height: 1.20,
                  ),
                ),
              ),
            ),
          ),
        ],
    );
  }
}
