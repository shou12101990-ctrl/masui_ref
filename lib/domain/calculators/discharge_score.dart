/// 退室基準スコア (Modified Aldrete / White-Song / MPADSS) の定義と判定.
/// 純粋 Dart (Flutter 非依存) に保ち, VM 上でユニットテスト可能にする.
library;

/// 1項目の選択肢 (点数 + 説明).
class ScoreOption {
  final int points;
  final String text;
  const ScoreOption(this.points, this.text);
}

/// スコアの1評価項目. options は 2点 → 0点 の順.
class ScoreItem {
  final String name;
  final List<ScoreOption> options;
  const ScoreItem(this.name, this.options);
}

/// 採点結果.
class DischargeScoreResult {
  final int total;
  final int maxTotal;
  final bool pass;

  /// 最低点条件 (White-Song の「各項目1点以上」) を満たさない項目があるか.
  final bool hasBelowMinItem;

  const DischargeScoreResult({
    required this.total,
    required this.maxTotal,
    required this.pass,
    required this.hasBelowMinItem,
  });
}

/// 退室基準スコア1種の定義 (項目・合格条件・運用情報).
class DischargeScale {
  final String name;
  final String purpose;
  final String timing;
  final String passCriteria;
  final int cutoff;

  /// 全項目に要求される最低点 (White-Song: 1, 他: 0).
  final int minPerItem;
  final List<ScoreItem> items;

  const DischargeScale({
    required this.name,
    required this.purpose,
    required this.timing,
    required this.passCriteria,
    required this.cutoff,
    this.minPerItem = 0,
    required this.items,
  });

  int get maxTotal => items.length * 2;

  /// 各項目の選択点数 (items と同順・同数) から合否を判定する.
  DischargeScoreResult evaluate(List<int> points) {
    assert(points.length == items.length);
    final total = points.fold(0, (a, b) => a + b);
    final hasBelowMin = points.any((p) => p < minPerItem);
    return DischargeScoreResult(
      total: total,
      maxTotal: maxTotal,
      pass: total >= cutoff && !hasBelowMin,
      hasBelowMinItem: hasBelowMin,
    );
  }
}

/// Modified Aldrete score — PACU退室 / Phase I回復の判定 (満点10).
const aldreteScale = DischargeScale(
  name: 'Modified Aldrete',
  purpose: 'PACU退室 / Phase I回復',
  timing: 'PACU内',
  passCriteria: '9点以上',
  cutoff: 9,
  items: [
    ScoreItem('活動', [
      ScoreOption(2, '四肢を自発的または指示で動かせる'),
      ScoreOption(1, '二肢のみ動かせる'),
      ScoreOption(0, '動かせない'),
    ]),
    ScoreItem('呼吸', [
      ScoreOption(2, '深呼吸と十分な咳ができる'),
      ScoreOption(1, '呼吸困難・浅く遅い呼吸'),
      ScoreOption(0, '無呼吸'),
    ]),
    ScoreItem('循環 (血圧)', [
      ScoreOption(2, '麻酔前値の±20%以内'),
      ScoreOption(1, '麻酔前値の±20-50%'),
      ScoreOption(0, '麻酔前値の±50%超'),
    ]),
    ScoreItem('意識', [
      ScoreOption(2, '完全に覚醒'),
      ScoreOption(1, '呼びかけで覚醒'),
      ScoreOption(0, '反応なし'),
    ]),
    ScoreItem('酸素飽和度', [
      ScoreOption(2, '室内気で SpO₂ ≥ 92%'),
      ScoreOption(1, '酸素投与下で SpO₂ > 90%'),
      ScoreOption(0, '酸素投与下でも SpO₂ < 90%'),
    ]),
  ],
);

/// White-Song score — fast-track (PACUバイパス) の判定 (満点14).
const whiteSongScale = DischargeScale(
  name: 'White-Song',
  purpose: 'PACUバイパス / Phase II直行',
  timing: 'OR退室直後〜早期',
  passCriteria: '12点以上かつ各項目1点以上',
  cutoff: 12,
  minPerItem: 1,
  items: [
    ScoreItem('意識レベル', [
      ScoreOption(2, '覚醒し見当識良好'),
      ScoreOption(1, '軽い刺激で覚醒'),
      ScoreOption(0, '触覚刺激のみに反応'),
    ]),
    ScoreItem('身体活動', [
      ScoreOption(2, '指示で四肢を動かせる'),
      ScoreOption(1, '四肢の動きが弱い'),
      ScoreOption(0, '自発的に動かせない'),
    ]),
    ScoreItem('血行動態 (血圧)', [
      ScoreOption(2, '術前MAP値の±15%以内'),
      ScoreOption(1, '術前MAP値の±15-30%'),
      ScoreOption(0, '術前MAP値の±30%超'),
    ]),
    ScoreItem('呼吸', [
      ScoreOption(2, '深呼吸ができる'),
      ScoreOption(1, '頻呼吸だが咳は良好'),
      ScoreOption(0, '呼吸困難で咳が弱い'),
    ]),
    ScoreItem('酸素飽和度', [
      ScoreOption(2, '室内気で SpO₂ > 90%'),
      ScoreOption(1, '酸素投与 (経鼻) が必要'),
      ScoreOption(0, '酸素投与下でも SpO₂ < 90%'),
    ]),
    ScoreItem('術後疼痛', [
      ScoreOption(2, 'なし〜軽度の不快感'),
      ScoreOption(1, '中等度〜高度だが IV 鎮痛薬で制御可'),
      ScoreOption(0, '持続する高度の疼痛'),
    ]),
    ScoreItem('術後嘔気・嘔吐', [
      ScoreOption(2, 'なし〜軽度の悪心 (嘔吐なし)'),
      ScoreOption(1, '一過性の嘔吐・空えずき'),
      ScoreOption(0, '持続する中等度〜高度の悪心・嘔吐'),
    ]),
  ],
);

/// MPADSS (Modified Post-Anesthesia Discharge Scoring System)
/// — 日帰り退院 / 帰宅判定 (満点10).
const mpadssScale = DischargeScale(
  name: 'MPADSS',
  purpose: '日帰り退院 / 帰宅判定',
  timing: 'Phase II後, 帰宅前',
  passCriteria: '9点以上',
  cutoff: 9,
  items: [
    ScoreItem('バイタルサイン', [
      ScoreOption(2, '術前値の±20%以内'),
      ScoreOption(1, '術前値の±20-40%'),
      ScoreOption(0, '術前値の±40%超'),
    ]),
    ScoreItem('歩行', [
      ScoreOption(2, 'ふらつきなく歩行可能 (術前レベル)'),
      ScoreOption(1, '介助があれば歩行可能'),
      ScoreOption(0, '歩行不能 / めまい'),
    ]),
    ScoreItem('嘔気・嘔吐', [
      ScoreOption(2, '軽度 (内服薬で制御可)'),
      ScoreOption(1, '中等度 (注射薬で制御可)'),
      ScoreOption(0, '高度 (治療を繰り返しても持続)'),
    ]),
    ScoreItem('疼痛', [
      ScoreOption(2, 'なし〜軽度 (経口鎮痛薬で許容内)'),
      ScoreOption(1, '中等度'),
      ScoreOption(0, '高度 (許容できない)'),
    ]),
    ScoreItem('手術部位出血', [
      ScoreOption(2, '軽度 (ガーゼ交換不要)'),
      ScoreOption(1, '中等度 (2回までの交換)'),
      ScoreOption(0, '高度 (3回以上の交換)'),
    ]),
  ],
);

/// 画面に並べる順 (Aldrete → White-Song → MPADSS).
const List<DischargeScale> kDischargeScales = [
  aldreteScale,
  whiteSongScale,
  mpadssScale,
];
