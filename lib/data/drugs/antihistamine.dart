import '../../models/drug.dart';

/// 薬剤データ: 抗ヒスタミン薬 (H1/H2). (lib/data/drugs.dart から分割)
const List<Drug> kAntihistamineDrugs = [
  Drug(
    name: 'd-クロルフェニラミン',
    brand: 'ポララミン',
    category: DrugCategory.antihistamine,
    spec: '注 5mg/1mL/A. 錠2mg, 散/DS/シロップ',
    dilution: '原液 or NS希釈',
    dose: 'アレルギー: 5mg iv/im. 内服 2mg 1日1-4回',
    mechanism: '第1世代H1受容体拮抗 (中枢移行あり→鎮静・抗コリン作用)',
    notes: [
      DrugNote('用量・使い方',
          '・蕁麻疹・アレルギー性反応・輸血反応 (蕁麻疹/発熱)に 5mg iv/im. 内服は2mg.\n'
          '・アナフィラキシーの第一選択はアドレナリンであり, 本剤はH1ブロックの補助的位置づけ.'),
      DrugNote('副作用・注意',
          '・眠気 (車の運転注意), 抗コリン作用 (口渇・尿閉・便秘).\n'
          '・閉塞隅角緑内障・前立腺肥大では禁忌/慎重. 高齢者はせん妄・転倒に注意.'),
    ],
  ),
  Drug(
    name: 'ファモチジン',
    brand: 'ガスター',
    category: DrugCategory.antihistamine,
    spec: '注 10mg/V, 20mg/V. 錠10/20mg, OD錠',
    dilution: '生食/ブドウ糖で希釈し緩徐に静注 or 点滴',
    dose: '20mg iv (1日2回まで). 術前の誤嚥予防にも',
    mechanism: '胃壁細胞のヒスタミンH2受容体を拮抗し胃酸分泌を抑制',
    notes: [
      DrugNote('用量・使い方',
          '・消化性潰瘍・上部消化管出血・逆流性食道炎. ストレス潰瘍予防.\n'
          '・全身麻酔前の誤嚥性肺炎予防に胃酸pHを上げる目的で用いることがある.\n'
          '・アナフィラキシーでは H1拮抗薬 (+アドレナリン)に H2ブロックを併用する補助. 20mg iv (1日2回まで).'),
      DrugNote('副作用・注意',
          '・腎排泄型→腎機能低下では減量. 高齢者・腎障害でせん妄をきたしうる.\n'
          '・急速静注で徐脈・不整脈の報告があり緩徐に投与する. まれに汎血球減少.'),
    ],
  ),
  Drug(
    name: 'ヒドロキシジン',
    brand: 'アタラックス-P',
    category: DrugCategory.antihistamine,
    spec: '注 (アタラックスP) 25mg/1mL, 50mg/1mL. 内服 (アタラックス) Cap/散/Syr',
    dilution: '筋注 or 生食希釈で緩徐に点滴静注 (原液の急速静注は避ける)',
    dose: '25-50mg im/緩徐iv (蕁麻疹・術前鎮静・悪心)',
    mechanism: '第1世代H1拮抗 (ピペラジン系)＋中枢抑制で鎮静・抗不安・制吐',
    notes: [
      DrugNote('用量・使い方',
          '・蕁麻疹・皮膚そう痒, 術前投薬 (鎮静・制吐), 悪心嘔吐, 不安・緊張.\n'
          '・オピオイドの鎮静/制吐の補助にも. 25-50mgを筋注 (静注は希釈し緩徐に).'),
      DrugNote('副作用・注意',
          '・QT延長・心室頻拍 (torsades)のリスク→先天性QT延長・QT延長のある患者は禁忌.\n'
          '・ポルフィリン症は禁忌. 眠気・抗コリン作用. 緑内障・前立腺肥大で注意.\n'
          '・静注は組織障害・血栓性静脈炎に注意し, 希釈して緩徐に投与する.'),
    ],
  ),
];
