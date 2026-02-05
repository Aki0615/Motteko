// =============================================================================
// app_theme.dart
// =============================================================================
// アプリ全体で使用するテーマ（色、フォント、スタイル）を一元管理するファイル。
// Figmaのデザインシステムに基づいて、統一感のあるUIを実現します。
//
// 【このファイルの役割】
// - カラーパレット（色の定義）
// - テキストスタイル（文字の大きさ・太さ）
// - 各種ウィジェットのテーマ設定（ボタン、カード、入力欄など）
// =============================================================================

import 'package:flutter/material.dart';

/// アプリのテーマを管理するクラス
///
/// 使用例:
/// ```dart
/// // 色を使う場合
/// Container(color: AppTheme.primaryOrange)
///
/// // テーマ全体を適用する場合（main.dartで）
/// MaterialApp(theme: AppTheme.lightTheme())
/// ```
class AppTheme {
  // ===========================================================================
  // カラーパレット（色の定義）
  // ===========================================================================
  // Figmaデザインに基づいた色を定義しています。
  // アプリ内で色を使う時は、直接 Color(0xFF...) と書かずに、
  // AppTheme.primaryOrange のように定数を使ってください。
  // こうすることで、色の変更が必要になった時に一箇所で済みます。

  // ---------------------------------------------------------------------------
  // プライマリカラー（メインのオレンジ系）
  // ---------------------------------------------------------------------------

  /// メインのオレンジ色（タイトルやアクセントに使用）
  /// カラーコード: #FF7B00 (primary-700)
  static const Color primaryOrange = Color(0xFFFF7B00);

  /// 薄いオレンジ色（背景に使用）
  /// カラーコード: #FFDAC4 (primary-400)
  static const Color primaryOrangeLight = Color(0xFFFFDAC4);

  /// 濃いオレンジ色（強調・ホバー時など）
  /// カラーコード: #FF6200 (primary-900)
  static const Color primaryOrangeDark = Color(0xFFFF6200);

  /// 薄いグレーの背景色
  /// カラーコード: #F3F4F6 (gray-200)
  static const Color backgroundLight = Color(0xFFF3F4F6);

  /// 白い背景色
  /// カラーコード: #FFFFFF (gray-100)
  static const Color backgroundWhite = Color(0xFFFFFFFF);

  /// コンテンツ表面の色（カードなどの背景）
  /// カラーコード: #FFFFFF
  static const Color surfaceLight = Colors.white;

  // ---------------------------------------------------------------------------
  // テキストカラー（文字の色）
  // ---------------------------------------------------------------------------
  // 文字の重要度に応じて3段階の色を使い分けます。

  /// 主要テキスト色（最も重要な文字、見出しなど）
  /// カラーコード: #111827 (gray-900)
  static const Color textPrimary = Color(0xFF111827);

  /// 補助テキスト色（説明文など、少し控えめな文字）
  /// カラーコード: #374151 (gray-700)
  static const Color textSecondary = Color(0xFF374151);

  /// 第三テキスト色（ヒントテキストなど、さらに控えめな文字）
  /// カラーコード: #6B7280 (gray-500)
  static const Color textTertiary = Color(0xFF6B7280);

  // ---------------------------------------------------------------------------
  // ステータスカラー（状態を表す色）
  // ---------------------------------------------------------------------------
  // ユーザーに状態を伝えるための色です。
  // 例: 成功=緑、警告=黄、エラー=赤

  /// 成功・正常を表す緑色
  /// カラーコード: #22C55E (color-success)
  static const Color successGreen = Color(0xFF22C55E);

  /// 警告を表す黄色
  /// カラーコード: #FACC15 (color-warning)
  static const Color warningYellow = Color(0xFFFACC15);

  /// エラー・危険を表す赤色
  /// カラーコード: #EF4444 (color-error)
  static const Color errorRed = Color(0xFFEF4444);

  /// エラー背景色（薄い赤）
  /// カラーコード: #FEF2F2 (color-error-bg)
  static const Color errorBackground = Color(0xFFFEF2F2);

  /// 情報を表す青色
  /// カラーコード: #26A5FF
  static const Color infoBlue = Color(0xFF26A5FF);

  // ---------------------------------------------------------------------------
  // グレースケール（グレーの濃淡）
  // ---------------------------------------------------------------------------
  // UIの様々な要素で使うグレーを段階的に定義しています。
  // 数字が小さいほど薄く、大きいほど濃くなります。

  /// 白（最も薄い）
  /// カラーコード: #FFFFFF (gray-100)
  static const Color gray100 = Color(0xFFFFFFFF);

  /// とても薄いグレー（背景色として使用）
  /// カラーコード: #F3F4F6 (gray-200)
  static const Color gray200 = Color(0xFFF3F4F6);

  /// 薄いグレー（区切り線・カード背景など）
  /// カラーコード: #6B7280 (gray-300)
  static const Color gray300 = Color(0xFF6B7280);

  /// 中間のグレー（ボーダー・枠線として使用）
  /// カラーコード: #AAAEB4 (gray-400)
  static const Color gray400 = Color(0xFFAAAEB4);

  /// やや濃いグレー（アイコン・プレースホルダーなど）
  /// カラーコード: #6B7280 (gray-500)
  static const Color gray500 = Color(0xFF6B7280);

  /// 濃いグレー（サブテキストなど）
  /// カラーコード: #374151 (gray-700)
  static const Color gray700 = Color(0xFF374151);

  /// gray-700のエイリアス（互換性維持）
  /// カラーコード: #374151
  static const Color gray600 = gray700;

  /// さらに濃いグレー（本文テキストなど）
  /// カラーコード: #1F2937 (gray-800)
  static const Color gray800 = Color(0xFF1F2937);

  /// 最も濃いグレー（見出し・タイトルなど）
  /// カラーコード: #111827 (gray-900)
  static const Color gray900 = Color(0xFF111827);

  // ===========================================================================
  // フォント設定
  // ===========================================================================

  /// アプリ全体で使用するフォントファミリー名
  /// LINE Seed JPフォントを使用（日本語対応の美しいフォント）
  static const String fontFamily = 'LINESeedJP';

  // ===========================================================================
  // テキストスタイル（TextTheme）の構築
  // ===========================================================================
  // MaterialDesignで定義されている各テキストスタイルを設定します。
  // これにより、Theme.of(context).textTheme.bodyLarge のように
  // 一貫したスタイルを使うことができます。

  /// TextThemeを構築するプライベートメソッド
  ///
  /// 各スタイルの用途:
  /// - displayLarge/Medium/Small: 大きな見出し（ヒーローセクションなど）
  /// - headlineMedium: セクションの見出し
  /// - titleLarge/Medium: 画面タイトル、カードタイトル
  /// - bodyLarge/Medium/Small: 本文テキスト
  /// - labelLarge: ボタンのラベル
  static TextTheme _buildTextTheme() {
    return const TextTheme(
      // 最大の見出し（32px、太字）
      // 用途: スプラッシュ画面のタイトルなど
      displayLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),

      // 大きめの見出し（24px、太字）
      // 用途: 画面の主要タイトルなど
      displayMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),

      // 中くらいの見出し（20px、太字）
      // 用途: セクションタイトルなど
      displaySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),

      // 中見出し（18px、太字）
      // 用途: カード内の見出しなど
      headlineMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),

      // タイトル大（18px、やや太字）
      // 用途: リストアイテムのタイトルなど
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),

      // タイトル中（16px、やや太字）
      // 用途: ダイアログのタイトルなど
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),

      // 本文大（16px、通常）
      // 用途: メインの本文テキスト
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textPrimary,
      ),

      // 本文中（14px、通常）
      // 用途: 一般的な本文テキスト
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textPrimary,
      ),

      // 本文小（12px、通常）
      // 用途: 補足説明、キャプションなど
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textSecondary,
      ),

      // ラベル大（14px、やや太字）
      // 用途: ボタンのテキストなど
      labelLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
    );
  }

  // ===========================================================================
  // ライトテーマの構築
  // ===========================================================================
  // アプリ全体に適用するThemeDataを構築します。
  // main.dartで MaterialApp(theme: AppTheme.lightTheme()) のように使用します。

  /// ライトテーマを生成するメソッド
  ///
  /// 戻り値: アプリ全体に適用するThemeData
  static ThemeData lightTheme() {
    // Flutterのデフォルトライトテーマをベースに使用
    final ThemeData base = ThemeData.light();

    return base.copyWith(
      // 基本色の設定
      primaryColor: primaryOrange,
      scaffoldBackgroundColor: backgroundLight,

      // カラースキーム（Material3で使用される色のセット）
      colorScheme: base.colorScheme.copyWith(
        primary: primaryOrange, // メインアクション色
        onPrimary: Colors.white, // primary色の上に置くテキスト・アイコンの色
        secondary: primaryOrangeLight, // セカンダリ色
        tertiary: successGreen, // 第三の色（成功表示など）
        surface: surfaceLight, // カード等の表面色
        error: errorRed, // エラー色
      ),

      // テキストスタイルを適用
      textTheme: _buildTextTheme(),

      // Material3デザインを使用
      useMaterial3: true,

      // -------------------------------------------------------------------------
      // AppBar（画面上部のバー）のテーマ
      // -------------------------------------------------------------------------
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundLight, // 背景色
        foregroundColor: textPrimary, // テキスト・アイコン色
        elevation: 0, // 影なし（フラットなデザイン）
        centerTitle: false, // タイトルを左寄せ
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: primaryOrangeLight, // タイトルはオレンジ色
        ),
        iconTheme: IconThemeData(color: gray600), // アイコンの色
      ),

      // -------------------------------------------------------------------------
      // Card（カード）のテーマ
      // -------------------------------------------------------------------------
      cardTheme: CardThemeData(
        elevation: 0, // 影なし
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // 角丸12px
        ),
        color: surfaceLight, // 背景色
      ),

      // -------------------------------------------------------------------------
      // FloatingActionButton（FAB、フローティングボタン）のテーマ
      // -------------------------------------------------------------------------
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryOrange, // 背景色
        foregroundColor: Colors.white, // アイコン色
        elevation: 2, // 少しだけ影
        shape: StadiumBorder(), // 丸い形状
      ),

      // -------------------------------------------------------------------------
      // ElevatedButton（強調ボタン）のテーマ
      // -------------------------------------------------------------------------
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryOrange, // 背景色
          foregroundColor: Colors.white, // テキスト色
          elevation: 0, // 影なし
          padding: const EdgeInsets.symmetric(
            horizontal: 24, // 左右の余白
            vertical: 14, // 上下の余白
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25), // 丸みを帯びた角
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // -------------------------------------------------------------------------
      // FilledButton（塗りつぶしボタン）のテーマ
      // -------------------------------------------------------------------------
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryOrange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // -------------------------------------------------------------------------
      // TextButton（テキストボタン）のテーマ
      // -------------------------------------------------------------------------
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryOrange, // テキスト色
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // -------------------------------------------------------------------------
      // OutlinedButton（枠線ボタン）のテーマ
      // -------------------------------------------------------------------------
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryOrange,
          side: const BorderSide(color: primaryOrange), // 枠線
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // -------------------------------------------------------------------------
      // InputDecoration（テキスト入力欄）のテーマ
      // -------------------------------------------------------------------------
      inputDecorationTheme: InputDecorationTheme(
        filled: true, // 背景色を塗る
        fillColor: Colors.white, // 背景色
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        // 通常時の枠線
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: gray300),
        ),
        // 有効時の枠線
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: gray300),
        ),
        // フォーカス時の枠線（オレンジ色で強調）
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryOrange, width: 2),
        ),
        // エラー時の枠線
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorRed),
        ),
        // ラベルのスタイル
        labelStyle: const TextStyle(
          fontFamily: fontFamily,
          color: textSecondary,
        ),
        // ヒントのスタイル
        hintStyle: const TextStyle(
          fontFamily: fontFamily,
          color: textTertiary,
        ),
      ),

      // -------------------------------------------------------------------------
      // Switch（トグルスイッチ）のテーマ
      // -------------------------------------------------------------------------
      switchTheme: SwitchThemeData(
        // つまみ（サム）の色
        thumbColor: WidgetStateProperty.resolveWith((states) {
          // ONの時はオレンジ、OFFの時はグレー
          if (states.contains(WidgetState.selected)) {
            return primaryOrange;
          }
          return gray400;
        }),
        // トラック（レール）の色
        trackColor: WidgetStateProperty.resolveWith((states) {
          // ONの時は薄いオレンジ、OFFの時は薄いグレー
          if (states.contains(WidgetState.selected)) {
            return primaryOrange.withOpacity(0.3);
          }
          return gray300;
        }),
      ),

      // -------------------------------------------------------------------------
      // Dialog（ダイアログ）のテーマ
      // -------------------------------------------------------------------------
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
      ),

      // -------------------------------------------------------------------------
      // SnackBar（画面下部の通知）のテーマ
      // -------------------------------------------------------------------------
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimary, // 濃い色の背景
        contentTextStyle: const TextStyle(
          fontFamily: fontFamily,
          color: Colors.white, // 白いテキスト
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating, // 浮いている表示
      ),

      // -------------------------------------------------------------------------
      // ListTile（リストアイテム）のテーマ
      // -------------------------------------------------------------------------
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 13,
          color: textSecondary,
        ),
      ),

      // -------------------------------------------------------------------------
      // Divider（区切り線）のテーマ
      // -------------------------------------------------------------------------
      dividerTheme: const DividerThemeData(
        color: gray200,
        thickness: 1,
      ),
    );
  }

  // ===========================================================================
  // ダークテーマ（未実装）
  // ===========================================================================

  /// ダークテーマを生成するメソッド
  ///
  /// 現在はライトテーマと同じ設定を返しています。
  /// 将来的にダークモードを実装する場合は、ここを編集してください。
  static ThemeData darkTheme() {
    // TODO: ダークテーマの実装
    // 現在はライトテーマをそのまま使用
    return lightTheme();
  }
}
