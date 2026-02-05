import 'package:flutter/material.dart';
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
      body: SafeArea(
        child: Column(
          children: [
            // ヘッダー部分
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 24), // 左側のバランス調整用
                  const Text(
                    '持ち物リスト',
                    style: TextStyle(
                      color: Color(0xFFFF7B00),
                      fontSize: 32,
                      fontFamily: 'LINESeedJP',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  // 追加ボタン（ヘッダーに移動）
                  GestureDetector(
                    onTap: () => _showAddItemDialog(context, appState),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF7B00),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x3F000000),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 24,
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
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppState appState) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // アイコン
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F6F7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              size: 40,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 16),
          // テキスト
          const Text(
            '持ち物が登録されていません',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 12,
              fontFamily: 'LINESeedJP',
              fontWeight: FontWeight.w400,
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
              onTap: () => _showEditItemDialog(context, appState, item),
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

  void _showAddItemDialog(BuildContext context, AppState appState) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final focusNode = FocusNode();

    // ダイアログが表示された後にフォーカスを要求
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });

    showDialog(
        context: context,
        barrierColor: const Color(0x666B7280), // 半透明グレー背景
        builder: (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 250,
                    height: 210,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: const Color(0xFFE5E7EB),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // タイトル
                        Positioned(
                          left: 37.50,
                          top: 16,
                          child: Text(
                            '新しいアイテムを追加',
                            style: TextStyle(
                              color: const Color(0xFF111827),
                              fontSize: 18,
                              fontFamily: 'LINESeedJP',
                              fontWeight: FontWeight.w700,
                              height: 1.20,
                            ),
                          ),
                        ),
                        // 名前入力欄
                        Positioned(
                          left: 23,
                          top: 50,
                          child: Container(
                            width: 204,
                            height: 44,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Container(
                                    width: 204,
                                    height: 44,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 1,
                                          color: const Color(0xFF111827)
                                              .withOpacity(0.5),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: TextField(
                                      controller: nameController,
                                      focusNode: focusNode,
                                      autofocus: true,
                                      style: const TextStyle(
                                        color: Color(0xFF111827),
                                        fontSize: 14,
                                        fontFamily: 'LINESeedJP',
                                      ),
                                      cursorColor: const Color(0xFFFF7B00),
                                      cursorWidth: 2,
                                      cursorRadius: const Radius.circular(2),
                                      decoration: const InputDecoration(
                                        hintText: '名前',
                                        hintStyle: TextStyle(
                                          color: Color(0xFF6B7280),
                                          fontSize: 14,
                                          fontFamily: 'LINESeedJP',
                                          fontWeight: FontWeight.w400,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 0),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // 名前カーソル装飾（提供コードにあるもの）
                        Positioned(
                          left: 68,
                          top: 62,
                          child: Container(
                            width: 2,
                            height: 17,
                            decoration: ShapeDecoration(
                              color: Colors.transparent, // 実際のカーソルを使うため透明に
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2)),
                            ),
                          ),
                        ),
                        // 説明入力欄
                        Positioned(
                          left: 23,
                          top: 106,
                          child: Container(
                            width: 204,
                            height: 44,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Container(
                                    width: 204,
                                    height: 44,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 1,
                                          color: const Color(0xFF111827)
                                              .withOpacity(0.5),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: TextField(
                                      controller: descriptionController,
                                      style: const TextStyle(
                                        color: Color(0xFF111827),
                                        fontSize: 14,
                                        fontFamily: 'LINESeedJP',
                                      ),
                                      cursorColor: const Color(0xFFFF7B00),
                                      decoration: const InputDecoration(
                                        hintText: '説明',
                                        hintStyle: TextStyle(
                                          color: Color(0xFF6B7280),
                                          fontSize: 14,
                                          fontFamily: 'LINESeedJP',
                                          fontWeight: FontWeight.w400,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 0),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // 説明カーソル装飾
                        Positioned(
                          left: 68,
                          top: 62, // 座標は名前と同じだが説明用なので調整不要（透明化するため）
                          child: Container(
                            width: 2,
                            height: 17,
                            decoration: ShapeDecoration(
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2)),
                            ),
                          ),
                        ),
                        // ボタン
                        Positioned(
                          left: 69,
                          top: 162,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  height: 32,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 1,
                                        color: const Color(0xFFFF7B00),
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'キャンセル',
                                        style: TextStyle(
                                          color: const Color(0xFFFF7B00),
                                          fontSize: 12,
                                          fontFamily: 'Noto Sans JP',
                                          fontWeight: FontWeight.w500,
                                          height: 1.20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  if (nameController.text.trim().isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('名前を入力してください')),
                                    );
                                    return;
                                  }

                                  final newItem = ItemModel(
                                    id: DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString(),
                                    name: nameController.text.trim(),
                                    description:
                                        descriptionController.text.trim(),
                                    isRequired: true,
                                  );

                                  appState.addItem(newItem);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 32,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFFF7B00),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '追加',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontFamily: 'LINESeedJP',
                                          fontWeight: FontWeight.w400,
                                          height: 1.20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ))); // 閉じカッコを追加
  }

  void _showEditItemDialog(
      BuildContext context, AppState appState, ItemModel item) {
    final nameController = TextEditingController(text: item.name);
    final descriptionController = TextEditingController(text: item.description);
    bool isRequired = item.isRequired;
    final focusNode = FocusNode();

    // ダイアログが表示された後にフォーカスを要求
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text(
            'アイテムを編集',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '名前',
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: nameController,
                  focusNode: focusNode,
                  autofocus: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppTheme.gray300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppTheme.gray300),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '説明',
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppTheme.gray300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppTheme.gray300),
                    ),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '必須アイテム',
                        style: TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    Switch(
                      value: isRequired,
                      activeColor: AppTheme.primaryOrange,
                      onChanged: (value) {
                        setState(() {
                          isRequired = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.primaryOrange),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'キャンセル',
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 13,
                    color: AppTheme.primaryOrange,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('名前を入力してください')),
                  );
                  return;
                }

                final updatedItem = item.copyWith(
                  name: nameController.text.trim(),
                  description: descriptionController.text.trim(),
                  isRequired: isRequired,
                );

                appState.updateItem(item.id, updatedItem);
                Navigator.pop(context);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '更新',
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
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
