import 'package:flutter/material.dart';

/// 薬剤1剤の情報。元データは麻酔薬リファレンス(Excel)に準拠。
class Drug {
  /// 一般名
  final String name;

  /// 商品名（代表的なもの）
  final String brand;

  /// 分類（一覧のフィルタに使用）
  final DrugCategory category;

  /// 規格（例: 200mg/20ml/A）
  final String? spec;

  /// 希釈（例: 原液 / 1A + NS 9ml）
  final String? dilution;

  /// 濃度（例: 10mg/ml）
  final String? concentration;

  /// 用法・用量の要約（1行で出せるもの）
  final String? dose;

  /// 作用機序の要約
  final String mechanism;

  /// 詳細解説（見出し付きの臨床メモ）
  final List<DrugNote> notes;

  const Drug({
    required this.name,
    required this.brand,
    required this.category,
    this.spec,
    this.dilution,
    this.concentration,
    this.dose,
    required this.mechanism,
    this.notes = const [],
  });

  /// 検索対象テキスト（一般名・商品名・分類・機序）
  String get searchText =>
      '$name $brand ${category.label} $mechanism ${dose ?? ''}'.toLowerCase();

  /// 拮抗薬・中和薬・血管拡張薬 → ■マーカーに斜線を重ねる
  bool get isDiagonal =>
      category == DrugCategory.vasodilator ||
      const {'フルマゼニル', 'スガマデクス', 'ナロキソン', 'ダントロレン', 'イントラリピッド'}
          .contains(name);
}

/// 解説の1セクション
class DrugNote {
  final String heading;
  final String body;
  const DrugNote(this.heading, this.body);
}

/// 薬剤分類（8ジャンル）
enum DrugCategory {
  sedative('鎮静薬'),
  inhalational('吸入麻酔薬'),
  muscleRelaxant('筋弛緩薬'),
  analgesic('鎮痛薬'),
  vasopressor('昇圧薬'),
  vasodilator('降圧薬'),
  localAnesthetic('局所麻酔薬'),
  anticoagulant('凝固系');

  final String label;
  const DrugCategory(this.label);

  Color get color => switch (this) {
        DrugCategory.sedative => const Color(0xFFFFC000),        // B18 accent4 黄
        DrugCategory.inhalational => const Color(0xFFFFE580),    // B18より淡い黄
        DrugCategory.muscleRelaxant => const Color(0xFFFF5661),  // B30 赤
        DrugCategory.analgesic => const Color(0xFF5B9BD5),       // B37 青
        DrugCategory.vasopressor => const Color(0xFFD5B0FF),     // B57 紫
        DrugCategory.vasodilator => const Color(0xFFD5B0FF),     // B57 +斜線
        DrugCategory.localAnesthetic => const Color(0xFF9E9E9E), // 灰
        DrugCategory.anticoagulant => const Color(0xFFED2341),   // B99 赤
      };
}
