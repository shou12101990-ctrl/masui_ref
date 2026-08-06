import '../../models/drug.dart';

/// 薬剤データ: 鎮痛薬. (lib/data/drugs.dart から分割)
const List<Drug> kAnalgesicDrugs = [
  Drug(
    name: 'フェンタニル',
    brand: 'フェンタニル注射液',
    category: DrugCategory.analgesic,
    spec: '0.1mg/2mL/A, 0.25mg/5mL/A',
    dilution: '電子添文: ブドウ糖液等で希釈可. 施設運用例は下記参照.',
    concentration: '50mcg/mL',
    dose: '成人バランス麻酔: 導入1.5-8mcg/kg. 維持25-50mcg間欠又は0.5-5mcg/kg/h.',
    doseLimit: '・バランス麻酔維持: 間欠投与25-50mcgずつ, 持続0.5-5mcg/kg/hまで\n・術後疼痛の持続静注: 1-2mcg/kg/hまで\n・硬膜外: 単回100mcgまで又は持続100mcg/hまで\n・くも膜下: 単回25mcgまで',
    mechanism: 'μオピオイド受容体作動薬. 強力な鎮痛作用と用量依存性の呼吸抑制を示す.',
    packageInsertReviewed: true,
    packageInsertRevision: '2025年4月改訂 第4版',
    packageInsertUrl:
        'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/430574_8219400A1063_2_01',
    contraindications: [
      DrugContraindication(
        '筋弛緩薬の使用が禁忌の患者',
        '筋強直による換気困難が生じた場合に筋弛緩薬と人工呼吸が必要となり得るため.',
      ),
      DrugContraindication('本剤成分への過敏症歴', '再投与で重篤な過敏反応を起こすおそれがあるため.'),
      DrugContraindication('頭部外傷・脳腫瘍等による昏睡状態', '重篤な呼吸抑制を起こしやすいため.'),
      DrugContraindication('痙攣発作の既往', '麻酔導入中に痙攣を起こすことがあるため.'),
      DrugContraindication('喘息患者', '気管支収縮を起こすことがあるため.'),
      DrugContraindication(
        'ナルメフェン投与中又は中止後1週間以内',
        'μ受容体拮抗により鎮痛効果が減弱し, 離脱症状を起こすおそれがあるため.',
      ),
      DrugContraindication(
        '硬膜外・くも膜下投与: 注射部位周辺の炎症又は敗血症',
        '化膿性又は敗血症性髄膜炎を生じるおそれがあるため.',
      ),
      DrugContraindication(
        'くも膜下投与: 活動性の中枢神経系疾患又は脊髄・脊椎疾患',
        'くも膜下投与で病状が悪化するおそれがあるため.',
      ),
    ],
    cautiousUse: [
      '重症高血圧・心弁膜症等の心血管障害',
      '慢性肺疾患等の呼吸機能障害',
      '不整脈',
      'poor risk状態',
      '薬物依存の既往',
      '血液凝固障害又は抗凝固薬投与中での神経軸投与',
      '脊柱の著明な変形での神経軸投与',
      '肥満患者への静脈内投与',
      '腎機能障害',
      '肝機能障害',
      '妊婦・授乳婦',
      '低出生体重児・新生児・乳児',
      '高齢者',
      '中枢神経抑制薬又はセロトニン作用薬の併用',
    ],
    notes: [
      DrugNote(
        '成人全身麻酔',
        'バランス麻酔の導入は1.5-8mcg/kgを緩徐静注又は点滴静注. 維持は25-50mcgずつの間欠静注又は0.5-5mcg/kg/hの持続静注. 大量フェンタニル麻酔は別の承認用量があるため, 通常のバランス麻酔用量と混同しない.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '術後疼痛・神経軸投与',
        '術後疼痛の静脈内投与は1-2mcg/kgを緩徐静注後, 1-2mcg/kg/hで持続. 硬膜外は単回25-100mcg又は25-100mcg/h, くも膜下は単回5-25mcg. 投与経路を必ず確認する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '遅発性呼吸抑制',
        '硬膜外・くも膜下投与では, 投与から数時間以上経過後に重篤な呼吸抑制が発現することがある. 脂溶性が高いことを理由に監視を省略しない.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '希釈・院内プロトコル',
        '10mcg/mLや20mcg/mL等の希釈は施設ごとの運用である. 原液50mcg/mLとの取り違えを防ぐため, シリンジラベルとポンプ設定を二者で確認する.',
        type: DrugNoteType.facilityPractice,
      ),
      DrugNote(
        '研修医向け要点',
        '呼吸数だけでなく換気量・意識・SpO2を継続評価する. 急速又は高用量投与では胸壁・声門の筋強直による換気困難があり, 気道確保と人工呼吸の準備下で使用する.',
      ),
    ],
  ),
  Drug(
    name: 'レミフェンタニル',
    brand: 'アルチバ',
    category: DrugCategory.analgesic,
    spec: '2mg/V, 5mg/V',
    dilution: '生理食塩液又は5%ブドウ糖液で希釈. 施設例: 2mg/20mL, 5mg/50mL.',
    concentration: '施設例 100mcg/mL',
    dose: '成人: 導入0.5mcg/kg/min. 維持0.25mcg/kg/minで開始し, 最大2.0mcg/kg/min.',
    doseLimit: '・成人維持: 最大2.0mcg/kg/minまで\n・小児 (1歳以上)維持: 最大1.3mcg/kg/minまで\n・単回投与: 1.0mcg/kgを30-60秒かけて投与',
    mechanism: 'μオピオイド受容体作動薬. 血中・組織の非特異的エステラーゼで速やかに代謝される.',
    packageInsertReviewed: true,
    packageInsertRevision: '2024年6月改訂 第1版',
    packageInsertUrl:
        'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/800155_8219401D1021_1_12',
    contraindications: [
      DrugContraindication(
        '本剤成分又はフェンタニル系化合物への過敏症歴',
        '再投与で重篤な過敏反応を起こすおそれがあるため.',
      ),
      DrugContraindication(
        'ナルメフェン投与中又は中止後1週間以内',
        'μ受容体拮抗により鎮痛効果が減弱するおそれがあるため.',
      ),
    ],
    cautiousUse: [
      'ASA III・IV',
      '衰弱又は循環血液量減少',
      '重症高血圧・心弁膜症等の心血管障害',
      '不整脈',
      '慢性肺疾患等の呼吸機能障害',
      '薬物依存の既往',
      '痙攣発作の既往',
      '気管支喘息',
      '妊婦・授乳婦',
      '低出生体重児・新生児・乳児',
      '高齢者',
    ],
    notes: [
      DrugNote(
        '成人の承認用量',
        '他の全身麻酔薬を必ず併用する. 導入は0.5mcg/kg/min. DLT使用や挿管困難等で強い刺激が予想される場合は1.0mcg/kg/min. 必要時は開始前に1.0mcg/kgを30-60秒かけて単回投与できる. 維持は0.25mcg/kg/minで開始し, 2-5分間隔で調節, 最大2.0mcg/kg/min.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '小児の承認用量',
        '1歳以上では他の全身麻酔薬を併用し, 維持0.25mcg/kg/minで開始. 2-5分間隔で調節し, 最大1.3mcg/kg/min. 低出生体重児・新生児・乳児の臨床試験はない.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '投与経路の警告',
        '添加物としてグリシンを含むため, 硬膜外及びくも膜下へ絶対に投与しない. 単回静注は30秒以上かけ, 急速投与による筋硬直・徐脈・低血圧に備える.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '施設運用例',
        '2mg/20mL又は5mg/50mLの100mcg/mL希釈, 術中0.1-0.3mcg/kg/min前後からの調節は院内運用例であり, 電子添文の開始用量そのものではない. 肥満成人では標準体重を用いることを検討する.',
        type: DrugNoteType.facilityPractice,
      ),
      DrugNote(
        '産科鎮痛',
        '無痛分娩等の鎮痛目的投与は本邦電子添文の承認効能ではない. 母体の呼吸管理と連続胎児監視を含む専門施設のプロトコルなしに実施しない.',
        type: DrugNoteType.offLabel,
      ),
      DrugNote(
        '終了前の鎮痛移行',
        '投与終了後に作用が速やかに減弱するため, 手術終了前に術後鎮痛薬の効果発現時間を見込んで移行計画を立てる.',
      ),
    ],
  ),
  Drug(
    name: 'モルヒネ',
    brand: 'モルヒネ塩酸塩注射液',
    category: DrugCategory.analgesic,
    spec: '10mg/1mL/A, 50mg/5mL/A',
    concentration: '10mg/mL',
    dose: '成人: 皮下5-10mg. 硬膜外2-6mg又は2-10mg/day. くも膜下0.1-0.5mg単回.',
    doseLimit: '・硬膜外: 単回2-6mgまで, 持続で1日10mgまで\n・くも膜下: 単回0.5mgまで, 原則として追加・持続投与は行わない',
    mechanism: '主にμオピオイド受容体を介して鎮痛・鎮静・呼吸抑制を示す強オピオイド.',
    packageInsertReviewed: true,
    packageInsertRevision: '2025年4月改訂 第4版',
    packageInsertUrl:
        'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/430574_8114401A1120_2_01',
    contraindications: [
      DrugContraindication('重篤な呼吸抑制', '呼吸抑制をさらに増強するため.'),
      DrugContraindication('気管支喘息発作中', '気道分泌を妨げ, 発作を悪化させるおそれがあるため.'),
      DrugContraindication('重篤な肝機能障害', '作用が増強・遷延し, 安全な用量調節が困難となるため.'),
      DrugContraindication('慢性肺疾患に続発する心不全', '呼吸抑制及び循環不全を増強するため.'),
      DrugContraindication('痙攣状態', '脊髄刺激作用があらわれるおそれがあるため.'),
      DrugContraindication('急性アルコール中毒', '呼吸抑制を増強するため.'),
      DrugContraindication('本剤成分又はアヘンアルカロイドへの過敏症', '重篤な過敏反応を起こすおそれがあるため.'),
      DrugContraindication('出血性大腸炎', '症状悪化及び治療期間延長のおそれがあるため.'),
      DrugContraindication(
        'ナルメフェン投与中又は中止後1週間以内',
        'μ受容体拮抗により効果減弱又は離脱症状を起こすおそれがあるため.',
      ),
      DrugContraindication(
        '硬膜外・くも膜下投与: 注射部位周辺の炎症又は敗血症',
        '化膿性又は敗血症性髄膜炎を生じるおそれがあるため.',
      ),
      DrugContraindication(
        'くも膜下投与: 活動性の中枢神経系疾患又は脊髄・脊椎疾患',
        'くも膜下投与で病状が悪化するおそれがあるため.',
      ),
    ],
    cautiousUse: [
      '心機能障害',
      '呼吸機能障害',
      '脳器質的障害・頭蓋内圧亢進',
      'ショック状態',
      '薬物依存の既往',
      '胆道疾患',
      '腎機能障害',
      '肝機能障害',
      '妊婦・授乳婦',
      '新生児・乳児',
      '高齢者',
      '血液凝固障害又は抗凝固薬投与中での神経軸投与',
    ],
    notes: [
      DrugNote(
        '承認用量',
        '成人は通常1回5-10mgを皮下注し, 麻酔補助では静脈内投与も可能. 癌疼痛の持続静注・皮下注は50-200mgを投与し症状で調節. 硬膜外は単回2-6mg又は2-10mg/day, くも膜下は0.1-0.5mg単回.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '神経軸投与の安全条件',
        '硬膜外・くも膜下投与は習熟した医師のみが実施する. くも膜下では原則として追加・持続投与を行わない. 投与経路・製剤濃度を確認し, 蘇生設備と呼吸監視を確保する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '遅発性呼吸抑制',
        '硬膜外・くも膜下投与では数時間以上経過してから重篤な呼吸抑制が発現し得る. 初回投与後の監視計画を事前に決め, 鎮静度・呼吸数・換気・酸素化を継続評価する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '施設・文献用量',
        'くも膜下100-150mcgを用いる運用があるが, 電子添文の承認範囲0.1-0.5mgの中の施設・文献用量である. 上級医の指示と院内監視基準に従う.',
        type: DrugNoteType.facilityPractice,
      ),
      DrugNote(
        '研修医向け要点',
        '腎機能低下では活性代謝物を含む作用遷延に注意する. 神経軸投与時は静注用量との単純な力価換算をせず, 投与経路・濃度・小数点を声出し確認する.',
      ),
    ],
  ),
  Drug(
    name: 'ペンタゾシン',
    brand: 'ソセゴン',
    category: DrugCategory.analgesic,
    spec: '15mg/1mL/A',
    concentration: '15mg/mL',
    dose: '鎮痛: 成人15mg IM/SC, 必要時3-4時間毎. 麻酔前投薬・補助: 30-60mg IM/SC/IV.',
    doseLimit: '・鎮痛: 1回15mg, 3-4時間毎に反復\n・麻酔前投薬・麻酔補助: 1回60mgまで',
    mechanism: '主にκオピオイド受容体作動作用を示し, μ受容体には部分作動・拮抗的に働く.',
    packageInsertReviewed: true,
    packageInsertRevision: '2024年3月改訂 第1版',
    packageInsertUrl:
        'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/730119_1149401A1027_2_05',
    contraindications: [
      DrugContraindication('本剤成分への過敏症歴', '重篤な過敏反応を起こすおそれがあるため.'),
      DrugContraindication('頭部傷害又は頭蓋内圧亢進', '頭蓋内圧をさらに上昇させることがあるため.'),
      DrugContraindication('重篤な呼吸抑制又は全身状態の著しい悪化', '呼吸抑制を増強することがあるため.'),
      DrugContraindication(
        'ナルメフェン投与中又は中止後1週間以内',
        'オピオイド離脱症状又はその悪化を起こすおそれがあるため.',
      ),
    ],
    cautiousUse: [
      '薬物依存の既往',
      'オピオイド依存',
      '胆道疾患',
      '心筋梗塞',
      '肝機能障害',
      '妊婦・授乳婦',
      '小児',
      '高齢者',
      'モルヒネ製剤又は中枢神経抑制薬の併用',
    ],
    notes: [
      DrugNote(
        '承認用量',
        '鎮痛は成人1回15mgを筋注又は皮下注し, 必要に応じ3-4時間毎に反復. 麻酔前投薬及び麻酔補助は30-60mgを筋注, 皮下注又は静注する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '小児への注意',
        '小児等には投与しないことが望ましい. 小児を対象とした臨床試験はない. 旧マスタの0.5mg/kgを承認用量として使用しない.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'オピオイド依存・併用',
        '軽度のμ拮抗作用により, オピオイド依存患者では禁断症状を起こすことがある. 高用量ではモルヒネの作用に拮抗し得るため, 原則としてモルヒネとの併用を避ける.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '院内での少量静注',
        '5mgずつの静注タイトレーションやGOSと組み合わせた導入手順は施設運用であり, 電子添文の定型用量ではない. 研修医が独自に実施せず, 上級医の指示と院内手順に従う.',
        type: DrugNoteType.facilityPractice,
      ),
    ],
  ),

  Drug(
    name: 'トラマドール',
    brand: 'トラマール / ワントラム / トラムセット',
    category: DrugCategory.analgesic,
    spec:
        '注 100mg/2ml/A. 内服: トラマール(OD)25/50mg・ワントラム100mg(徐放)・トラムセット配合錠(トラマドール37.5mg+アセトアミノフェン325mg)',
    dose:
        '注 100-150mgを筋注 or 緩徐に静注 (1日400mgまで). 内服 1回25-100mgを1日4回 (高齢者300mg・最大400mg)',
        doseLimit: '・注射: 1回100-150mg, 4-5時間毎に反復\n・内服 (トラマール): 1回100mgまで, 4-6時間ごとに1日4回まで (1日400mgまで, 高齢者は1日300mgを目安)\n・ワントラム (徐放): 1日1回, 1日400mgまで\n・トラムセット: 1回2錠まで, 4時間以上あけて, 1日8錠まで',
    mechanism:
        'μオピオイド受容体への弱い作動＋セロトニン/ノルアドレナリン再取り込み阻害 (下行性疼痛抑制系の賦活)の二重機序. 活性代謝物M1 (CYP2D6で生成)がμ作用の主体. 非麻薬性 (麻薬指定なし)',
    notes: [
      DrugNote(
        '適応疾患',
        '・非オピオイド鎮痛薬で効果不十分な慢性疼痛: 変形性関節症・腰痛症などの慢性運動器痛, 帯状疱疹後神経痛・糖尿病性神経障害など神経障害性疼痛. \n'
            '・癌性疼痛 (WHO方式 Step 2 の弱オピオイド). \n'
            '・術後疼痛 (注射), 抜歯後の疼痛 (トラムセット). ',
      ),
      DrugNote(
        'どんな患者に使うか',
        '・NSAIDs/アセトアミノフェンでは不十分だが, 強オピオイド (モルヒネ等)までは要さない/避けたい「中等度」の痛みの患者. \n'
            '・NSAIDsが使いにくい患者 (腎機能低下・消化性潰瘍・抗凝固中など)で, 非麻薬性に鎮痛を上乗せしたいとき. \n'
            '・神経障害性疼痛の要素を伴う慢性痛 (SNRI様作用が有利). \n'
            '・麻薬処方の管理や抵抗感が障壁となる外来/在宅で扱いやすい (非麻薬). 癌性疼痛のStep 2導入にも. ',
      ),
      DrugNote(
        '用量',
        '注: 100-150mgを筋注または生食希釈で緩徐に静注. 1日400mgまで. \n'
            '内服: 25mgから開始し1回25-100mgを1日4回 (高齢者は1日300mg, 最大400mg). ワントラムは100mg 1日1回 (徐放, 最大400mg). トラムセットは1回1-2錠を1日4回 (最大8錠). 悪心予防に低用量から漸増する. ',
      ),
      DrugNote(
        '薬物動態 / 力価',
        '経口モルヒネ換算は約1/5 (弱オピオイド). CYP2D6で活性代謝物M1へ代謝され鎮痛を発揮するため, PM (poor metabolizer)では効きにくく, UM (ultra-rapid)では過量様作用に注意. ',
      ),
      DrugNote(
        '副作用・注意',
        '・セロトニン症候群: SSRI/SNRI/三環系/トリプタン併用でリスク. MAO阻害薬併用は禁忌. \n'
            '・痙攣閾値を下げる: てんかん/痙攣既往・併用薬・過量で痙攣リスク. \n'
            '・悪心・嘔吐 (開始時に多い→漸増・制吐薬で軽減)・便秘・眠気・めまい. \n'
            '・呼吸抑制は強オピオイドより弱いが, 過量・腎障害・CYP2D6 UMで起こりうる (特に小児). 12歳未満は推奨されない. \n'
            '・長期使用で身体依存・離脱 (オピオイド離脱＋自律神経症状). 腎/肝障害・高齢者は減量・投与間隔の延長を. ',
      ),
    ],
  ),
  Drug(
    name: 'ドロペリドール',
    brand: 'ドロレプタン',
    category: DrugCategory.antiemetic,
    spec: '25mg/10ml',
    dilution: '原液',
    concentration: '2.5mg/ml',
    dose: '制吐 0.625-2.5mg iv (2.5mgを超えない)',
    doseLimit: '・制吐: 1回0.625-2.5mg, 2.5mgを超えない (添文外)',
    mechanism: '最後野のCTZでドパミンD2受容体を拮抗して制吐 (ブチロフェノン系)',
    notes: [
      DrugNote(
        '用量',
        '制吐: 0.625-2.5mg iv(2.5mgを超えない). NLA麻酔時: フェンタニル4mcg/kgと併用し0.25-0.50mg/kg. ',
      ),
      DrugNote('薬物動態', '半減期2h, 作用発現 3-10min. 鎮静は2-4h, 軽度意識変容状態は12h程度持続. '),
      DrugNote(
        '一般的性質 / 副作用',
        '・フェンタニル使用時の制吐目的で併用. 小児は錐体外路症状が出やすく使用を控える/減量. \n・QT延長作用→QT延長患者やPD患者には禁忌. ',
      ),
    ],
  ),
  Drug(
    name: 'アセトアミノフェン',
    brand: 'アセリオ',
    category: DrugCategory.analgesic,
    spec: '1000mg/100ml (バッグ製剤)',
    dose: '成人 300-1000mgを15minでiv, 4hおき, 最大4000mg/day',
    doseLimit: '・成人 (50kg以上): 1回1000mgまで, 4-6時間以上あけて, 1日4000mgまで\n・成人 (50kg未満)・小児 (2歳以上): 15mg/kg/回まで, 4-6時間以上あけて, 1日60mg/kgまで\n・小児 (2歳未満): 7.5mg/kg/回, 4-6時間以上あけて, 1日30mg/kgまで\n・投与時間: 15分かけて点滴',
    mechanism: '視床・大脳皮質の痛覚閾値を高めることによる鎮痛と推定',
    notes: [
      DrugNote(
        '用量',
        '成人疼痛: 300-1000mgを15minでiv, 4hおき, 最大4000mg/day. 50kg未満は15mg/kg/回・最大60mg/kg/day. \n2歳以上: 10-15mg/kg 4hおき・最大60mg/kg/day. 2歳未満: 7.5mg/kg 4hおき・最大30mg/kg. ',
      ),
      DrugNote(
        '薬物動態 / 相互作用',
        '半減期2.5h. シクロオキシゲナーゼ阻害作用は殆ど無い. アルコール多量常飲者は肝不全に, ワーファリン併用は出血傾向助長のため減量. ',
      ),
    ],
  ),
  Drug(
    name: 'フルルビプロフェン',
    brand: 'ロピオン',
    category: DrugCategory.analgesic,
    spec: '50mg/5ml/A',
    dilution: '原液もしくはNS100ml',
    dose: '成人 50mg/回を1分以上かけて緩徐にiv (経口不可/効果不十分時)',
    mechanism: 'PG合成阻害による鎮痛 (NSAIDs)',
    notes: [
      DrugNote(
        '薬物動態 / 性質',
        '半減期6h. ペンタゾシンと比べ鎮痛同等・持続は長い. COX-1は恒常発現(腎RBF維持・胃保護), COX-2は炎症で誘導. ワルファリンと置換反応(毒性誘発). ',
      ),
      DrugNote(
        '禁忌',
        '・消化性潰瘍, 重篤な血液異常. \n・重篤な腎障害: PG合成阻害で腎血流が低下. \n・重篤な心機能不全・高血圧症: 水Na貯留で増悪. \n・重篤な肝障害. \n・アスピリン喘息(NSAIDs喘息)の既往: 発作を誘発. \n・妊娠後期: 動脈管収縮のおそれ. \n・ニューキノロン系(エノキサシン等)併用: 痙攣誘発. \n・本剤過敏症. ',
      ),
      DrugNote(
        '炎症性腸疾患 (UC / クローン病)',
        'ロピオンでは禁忌ではなく9.1 (特定の背景を有する患者)扱い. 9.1.8 潰瘍性大腸炎・9.1.9 クローン病はいずれも「他の非ステロイド性消炎鎮痛剤で症状が悪化したとの報告がある」. \n'
            'NSAIDs全体でも, 国内添文でUCを禁忌としている薬剤はない. ボルタレンも9.1.9 / 9.1.10で同様の記載, セレコックスは炎症性腸疾患の記載自体がない. \n'
            '最もUCに近い禁忌はメフェナム酸 (ポンタール)の「過去に本剤により下痢を起こした患者」で, 9.1でも「潰瘍性大腸炎: 病態を悪化させることがある」と他剤より強い表現. IBD患者ではNSAIDs常用を避け, 必要時は短期頓用にとどめアセトアミノフェンを優先する. ',
        type: DrugNoteType.packageInsert,
      ),
    ],
  ),
  Drug(
    name: 'ジクロフェナク',
    brand: 'ボルタレン',
    category: DrugCategory.analgesic,
    spec: '錠25mg / 坐剤 (サポ) 12.5・25・50mg',
    dose: '内服 1日75-100mgを3回分割, 頓用は1回25-50mg. 坐剤は成人1回25-50mgを1日1-2回直腸内挿入 (小児 0.5-1.0mg/kgを1日1-2回)',
    doseLimit: '・内服: 1日75-100mgを3回に分割 (頓用: 1回25-50mg, 1日2回, 100mgまで)\n・坐剤: 1回25-50mgを1日1-2回まで\n・坐剤 (小児): 0.5-1.0mg/kgを1日1-2回まで',
    forms: DrugFormAvailability(
      hasInjection: false,
      hasOral: true,
      summary: '内服 (錠・SRカプセル)と坐剤. 国内に静注剤はない',
    ),
    mechanism: 'COX阻害によるPG合成抑制 (酸性NSAIDs). 抗炎症・解熱・鎮痛',
    packageInsertReviewed: true,
    packageInsertRevision: '2024年10月改訂 第2版 (ボルタレンサポ)',
    contraindications: [
      DrugContraindication('消化性潰瘍のある患者', 'PG合成阻害で粘膜防御が低下し, 潰瘍を悪化させるため.'),
      DrugContraindication('重篤な血液の異常', '血液障害を増悪させるおそれがあるため.'),
      DrugContraindication('重篤な肝障害', '肝障害を増悪させるおそれがあるため.'),
      DrugContraindication('重篤な腎障害', 'PG合成阻害で腎血流が低下し, 腎障害を増悪させるため.'),
      DrugContraindication('重篤な高血圧症', '水・Na貯留により血圧を上昇させるため.'),
      DrugContraindication('重篤な心機能不全', '水・Na貯留により心不全を増悪させるため.'),
      DrugContraindication('本剤成分への過敏症歴', '重篤な過敏反応を起こすおそれがあるため.'),
      DrugContraindication('アスピリン喘息 (NSAIDsによる喘息発作)又はその既往', '重篤な発作を誘発するため.'),
      DrugContraindication('インフルエンザの臨床経過中の脳炎・脳症', '致死的な経過をたどる例が報告されているため.'),
      DrugContraindication('妊婦又は妊娠している可能性のある女性', '胎児の動脈管収縮等を起こすおそれがあるため.'),
      DrugContraindication('トリアムテレン投与中', '急性腎不全を起こすおそれがあるため.'),
      DrugContraindication(
        '直腸炎, 直腸出血又は痔疾のある患者 (坐剤)',
        '坐剤の局所刺激で症状を悪化させるため. 坐剤に固有の禁忌 (2.8)で, 潰瘍性大腸炎そのものの禁忌ではない.',
      ),
    ],
    cautiousUse: [
      '潰瘍性大腸炎',
      'クローン病',
      '消化性潰瘍の既往歴',
      '気管支喘息',
      '血液の異常又はその既往歴',
      '出血傾向',
      '肝機能障害',
      '腎機能障害',
      '心機能障害・高血圧症',
      '感染症の合併 (症状が不顕性化しうる)',
      '高齢者',
    ],
    notes: [
      DrugNote(
        '炎症性腸疾患 (UC / クローン病)',
        '9.1.9 潰瘍性大腸炎・9.1.10 クローン病はいずれも「症状が悪化したとの報告がある」で, 禁忌ではなく特定の背景を有する患者. 一方, 坐剤では「直腸炎, 直腸出血又は痔疾」が禁忌 (2.8)なので, 直腸病変のあるUCで坐剤を選ぶ場面は特に注意する. ',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の使い方',
        '坐剤は経口不可の術後に使いやすいが, 血圧低下・腎血流低下を来しやすく, 脱水・出血後・高齢・腎障害では避ける. 抗血小板作用は可逆的だが周術期出血に配慮し, 硬膜外カテーテル管理中の併用は施設方針に従う. ',
        type: DrugNoteType.clinical,
      ),
    ],
  ),
  Drug(
    name: 'セレコキシブ',
    brand: 'セレコックス',
    category: DrugCategory.analgesic,
    spec: '錠100mg / 200mg',
    dose: '手術後・外傷後・抜歯後: 初回400mg, 以降1回200mgを1日2回 (6時間以上あける). 頓用は初回400mg, 以降200mgを6時間以上あけて1日2回まで',
    doseLimit: '・術後・外傷後・抜歯後: 初回400mg, 以降1回200mgを6時間以上あけて1日2回まで',
    forms: DrugFormAvailability(
      hasInjection: false,
      hasOral: true,
      summary: '内服のみ (錠100mg / 200mg)',
    ),
    mechanism: 'COX-2選択的阻害によるPG合成抑制. COX-1は温存され消化管粘膜防御・血小板機能への影響が少ない',
    packageInsertReviewed: true,
    packageInsertRevision: '2025年7月改訂 第6版',
    contraindications: [
      DrugContraindication('本剤成分又はスルホンアミドへの過敏症歴', '重篤な過敏反応を起こすおそれがあるため.'),
      DrugContraindication('アスピリン喘息又はその既往', '重篤な発作を誘発するため.'),
      DrugContraindication('消化性潰瘍のある患者', '潰瘍を悪化させるおそれがあるため.'),
      DrugContraindication('重篤な肝障害', '肝障害を増悪させるおそれがあるため.'),
      DrugContraindication('重篤な腎障害', 'PG合成阻害で腎血流が低下し, 腎障害を増悪させるため.'),
      DrugContraindication('重篤な心機能不全', '水・Na貯留により心不全を増悪させるため.'),
      DrugContraindication('冠動脈バイパス再建術 (CABG)の周術期', '心血管系の重篤な血栓塞栓性事象の発現が高まるため.'),
      DrugContraindication('妊娠末期の女性', '胎児の動脈管収縮を起こすおそれがあるため.'),
    ],
    cautiousUse: [
      '消化性潰瘍の既往歴',
      '気管支喘息',
      '心血管系疾患の既往歴・危険因子を有する患者',
      '血液の異常又はその既往歴',
      '肝機能障害',
      '腎機能障害',
      '高齢者',
    ],
    notes: [
      DrugNote(
        '炎症性腸疾患 (UC / クローン病)',
        '電子添文の禁忌にも9.1にも炎症性腸疾患の記載はない. COX-2選択性のため下部消化管障害は非選択的NSAIDsより少ないとされるが, 記載がないことは安全性の保証ではなく, 活動期IBDでは他のNSAIDs同様に慎重に判断する. ',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の位置づけ',
        '血小板機能を阻害しないため周術期出血の点では扱いやすい一方, CABG周術期は禁忌で, 心血管リスクの高い患者では長期・高用量を避ける. スルホンアミド過敏 (ST合剤等)の既往を必ず確認する. ',
        type: DrugNoteType.clinical,
      ),
    ],
  ),
  Drug(
    name: 'ナロキソン',
    brand: 'ナロキソン塩酸塩静注',
    category: DrugCategory.analgesic,
    spec: '0.2mg/1mL/A',
    concentration: '0.2mg/mL',
    dose: '成人0.2mg IV. 不十分なら2-3分間隔で0.2mgを1-2回追加.',
    doseLimit: '・追加投与: 2-3分間隔で0.2mgずつ, 1-2回まで追加',
    mechanism: 'オピオイド受容体拮抗薬. 麻薬による呼吸抑制及び覚醒遅延を改善する.',
    packageInsertReviewed: true,
    packageInsertRevision: '2021年12月改訂 第1版',
    packageInsertUrl:
        'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/530258_2219402A1049_1_01',
    contraindications: [
      DrugContraindication('本剤成分への過敏症歴', '重篤な過敏反応を起こすおそれがあるため.'),
      DrugContraindication(
        '非オピオイド性中枢神経抑制薬又は病的原因による呼吸抑制',
        'オピオイド拮抗薬である本剤は無効であり, 原因治療を遅らせるため.',
      ),
    ],
    cautiousUse: [
      '高血圧又は心疾患',
      'オピオイド依存又はその疑い',
      'オピオイド依存母体から出生した新生児',
      '妊婦・授乳婦',
      '小児',
      '高齢者',
    ],
    notes: [
      DrugNote(
        '承認用量',
        '成人1回0.2mgを静注. 効果不十分なら2-3分間隔で0.2mgを1-2回追加し, 状態に応じて調節する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '再呼吸抑制',
        '原因オピオイドの作用時間がナロキソンより長い場合, 一度改善しても呼吸抑制が再発する. 効果後も監視し, 必要に応じ反復投与する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '急性退薬・疼痛再燃',
        '過量では鎮痛が拮抗され疼痛が出現する. オピオイド依存患者や依存母体から出生した新生児では急性退薬症候を起こし得る. 血圧上昇, 頻脈, 肺水腫等にも注意する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '少量タイトレーション',
        '鎮痛を可能な範囲で温存する目的で0.04mgずつ静注する運用があるが, 電子添文の標準1回量は0.2mgである. 換気補助を優先し, 反応を見ながら上級医の指示で調節する.',
        type: DrugNoteType.facilityPractice,
      ),
    ],
  ),
];
