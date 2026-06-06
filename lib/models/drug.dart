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
      const ['フルマゼニル', 'スガマデクス', 'ナロキソン', 'ダントロレン', 'イントラリピッド', 'プロタミン']
          .any((s) => name.contains(s));
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

  /// ISO 26825:2020 麻酔薬ラベル国際標準色 (Pantone → hex 変換)
  Color get color => switch (this) {
        DrugCategory.sedative => const Color(0xFFFFD700),        // PMS 109   : 鎮静/誘導薬 標準黄
        DrugCategory.inhalational => const Color(0xFFFFF0A8),    // PMS 109系 : 吸入麻酔薬 (UI区別のため淡黄)
        DrugCategory.muscleRelaxant => const Color(0xFFEF3340),  // PMS Red032: 筋弛緩薬 標準赤
        DrugCategory.analgesic => const Color(0xFF7EC8E3),       // PMS 297   : 鎮痛薬/麻薬 ライトブルー
        DrugCategory.vasopressor => const Color(0xFF8B5CF6),     // PMS 267   : 昇圧薬 バイオレット
        DrugCategory.vasodilator => const Color(0xFF8B5CF6),     // PMS 267   : 降圧薬 (+ 斜線)
        DrugCategory.localAnesthetic => const Color(0xFF97999B), // Cool Gray7 : 局所麻酔薬 標準灰
        DrugCategory.anticoagulant => const Color(0xFFF5A623),   // ISO外区分  : 凝固系 橙 (赤系との混同回避)
      };
}
