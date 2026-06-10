import '../../models/drug.dart';

/// 薬剤データ: 輸血製剤. (lib/data/drugs.dart から分割)
const List<Drug> kTransfusionDrugs = [
  Drug(
    name: '5%アルブミン',
    brand: '献血アルブミン5% / ブミネート',
    category: DrugCategory.transfusion,
    spec: '250ml/V (等張)',
    dose: '循環血漿量の補充 (出血・血漿喪失)',
    mechanism: '等張アルブミン. 膠質浸透圧を保ち循環血漿量を維持',
    notes: [
      DrugNote('使い方',
          '・等張で投与量とほぼ同量の血漿増量効果. 出血・熱傷・敗血症などの volume 補充.\n'
          '・晶質液で反応不十分な血管内volume不足に.\n'
          '・外傷性脳損傷では予後悪化のため避ける (SAFE study). 敗血症の初期蘇生にルーチン投与は推奨されない. SAH後の血管攣縮で晶質液無効時は考慮.'),
    ],
  ),
  Drug(
    name: '25%アルブミン',
    brand: '献血アルブミン25% / ブミネート25%',
    category: DrugCategory.transfusion,
    spec: '50ml/V (高張)',
    dose: '低Alb血症・浮腫を伴う循環血漿量減少',
    mechanism: '高張アルブミン. 強い膠質浸透圧で間質から血管内へ水を移動させる',
    notes: [
      DrugNote('使い方',
          '・低アルブミン血症で浮腫・腹水を伴う症例の血漿量補正 (投与量の約3-4倍の血漿量増加).\n'
          '・間質から血管内へ水を引き込むため, 脱水・心不全では肺水腫に注意.'),
    ],
  ),
  Drug(
    name: '赤血球濃厚液 (RBC)',
    brand: 'RCC-LR (照射赤血球液)',
    category: DrugCategory.transfusion,
    spec: '1単位 約140ml, 2単位 約280ml',
    dose: '2単位輸血で成人 Hb 約1.5g/dL 上昇 (体重あたり 3-4ml/kgで約1g/dL)',
    mechanism: '酸素運搬能の改善 (Hb補充)',
    notes: [
      DrugNote('適応・目安',
          '・Hb 7g/dL以上を維持するのが一般的なトリガー (心疾患・出血進行中は高めに).\n'
          '・予測上昇Hb(g/dL) ≒ 投与Hb量(g) / 循環血液量(dL). RCC-LR 1単位=Hb約26.5g, 循環血液量≒体重×70mL.\n'
          '・献血200ml由来が1単位. 緊急時はO型RBC (Rh−)を使用しうる.'),
      DrugNote('注意',
          '・原則ABO同型. 大量輸血時は加温・カルシウム補充 (クエン酸中毒)・高K血症に注意.\n'
          '・GVHD予防のため放射線照射製剤を使用.'),
    ],
  ),
  Drug(
    name: '新鮮凍結血漿 (FFP)',
    brand: 'FFP-LR',
    category: DrugCategory.transfusion,
    spec: '1単位 約120ml, 2単位 約240ml',
    dose: '初期 10-15ml/kg (PT/APTT延長・フィブリノゲン低下の補正)',
    mechanism: '凝固因子・フィブリノゲンの補充',
    notes: [
      DrugNote('適応・目安',
          '・PT-INR>2.0 or APTT基準2倍以上, フィブリノゲン<150mg/dL の出血時.\n'
          '・10-15ml/kgで凝固因子活性が20-30%上昇.\n'
          '・融解後は直ちに使用が望ましい. 直ちに使えない場合は2-6℃で24時間以内 (第VIII因子は経時的に失活). 融解に時間がかかるため早めにオーダー.'),
      DrugNote('注意',
          'ABO同型または適合型. 急速大量投与でクエン酸による低Ca血症・TACO (循環過負荷)に注意.'),
    ],
  ),
  Drug(
    name: '濃厚血小板 (PC)',
    brand: 'PC-LR (照射濃厚血小板)',
    category: DrugCategory.transfusion,
    spec: '10単位 約200ml (血小板 約2×10¹¹)',
    dose: '血小板 5万/μL未満の出血時・観血的処置前に輸血',
    mechanism: '血小板の補充 (一次止血の改善)',
    notes: [
      DrugNote('適応・目安',
          '・大量出血・DIC・抗血小板薬下の出血で 5万/μL未満.\n'
          '・脳神経外科・眼科など 10万/μL を要する手技もある.\n'
          '・10単位輸血で成人 血小板 約3-5万/μL 上昇.'),
      DrugNote('注意',
          '・室温保存・振盪, 有効期間が短い (採血後4日). ABO同型が望ましい.\n'
          '・GVHD予防のため放射線照射製剤を使用.\n'
          '・効果判定はCCI (輸血1時間後≧7500, 24時間後≧4500. 低ければHLA抗体等による血小板輸血不応を疑う).'),
    ],
  ),
  Drug(
    name: '自己回収血',
    brand: 'セルセーバー (術中回収式自己血)',
    category: DrugCategory.transfusion,
    spec: '術野出血を回収・洗浄・濃縮して返血',
    dose: '回収・洗浄した赤血球を返血',
    mechanism: '術野の出血を吸引・洗浄し, 赤血球のみを返血 (自己血)',
    notes: [
      DrugNote('特徴',
          '・洗浄赤血球のため Ht が高い一方で, 血小板・凝固因子・血漿は含まれない (大量返血時はFFP/PC併用を考慮).\n'
          '・同種輸血を回避できる. 大量出血が予想される心臓・大血管・整形外科手術などで使用.'),
      DrugNote('禁忌・注意',
          '・術野の悪性腫瘍細胞・細菌・羊水などの混入が問題となる場面では原則禁忌 (白血球除去フィルターで一部対応).\n'
          '・大量返血では洗浄液による希釈性凝固障害に注意.'),
    ],
  ),
  Drug(
    name: 'ハプトグロビン (Hp)',
    brand: 'ハプトグロビン静注',
    category: DrugCategory.transfusion,
    spec: '2000単位/V, 4000単位/V',
    dose: '溶血時 4000単位 div',
    mechanism: '遊離ヘモグロビンと結合し腎尿細管障害 (ヘモグロビン尿性腎症)を防ぐ',
    notes: [
      DrugNote('適応',
          '・大量輸血・自己血大量返血・体外循環・溶血性輸血反応などで遊離Hbが増加した時.\n'
          '・遊離Hbと結合して網内系で処理させ, 急性腎障害 (ヘモグロビン尿)を予防する.'),
      DrugNote('注意',
          '献血由来血漿分画製剤で投与記録の保管が必要. 急速投与で血圧低下を起こすため緩徐に投与する.'),
    ],
  ),
];
