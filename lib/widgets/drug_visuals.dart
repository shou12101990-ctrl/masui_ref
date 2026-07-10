import 'package:flutter/material.dart';

import '../models/drug.dart';

/// 薬剤マーカーの表示色・斜線判定 (UI関心) を Drug モデルから分離した拡張.
/// モデル (lib/models/drug.dart) は Flutter 非依存の純粋 Dart に保つ.

extension DrugCategoryVisual on DrugCategory {
  /// ISO 26825:2020 麻酔薬ラベル国際標準色 (Pantone → hex 変換)
  Color get color => switch (this) {
        DrugCategory.sedative => const Color(0xFFFFD700),        // PMS 109   : 鎮静/誘導薬 標準黄
        DrugCategory.inhalational => const Color(0xFFFFF0A8),    // PMS 109系 : 吸入麻酔薬 (UI区別のため淡黄)
        DrugCategory.muscleRelaxant => const Color(0xFFEF3340),  // PMS Red032: 筋弛緩薬 標準赤
        DrugCategory.analgesic => const Color(0xFF7EC8E3),       // PMS 297   : 鎮痛薬/麻薬 ライトブルー
        DrugCategory.vasopressor => const Color(0xFFB39DDB),     // 昇圧薬 : 淡い明るいバイオレット
        DrugCategory.vasodilator => const Color(0xFFB39DDB),     // 降圧薬 : 淡い明るいバイオレット (+ 斜線)
        DrugCategory.circulatoryOther => const Color(0xFFB39DDB),// 循環作動薬 (その他) : 昇圧薬と同色
        DrugCategory.localAnesthetic => const Color(0xFF97999B), // Cool Gray7 : 局所麻酔薬 標準灰
        DrugCategory.anticoagulant => const Color(0xFFB52020),   // 凝固系 : 血色 (blood red)
        DrugCategory.steroid => const Color(0xFFEF8C00),         // ステロイド : warm orange
        DrugCategory.antiemetic => const Color(0xFF26A69A),      // 制吐薬 : teal
        DrugCategory.antihistamine => const Color(0xFF7CB342),   // 抗ヒスタミン薬 : light green
        DrugCategory.transfusion => const Color(0xFFAD1457),     // 輸血製剤 : crimson
        DrugCategory.other => const Color(0xFF6B1414),           // その他 : 赤黒い (dark red)
      };
}

extension DrugVisual on Drug {
  /// 拮抗薬・中和薬・血管拡張薬 → ■マーカーに斜線を重ねる
  bool get isDiagonal =>
      category == DrugCategory.vasodilator ||
      const ['フルマゼニル', 'スガマデクス', 'ナロキソン', 'ダントロレン', 'イントラリピッド', 'プロタミン', 'ハプトグロビン', 'イダルシズマブ', 'アンデキサネット', 'ビタミンK']
          .any((s) => name.contains(s));

  /// 表示マーカー色. 基本はカテゴリ色だが, 一部薬剤 (プロカテロール・インスリン・KCL) は黄緑に上書きする.
  Color get markColor =>
      const ['プロカテロール', 'インスリン', 'KCL'].any((s) => name.contains(s))
          ? const Color(0xFFC5E1A5)
          : category.color;
}
