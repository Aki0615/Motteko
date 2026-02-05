// =============================================================================
// sensor_indicator.dart
// =============================================================================
// センサーの状態を視覚的に表示するウィジェット。
// 人感センサーが人を検知しているかどうかをわかりやすく表示します。
//
// 【このファイルの役割】
// - センサーの状態（検知中/未検知）を視覚的に表示
// - 状態に応じて色を変える（緑: 検知中、グレー: 未検知）
// - タップでセンサー状態を切り替え可能（デバッグ用）
// =============================================================================

import 'package:flutter/material.dart';

// テーマ設定のインポート
import '../core/app_theme.dart';

// =============================================================================
// SensorIndicator クラス
// =============================================================================

/// センサーの状態を表示するインジケーターウィジェット
///
/// 円形のアイコンとステータスバッジで、センサーの状態を視覚的に表します。
///
/// 使用例:
/// ```dart
/// SensorIndicator(
///   isActive: true,
///   label: '人感センサー',
///   onTap: () => print('タップされました'),
/// )
/// ```
class SensorIndicator extends StatelessWidget {
  // ---------------------------------------------------------------------------
  // プロパティ
  // ---------------------------------------------------------------------------

  /// センサーがアクティブ（検知中）かどうか
  ///
  /// true: 人を検知中（緑色のバッジ表示）
  /// false: 未検知（グレーのバッジ表示）
  final bool isActive;

  /// センサーのラベル（表示名）
  ///
  /// 例: "人感センサー"
  final String label;

  /// タップ時のコールバック関数（オプション）
  ///
  /// 主にデバッグ用途で、タップでセンサー状態を切り替えるのに使用
  final VoidCallback? onTap;

  // ---------------------------------------------------------------------------
  // コンストラクタ
  // ---------------------------------------------------------------------------

  /// SensorIndicatorのコンストラクタ
  ///
  /// [isActive] - センサーがアクティブかどうか（必須）
  /// [label] - センサーの表示名（必須）
  /// [onTap] - タップ時のコールバック（オプション）
  const SensorIndicator({
    super.key,
    required this.isActive,
    required this.label,
    this.onTap,
  });

  // ---------------------------------------------------------------------------
  // ビルドメソッド
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // タップ可能なウィジェット
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // 上下の内側余白
        padding: const EdgeInsets.symmetric(vertical: 32),

        // コンテナの見た目
        decoration: BoxDecoration(
          color: Colors.white, // 白背景
          borderRadius: BorderRadius.circular(12), // 角丸
        ),

        child: Column(
          children: [
            // =================================================================
            // 円形のセンサーアイコン
            // =================================================================
            Container(
              width: 80, // 円の直径
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.gray100, // 薄いグレー背景
                shape: BoxShape.circle, // 円形
                border: Border.all(
                  color: AppTheme.gray300, // 中間グレーの枠線
                  width: 2,
                ),
              ),
              // 人型アイコン
              child: const Icon(
                Icons.person_outline,
                size: 36,
                color: AppTheme.gray500,
              ),
            ),

            const SizedBox(height: 16), // アイコンとラベルの間隔

            // =================================================================
            // センサーのラベル（名前）
            // =================================================================
            Text(
              label,
              style: const TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),

            const SizedBox(height: 12), // ラベルとバッジの間隔

            // =================================================================
            // ステータスバッジ（検知中 / 未検知）
            // =================================================================
            Container(
              // 内側の余白
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              // バッジの見た目
              decoration: BoxDecoration(
                // 検知中: 緑、未検知: グレー
                color: isActive ? AppTheme.successGreen : AppTheme.gray400,
                borderRadius: BorderRadius.circular(20), // 丸みを帯びた角
              ),
              // ステータステキスト
              child: Text(
                isActive ? '検知中' : '未検知',
                style: const TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white, // 白文字
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
