import 'package:flutter/material.dart';

/// 抗菌薬・向精神薬以外のマトリクス (利尿薬 / 便秘薬 / 整腸剤)の1行.
///
/// 抗菌薬表の AbxMatrixRow が「カバー範囲」と「臓器移行性」の2種類の列を持つのに対し,
/// こちらは列が1種類だけなので marks 1本にまとめている.
class SimpleMatrixRow {
  /// 上位分類 (系統). 表の左端に90度回転の縦帯で出す.
  final String group;

  /// 一般名
  final String generic;

  /// 商品名
  final String brand;

  /// 規格
  final String spec;

  /// 標準的な用法・用量
  final String dose;

  /// 上限量・投与間隔の規定. 規定が無ければ空文字.
  final String doseLimit;

  /// 位置づけ・作用の一言
  final String effect;

  /// 作用機序
  final String mechanism;

  /// 補足 (原典のセルコメント由来の臨床メモ)
  final String note;

  /// 列 → 判定. 値は "○" (該当) / "△" (限定的・条件付き) / "" (非該当).
  final Map<String, String> marks;

  const SimpleMatrixRow({
    required this.group,
    required this.generic,
    this.brand = '',
    this.spec = '',
    this.dose = '',
    this.doseLimit = '',
    this.effect = '',
    this.mechanism = '',
    this.note = '',
    this.marks = const {},
  });

  String get searchText =>
      '$group $generic $brand $spec $dose $effect $mechanism $note'
          .toLowerCase();
}

/// マトリクスの記号の凡例. 3つの表で共通.
const Map<String, String> kSimpleMarkLegend = {
  '○': '該当する',
  '△': '限定的・条件付き',
};

// ---------------------------------------------------------------------------
// 利尿薬
// ---------------------------------------------------------------------------

/// 利尿薬の列. 前半5列がネフロン上の作用部位, 後半2列が利尿の型.
const List<String> kDiureticCols = [
  '近位',
  'Henle',
  '遠位',
  '集合管',
  '血管',
  'Na利尿',
  '水利尿',
];

/// 列の色. 作用部位 (青系)と利尿の型 (橙系)で色相を分ける.
const Map<String, Color> kDiureticColColors = {
  '近位': Color(0xFF1565C0),
  'Henle': Color(0xFF1565C0),
  '遠位': Color(0xFF1565C0),
  '集合管': Color(0xFF1565C0),
  '血管': Color(0xFF00838F),
  'Na利尿': Color(0xFFE65100),
  '水利尿': Color(0xFFE65100),
};

/// 凡例に出す「色 → 何を表すか」
const List<(String, Color)> kDiureticLegendGroups = [
  ('ネフロン上の作用部位', Color(0xFF1565C0)),
  ('血管への作用', Color(0xFF00838F)),
  ('利尿の型', Color(0xFFE65100)),
];

// ---------------------------------------------------------------------------
// 便秘薬・消化管運動改善薬
// ---------------------------------------------------------------------------

/// 便秘薬の列. 原典 (Book4)の「上 / 下 / 軟便化 / 蠕動改善」に対応する.
const List<String> kLaxativeCols = ['上部消化管', '下部消化管', '軟便化', '蠕動改善'];

const Map<String, Color> kLaxativeColColors = {
  '上部消化管': Color(0xFF6A1B9A),
  '下部消化管': Color(0xFF6A1B9A),
  '軟便化': Color(0xFF2E7D32),
  '蠕動改善': Color(0xFFC62828),
};

const List<(String, Color)> kLaxativeLegendGroups = [
  ('作用する部位', Color(0xFF6A1B9A)),
  ('便を軟らかくする', Color(0xFF2E7D32)),
  ('腸管運動を促す', Color(0xFFC62828)),
];

// ---------------------------------------------------------------------------
// 整腸剤 (プロバイオティクス)
// ---------------------------------------------------------------------------

/// 整腸剤の列. 製剤に含まれる菌種.
const List<String> kProbioticCols = [
  '酪酸菌',
  '乳酸菌',
  '耐性乳酸菌',
  '糖化菌',
  '酵母菌',
  'ビフィズス菌',
];

const Map<String, Color> kProbioticColColors = {
  '酪酸菌': Color(0xFF00695C),
  '乳酸菌': Color(0xFFAD1457),
  '耐性乳酸菌': Color(0xFFAD1457),
  '糖化菌': Color(0xFF4527A0),
  '酵母菌': Color(0xFFEF6C00),
  'ビフィズス菌': Color(0xFF1565C0),
};

const List<(String, Color)> kProbioticLegendGroups = [
  ('酪酸菌', Color(0xFF00695C)),
  ('乳酸菌・耐性乳酸菌', Color(0xFFAD1457)),
  ('糖化菌', Color(0xFF4527A0)),
  ('酵母菌', Color(0xFFEF6C00)),
  ('ビフィズス菌', Color(0xFF1565C0)),
];
