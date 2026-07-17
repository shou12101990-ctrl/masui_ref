/// 薬剤1剤の情報. 元データは麻酔薬リファレンス (Excel) に準拠.
/// 表示色・マーカー判定などのUI関心は lib/widgets/drug_visuals.dart に分離.
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
}

/// 解説の1セクション
class DrugNote {
  final String heading;
  final String body;
  const DrugNote(this.heading, this.body);
}

/// 薬剤分類
enum DrugCategory {
  sedative('鎮静薬'),
  inhalational('吸入麻酔薬'),
  muscleRelaxant('筋弛緩薬'),
  analgesic('鎮痛薬'),
  vasopressor('昇圧薬'),
  vasodilator('降圧薬'),
  circulatoryOther('循環作動薬 (その他)'),
  localAnesthetic('局所麻酔薬'),
  anticoagulant('凝固系'),
  steroid('ステロイド'),
  antiemetic('制吐薬'),
  psychotropic('向精神薬'),
  antihistamine('抗ヒスタミン薬'),
  transfusion('輸血製剤'),
  other('その他');

  final String label;
  const DrugCategory(this.label);
}
