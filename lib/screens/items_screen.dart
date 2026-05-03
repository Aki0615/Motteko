import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/item_model.dart';
import '../widgets/item_card.dart';
import '../core/app_theme.dart';

class ItemsScreen extends StatelessWidget {
  const ItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ============================================================
          // ヘッダー（Figmaデザイン準拠）
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 22),
                Text(
                  '持ち物リスト',
                  style: GoogleFonts.zenMaruGothic(
                    color: const Color(0xFFFF7B00),
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    height: 0.90,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _showItemDialog(context, appState),
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFF7B00),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45),
                      ),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // メインコンテンツエリア
          Expanded(
            child: appState.items.isEmpty
                ? _buildEmptyState(context, appState)
                : _buildItemsList(context, appState),
          ),
        ],
      ),
      // ============================================================
      // 追加：アイテムが1つ以上ある時に表示される右下の「＋」ボタン
      // ============================================================
      floatingActionButton: appState.items.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _showItemDialog(context, appState),
              backgroundColor: const Color(0xFFFF7B00),
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            )
          : null, // 空の時は画面中央のボタンがあるので非表示にする
    );
  }

  Widget _buildEmptyState(BuildContext context, AppState appState) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // box_icon を丸い枠に入れて表示
          Container(
            width: 112.5,
            height: 112.5,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 2, color: Colors.black),
                borderRadius: BorderRadius.circular(56.25),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0xFF000000),
                  blurRadius: 0,
                  offset: Offset(3, 4.50),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Center(
              child: Image.asset(
                'assets/icons/box_icon.png',
                width: 64,
                height: 64,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // テキスト
          Text(
            '持ち物が登録されていません',
            style: GoogleFonts.zenMaruGothic(
              color: const Color(0xFF6B7280),
              fontSize: 16,
              fontWeight: FontWeight.w900,
              height: 1.20,
            ),
          ),
          const SizedBox(height: 16),
          // 「＋ 最初のアイテムを追加」ボタン
          GestureDetector(
            onTap: () => _showItemDialog(context, appState),
            child: Container(
              height: 50,
              padding: const EdgeInsets.only(
                top: 16,
                left: 16,
                right: 20,
                bottom: 16,
              ),
              decoration: ShapeDecoration(
                color: const Color(0xFFFF7B00),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0xFF000000),
                    blurRadius: 0,
                    offset: Offset(3, 4.50),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Text(
                '＋　最初のアイテムを追加',
                textAlign: TextAlign.center,
                style: GoogleFonts.zenMaruGothic(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  height: 1.20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(BuildContext context, AppState appState) {
    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
          itemCount: appState.items.length,
          itemBuilder: (context, index) {
            final item = appState.items[index];
            return ItemCard(
              item: item,
              onTap: () =>
                  _showItemDialog(context, appState, existingItem: item),
              onDelete: () => _showDeleteConfirmation(
                context,
                appState,
                item,
              ),
            );
          },
        ),
      ],
    );
  }

  void _showItemDialog(BuildContext context, AppState appState,
      {ItemModel? existingItem}) {
    final isEditing = existingItem != null;
    final nameController =
        TextEditingController(text: existingItem?.name ?? '');
    final descriptionController =
        TextEditingController(text: existingItem?.description ?? '');
    bool isWeekday = existingItem?.isWeekday ?? false;
    bool isWeekend = existingItem?.isWeekend ?? false;
    bool isRequired = existingItem?.isRequired ?? false;

    showDialog(
      context: context,
      barrierColor: const Color(0x66C4C7CC),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 280,
                  padding: const EdgeInsets.all(16),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0xFF000000),
                        blurRadius: 0,
                        offset: Offset(3, 4.50),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        isEditing ? 'アイテムを編集' : '新しいアイテムを追加',
                        style: GoogleFonts.zenMaruGothic(
                          color: const Color(0xFF111827),
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          height: 1.20,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDialogTextField(
                        controller: nameController,
                        hintText: '名前',
                        autofocus: !isEditing,
                      ),
                      const SizedBox(height: 12),
                      _buildDialogTextField(
                        controller: descriptionController,
                        hintText: '説明',
                      ),
                      const SizedBox(height: 16),
                      // ビジネスルール: 必須/平日のみ/週末のみは排他的。
                      // 1つをONにすると他がOFFになる。
                      _buildCategoryToggles(
                        isWeekday: isWeekday,
                        isWeekend: isWeekend,
                        isRequired: isRequired,
                        setState: setState,
                        onWeekdayChanged: (v) {
                          isWeekday = v;
                          if (v) isRequired = false;
                        },
                        onWeekendChanged: (v) {
                          isWeekend = v;
                          if (v) isRequired = false;
                        },
                        onRequiredChanged: (v) {
                          isRequired = v;
                          if (v) {
                            isWeekday = false;
                            isWeekend = false;
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isEditing
                            ? '※更新後、カテゴリの設定が変わるので注意してください'
                            : '※これ以降、このアイテムの概要は編集できない',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.zenMaruGothic(
                          color: const Color(0xFFFF0000),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          height: 1.44,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDialogActions(
                        context: context,
                        isEditing: isEditing,
                        onSave: () => _handleSaveItem(
                          context: context,
                          appState: appState,
                          nameController: nameController,
                          descriptionController: descriptionController,
                          isEditing: isEditing,
                          existingItem: existingItem,
                          isRequired: isRequired,
                          isWeekday: isWeekday,
                          isWeekend: isWeekend,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ダイアログ内のテキスト入力フィールド
  Widget _buildDialogTextField({
    required TextEditingController controller,
    required String hintText,
    bool autofocus = false,
  }) {
    return Container(
      width: 204,
      height: 44,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1.50),
          borderRadius: BorderRadius.circular(10),
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
        controller: controller,
        autofocus: autofocus,
        style: GoogleFonts.zenMaruGothic(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        cursorColor: const Color(0xFFFF7B00),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.zenMaruGothic(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 21, vertical: 13),
          border: InputBorder.none,
        ),
      ),
    );
  }

  /// カテゴリトグル群（平日/休日/必須の排他選択）
  Widget _buildCategoryToggles({
    required bool isWeekday,
    required bool isWeekend,
    required bool isRequired,
    required StateSetter setState,
    required ValueChanged<bool> onWeekdayChanged,
    required ValueChanged<bool> onWeekendChanged,
    required ValueChanged<bool> onRequiredChanged,
  }) {
    return Column(
      children: [
        _buildNewCategoryToggle(
          title: '平日',
          description: '平日は持っていくもの(連続記録が平日のみ反映される)',
          titleColor: Colors.black,
          isSelected: isWeekday,
          onChanged: (value) => setState(() => onWeekdayChanged(value)),
        ),
        const SizedBox(height: 8),
        _buildNewCategoryToggle(
          title: '休日',
          description: '土日祝に持っていくもの(連続記録が土日祝のみ反映される)',
          titleColor: Colors.black,
          isSelected: isWeekend,
          onChanged: (value) => setState(() => onWeekendChanged(value)),
        ),
        const SizedBox(height: 8),
        _buildNewCategoryToggle(
          title: '必須アイテム',
          description: '毎日持ち歩くものは\nONにしてください',
          titleColor: const Color(0xFFFF7B00),
          isSelected: isRequired,
          onChanged: (value) => setState(() => onRequiredChanged(value)),
        ),
      ],
    );
  }

  /// ダイアログ下部のキャンセル・保存ボタン
  Widget _buildDialogActions({
    required BuildContext context,
    required bool isEditing,
    required VoidCallback onSave,
  }) {
    return SizedBox(
      width: 204,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildDialogButton(
            label: 'キャンセル',
            backgroundColor: Colors.white,
            textColor: Colors.black,
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(width: 10),
          _buildDialogButton(
            label: isEditing ? '更新' : '追加',
            backgroundColor: const Color(0xFFFF7B00),
            textColor: Colors.white,
            fontSize: 12,
            onTap: onSave,
          ),
        ],
      ),
    );
  }

  /// ダイアログ内の汎用ボタン
  Widget _buildDialogButton({
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onTap,
    double fontSize = 14,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1.50, color: Colors.black),
            borderRadius: BorderRadius.circular(10),
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
            label,
            style: GoogleFonts.zenMaruGothic(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              height: 1.20,
            ),
          ),
        ),
      ),
    );
  }

  /// アイテムの保存処理（新規追加/既存更新）
  void _handleSaveItem({
    required BuildContext context,
    required AppState appState,
    required TextEditingController nameController,
    required TextEditingController descriptionController,
    required bool isEditing,
    required ItemModel? existingItem,
    required bool isRequired,
    required bool isWeekday,
    required bool isWeekend,
  }) {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('名前を入力してください')),
      );
      return;
    }

    final newItem = ItemModel(
      id: isEditing
          ? existingItem!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      isRequired: isRequired,
      isWeekday: isWeekday,
      isWeekend: isWeekend,
    );

    if (isEditing) {
      appState.updateItem(existingItem!.id, newItem);
    } else {
      appState.addItem(newItem);
    }
    Navigator.pop(context);
  }

  Widget _buildNewCategoryToggle({
    required String title,
    required String description,
    required Color titleColor,
    required bool isSelected,
    required ValueChanged<bool> onChanged,
  }) {
    return SizedBox(
      width: 204,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: title + '\n',
                    style: GoogleFonts.zenMaruGothic(
                      color: titleColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.20,
                    ),
                  ),
                  TextSpan(
                    text: description,
                    style: GoogleFonts.zenMaruGothic(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 51,
            height: 31,
            child: Switch(
              value: isSelected,
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFFFF7B00),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFFE5E7EB),
              onChanged: onChanged,
            ),
          ),
        ],
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
              child: const Text(
                '削除',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
