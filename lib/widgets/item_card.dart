// =============================================================================
// item_card.dart
// =============================================================================
// 持ち物リストで使用するカードウィジェット。
// 各アイテムの名前、説明、必須かどうかのステータスを表示します。
//
// 【このファイルの役割】
// - 個々のアイテムをカード形式で表示
// - タップ時のアクション（編集など）をサポート
// - 削除ボタンの表示と処理
// =============================================================================

import 'package:flutter/material.dart';

// データモデルのインポート
import '../models/item_model.dart';

// テーマ設定のインポート
import '../core/app_theme.dart';

// =============================================================================
// ItemCard クラス
// =============================================================================

/// 持ち物アイテムを表示するカードウィジェット
///
/// 使用例:
/// ```dart
/// ItemCard(
///   item: myItem,
///   onTap: () => print('タップされました'),
///   onDelete: () => print('削除されました'),
/// )
/// ```
class ItemCard extends StatelessWidget {
  // ---------------------------------------------------------------------------
  // プロパティ（このウィジェットが受け取るデータ）
  // ---------------------------------------------------------------------------

  /// 表示するアイテムのデータ
  final ItemModel item;

  /// カードがタップされた時のコールバック関数（オプション）
  /// 例: アイテムの詳細画面を開く
  final VoidCallback? onTap;

  /// 削除ボタンがタップされた時のコールバック関数（オプション）
  /// 例: アイテムを削除する
  final VoidCallback? onDelete;

  // ---------------------------------------------------------------------------
  // コンストラクタ
  // ---------------------------------------------------------------------------

  /// ItemCardのコンストラクタ
  ///
  /// [item] - 表示するアイテムのデータ（必須）
  /// [onTap] - タップ時のコールバック（オプション）
  /// [onDelete] - 削除時のコールバック（オプション、指定すると削除ボタンが表示される）
  const ItemCard({
    super.key,
    required this.item,
    this.onTap,
    this.onDelete,
  });

  // ---------------------------------------------------------------------------
  // ビルドメソッド（UI構築）
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Container(
      // 下方向のマージン（カード間の間隔）
      margin: const EdgeInsets.only(bottom: 8),

      // カードの見た目を設定
      decoration: BoxDecoration(
        color: Colors.white, // 背景色
        borderRadius: BorderRadius.circular(12), // 角丸
      ),

      // タップ可能なウィジェット（インク効果付き）
      child: InkWell(
        onTap: onTap, // タップ時の処理
        borderRadius: BorderRadius.circular(12), // インク効果の角丸

        child: Padding(
          padding: const EdgeInsets.all(16), // 内側の余白

          child: Row(
            children: [
              // =================================================================
              // 左側のカラーライン（必須アイテムかどうかを視覚的に表示）
              // =================================================================
              Container(
                width: 4, // 線の太さ
                height: 40, // 線の高さ
                decoration: BoxDecoration(
                  // 必須アイテム: オレンジ、オプション: グレー
                  color: item.isRequired
                      ? AppTheme.primaryOrange
                      : AppTheme.gray300,
                  borderRadius: BorderRadius.circular(2), // わずかに角丸
                ),
              ),

              const SizedBox(width: 12), // ラインとテキストの間隔

              // =================================================================
              // 中央のテキスト情報（アイテム名と説明）
              // =================================================================
              Expanded(
                // 残りのスペースを全て使用
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // 左寄せ
                  children: [
                    // アイテム名
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 15,
                        fontWeight: FontWeight.w600, // やや太字
                        color: AppTheme.textPrimary,
                      ),
                    ),

                    // 説明文（存在する場合のみ表示）
                    // Dartの ... 記法（スプレッド演算子）で条件付きでウィジェットを追加
                    if (item.description.isNotEmpty) ...[
                      const SizedBox(height: 2), // 名前と説明の間隔

                      Text(
                        item.description,
                        style: const TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 12,
                          color: AppTheme.textSecondary, // 控えめな色
                        ),
                        maxLines: 1, // 1行に制限
                        overflow: TextOverflow.ellipsis, // 長い場合は「...」で省略
                      ),
                    ],
                  ],
                ),
              ),

              // =================================================================
              // 右側の削除ボタン（onDeleteが指定されている場合のみ表示）
              // =================================================================
              if (onDelete != null)
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline, // ゴミ箱アイコン（線画）
                    size: 20,
                  ),
                  color: AppTheme.gray500, // グレー色
                  onPressed: onDelete, // タップ時の処理
                ),
            ],
          ),
        ),
      ),
    );
  }
}
