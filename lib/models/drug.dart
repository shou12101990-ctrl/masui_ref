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

  /// 上限量・投与間隔の規定. 1回量/1日量の上限, 1日の使用回数の上限,
  /// 再投与までの最短間隔, 総投与期間の上限など「超えてはいけない値」を集約する.
  /// 電子添文に上限の規定がない薬では null.
  final String? doseLimit;

  /// 剤形. 「静注できるのか, 内服しかないのか」を一目で分かるようにする.
  /// 麻酔薬のように注射が前提の薬では省略してよい (null).
  final DrugFormAvailability? forms;

  /// 緊急時の投与法. 致死的不整脈, 急性興奮, てんかん重積, 周術期予防投与など.
  final String? emergencyDose;

  /// 抗菌薬のスペクトラム要約.
  final String? spectrum;

  /// 腎機能による用量調節.
  final String? renalAdjust;

  /// 周術期・麻酔科的な注意 (継続/休薬, 相互作用, 術中管理).
  final String? periop;

  /// 作用機序の要約
  final String mechanism;

  /// 詳細解説（見出し付きの臨床メモ）
  final List<DrugNote> notes;

  /// 電子添文との照合が完了しているか。
  final bool packageInsertReviewed;

  /// 参照した電子添文の改訂年月。
  final String? packageInsertRevision;

  /// PMDA電子添文URL。
  final String? packageInsertUrl;

  /// 電子添文上の禁忌。理由を必須とする。
  final List<DrugContraindication> contraindications;

  /// 電子添文上、注意が必要な患者背景。理由は詳細画面では省略する。
  final List<String> cautiousUse;

  const Drug({
    required this.name,
    required this.brand,
    required this.category,
    this.spec,
    this.dilution,
    this.concentration,
    this.dose,
    this.doseLimit,
    this.forms,
    this.emergencyDose,
    this.spectrum,
    this.renalAdjust,
    this.periop,
    required this.mechanism,
    this.notes = const [],
    this.packageInsertReviewed = false,
    this.packageInsertRevision,
    this.packageInsertUrl,
    this.contraindications = const [],
    this.cautiousUse = const [],
  });

  /// 検索対象テキスト（一般名・商品名・分類・機序）
  String get searchText => [
    name,
    brand,
    category.label,
    mechanism,
    dose ?? '',
    doseLimit ?? '',
    forms?.summary ?? '',
    emergencyDose ?? '',
    spectrum ?? '',
    periop ?? '',
    ...notes.expand((note) => [note.heading, note.body]),
    ...contraindications.expand((item) => [item.target, item.reason]),
    ...cautiousUse,
  ].join(' ').toLowerCase();
}

/// 剤形の可用性. 「静注できるか」を最優先の情報として持つ.
class DrugFormAvailability {
  /// 国内に注射剤 (静注・筋注・皮下注) があるか.
  final bool hasInjection;

  /// 内服製剤があるか.
  final bool hasOral;

  /// 剤形の要約. 例「注射 (静注)と内服の両方」「内服のみ (錠・OD錠)」「舌下錠のみ」
  final String summary;

  const DrugFormAvailability({
    required this.hasInjection,
    required this.hasOral,
    required this.summary,
  });

  /// 一覧・詳細で出す短いバッジ表記.
  String get badge {
    if (hasInjection && hasOral) return '注射 / 内服';
    if (hasInjection) return '注射のみ';
    if (hasOral) return '内服のみ';
    return 'その他';
  }
}

/// 解説の1セクション
class DrugNote {
  final String heading;
  final String body;
  final DrugNoteType type;
  const DrugNote(this.heading, this.body, {this.type = DrugNoteType.clinical});
}

/// 薬剤解説の根拠区分。
enum DrugNoteType {
  packageInsert,
  facilityPractice,
  offLabel,
  literature,
  clinical,
}

/// 電子添文上の禁忌と、その理由。
class DrugContraindication {
  final String target;
  final String reason;
  const DrugContraindication(this.target, this.reason);
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
  antiarrhythmic('抗不整脈薬'),
  localAnesthetic('局所麻酔薬'),
  anticoagulant('凝固系'),
  steroid('ステロイド'),
  antiemetic('制吐薬'),
  psychotropic('向精神薬'),
  antimicrobial('抗菌薬'),
  antihistamine('抗ヒスタミン薬'),
  transfusion('輸血製剤'),
  other('その他');

  final String label;
  const DrugCategory(this.label);
}
