/// 向精神薬の分類表の1行. 上位分類 (定型/非定型, 受容体プロファイル)を保持する.
class PsyClassRow {
  /// 大分類 (抗精神病薬 / 抗不安薬 / 抗てんかん薬 など)
  final String section;

  /// 上位分類 (非定型 / 定型 / BZ系 / SSRI など)
  final String subclass;

  /// 受容体プロファイル・化学構造による分類
  /// MARTA / SDA / DSA / DPA / ブチロフェノン系 / フェノチアジン系 / ベンズアミド系 など
  final String profile;

  final String generic;
  final String brand;
  final String abbr;
  final String spec;

  /// 効果・位置づけ
  final String effect;

  /// 補足 (原典のセルコメント由来)
  final String note;

  const PsyClassRow({
    required this.section,
    this.subclass = '',
    this.profile = '',
    required this.generic,
    this.brand = '',
    this.abbr = '',
    this.spec = '',
    this.effect = '',
    this.note = '',
  });

  String get searchText =>
      '$section $subclass $profile $generic $brand $abbr $effect $note'
          .toLowerCase();
}

/// 受容体プロファイルの説明. 抗精神病薬の「上位分類」を理解するための凡例.
const Map<String, String> kPsyProfileLegend = {
  'MARTA':
      'multi-acting receptor targeted antipsychotic. D2に加えて5-HT2, H1, M1, α1など多受容体に作用する. '
      '鎮静が強く不眠・不穏に使いやすい一方, 体重増加と耐糖能異常が問題となり糖尿病には禁忌のものがある. ',
  'SDA':
      'serotonin-dopamine antagonist. 5-HT2A遮断がD2遮断より優位で, 定型薬より錐体外路症状が出にくい. '
      '陰性症状にも一定の効果が期待される. ',
  'DSA':
      'dopamine-serotonin antagonist. D2遮断が5-HT2A遮断より優位. 陽性症状への効果が主体で鎮静は弱め. ',
  'DPA':
      'dopamine partial agonist. D2受容体の部分作動薬で, ドパミンが過剰なら遮断的に, 不足なら作動的に働く. '
      '錐体外路症状と高プロラクチン血症が少ないがアカシジアはみられる. ',
  'ブチロフェノン系': '定型抗精神病薬. 強力なD2遮断で陽性症状に有効だが錐体外路症状とQT延長が問題となる. ',
  'フェノチアジン系': '定型抗精神病薬. D2遮断に加えα1遮断・抗ヒスタミン作用が強く, 鎮静と血圧低下を来しやすい. ',
  'ベンズアミド系': '定型抗精神病薬. 低用量では消化管運動改善・抗うつ的に働き, 高用量でD2遮断による抗精神病作用を示す. ',
  'D2遮断': 'D2受容体遮断が主体の定型抗精神病薬. ',
};

/// 薬剤 x 精神疾患・症状 の対応表の1行.
class PsyIndicationRow {
  final String generic;
  final String brand;

  /// 上位分類 (MARTA, SDA, ブチロフェノン系 など)
  final String classLabel;

  /// 疾患・症状ごとの適合度. ◎ 主たる適応 / ○ 使える / △ 限定的 / ✕ 避ける
  final Map<String, String> indications;

  /// 周術期・ICUで押さえる注意
  final String cautions;

  const PsyIndicationRow({
    required this.generic,
    this.brand = '',
    this.classLabel = '',
    this.indications = const {},
    this.cautions = '',
  });

  String get searchText =>
      '$generic $brand $classLabel $cautions'.toLowerCase();
}

/// 対応表の列 (表示順)
const List<String> kPsyIndicationCols = [
  '統合失調症',
  '双極性障害躁',
  'うつ病',
  '不安障害',
  '不眠',
  'せん妄',
  '興奮激越',
  '認知症周辺症状',
  '悪心嘔吐',
];

/// 対応表の記号の意味
const Map<String, String> kPsyMarkLegend = {
  '◎': '主たる適応・第一選択',
  '○': '使える',
  '△': '限定的・条件付き',
  '✕': '避ける',
};
