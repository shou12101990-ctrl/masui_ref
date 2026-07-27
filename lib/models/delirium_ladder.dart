/// せん妄・不眠のラダーで使う薬剤1剤. 病態ごとの可否を持ち, 患者背景から適否を判定する.
class LadderDrug {
  final String generic;
  final String brand;

  /// ラダー上の位置づけ (例「せん妄 (1) 基本」)
  final String step;

  /// ラダーでの用量
  final String dose;

  /// 病態ごとの可否. 値は 禁忌 / 原則回避 / 減量 / 注意 / '' (制限なし)
  final Map<String, String> conditions;

  /// 電子添文の禁忌のうち周術期・ICUで問題になるもの
  final List<LadderContraindication> keyContraindications;

  /// 使えないときの代替案
  final String alternative;

  const LadderDrug({
    required this.generic,
    this.brand = '',
    this.step = '',
    this.dose = '',
    this.conditions = const {},
    this.keyContraindications = const [],
    this.alternative = '',
  });

  /// 選択された病態に対する最も重い判定を返す. 何もなければ空文字.
  String verdictFor(Set<String> selected) {
    var worst = '';
    for (final c in selected) {
      final v = conditions[c] ?? '';
      if (_rank(v) > _rank(worst)) worst = v;
    }
    return worst;
  }

  /// 判定に至った病態を列挙する (画面で理由を出すため)
  List<MapEntry<String, String>> reasonsFor(Set<String> selected) {
    final out = <MapEntry<String, String>>[];
    for (final c in selected) {
      final v = conditions[c] ?? '';
      if (v.isNotEmpty) out.add(MapEntry(c, v));
    }
    out.sort((a, b) => _rank(b.value).compareTo(_rank(a.value)));
    return out;
  }

  static int _rank(String v) => switch (v) {
    '禁忌' => 4,
    '原則回避' => 3,
    '減量' => 2,
    '注意' => 1,
    _ => 0,
  };
}

class LadderContraindication {
  final String target;
  final String reason;
  const LadderContraindication(this.target, this.reason);
}

/// 判定に使う患者背景. 画面のチェックボックスに並ぶ.
const List<String> kLadderConditions = [
  '糖尿病',
  '腎機能低下',
  '肝機能障害',
  'パーキンソン病レビー小体',
  'QT延長不整脈',
  '閉塞隅角緑内障',
  '重症筋無力症',
  '呼吸抑制リスク',
  'けいれん既往',
  '高齢者',
  '内服困難',
  'アルコール離脱疑い',
];

/// 画面表示用の短いラベル
const Map<String, String> kLadderConditionLabels = {
  '糖尿病': '糖尿病',
  '腎機能低下': '腎機能低下 (eGFR<30)',
  '肝機能障害': '肝機能障害',
  'パーキンソン病レビー小体': 'パーキンソン病 / DLB',
  'QT延長不整脈': 'QT延長・不整脈',
  '閉塞隅角緑内障': '閉塞隅角緑内障',
  '重症筋無力症': '重症筋無力症',
  '呼吸抑制リスク': '呼吸抑制リスク (COPD/SAS)',
  'けいれん既往': 'けいれん既往',
  '高齢者': '高齢者',
  '内服困難': '内服困難',
  'アルコール離脱疑い': 'アルコール離脱疑い',
};
