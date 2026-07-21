import '../../models/drug.dart';

/// 薬剤データ: 筋弛緩薬・筋弛緩回復剤.
const List<Drug> kMuscleRelaxantDrugs = [
  Drug(
    name: 'ロクロニウム (ROC)',
    brand: 'エスラックス',
    category: DrugCategory.muscleRelaxant,
    spec: '25mg/2.5mL, 50mg/5.0mL',
    dilution: '原液',
    concentration: '10mg/mL',
    dose:
        '気管挿管: 成人0.6mg/kg. 年齢・症状に応じて増減するが上限0.9mg/kg.\n'
        '追加: 術中必要に応じて0.1-0.2mg/kg.\n'
        '持続注入: 7mcg/kg/minで開始し, 筋弛緩モニターで調節.',
    mechanism: '神経筋接合部のニコチン性ACh受容体を競合的に遮断する非脱分極性筋弛緩薬.',
    packageInsertReviewed: true,
    packageInsertRevision: '2024年3月改訂 第2版',
    packageInsertUrl:
        'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/170050_1229405A1028_2_11',
    contraindications: [
      DrugContraindication('本剤成分または臭化物に対する過敏症の既往', '再投与で重篤な過敏反応を起こすおそれがある.'),
      DrugContraindication(
        '重症筋無力症・筋無力症候群で, スガマデクス過敏症の既往がある患者',
        '回復剤のスガマデクスを使用できず, 筋弛緩作用が遅延しやすい.',
      ),
    ],
    cautiousUse: [
      '気道閉塞・呼吸予備力低下',
      '胆道疾患',
      '気管支喘息',
      '電解質異常',
      '低蛋白血症',
      '脱水・アシドーシス・高炭酸ガス血症',
      '低体温',
      '重症筋無力症・筋無力症候群・その他の神経筋疾患',
      '心拍出量低下',
      '肥満',
      '広範囲熱傷',
      '血液脳関門障害',
      '腎・肝機能障害',
      '妊娠・授乳中',
      '小児・高齢者',
    ],
    notes: [
      DrugNote(
        '調節呼吸と回復確認',
        '本剤は呼吸筋を麻痺させるため, 十分な自発呼吸が回復するまで必ず調節呼吸を行う. 残存筋弛緩による呼吸抑制・誤嚥を防ぐため, 十分な回復を確認してから抜管する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '持続注入の前提',
        '電子添文は7mcg/kg/minで持続注入を開始する用量を示すが, 同時に筋弛緩モニタリング装置を用いて注入速度を調節することを求めている. TOFモニタリングがない状況で持続投与しない.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '研修医向けの安全原則',
        '術中持続投与は筋弛緩蓄積と術後残存筋弛緩のリスクがある. 研修医が電子添文の7mcg/kg/minを定型的に開始することは推奨しない. 持続投与が必要な場合は, 定量的TOFモニタリング, 上級医の指示, 終了時の回復計画をそろえる.',
      ),
      DrugNote(
        '術中持続の施設運用例',
        '5mcg/kg/minで開始し, 定量的TOFで調節する院内運用がある. 電子添文の開始用量は7mcg/kg/minであり, 5mcg/kg/minは承認用量の転記ではない.',
        type: DrugNoteType.facilityPractice,
      ),
      DrugNote(
        '筋弛緩の増強・遅延',
        '揮発性吸入麻酔薬, 電解質異常, アシドーシス, 低体温, 低蛋白血症, 腎・肝機能障害などで効果が増強・遅延しうる. 抗てんかん薬長期内服や広範囲熱傷では感受性が低下することがある.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'アナフィラキシー',
        'ショック・アナフィラキシーが起こりうる. 投与直後の低血圧, 気管支痙攣, 皮膚症状で疑い, 投与中止とアナフィラキシーの緊急対応を開始する.',
        type: DrugNoteType.packageInsert,
      ),
    ],
  ),
  Drug(
    name: 'スガマデクス (SGX)',
    brand: 'ブリディオン',
    category: DrugCategory.muscleRelaxant,
    spec: '200mg/2mL, 500mg/5mL',
    dilution: '原液',
    concentration: '100mg/mL',
    dose:
        '浅い筋弛緩 (T2再出現後): 2mg/kg.\n'
        '深い筋弛緩 (1-2 PTC出現後): 4mg/kg.\n'
        'ロクロニウム挿管用量投与直後の緊急回復: 投与3分後を目安に16mg/kg.',
    mechanism: 'ロクロニウムまたはベクロニウムを選択的に包接し, 神経筋接合部の自由型筋弛緩薬濃度を低下させる変形ガンマシクロデキストリン.',
    packageInsertReviewed: true,
    packageInsertRevision: '2023年11月改訂 第2版',
    packageInsertUrl:
        'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/170050_3929409A1023_1_13',
    contraindications: [
      DrugContraindication(
        '本剤成分に対する過敏症の既往',
        '再投与でショック・アナフィラキシー等の重篤な過敏反応を起こすおそれがある.',
      ),
    ],
    cautiousUse: [
      '心拍出量低下',
      '浮腫性疾患',
      'アレルギー素因',
      '呼吸器疾患の既往',
      '血液凝固障害',
      '腎機能障害',
      '肝機能障害',
      '妊娠・授乳中',
      '小児・高齢者',
    ],
    notes: [
      DrugNote(
        '回復深度と用量',
        '2mg/kgはTOFの2回目反応T2が再出現した浅い筋弛緩に用いる. 4mg/kgは1-2 PTCが出現した深い筋弛緩に用いる. 単収縮反応が1回みられたことだけを根拠に2mg/kgとしない. モニターが使えない場合は, 電子添文7.1の自発呼吸に基づく手順と投与後の十分な観察が必要である.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '対象となる筋弛緩薬',
        '承認効能はロクロニウムまたはベクロニウムによる筋弛緩状態からの回復である. それ以外の筋弛緩薬には使用しない. ベクロニウム挿管用量直後の緊急回復は有効性・安全性が確立していない.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '重大な副作用',
        'ショック・アナフィラキシー, 心室細動, 心室頻拍, 心停止, 高度徐脈, 冠動脈攀縮, 気管支痙攣が起こりうる. 投与後は循環・呼吸と筋弛緩回復を監視する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '腎機能障害',
        '本剤と包接体は主に腎排泄される. 腎機能障害では排泄が遅延するため, 回復時間と投与後の状態を十分に観察する. 「再クラーレ化は考慮不要」と断定しない.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '相互作用・配合変化',
        '経口避妊薬は飲み忘れと同様の対応が必要. 抗凝固薬併用時は凝固作用増強とPT/APTTに注意する. 他剤と同一ルートを使う場合は中性溶液でフラッシュし, 混合しない.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'ロクロニウムアナフィラキシー時',
        'スガマデクスはロクロニウムアナフィラキシーの標準治療ではない. 原因薬中止, アドレナリン, 気道・酸素化, 輸液等の標準対応を優先する. スガマデクス自体もアナフィラキシーを起こしうる.',
      ),
      DrugNote(
        '再筋弛緩が必要な場合',
        'スガマデクス後のロクロニウム再投与では作用発現が遅延するおそれがある. 一律の再投与手順とせず, 必要性, 経過時間, 気道の緊急度を評価し, 上級医と薬剤選択・用量を決める.',
      ),
    ],
  ),
];
