/// 抗菌薬一覧表の1行. カバー範囲と臓器移行性をマトリクスで持つ.
class AbxMatrixRow {
  /// 系統 (第1世代, カルバペネム系 など)
  final String group;

  /// 一般名 (成分名)
  final String generic;

  /// 商品名
  final String brand;

  /// 略号 (CEZ, MEPM など)
  final String abbr;

  /// 標準的な用量
  final String dose;

  /// 効果・位置づけの一言
  final String effect;

  /// 補足 (原典のセルコメント由来)
  final String note;

  /// カバー範囲. キーは MRSA / 腸球菌 / Strep / MSSA / EKPSCE / 緑膿菌 / 嫌気 / 非定型
  final Map<String, String> coverage;

  /// 臓器移行性. キーは 眼球 / CNS / 骨 / 前立腺 / 膿瘍
  final Map<String, String> organ;

  const AbxMatrixRow({
    required this.group,
    required this.generic,
    this.brand = '',
    this.abbr = '',
    this.dose = '',
    this.effect = '',
    this.note = '',
    this.coverage = const {},
    this.organ = const {},
  });

  /// 検索対象テキスト
  String get searchText =>
      '$group $generic $brand $abbr $dose $effect $note'.toLowerCase();
}

/// カバー範囲の列 (表示順)
const List<String> kAbxCoverageCols = [
  'MRSA',
  '腸球菌',
  'Strep',
  'MSSA',
  'EKPSCE',
  '緑膿菌',
  '嫌気',
  '非定型',
];

/// 臓器移行性の列 (表示順)
const List<String> kAbxOrganCols = ['眼球', 'CNS', '骨', '前立腺', '膿瘍'];

/// 抗真菌薬のカバー範囲の列. 細菌用とは意味が異なる (真菌の種類).
const List<String> kAntifungalCoverageCols = [
  'カンジダ',
  'クリプトコックス',
  '接合菌',
  'アスペルギルス',
  'フサリウム/スケドスポリウム',
  'PCP',
  '地域流行真菌',
];

/// 抗真菌薬の臓器移行性の列
const List<String> kAntifungalOrganCols = [
  '眼球',
  'CNS',
  '骨',
  '前立腺',
  '尿',
  '唾液',
];

/// 抗ウイルス薬のカバー範囲の列
const List<String> kAntiviralCoverageCols = ['対象ウイルス'];

/// セルの記号の意味. 凡例に使う.
const Map<String, String> kAbxMarkLegend = {
  '●': 'カバーする',
  '▲': '一部・条件付き',
  '△': '限定的',
  '✕': 'カバーしない',
};
