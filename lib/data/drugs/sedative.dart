import '../../models/drug.dart';

const _barbiturateContraindications = [
  DrugContraindication(
    'ショック, 大出血による循環不全, 重症心不全',
    '血管運動中枢抑制により過度の血圧低下を起こすおそれがある.',
  ),
  DrugContraindication('急性間歇性ポルフィリン症', '酵素誘導によりポルフィリン合成を促進し, 症状を悪化させるおそれがある.'),
  DrugContraindication('アジソン病', '催眠作用の持続・増強, 血圧低下, 高カリウム血症の増悪を来すおそれがある.'),
  DrugContraindication('重症気管支喘息', '気管支痙攣を誘発するおそれがある.'),
  DrugContraindication('バルビツール酸系薬物に対する過敏症', '再投与で過敏反応を起こすおそれがある.'),
];

const _barbiturateCautions = [
  '重症糖尿病',
  '重症高血圧・低血圧',
  '重症貧血・低蛋白血症',
  '心筋障害・動脈硬化症',
  '脳圧上昇時',
  '重症筋無力症・筋ジストロフィー',
  '呼吸困難・気道閉塞',
  '電解質異常',
  '重症腎障害',
  '重症肝障害',
  '妊婦・授乳婦',
  '小児・高齢者',
];

/// 薬剤データ: 鎮静薬. 電子添文確認済み薬剤から新形式へ移行する.
const List<Drug> kSedativeDrugs = [
  Drug(
    name: 'プロポフォール',
    brand: 'ディプリバン / プロポフォール',
    category: DrugCategory.sedative,
    spec: '200mg/20mL, 500mg/50mL, 1000mg/100mL',
    dilution: '原液',
    concentration: '10mg/mL',
    dose:
        '全身麻酔導入: 0.5mg/kg/10秒で就眠まで投与. 通常2.0-2.5mg/kgで就眠.\n'
        '全身麻酔維持: 4-10mg/kg/hで調節し, 鎮痛薬を併用.\n'
        '成人ICU人工呼吸中鎮静: 0.3mg/kg/hで開始し, 通常0.3-3.0mg/kg/h.',
    mechanism: 'GABA-A受容体機能を促進し, 中枢神経系を可逆的に抑制する静脈麻酔薬.',
    packageInsertReviewed: true,
    packageInsertRevision: '2023年9月改訂 第1版',
    packageInsertUrl:
        'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/112268_1119402A1022_2_06',
    contraindications: [
      DrugContraindication('本剤または本剤成分に対する過敏症の既往', '再投与で重篤な過敏反応を起こすおそれがある.'),
      DrugContraindication('小児等への集中治療における人工呼吸中の鎮静', '海外で小児等の死亡例が報告されている.'),
    ],
    cautiousUse: [
      'ASA III・IV, 衰弱患者',
      '循環器・呼吸器障害',
      '循環血液量減少',
      'てんかん発作の既往',
      '薬物依存・薬物過敏症の既往',
      '脂質代謝障害・脂肪乳剤投与中',
      '腎・肝機能障害',
      '妊婦・授乳婦',
      '高齢者',
    ],
    notes: [
      DrugNote(
        '投与時の基本',
        '気道確保, 酸素投与, 人工呼吸, 循環管理ができる準備下で使用する. 無呼吸, 低血圧, 徐脈, 舌根沈下などの呼吸循環抑制を前提に連続監視する. ICU鎮静では持続注入とし, 急速投与しない.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '維持投与例',
        '電子添文の使用例は導入後0-10分を10mg/kg/h, 10-20分を8mg/kg/h, 20-30分を6mg/kg/hとし, 30分以降は全身状態をみながら調節する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'TCI・慣用的な導入量',
        '施設によって導入1-2mg/kg, TCI目標濃度5.0mcg/mLから就眠後3.0-3.5mcg/mLなどの運用がある. 固定値ではなく, 患者背景, 併用鎮痛薬, 手術刺激, 脳波・循環所見に合わせる.',
        type: DrugNoteType.facilityPractice,
      ),
      DrugNote(
        '低心機能・全身状態不良時',
        '少量分割投与, 緩徐投与, 吸入麻酔薬との併用などの導入法は施設差が大きい. 電子添文ではASA III・IV患者の導入速度を約半分に減速する例が示されているため, 院内手順と上級医の方針を優先する.',
        type: DrugNoteType.facilityPractice,
      ),
      DrugNote(
        '非挿管下鎮静・覚醒下手術',
        '覚醒下手術や一般的な処置時鎮静は本剤の承認効能ではない. 実施する場合は適応外使用として, 鎮静担当者, 気道管理, モニタリング, 投与手順を院内で定める.',
        type: DrugNoteType.offLabel,
      ),
      DrugNote(
        'プロポフォール注入症候群',
        '長時間・高用量投与, 重症病態, カテコラミンやステロイド併用などでリスクが上がる. 代謝性アシドーシス, 横紋筋融解, 高カリウム血症, 高脂血症, 肝腫大, 不整脈, 心不全を疑う所見があれば直ちに中止し, 集中治療を行う.',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        '薬物動態・特徴',
        '作用発現は速く, 単回投与後は主に再分布により短時間で覚醒する. 鎮痛作用はないため鎮痛薬を併用する. 呼吸抑制は軽いとは限らず, 単回導入でも無呼吸を起こしうる.',
      ),
    ],
  ),
  Drug(
    name: 'チオペンタール',
    brand: 'ラボナール',
    category: DrugCategory.sedative,
    spec: '300mg, 500mg',
    dilution: '添付の注射用水12mL (300mg) / 20mL (500mg)',
    concentration: '2.5% (25mg/mL)',
    dose:
        '導入: 最初に2-4mL (50-100mg)を投与し反応を観察. 応答がなくなるまで追加し, 就眠量の半量ないし同量を追加して他の麻酔法へ移行.',
    mechanism: 'GABA-A受容体機能を増強する超短時間作用型バルビツール酸系静脈麻酔薬.',
    packageInsertReviewed: true,
    packageInsertRevision: '2025年4月改訂',
    packageInsertUrl:
        'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/530100_1115400X1027_3_01',
    contraindications: _barbiturateContraindications,
    cautiousUse: _barbiturateCautions,
    notes: [
      DrugNote(
        '調製・配合',
        '2.5%水溶液として使用する. 5%溶液は静脈炎を起こすことがある. 酸性薬剤や非脱分極性筋弛緩薬との直接混合で沈殿することがあるため, 同一ルート使用時は十分にフラッシュする.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '血管外漏出・動脈内誤注入',
        '強アルカリ性で組織障害を起こしうる. 血管外漏出時は投与を中止し, 電子添文に沿ってプロカイン等の局所麻酔薬注入や温罨法を検討する. 動脈内誤注入は動脈攣縮・血栓・壊死につながるため緊急対応する. ロピバカインでの「中和」は電子添文記載ではない.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '体重換算の慣用量',
        '健常成人3-5mg/kg, 小児5-6mg/kg, 乳幼児5-8mg/kgなどの体重換算が施設運用として用いられる. 電子添文は体重固定量ではなく, 50-100mgから反応をみる分割投与である.',
        type: DrugNoteType.facilityPractice,
      ),
      DrugNote(
        '神経保護目的',
        '大動脈手術などでの神経保護目的投与は承認効能ではなく, 有効性は病態・研究により一定しない. 施設プロトコルなしに routine 使用しない.',
        type: DrugNoteType.literature,
      ),
      DrugNote('特徴', '作用発現は速いが, 反復投与では末梢組織への蓄積により覚醒が遅延しうる. 鎮痛作用はない.'),
    ],
  ),
  Drug(
    name: 'チアミラール',
    brand: 'イソゾール / チトゾール',
    category: DrugCategory.sedative,
    spec: '500mg/V',
    dilution: '添付の注射用水20mL',
    concentration: '2.5% (25mg/mL)',
    dose:
        '導入: 最初に2-4mL (50-100mg)を投与し反応を観察. 応答がなくなるまで追加し, 就眠量の半量ないし同量を追加して他の麻酔法へ移行.',
    mechanism: 'GABA-A受容体機能を増強する超短時間作用型バルビツール酸系静脈麻酔薬.',
    packageInsertReviewed: true,
    packageInsertRevision: '2022年3月改訂 第1版',
    packageInsertUrl:
        'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/530169_1115403D3043_1_03',
    contraindications: _barbiturateContraindications,
    cautiousUse: _barbiturateCautions,
    notes: [
      DrugNote(
        '調製・配合',
        '2.5%水溶液として使用する. 5%溶液は静脈炎を起こすことがある. 強アルカリ性で, 酸性薬剤やロクロニウム等との同一ルート投与では結晶・沈殿を避けるため前後にフラッシュする.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '血管外漏出・動脈内誤注入',
        '血管外漏出では投与を中止し, 組織障害に対応する. 動脈内誤注入は攣縮, 血栓, 末梢壊死の危険がある. ロピバカインでの「中和」は電子添文記載ではない.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '体重換算の慣用量',
        '3mg/kg前後を導入量の目安にする施設があるが, 電子添文は体重固定量ではなく50-100mgから反応をみる分割投与である. 根拠不明だった旧gamma表記は削除した.',
        type: DrugNoteType.facilityPractice,
      ),
      DrugNote(
        '神経保護目的',
        '大動脈手術などでの神経保護目的投与は承認効能ではなく, 有効性は一定しない. 施設プロトコルと上級医判断を要する.',
        type: DrugNoteType.literature,
      ),
    ],
  ),
  Drug(
    name: 'ミダゾラム (MDZ)',
    brand: 'ドルミカム / ミダゾラム',
    category: DrugCategory.sedative,
    spec: '10mg/2mL/A',
    dilution: '原液5mg/mL. 持続投与時の希釈は施設手順による',
    concentration: '5mg/mL (原液)',
    dose:
        '麻酔前投薬: 成人0.08-0.10mg/kgを手術30-60分前に筋注.\n'
        '全身麻酔導入・維持: 成人0.15-0.30mg/kgを1分以上かけて静注. 必要時は初回量の半量ないし同量を追加.\n'
        '成人ICU鎮静: 導入0.03mg/kgを1分以上, 必要時追加 (総量0.30mg/kgまで). 維持0.03-0.06mg/kg/hで開始.',
        doseLimit: '・成人ICU鎮静の導入: 追加投与を含め総量0.30mg/kgまで.',
    mechanism: 'ベンゾジアゼピン結合部位を介してGABA-A受容体機能を増強する.',
    packageInsertReviewed: true,
    packageInsertRevision: '2025年11月改訂 第2版',
    packageInsertUrl:
        'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/270428_1124401A1060_1_21',
    contraindications: [
      DrugContraindication('本剤成分に対する過敏症の既往', '再投与で重篤な過敏反応を起こすおそれがある.'),
      DrugContraindication('急性閉塞隅角緑内障', '抗コリン作用により眼圧が上昇し, 症状を悪化させることがある.'),
      DrugContraindication('重症筋無力症', '筋弛緩作用により症状を悪化させるおそれがある.'),
      DrugContraindication(
        '特定の強力なCYP3A阻害薬投与中',
        'HIVプロテアーゼ阻害薬, コビシスタット含有薬, ニルマトレルビル・リトナビル等により作用が著しく増強・遷延するおそれがある.',
      ),
      DrugContraindication(
        'ショック, 昏睡, バイタル抑制を伴う急性アルコール中毒',
        '呼吸抑制や血圧低下を増悪させるおそれがある.',
      ),
    ],
    cautiousUse: [
      '高度重症・呼吸予備力低下',
      '衰弱患者',
      '脳器質的障害',
      '重症心不全などの心疾患',
      '重症の水分・電解質障害',
      '大量出血・大量輸液後',
      'アルコール・薬物乱用歴',
      '睡眠時無呼吸・上気道閉塞リスク',
      '腎・肝機能障害',
      '妊婦・授乳婦',
      '小児・高齢者',
    ],
    notes: [
      DrugNote(
        '呼吸・循環管理',
        '無呼吸, 呼吸抑制, 舌根沈下, 血圧低下を起こしうる. 酸素, 吸引, 気道確保・人工呼吸器具, 昇圧薬を準備し, 完全回復まで管理する. ICU持続投与中は気管挿管による気道確保が必要.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '持続投与の希釈例',
        '6A + 5%ブドウ糖18mLで2mg/mL, 1A + 生理食塩液8mLで1mg/mLなどの院内希釈例がある. 標準希釈ではないため, ポンプ設定を含め院内手順を確認する.',
        type: DrugNoteType.facilityPractice,
      ),
      DrugNote(
        '一般的な処置時鎮静',
        '電子添文で承認されている処置時鎮静は歯科・口腔外科領域である. それ以外のPSAは適応外となるため, 鎮静担当者, 気道管理, モニタリング, 追加間隔を院内手順で定める.',
        type: DrugNoteType.offLabel,
      ),
      DrugNote(
        '覚醒遅延時',
        '残存鎮静だけでなく, 低体温, 代謝異常, 残存筋弛緩, 高CO2血症, 脳血管障害, 非痙攣性てんかん重積などを並行評価する. フルマゼニルへの反応だけで神経疾患を除外しない.',
      ),
      DrugNote('奇異反応・依存', '脱抑制, 興奮, せん妄などの奇異反応が起こりうる. 長期・高用量使用では依存や離脱に注意する.'),
    ],
  ),
  Drug(
    name: 'レミマゾラム (RMZ)',
    brand: 'アネレム',
    category: DrugCategory.sedative,
    spec: '20mg/V, 50mg/V',
    dilution: '通常は生理食塩液で溶解. 乳酸リンゲル液は溶解液に使用不可',
    dose:
        '全身麻酔導入: 成人12mg/kg/hで意識消失まで持続注入し, 年齢・状態により減速.\n'
        '維持: 1mg/kg/hで開始し適宜調節 (上限2mg/kg/h). 覚醒徴候時は最大0.2mg/kg追加可.\n'
        '消化器内視鏡鎮静: 3mgを15秒以上かけて投与. 不十分なら2分以上空け1mgずつ追加.',
        doseLimit: '・全身麻酔維持の投与速度は2mg/kg/hまで.\n・覚醒徴候時の追加投与は1回0.2mg/kgまで.\n・消化器内視鏡鎮静の追加投与は2分以上空けて1mgずつ.',
    mechanism: 'ベンゾジアゼピン結合部位を介してGABA-A受容体機能を増強する超短時間作用型鎮静薬.',
    packageInsertReviewed: true,
    packageInsertRevision: '2025年11月改訂 第5版',
    packageInsertUrl:
        'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/770098_1119403F1024_1_04',
    contraindications: [
      DrugContraindication('本剤成分に対する過敏症の既往', '再投与で重篤な過敏反応を起こすおそれがある.'),
      DrugContraindication('急性閉塞隅角緑内障', '抗コリン作用により眼圧が上昇し, 症状を悪化させることがある.'),
      DrugContraindication('重症筋無力症', '筋弛緩作用により症状を悪化させることがある.'),
      DrugContraindication(
        'ショック, 昏睡, バイタル抑制を伴う急性アルコール中毒',
        '呼吸抑制と低血圧を増強させることがある.',
      ),
    ],
    cautiousUse: [
      'ASA III以上',
      '薬物依存の既往',
      '脳器質的障害',
      '上気道閉塞リスク',
      '重度肝機能障害 (Child-Pugh C)',
      '妊婦・授乳婦',
      '高齢者',
    ],
    notes: [
      DrugNote(
        '全身麻酔での基本',
        '導入はボーラスではなく, 12mg/kg/hで意識消失まで持続注入する. 鎮痛薬・筋弛緩薬を適宜併用し, 脳波やバイタルサインを含む全身状態をみながら手術に必要な最低限の麻酔深度に調節する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '呼吸・循環管理',
        '低血圧, 徐脈, 低酸素症, 呼吸抑制, 覚醒遅延が起こりうる. 気道確保, 酸素投与, 人工呼吸, 循環管理を行える状態で使用し, 必要時に備えてフルマゼニルを準備する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '院内希釈例',
        '50mgを生理食塩液で50mLとして1mg/mLで使用する施設がある. 製剤・シリンジ・ポンプ設定を含む院内手順を優先する.',
        type: DrugNoteType.facilityPractice,
      ),
      DrugNote(
        'ASA III以上での減速',
        '6mg/kg/hから導入する施設運用があるが, 現行電子添文は固定速度を指定せず, 年齢・状態に応じた減速と減量を求めている.',
        type: DrugNoteType.facilityPractice,
      ),
      DrugNote(
        'BIS・低心機能症例',
        'BISの固定目標55-65や, 特定の左室駆出率を根拠にした選択は電子添文記載ではない. ベンゾジアゼピン系では脳波指標の解釈がプロポフォールと異なる可能性があり, 文献・患者背景・施設手順に基づき判断する.',
        type: DrugNoteType.literature,
      ),
    ],
  ),
  Drug(
    name: 'デクスメデトミジン',
    brand: 'プレセデックス',
    category: DrugCategory.sedative,
    spec: '200mcg/2mL/V, 200mcg/50mLシリンジ',
    dilution: '200mcg/2mLを生理食塩液48mLで希釈',
    concentration: '4mcg/mL',
    dose:
        '成人ICU・成人非挿管鎮静: 6mcg/kg/hで10分負荷 (総量1mcg/kg)後, 0.2-0.7mcg/kg/h. 維持から開始も可.\n'
        '小児ICU: 0.2mcg/kg/hで開始し, 6歳以上0.2-1.0, 6歳未満0.2-1.4mcg/kg/h.\n'
        '小児非侵襲的処置: 2歳以上12mcg/kg/h, 1か月-2歳未満9mcg/kg/hを10分負荷後, 1.5mcg/kg/h.',
        doseLimit: '・成人ICU・非挿管鎮静の維持投与は0.7mcg/kg/hまで.\n・小児ICU鎮静: 6歳以上は1.0mcg/kg/h, 6歳未満は1.4mcg/kg/hまで.\n・急速静注は行わず, 負荷投与は10分かけて行う.',
    mechanism: '中枢性α2アドレナリン受容体を介して鎮静・鎮痛補助作用を示す.',
    packageInsertReviewed: true,
    packageInsertRevision: '2023年2月改訂',
    packageInsertUrl:
        'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/672212_1129400A1054_2_02',
    contraindications: [
      DrugContraindication('本剤成分に対する過敏症の既往', '再投与で重篤な過敏反応を起こすおそれがある.'),
    ],
    cautiousUse: [
      '心血管系障害・高度心ブロック',
      '心機能低下',
      '循環血液量低下',
      '血液浄化中',
      '薬物依存・薬物過敏症の既往',
      '腎・肝機能障害',
      '妊婦・授乳婦',
      '低年齢小児',
      '高齢者',
    ],
    notes: [
      DrugNote(
        '循環管理',
        '低血圧, 高血圧, 徐脈, 洞停止, 心停止を起こしうる. 急速静注・単回急速投与は行わず, 緩徐な持続注入を厳守する. 心拍数低下は必発ではないが, 高度心ブロック, 低心機能, 循環血液量低下では特に注意する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '長期投与後の中止',
        '長期投与後の急な中止で神経過敏, 激越, 頭痛, 急激な血圧上昇などのリバウンド・離脱が起こりうるため徐々に減量する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '負荷を省略する運用',
        '循環変動を避ける目的で初期負荷を行わず, 他剤で安定後に0.2-0.4mcg/kg/h程度から開始する施設運用がある. 電子添文でも成人ICUでは維持投与から開始可能だが, 適応と患者状態を確認する.',
        type: DrugNoteType.facilityPractice,
      ),
      DrugNote(
        '小児の点鼻前投薬',
        '点鼻投与は承認された投与経路ではない. 実施する場合は適応外使用として院内手順, 投与量, 呼吸循環監視, 回復基準を定める.',
        type: DrugNoteType.offLabel,
      ),
      DrugNote(
        '術後せん妄・臓器保護',
        '術後せん妄や一部合併症を減らす可能性を示す研究はあるが, 効果は集団・用量・比較薬で異なり, 電子添文上の効能ではない. 徐脈・低血圧との利益衡量が必要.',
        type: DrugNoteType.literature,
      ),
    ],
  ),
  Drug(
    name: 'ケタミン',
    brand: 'ケタラール',
    category: DrugCategory.sedative,
    spec: '50mg/5mL/A, 200mg/20mL/V',
    dilution: '原液',
    concentration: '10mg/mL',
    dose:
        '初回1-2mg/kgを1分以上かけて静注. 必要時は初回量と同量または半量を追加.\n'
        '点滴維持例: 最初30分0.1mg/kg/min, 以後0.05mg/kg/minを基準とし, 手術終了30分前に中止.',
        doseLimit: '・静脈内投与は1分以上かけて行い, 急速投与は避ける.',
    mechanism: '主にNMDA受容体を非競合的に阻害し, 解離性麻酔と鎮痛を生じる.',
    packageInsertReviewed: true,
    packageInsertRevision: '2025年4月改訂 第2版',
    packageInsertUrl:
        'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/430574_1119400A1031_4_01',
    contraindications: [
      DrugContraindication('本剤成分に対する過敏症の既往', '再投与で重篤な過敏反応を起こすおそれがある.'),
      DrugContraindication(
        '脳血管障害, 高血圧 (160/100mmHg以上), 脳圧亢進, 重症心代償不全',
        '一過性の血圧上昇作用と脳圧亢進作用がある.',
      ),
      DrugContraindication('痙攣発作の既往', '痙攣を誘発することがある.'),
      DrugContraindication('外来患者', '麻酔前後の十分な管理が行き届かない.'),
    ],
    cautiousUse: ['急性・慢性アルコール中毒', '妊婦・授乳婦', '高齢者'],
    notes: [
      DrugNote(
        '投与時の基本',
        '一般の全身麻酔と同様に, 完全覚醒まで専任医師が全身状態を監視し, 呼吸・循環管理を行える環境で使用する. 静注は1分以上かけ, 急速投与を避ける.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '循環・気道への影響',
        '交感神経活動を高め血圧・心拍数が上昇することが多い一方, カテコラミン枯渇状態では直接的な心筋抑制が前景化し低血圧となりうる. 気道分泌増加, 喉頭痙攣, 覚醒時反応にも注意する.',
      ),
      DrugNote(
        '鎮痛目的の低用量投与',
        '0.1-0.5mg/kgのボーラスや低用量持続投与は周術期鎮痛で用いられるが, 本邦電子添文の承認用法ではない. 院内の適応外使用手順と上級医判断に従う.',
        type: DrugNoteType.offLabel,
      ),
      DrugNote(
        '覚醒時反応',
        '悪夢, 幻覚, 興奮などが起こりうる. 予防・治療薬の選択は患者背景と施設手順に従い, routineな併用を固定化しない.',
      ),
    ],
  ),
  Drug(
    name: 'フルマゼニル',
    brand: 'アネキセート / フルマゼニル',
    category: DrugCategory.sedative,
    spec: '0.5mg/5mL/A',
    dilution: '原液',
    concentration: '0.1mg/mL',
    dose:
        '初回0.2mgを緩徐静注. 4分以内に不十分なら0.1mg追加し, 以後1分間隔で0.1mgずつ追加. 総量は通常1mgまで, ICU領域では2mgまで.',
        doseLimit: '・総投与量は通常1mgまで, ICU領域では2mgまで.\n・追加投与は1分間隔で0.1mgずつ.',
    mechanism: 'ベンゾジアゼピン受容体に競合的に結合し, ベンゾジアゼピン系薬剤の作用を拮抗する.',
    packageInsertReviewed: true,
    packageInsertRevision: '2024年1月改訂 第1版',
    packageInsertUrl:
        'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/670109_2219403A1035_1_06',
    contraindications: [
      DrugContraindication(
        '本剤またはベンゾジアゼピン系薬剤に対する過敏症の既往',
        '再投与で重篤な過敏反応を起こすおそれがある.',
      ),
      DrugContraindication(
        '長期間ベンゾジアゼピン系薬剤を投与されているてんかん患者',
        '急な拮抗により痙攣を生じることがある.',
      ),
    ],
    cautiousUse: [
      'ベンゾジアゼピン長期・高用量使用',
      '不安が強い患者・冠動脈疾患',
      'ICU領域の高血圧',
      '重症頭部外傷・不安定な頭蓋内圧',
      '三環系・四環系抗うつ薬併用',
      '肝機能障害',
      '妊婦・授乳婦',
      '小児・高齢者',
    ],
    notes: [
      DrugNote(
        '再鎮静',
        'フルマゼニルの半減期は約50分で, 原因となったベンゾジアゼピン系薬剤より短い場合がある. 覚醒後も再鎮静・呼吸抑制を監視する. 手術終了時は筋弛緩薬の作用消失後に投与する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '離脱・痙攣リスク',
        '長期・高用量ベンゾジアゼピン使用患者では急速な拮抗により不安, 興奮, 振戦, せん妄, 痙攣などの急性離脱を誘発しうる. 急速投与を避け少量ずつ緩徐投与し, 離脱時はベンゾジアゼピンの緩徐静注などを行う.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '混合中毒',
        '三環系・四環系抗うつ薬との混合中毒では, ベンゾジアゼピンの抗痙攣作用を解除して抗うつ薬中毒症状を顕在化させることがある. 投与前に服薬歴, 心電図, 痙攣リスクを評価する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '診断目的に使わない',
        '意識障害の原因診断をフルマゼニルへの反応だけで行わない. 用法用量内で改善しない場合はベンゾジアゼピン以外の原因を考慮する.',
        type: DrugNoteType.packageInsert,
      ),
    ],
  ),
];
