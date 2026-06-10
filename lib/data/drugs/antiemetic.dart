import '../../models/drug.dart';

/// 薬剤データ: 制吐薬. (lib/data/drugs.dart から分割)
const List<Drug> kAntiemeticDrugs = [
  Drug(
    name: 'メトクロプラミド',
    brand: 'プリンペラン',
    category: DrugCategory.antiemetic,
    spec: '10mg/2ml/A',
    dilution: '原液 or NS希釈',
    dose: '10mg iv / div (1日1-2回)',
    mechanism: '中枢性D2受容体拮抗＋消化管運動亢進による制吐作用',
    notes: [
      DrugNote('用量・使い方',
          '・PONV・術中の嘔気: 10mg iv (緩徐に).\n'
          '・C繊維とAδ繊維のブロックずれによる上腹部操作時の嘔気にも 1A iv.\n'
          '・消化管運動を亢進させるため腸管蠕動の改善目的にも用いる.'),
      DrugNote('副作用・注意',
          '・錐体外路症状 (アカシジア・ジストニア), 高プロラクチン血症.\n'
          '・急速静注で不穏が出ることがあるため緩徐に. パーキンソン病では慎重投与.\n'
          '・消化管穿孔・出血・閉塞では禁忌 (蠕動亢進のため).'),
    ],
  ),
  Drug(
    name: 'グラニセトロン',
    brand: 'カイトリル',
    category: DrugCategory.antiemetic,
    spec: '1mg/1ml/A, 3mg/3ml/A',
    dilution: '原液 or NS希釈',
    dose: 'PONV・制吐 1mg iv',
    mechanism: '選択的5-HT3受容体拮抗による制吐作用',
    notes: [
      DrugNote('用量・使い方',
          '・PONV予防/治療: 1mg iv (注射は術後の悪心・嘔吐が適応, 1日3mgまで). 抗癌剤による悪心嘔吐にも使用.\n'
          '・PONVハイリスクでは「5-HT3拮抗薬 ＋ ステロイド ＋ ドロペリドール」など多剤併用が推奨.'),
      DrugNote('副作用・注意',
          '・QT延長に注意 (ドロペリドール併用時は特に). 頭痛・便秘.\n'
          '・主に消化管・CTZの5-HT3受容体を遮断して作用する.'),
    ],
  ),
  Drug(
    name: 'オンダンセトロン',
    brand: 'ゾフラン',
    category: DrugCategory.antiemetic,
    spec: '2mg/1ml/A, 4mg/2ml/A',
    dilution: '原液 or NS希釈',
    dose: 'PONV・制吐 4mg iv',
    mechanism: '選択的5-HT3受容体拮抗による制吐作用',
    notes: [
      DrugNote('用量・使い方',
          '・PONV予防/治療: 4mg iv (手術終了前後). 抗癌剤による悪心嘔吐にも使用.\n'
          '・グラニセトロンと同系統 (5-HT3拮抗薬). ステロイド・ドロペリドールなどと多剤併用.'),
      DrugNote('副作用・注意',
          '・QT延長に注意 (特にドロペリドール併用時). 頭痛・便秘.\n'
          '・肝代謝 (CYP). 半減期は約3-4時間.\n'
          '・本邦の適応は抗悪性腫瘍剤に伴う悪心・嘔吐のみで, PONVは適応外 (グラニセトロン注はPONVも適応).'),
    ],
  ),
];
