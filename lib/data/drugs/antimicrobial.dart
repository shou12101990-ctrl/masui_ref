import '../../models/drug.dart';

/// 抗菌薬・抗真菌薬・抗ウイルス薬. 周術期予防投与と重症感染で用いる.
/// Book3.xlsx のセルコメントを起点に, 各電子添文で裏取りして作成.
const List<Drug> kAntimicrobialDrugs = [
  Drug(
    name: 'ベンジルペニシリン (PCG)',
    brand: '注射用ペニシリンGカリウム',
    category: DrugCategory.antimicrobial,
    spec: '20万単位/V, 100万単位/V (用時溶解の粉末)',
    dilution: '筋注: 日局生理食塩液または注射用水に溶解. 点滴静注: 生理食塩液またはブドウ糖注射液に溶解',
    concentration: '用時溶解のため濃度は希釈量により可変. 100万単位はカリウムとして約59.8mg (1.53mEq) を含有',
    dose: '・一般感染症 (筋注): 1回30-60万単位を1日2-4回筋肉内注射\n'
        '・重症感染症 (化膿性髄膜炎・感染性心内膜炎): 1回400万単位を1日6回点滴静注 (1日2400万単位)\n'
        '・梅毒: 1回300-400万単位を1日6回点滴静注\n'
        '・年齢, 症状により適宜増減',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射 (筋注・静注・点滴静注) のみ. 国内に経口ペニシリンG製剤はない',
    ),
    emergencyDose: '劇症型溶血性レンサ球菌感染症 (壊死性筋膜炎・STSS) では大量療法として1回400万単位を4-6時間毎 (1日2400万単位前後) の点滴静注 + クリンダマイシン併用が用いられる (施設プロトコルに準拠)',
    spectrum: '溶血性レンサ球菌・肺炎球菌 (感受性株)・梅毒トレポネーマ・放線菌などに現在も第一選択となる狭域スペクトラム. ブドウ糖球菌の多くはβラクタマーゼ産生のため無効',
    renalAdjust: '高度腎障害では血中濃度が持続するため, 投与量を減じるか投与間隔をあける. 具体的な段階表は添付文書に明記なく, 他のβラクタム系に準じ腎機能に応じて調節する',
    periop: '感染症治療目的の投与は手術当日も中断せず継続する. 手術部位感染 (SSI) 予防の第一選択は通常セファゾリンであり, ペニシリンGはルーチンの周術期予防抗菌薬としては用いない. カリウム塩製剤 (100万単位あたりK 59.8mg, 1.53mEq) であり急速静注はカリウム性不整脈・心停止のリスクがあるため, 麻酔導入前後を含め必ず希釈して緩徐に投与する. ペニシリンアレルギーの既往がある場合は周術期抗菌薬をバンコマイシン・クリンダマイシン等へ変更する.',
    mechanism: '細胞壁合成酵素であるペニシリン結合蛋白 (PBP) に結合しトランスペプチダーゼ (架橋形成) を阻害し, 細菌を溶菌させる (殺菌的)',
    packageInsertReviewed: true,
    packageInsertRevision: '2023年6月 (第1版)',
    packageInsertUrl: 'https://pins.japic.or.jp/pdf/newPINS/00060242.pdf',
    notes: [
      DrugNote(
        '薬物動態',
        '腎排泄型で半減期は約0.5時間と短く, 頻回投与が必要. 正常髄膜では髄液移行は不良だが, 炎症時には移行が増加するため髄膜炎では大量投与が必要になる.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        '国内には経口ペニシリンG製剤はなく注射剤のみ. なお抗ブドウ球菌用ペニシリンであるナフシリン・オキサシリンは国内では未承認であり使用できない. MSSA感染症の治療には国内では主にセファゾリンが用いられる.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用・周術期の注意',
        'カリウム塩製剤のため急速静注でカリウム性不整脈・心停止のリスクがある. 必ず希釈し緩徐に投与する. アナフィラキシー, 痙攣 (腎障害・大量投与時), 溶血性貧血, 偽膜性大腸炎に注意.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '単位とグラム換算',
        'ベンジルペニシリンカリウムは力価 (単位) 表記が基本で, 概ね100万単位 ≒ 0.6g (力価) に相当する. 処方・換算時に単位とグラムを混同しないよう注意する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 新生児早発型敗血症のempiric',
        '新生児早発型敗血症(GBSなど)のempiric therapyとしてPCGとGMの併用, またはABPCとGMの併用が広く用いられる. NICEのガイドラインでは早発型原因菌の95-97%をカバーするとされる.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 細菌性髄膜炎での特異的治療',
        'ペニシリン感受性のN. meningitidis(PCG MIC 0.1未満)による細菌性髄膜炎の特異的治療はPCG 400万単位を4時間ごとに静注し7日間, ペニシリン感受性のS.pneumoniaeでも同様の考え方でPCGが使われる(MICが高ければCTRXやVCM併用に切替える).\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 脳膿瘍の経験的治療',
        '脳膿瘍の経験的治療ではPCG 300~400万単位を4時間ごとに静注し, MNZ 7.5mg/kgを6時間ごと(または15mg/kgを12時間ごと)で併用する処方が選択肢の一つとなる.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        'アナフィラキシー再発のリスク',
      ),
    ],
    cautiousUse: [
      'ペニシリン系・セフェム系薬剤への過敏症の既往歴',
      '気管支喘息などアレルギー素因のある患者',
      '高度腎障害患者 (中枢神経症状・カリウム蓄積のリスク)',
      '心疾患・電解質異常のある患者 (大量投与によるカリウム負荷)',
    ],
  ),
  Drug(
    name: 'アンピシリン水和物 (ABPC)',
    brand: 'ビクシリン',
    category: DrugCategory.antimicrobial,
    spec: '注射用0.25g/V, 0.5g/V, 1g/V, 2g/V. カプセル250mg',
    dilution: '筋注: 注射用水等に溶解. 静注: 生理食塩液またはブドウ糖注射液に溶解. 点滴静注: 輸液100-500mLに溶解し1-2時間かけて投与',
    concentration: '用時溶解のため濃度は希釈量により可変',
    dose: '・筋注: 1回250-1000mg (力価) を1日2-4回\n'
        '・静注: 1日1-2g (力価) を1-2回に分割\n'
        '・点滴静注: 1日1-4g (力価) を1-2回に分割し輸液100-500mLに溶解, 1-2時間かけて投与\n'
        '・小児: 1日100-200mg/kgを3-4回に分割 (上限400mg/kg/日)\n'
        '・敗血症・感染性心内膜炎・化膿性髄膜炎では通常量より大量を使用',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: true,
      summary: '注射 (筋注・静注・点滴静注) と内服 (カプセル・顆粒・ドライシロップ) の両方',
    ),
    emergencyDose: '感受性腸球菌による感染性心内膜炎: アンピシリン2gを4時間毎 (1日量として12g前後) 点滴静注しアミノグリコシド系と併用する治療が一般的 (施設プロトコル・ガイドラインに準拠)',
    spectrum: '腸球菌属・リステリア菌に対する第一選択薬. β-ラクタマーゼ非産生の大腸菌・インフルエンザ菌などグラム陰性桿菌にも有効だが, β-ラクタマーゼ産生菌には無効',
    renalAdjust: '高度腎障害では血中濃度が持続するため投与間隔を延長する (通常6-8時間毎を12-24時間毎へ延長するなど). 血液透析で除去されるため透析後の追加投与を考慮する',
    periop: '感染症治療中は手術当日も継続する. 腸球菌性心内膜炎に対する弁手術など外科的処置時もアンピシリンを継続しつつ実施する. 注射用アンピシリンナトリウムはNa負荷となるため, 大量投与時は心不全・腎不全患者で輸液・Na量を管理する.',
    mechanism: 'PBPに結合しトランスペプチダーゼを阻害して細胞壁合成を阻害する. ペニシリンGよりグラム陰性桿菌への浸透性が高く抗菌域が広い (アミノペニシリン)',
    packageInsertReviewed: true,
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00057343',
    notes: [
      DrugNote(
        '適応菌種',
        '腸球菌属 (Enterococcus faecalis 等) およびリステリア・モノサイトゲネスに対する第一選択薬. 髄膜炎・敗血症・新生児早期発症GBS感染症などでも中心的な役割を持つ.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '薬物動態',
        '腎排泄が主で半減期は約1時間. 一部胆汁排泄もある. 経口製剤 (カプセル・顆粒) と注射剤の双方が国内にあり, 内服では吸収率がアモキシシリンより低い.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        'アナフィラキシー, 皮疹 (伝染性単核症合併時は高頻度), 偽膜性大腸炎, 間質性腎炎, 無顆粒球症・溶血性貧血などの血液障害に注意.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '国内未承認薬の注意',
        '抗ブドウ球菌用ペニシリンであるナフシリン・オキサシリンは国内では未承認であり使用できない. MSSA治療は国内ではセファゾリン等が用いられる.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 感染性心内膜炎高リスク患者の抜歯',
        '人工弁置換術後・IE既往・複雑チアノーゼ性先天性心疾患などIE高リスク患者の抜歯では, ABPC静注 (または経口AMPC 2g) を手術前に単回投与する. 代替薬はCLDM, AZM, CAMの経口.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: Enterococcus感染CRBSIの第一選択',
        'Enterococcus faecalis(ABPC感受性)によるCRBSIのdefinitive therapy第一選択: ABPC 1回2g・1日4-6回点滴静注. ABPC耐性かつVCM感受性であればVCM(±GM)へ変更する.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 新生児UTIのempiric therapy',
        '新生児期の尿路感染症のempiric therapyの第一選択はABPC点滴静注+GM点滴静注の併用. Enterococcus属が疑われる場合はABPC 1回30~40mg/kgを1日3回・7~14日間投与するかVCMを併用する.\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 髄膜炎でのListeriaカバー',
        'Listeria monocytogenesによる髄膜炎ではABPC 2gを4時間ごとに静注するのが軸になる. ペニシリンアレルギー時はST合剤(トリメトプリムとして5mg/kg/日を6~8時間ごと)が代替となり, アミノグリコシド併用の有用性は結論が出ていない.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        'アナフィラキシー再発のリスク',
      ),
      DrugContraindication(
        '伝染性単核症の患者',
        '皮疹の発現頻度が著しく高くなることが知られているため',
      ),
    ],
    cautiousUse: [
      'ペニシリン系・セフェム系薬剤への過敏症の既往歴',
      'アレルギー素因のある患者',
      '経口摂取不良で全身状態の悪い患者',
      '腎障害患者',
    ],
  ),
  Drug(
    name: 'アモキシシリン (AMPC)',
    brand: 'サワシリン',
    category: DrugCategory.antimicrobial,
    spec: 'カプセル125mg・250mg, 錠250mg, 細粒10%',
    dose: '・一般感染症: 1回250mg (力価) を1日3-4回経口投与, 年齢・症状により適宜増減\n'
        '・小児: 1日20-40mg (力価) /kgを3-4回に分割経口投与 (上限90mg/kg/日)\n'
        '・H.ピロリ除菌: 1回750mg (力価) を1日2回, クラリスロマイシン・PPIと3剤併用で7日間投与',
    forms: DrugFormAvailability(
      hasInjection: false,
      hasOral: true,
      summary: '内服 (カプセル・錠・細粒) のみ. 国内に注射剤はない (静注が必要な場合はアンピシリン注射剤を用いる)',
    ),
    spectrum: 'アンピシリンに準じるが経口投与での血中濃度がより高く得られる. 溶連菌性咽頭炎・中耳炎・副鼻腔炎, H.ピロリ除菌などに繁用',
    renalAdjust: '腎機能低下例では投与間隔を延長する. 血液透析で除去されるため透析後に追加投与を検討する',
    periop: '経口薬のため, 絶飲食となる手術当日朝は内服できないことが多い. 治療継続の必要性が高い場合は注射用アンピシリンなど静注可能な薬剤への一時的な切替を検討する. H.ピロリ除菌など短期・待機的な投与は手術予定に応じて延期可能であれば延期する. 国内に注射剤はなく緊急時の静注はできない点に注意する.',
    mechanism: 'PBPに結合しトランスペプチダーゼを阻害する. アンピシリンと同一のアミノペニシリン系だが経口吸収率が高い (バイオアベイラビリティ約74-92% 対 アンピシリン約40%)',
    packageInsertReviewed: true,
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00059434',
    notes: [
      DrugNote(
        '一般的性質',
        '国内では経口剤 (カプセル・錠・細粒) のみが承認されており, 国内に注射剤はない. 静注可能なアミノペニシリンとしてはアンピシリンが用いられる.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '薬物動態',
        '経口吸収率が高く食事の影響を受けにくい. 半減期は約1時間でアンピシリンと同程度. 腎排泄型.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '下痢・軟便, 皮疹, 肝機能障害, まれにアナフィラキシー, 偽膜性大腸炎に注意.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        '絶飲食下では内服できないため, 治療の必要度に応じて代替の静注薬 (アンピシリン等) への切替を判断する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 歯科インプラント・抜歯での経口投与',
        '歯科インプラント埋入手術や下顎埋伏智歯抜歯ではAMPC経口250mg~1g (またはCVA/AMPC 375mg~1.5g) を手術1時間前に服用する. 骨削除など侵襲が大きい場合は術後投与 (単回~48時間) も考慮.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: IE高リスク患者の抜歯予防',
        'IE高リスク患者の抜歯予防にはAMPC経口2gを手術1時間前に単回服用する. 注射が使えない場合の経口代替として位置づけられる.\n[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 妊婦の無症候性細菌尿',
        '妊婦は胎児への影響を考慮しβ-ラクタム系を選択する. AMPC 経口500mgを1日3回・3~7日間が選択肢の一つで, 妊娠中はキノロン系, テトラサイクリン系, ST合剤(妊娠後期)を避ける.\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 泌尿器科処置前の細菌尿治療',
        '経尿道的処置など出血が予測される泌尿器科的処置の前は無症候性細菌尿のスクリーニングと治療を行う. 第二選択としてAMPC 経口500mgを1日3回・3日間投与する.\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        'アナフィラキシー再発のリスク',
      ),
      DrugContraindication(
        '伝染性単核症の患者',
        '皮疹の発現頻度が高くなるため',
      ),
    ],
    cautiousUse: [
      'ペニシリン系・セフェム系薬剤への過敏症の既往歴',
      'アレルギー素因のある患者',
      '腎障害患者',
    ],
  ),
  Drug(
    name: 'アンピシリンナトリウム・スルバクタムナトリウム (ABPC/SBT)',
    brand: 'ユナシン-S',
    category: DrugCategory.antimicrobial,
    spec: '静注用1.5g/V (SBT 0.5g・ABPC 1g), 静注用3g/V (SBT 1g・ABPC 2g), キット製剤あり',
    dilution: 'バイアル: 生理食塩液等に溶解. キット製剤: 隔壁を開通させ繰り返し押して完全に溶解させる',
    concentration: '用時溶解のため濃度は希釈量により可変',
    dose: '・肺炎・肺膿瘍・腹膜炎: 1日6g (力価) を2回に分けて静脈内注射または点滴静注\n'
        '・重症感染症: 1回3g (力価) を1日4回 (1日量12g) まで増量可\n'
        '・膀胱炎: 1日3g (力価) を2回に分割\n'
        '・小児: 1日60-150mg (力価) /kgを3-4回に分割',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射 (静注・点滴静注) のみ. 経口のスルタミシリン (ユナシン錠, 別成分のプロドラッグ) とは剤形・成分が異なる',
    ),
    spectrum: 'アンピシリンの抗菌域に加え, β-ラクタマーゼ産生ブドウ球菌 (MSSA) ・大腸菌・インフルエンザ菌・バクテロイデス属などをカバー. 緑膿菌には無効',
    renalAdjust: '腎機能に応じて投与間隔を調節する. CLcr 90-60: 6時間毎4回, CLcr 59-30: 6時間毎4回または8時間毎3回, CLcr 29-15: 12時間毎2回, CLcr 14-5: 24時間毎1回 (添付文書の投与間隔表に基づく)',
    periop: '治療目的の投与は手術当日も継続する. スルバクタム含有製剤はアシネトバクター属感染症の治療にも用いられ, 院内感染治療で周術期をまたいで継続されることが多い. ナトリウム負荷となるため, 大量投与時は心不全・腎不全患者や厳格なNa制限が必要な患者で輸液・電解質管理に注意する.',
    mechanism: 'アンピシリンにβラクタマーゼ阻害薬スルバクタムを配合し, β-ラクタマーゼ産生菌にも抗菌力を発揮する',
    packageInsertReviewed: true,
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00052370',
    notes: [
      DrugNote(
        '配合の意義',
        'スルバクタムはβラクタマーゼ阻害薬であり単独では抗菌活性は弱いが, アンピシリンと配合することでβ-ラクタマーゼ産生菌にも有効域を広げる.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '適応菌種',
        'MSSA, β-ラクタマーゼ産生大腸菌・インフルエンザ菌, バクテロイデス属を含む嫌気性菌など. 誤嚥性肺炎・腹腔内感染症の経験的治療に広く用いられる.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        'ショック・アナフィラキシー, 中毒性表皮壊死融解症, 無顆粒球症・血小板減少, 急性腎障害, 出血性・偽膜性大腸炎, 間質性肺炎に注意.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        'Na含有量が多く大量投与時は電解質・輸液バランスに留意する. 経口のスルタミシリン (プロドラッグ) とは異なる薬剤であり切替時は用量換算に注意する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 半減期・再投与・用量',
        '半減期0.8~1.3時間, 再投与間隔2~3時間 (腎機能正常) , eGFR-IND 20~50 mL/分で6時間, 20未満で12時間. 1回投与量1.5~3.0g, 80kg以上は3.0gを推奨する.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 呼吸器外科での位置づけ',
        '開胸肺切除でCEZと比較し術後肺炎・膿胸に有用な可能性があり, 気管支形成術など気道が胸腔内で開放される術式や肺全摘術ではSBT/ABPCを考慮する.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: PEG・上部消化管手術',
        '内視鏡的経皮胃瘻造設術 (PEG) のpull/push法では口腔内嫌気性菌をねらいSBT/ABPCを単回投与する. 胃全摘術 (膵合併切除) など消化管再建を伴う上部消化管手術でも第一選択となる.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: GBS陽性/不明の帝王切開',
        '腟周辺B群溶連菌保菌陽性または不明の帝王切開ではSBT/ABPCを単回投与する (β-ラクタムアレルギー時はCLDM+アミノグリコシド系薬) .\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: CDI発症リスク: β-ラクタマーゼ阻害薬配合ペニシリン',
        'β-ラクタマーゼ阻害薬配合ペニシリン系薬は院内発症CDIのリスク因子として報告されている (オッズ比1.54, 95%CI 1.05~2.24). 周術期の広域抗菌薬使用時はCDI発症の可能性を考慮する.\n'
          '[出典] CDI診療GL 2022',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: CEZ不可時やAcinetobacter感染で選択',
        'MSSA/メチシリン感受性CNSによるCRBSIでCEZが使えない場合の第二選択: SBT/ABPC 1回3g・1日4回点滴静注. 多剤耐性Acinetobacter属感染では1回3g・1日3-4回とし, 必要に応じMEPM+MINOへ変更する.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 長時間静注のPK/PD',
        'ABPC/SBTは9g(ABPC 6g+SBT 3g)を4時間以上かけて8時間ごとに投与する長時間静注が検討されている. 生食中の安定性は37度でABPC 77%, SBT 93%(24時間)であり, Acinetobacterによる人工呼吸器関連肺炎への高用量長時間静注が有効との報告がある.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 誤嚥性肺炎/肺膿瘍での位置づけ',
        '誤嚥性肺炎や肺膿瘍の入院治療の第一選択にSBT/ABPC 3gを1日3~4回投与するレジメンが挙げられ, 口腔内常在の嫌気性菌をカバーする.\n'
          '[出典] JAID/JSC 呼吸器感染症GL 2014',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: Acinetobacter baumanniiでの使いどころ',
        'SBT/ABPCはAcinetobacter baumanniiに感性であれば第一選択として使用できる(スルバクタム自体に抗菌活性がある). CVA/AMPCやTAZ/PIPCが同等の効果を持つかは十分に検証されていない.\n'
          '[出典] JAID/JSC 呼吸器感染症GL 2014',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 透析患者の難治性膀胱炎',
        '透析患者の難治性膀胱炎の治療薬の一つとして, SBT/ABPC点滴静注1.5gを1日1回投与し, 透析日は透析終了後に投与する用法が用いられる(初日ローディングドーズを設定するMEPMやCPRとは異なり通常維持量のみ).\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        'アナフィラキシー再発のリスク',
      ),
      DrugContraindication(
        '伝染性単核症の患者',
        '皮疹の発現頻度が高くなるため',
      ),
    ],
    cautiousUse: [
      'ペニシリン系・セフェム系薬剤への過敏症の既往歴',
      'アレルギー素因のある患者',
      'ナトリウム摂取制限が必要な患者',
      '心臓・循環器障害のある患者',
      '1歳以下の乳児, 高齢者, 腎機能障害患者',
    ],
  ),
  Drug(
    name: 'ピペラシリン・タゾバクタム (PIPC/TAZ)',
    brand: 'ゾシン',
    category: DrugCategory.antimicrobial,
    spec: '配合点滴静注用バッグ4.5g (TAZ 0.5g・PIPC 4g), 静注用バイアル2.25g・4.5gもあり',
    dilution: 'バッグ製剤: 下室の日局生理食塩液に溶解液部を押して隔壁を開通させ完全に溶解. バイアル製剤: 生理食塩液等に溶解し点滴静注',
    concentration: '用時溶解のため濃度は希釈量により可変',
    dose: '・一般感染症 (敗血症・肺炎・腹膜炎・腹腔内膿瘍・胆嚢炎・胆管炎等): 1回4.5g (力価) を1日3回点滴静注\n'
        '・肺炎で症状・病態に応じ1日4回 (4.5g q6h) まで増量可\n'
        '・小児: 1回112.5mg (力価) /kgを1日3回点滴静注 (1回量は成人の4.5gを超えない)\n'
        '・必要に応じ緩徐な静脈内注射も可',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射 (点滴静注, 必要に応じ緩徐に静脈内注射も可) のみ',
    ),
    emergencyDose: '敗血症性ショックのempiric治療として1回4.5gを6時間毎に点滴静注する高頻度投与が用いられることがある (施設プロトコルに準拠)',
    spectrum: '緑膿菌を含む広域グラム陰性桿菌, グラム陽性球菌, バクテロイデス属を含む嫌気性菌まで広くカバーする. MRSA・ESBL産生菌・カルバペネマーゼ産生菌には無効',
    renalAdjust: '腎機能障害患者では投与量を減量するか投与間隔を延長する. 高度腎障害では投与間隔をさらに延長する (詳細は添付文書のCcr別投与表を参照)',
    periop: '重症感染症・腹腔内感染症の広域治療薬として手術当日も継続することが多い. ピペラシリンはベクロニウムなど非脱分極性筋弛緩薬の作用を延長したとの報告があり, 術中は筋弛緩モニタリング (TOF) に留意する. Naおよび低カリウム血症のリスクがあるため大量・長期投与時は電解質を確認する.',
    mechanism: '広域ペニシリンのピペラシリンにβラクタマーゼ阻害薬タゾバクタムを配合し, β-ラクタマーゼ産生菌にも抗菌力を発揮する',
    packageInsertReviewed: true,
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00065172',
    notes: [
      DrugNote(
        '緑膿菌カバー',
        '緑膿菌に対する抗菌力を持つ数少ない広域ペニシリンで, 院内発症の重症感染症・発熱性好中球減少症のempiric治療で中心的に用いられる. 標準投与は1回4.5gを1日3回, 重症例や肺炎では1日4回 (4.5g q6h) へ増量する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '薬物動態',
        '半減期は約1時間で腎排泄が主. 高用量では延長持続点滴 (3-4時間かけた投与) が院内プロトコルとして用いられることがある.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        'ショック・アナフィラキシー, 劇症肝炎・肝機能障害, 急性腎障害, 間質性肺炎, 偽膜性大腸炎, 低カリウム血症 (約4%) に注意.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        'ベクロニウムなど筋弛緩薬の作用増強が報告されており, 術中は筋弛緩モニタリングを行う. 重症感染症治療中は手術当日も継続する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 消化管利用尿路変向術',
        '膀胱全摘+消化管利用尿路変向術はSSI発生率20~40%と高率. SBT/ABPCに対する大腸菌の耐性化も踏まえ, TAZ/PIPCによる1~2日間の予防投与が検討される.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 前立腺生検の高リスク例',
        '経直腸的前立腺生検の高リスク例 (前立腺体積75mL以上, 糖尿病, IPSS 20以上, Qmax 12mL/秒以下, 残尿100mL以上など) ではTAZ/PIPCを1日2回, 検査当日のみ投与する.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: CDI発症リスク: β-ラクタマーゼ阻害薬配合ペニシリン',
        'β-ラクタマーゼ阻害薬配合ペニシリン系薬は院内発症CDIのリスク因子として報告されている (オッズ比1.54, 95%CI 1.05~2.24). 周術期の広域抗菌薬使用時はCDI発症の可能性を考慮する.\n'
          '[出典] CDI診療GL 2022',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 敗血症empiricの抗緑膿菌薬第一選択',
        '市中発症, 院内発症敗血症のempiric therapyで抗緑膿菌活性を持つβ-ラクタム系薬の第一選択の一つ. TAZ/PIPC 1回4.5g・1日3-4回点滴静注とし, 敗血症を疑ったら1時間以内の投与開始が予後改善に重要である.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: VCM併用時のAKIリスク',
        'VCMとの併用で腎機能低下のリスクが高まるとの報告がある. 周術期にVCM (予防投与含む) とPIPC/TAZOを併用する際は腎機能を注意深くモニタリングする.\n'
          '[出典] MRSA感染症 診療GL 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 持続/延長静注のエビデンス',
        '観察研究のメタ解析では, カルバペネムまたはPIPC/TAZの長時間・持続静注による治療は間欠投与より死亡率を減少させたが, 有意な死亡率低下が確認されたのはPIPC/TAZのみでカルバペネムでは認められなかった.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 複雑性UTI/尿路性敗血症での位置づけ',
        '緑膿菌を含むグラム陰性桿菌をカバーし, 複雑性UTIの難治例や尿路性敗血症の第一選択に位置づけられる. 用量はTAZ/PIPC 4.5gを1日3回(重症例では2~3回)静注する.\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 胆道感染での位置づけ',
        '胆管炎/胆嚢炎の第一選択の一つ. E.coli分離株に高度耐性株が増えているためABPC/SBTは避けるべきとされ, PIPC/TAZやErtapenemが推奨される.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤またはペニシリン系抗生物質に対し過敏症の既往歴のある患者',
        'アナフィラキシー再発のリスク',
      ),
      DrugContraindication(
        '伝染性単核症の患者',
        '皮疹の発現頻度が高くなるため',
      ),
    ],
    cautiousUse: [
      'セフェム系抗生物質への過敏症の既往歴',
      'アレルギー素因のある患者',
      '腎機能障害患者',
      '肝機能障害患者',
      '経口摂取不良で全身状態の悪い患者',
    ],
  ),
  Drug(
    name: 'アズトレオナム (AZT)',
    brand: 'アザクタム',
    category: DrugCategory.antimicrobial,
    spec: '注射用0.5g/V, 1g/V',
    dilution: '筋注: 注射用水等に溶解. 静注: 注射用水等に溶解し緩徐に投与. 点滴静注: 輸液に溶解し投与',
    concentration: '用時溶解のため濃度は希釈量により可変',
    dose: '・一般感染症: 1日1-2g (力価) を2回に分けて静脈内注射, 点滴静注または筋肉内注射\n'
        '・淋菌感染症・子宮頸管炎: 1日1回1-2g (力価) を筋肉内注射または静脈内注射\n'
        '・小児: 1日40-80mg (力価) /kgを2-4回に分けて静脈内注射または点滴静注\n'
        '・難治性・重症感染症: 1日4g (力価) まで増量し2-4回に分割',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射 (静注・点滴静注・筋注) のみ',
    ),
    spectrum: '好気性グラム陰性桿菌 (緑膿菌を含む) に選択的に有効. グラム陽性菌・嫌気性菌には抗菌力を持たない',
    renalAdjust: '腎機能障害患者では血中濃度が持続し半減期が延長するため, 投与量を減じるか投与間隔をあける. Ccr低下に応じた減量が必要 (詳細は添付文書を参照)',
    periop: '側鎖構造がペニシリン系・セフェム系の多くと共通しないため交差アレルギーが少なく, ペニシリンアレルギーの既往がある患者で緑膿菌を含むグラム陰性桿菌カバーが必要な周術期・術後感染症治療に選択されることがある. ただしセフタジジムとはR1側鎖構造が同一のため交差反応の報告があり, セフタジジムアレルギーの既往がある患者への投与は避ける. 感染症治療中は手術当日も継続する.',
    mechanism: 'モノバクタム系 (単環β-ラクタム) 薬. グラム陰性菌のPBP3に選択的に結合し細胞壁合成を阻害する',
    packageInsertReviewed: true,
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00003050',
    notes: [
      DrugNote(
        '一般的性質・交差反応',
        'モノバクタム系は4員環β-ラクタムのみを持ちペニシリン・セフェム系との交差アレルギーが少なく, βラクタムアレルギー患者でも比較的安全に使用できる. ただしセフタジジムとはR1側鎖が同一構造のため交差アレルギーの報告があり注意する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '薬物動態',
        '腎排泄型で半減期は約1.5-2時間. 髄液移行は炎症時に良好で中枢神経系感染症にも使用される.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '適応',
        '緑膿菌を含むグラム陰性桿菌感染症, 淋菌感染症・子宮頸管炎など. グラム陽性菌・嫌気性菌カバーはなくempiric治療では他剤との併用が前提となる.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        'アナフィラキシー, 急性腎障害等の重篤な腎障害, 偽膜性大腸炎, 肝機能障害に注意し, 定期的な腎機能検査が推奨される.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 半減期・再投与間隔',
        '半減期1.6~1.8時間, 再投与間隔3~4時間 (腎機能正常) , eGFR-IND 20~50 mL/分で8~10時間, 20未満で12~16時間.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: β-ラクタムアレルギー時のグラム陰性菌カバー',
        'β-ラクタムアレルギーでグラム陰性菌カバーも必要な準清潔創 (消化器・心臓血管手術など) では, CLDMまたはVCMにアミノグリコシド系薬・キノロン系薬・AZTのいずれかを併用する.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: β-ラクタムアレルギー時の代替薬',
        'β-ラクタム系薬にアレルギーがある患者でグラム陰性桿菌をカバーする代替薬(モノバクタム系). 小児では1回30mg/kg・1日4回(最大4g/日)点滴静注. 米国では腸内細菌の約15%がAZT耐性との報告があり, 自施設のアンチバイオグラムを確認して選択する.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: βラクタムアレルギーでの代替',
        'モノバクタム系でグラム陰性菌に限定した活性を持ち, 重症βラクタムアレルギー患者でも比較的安全に使用できる. 髄膜炎の経験的治療でCAZ/CFPMの代わりにAZT 2gを6~8時間ごとに静注する選択肢がある.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: スペクトラムの限界と新生児適応',
        'グラム陰性桿菌のみに活性がありグラム陽性菌・嫌気性菌はカバーしない. 低出生体重児/新生児のUTIに適応がある数少ない薬剤の一つ(ABPC, CAZ, CZOP, FMOX, AZT, AMK, VCM).\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分によるショックの既往歴のある患者',
        'アナフィラキシー再発のリスク',
      ),
    ],
    cautiousUse: [
      'ペニシリン系・セフェム系薬剤への過敏症の既往歴 (特にセフタジジムは側鎖構造が共通し交差反応の報告あり)',
      'アレルギー素因のある患者',
      '高度腎障害患者',
    ],
  ),
  Drug(
    name: 'メロペネム水和物 (MEPM)',
    brand: 'メロペン',
    category: DrugCategory.antimicrobial,
    spec: '点滴用バイアル0.25g/V, 0.5g/V, キット0.5g',
    dilution: '100mL以上の日局生理食塩液等に溶解し30分以上かけて点滴静注. キット製剤は隔壁を開通させ振盪して溶解',
    concentration: '用時溶解のため濃度は希釈量により可変',
    dose: '・一般感染症 (化膿性髄膜炎を除く): 1日0.5-1g (力価) を2-3回に分割し30分以上かけ点滴静注. 重症・難治性感染症では1回1gを上限に1日3gまで増量可\n'
        '・化膿性髄膜炎: 1日6g (力価) を3回に分割 (1回2g) し30分以上かけ点滴静注\n'
        '・小児 (化膿性髄膜炎): 1日120mg (力価) /kg (成人量6gを超えない)',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射 (点滴静注) のみ',
    ),
    spectrum: 'グラム陽性菌・陰性菌 (緑膿菌を含む) ・嫌気性菌まで広くカバーし, ESBL産生腸内細菌科にも有効. MRSA・一部の非定型菌には無効',
    renalAdjust: 'Ccr 26-50mL/min: 通常量を12時間毎. Ccr 10-25mL/min: 半量を12時間毎. Ccr 10mL/min未満: 半量を24時間毎 (添付文書の腎機能別投与表に基づく)',
    periop: '重症感染症・院内感染に対する広域治療薬として手術当日も継続する. バルプロ酸ナトリウム投与中の患者には併用禁忌であり, てんかん既往患者やバルプロ酸内服中の患者では周術期の痙攣誘発を避けるため他系統の抗菌薬への変更, またはバルプロ酸をレベチラセタム等へ切替えた上で血中濃度をモニタリングする. 腎機能に応じた用量調整を要する.',
    mechanism: 'カルバペネム系β-ラクタム. PBPに結合し細胞壁合成を阻害する. β-ラクタマーゼへの安定性が高く抗菌域が広い',
    packageInsertReviewed: true,
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00054716',
    notes: [
      DrugNote(
        'バルプロ酸との相互作用',
        'カルバペネム系はバルプロ酸のグルクロン酸抱合体の加水分解を阻害するなどの機序でバルプロ酸血中濃度を数時間以内に大きく低下させ, てんかん発作の再発リスクがあるため併用禁忌. てんかん患者では投与前に必ず内服歴を確認する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '薬物動態',
        '腎排泄型で半減期は約1時間. 髄液移行が良好でカルバペネムの中では髄膜炎に高用量投与が承認されている数少ない薬剤.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用・中枢神経症状',
        '痙攣・意識障害等の中枢神経症状は腎機能低下例や高齢者, 中枢神経系疾患合併例で発現しやすく, 減量や中止を要することがある.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        '緑膿菌を含む広域グラム陰性菌カバーがあり, 発熱性好中球減少症や重症院内感染のempiric治療の中心的薬剤の一つ.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: CDI発症リスク: カルバペネム系薬',
        'カルバペネム系薬はCDI発症のリスク因子であり, 他系統抗菌薬との比較でのリスク比は2.26 (95%CI 1.64~3.11)と, フルオロキノロン系薬 (RR 2.44)やセフェム系薬 (RR 2.24)より高い. 広域抗菌薬の長期使用時はCDIを念頭に置く.\n'
          '[出典] CDI診療GL 2022',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: ESBL高リスク敗血症のempiric',
        'ESBL産生菌高リスク(検出歴, 直近のβ-ラクタム系薬使用歴など)の市中発症敗血症, および院内発症敗血症のempiric therapyでMEPM 1回1g・1日3回点滴静注を選択する. 敗血症を疑ったら1時間以内の投与開始が推奨される.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: PK/PDに基づく個別化投与',
        'メロペネムの推奨用量は肺炎と髄膜炎とで異なるなど, 罹患臓器や腎機能に応じたPK/PD理論に基づく用量設定が重要である. 薬剤師主導の介入で腎機能正常患者への1日3回投与が是正され, 14日を超える長期投与例が有意に減少したとの報告がある.\n'
          '[出典] 抗菌薬適正使用支援(AS)ガイダンス 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: ESBL産生菌・重症UTIでの位置づけ',
        'ESBL産生菌による複雑性尿路感染や尿路性敗血症の第一選択の一つ. 難治例では0.5~1gを1日3回, 尿路性敗血症など重症例では1gを1日3回投与する.\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 髄膜炎での高用量投与',
        '細菌性髄膜炎(グラム陰性桿菌が疑われる例)の治療ではMEPM 2gを8時間ごとに静注する高用量を用い, VCM+CFPM/CAZ併用に対する代替として使われる.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 持続/延長静注の限界',
        'PIPC/TAZの長時間・持続静注は観察研究のメタ解析で死亡率減少と関連したが, カルバペネム単独では死亡率低下の有意差は確認されていない点に留意する.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        'アナフィラキシー再発のリスク',
      ),
      DrugContraindication(
        'バルプロ酸ナトリウムを投与中の患者',
        'バルプロ酸の血中濃度が低下し, てんかん発作が再発するおそれがあるため (併用禁忌)',
      ),
    ],
    cautiousUse: [
      'カルバペネム系・ペニシリン系・セフェム系抗生物質への過敏症の既往歴',
      'てんかんなど中枢神経系疾患の既往',
      '高度腎障害患者',
    ],
  ),
  Drug(
    name: 'イミペネム水和物・シラスタチンナトリウム (IPM/CS)',
    brand: 'チエナム',
    category: DrugCategory.antimicrobial,
    spec: '点滴静注用0.25g/V, 0.5g/V, キット0.5g, 筋注用0.5g/V',
    dilution: '生理食塩液100mLでよく振盪して溶解 (乳酸塩含有輸液は配合不可). 溶解後は速やかに使用する',
    concentration: '用時溶解のため濃度は希釈量により可変',
    dose: '・一般感染症: 1日0.5-1.0g (力価) を2-3回に分割し30分以上かけ点滴静脈内注射\n・重症感染症: 1日2gまで増量可',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射 (点滴静注・筋注) のみ',
    ),
    spectrum: 'グラム陽性菌・陰性菌 (緑膿菌を含む) ・嫌気性菌まで広くカバーする広域抗菌薬. MRSAには無効',
    renalAdjust: 'Ccr 70-50mL/min: 0.5gを12時間毎. Ccr 50-30mL/min: 0.5-0.25gを12-24時間毎. Ccr 10mL/min未満では慎重投与とし少量からの検討が必要 (添付文書の腎機能別投与表に基づく)',
    periop: '重症感染症の広域治療薬として手術当日も継続する. カルバペネム系の中でも中枢神経系副作用 (痙攣) の報告が最も多く, てんかん既往・腎機能低下患者・高齢者では特に注意し, 可能であれば他のカルバペネムやβラクタム系への変更を検討する. バルプロ酸ナトリウム投与中の患者には併用禁忌であり, 抗てんかん薬の変更を要する.',
    mechanism: 'カルバペネム系β-ラクタム (イミペネム). 腎デヒドロペプチダーゼIによる分解を防ぐためシラスタチン (阻害薬) を配合し有効血中濃度を維持する',
    packageInsertReviewed: true,
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00068020',
    notes: [
      DrugNote(
        '痙攣リスク',
        'カルバペネム系の中で最も中枢神経系副作用 (痙攣) の報告が多い薬剤で, 発現率は約0.14%とされる. 高用量投与, 腎機能低下, 中枢神経系疾患の既往で発現しやすく, これらの背景がある場合は他のカルバペネムへの変更を検討する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'バルプロ酸との相互作用',
        '他のカルバペネムと同様にバルプロ酸の血中濃度を低下させ, てんかん発作の再発リスクがあるため併用禁忌.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '薬物動態',
        'イミペネム単独では腎デヒドロペプチダーゼIにより速やかに分解されるため, 阻害薬シラスタチンを1:1で配合し有効血中濃度を維持している.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '痙攣・意識障害等の中枢神経症状のほか, ショック・アナフィラキシー, 急性腎障害, 偽膜性大腸炎, 肝機能障害に注意.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: CDI発症リスク: カルバペネム系薬',
        'カルバペネム系薬はCDI発症のリスク因子であり, 他系統抗菌薬との比較でのリスク比は2.26 (95%CI 1.64~3.11)と, フルオロキノロン系薬 (RR 2.44)やセフェム系薬 (RR 2.24)より高い. 広域抗菌薬の長期使用時はCDIを念頭に置く.\n'
          '[出典] CDI診療GL 2022',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: ESBL高リスク敗血症の選択肢',
        'ESBL産生菌高リスクの市中発症敗血症や院内発症敗血症のempiric therapyの選択肢. IPM/CS 1回0.5g・1日4回点滴静注.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 重症UTI/敗血症での投与回数',
        'ウロセプシスや重症腎盂腎炎の治療でIPM/CS 0.5gを1日4回投与するなど, 他のカルバペネム(MEPMは1日3回, DRPMは1日2~3回)より投与回数が多い点に注意する.\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 妊娠中/授乳中の安全性',
        'ヒトでの妊娠中データは不十分だが動物実験で明らかな毒性は認められていない. 授乳中はおそらく安全とされるが参照データは少なくモニターが必要とされる.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        'アナフィラキシー再発のリスク',
      ),
      DrugContraindication(
        'バルプロ酸ナトリウムを投与中の患者',
        'バルプロ酸の血中濃度が低下し, てんかん発作が再発するおそれがあるため (併用禁忌)',
      ),
    ],
    cautiousUse: [
      'カルバペネム系・ペニシリン系・セフェム系抗生物質への過敏症の既往歴',
      'てんかんなど中枢神経系疾患の既往',
      '肝機能障害患者',
      '高度腎障害患者',
      'ガンシクロビル投与中の患者 (痙攣リスクが増大するため併用注意)',
    ],
  ),
  Drug(
    name: 'ドリペネム水和物 (DRPM)',
    brand: 'フィニバックス',
    category: DrugCategory.antimicrobial,
    spec: '点滴静注用0.25g/V, 0.5g/V, キット0.25g',
    dilution: '生理食塩液等100mL程度に溶解し30分以上かけて点滴静注',
    concentration: '用時溶解のため濃度は希釈量により可変',
    dose: '・一般感染症: 1回0.25g (力価) を1日2-3回, 30分以上かけて点滴静注\n'
        '・重症・難治性感染症: 1回0.5gを1日3回とし, さらに増量を要する場合は1回1.0g, 1日量3.0gまで\n'
        '・小児: 1回20mg (力価) /kgを1日3回, 重症例は1回40mg/kgまで (1回上限1.0g)',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射 (点滴静注) のみ',
    ),
    spectrum: 'グラム陽性菌・陰性菌 (緑膿菌を含む) ・嫌気性菌まで広くカバーする広域抗菌薬. MRSAには無効',
    renalAdjust: '腎機能障害患者では投与量・投与間隔の調節が必要 (添付文書の腎機能別投与表に基づく)',
    periop: '重症感染症の広域治療薬として手術当日も継続する. バルプロ酸ナトリウム投与中の患者には併用禁忌であり, てんかん既往患者では周術期の痙攣誘発を避けるため抗てんかん薬の変更を検討する. 腎機能に応じた用量調整を要する.',
    mechanism: 'カルバペネム系β-ラクタム. PBPに結合し細胞壁合成を阻害する',
    packageInsertReviewed: true,
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00059816',
    notes: [
      DrugNote(
        'バルプロ酸との相互作用',
        'カルバペネム系に共通の相互作用で, バルプロ酸血中濃度を低下させ発作再発のリスクがあるため併用禁忌.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '用量の特徴',
        '1回投与量が0.25-0.5gと他のカルバペネムより小さい範囲から開始でき, 重症例では1回1.0gまで増量できる柔軟な用量設定になっている.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '薬物動態',
        '腎排泄型. 緑膿菌を含む広域グラム陰性菌への抗菌活性が良好で, 呼吸器感染症や複雑性尿路感染症で使用される.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '痙攣・意識障害等の中枢神経症状, ショック・アナフィラキシー, 急性腎障害, 偽膜性大腸炎に注意.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: CDI発症リスク: カルバペネム系薬',
        'カルバペネム系薬はCDI発症のリスク因子であり, 他系統抗菌薬との比較でのリスク比は2.26 (95%CI 1.64~3.11)と, フルオロキノロン系薬 (RR 2.44)やセフェム系薬 (RR 2.24)より高い. 広域抗菌薬の長期使用時はCDIを念頭に置く.\n'
          '[出典] CDI診療GL 2022',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: ESBL産生菌CRBSIのdefinitive',
        'ESBL産生の大腸菌/肺炎桿菌や, Enterobacter属/Serratia属によるCRBSIのdefinitive therapyで選択. DRPM 1回0.5-1g・1日3回点滴静注. 多剤耐性Acinetobacter属にはMINO 1回100mg・1日2回を併用する.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 難治性UTIでの用量',
        '難治性膀胱炎/複雑性UTIではDRPM 0.25gを1日2回, 重症腎盂腎炎/尿路性敗血症では0.5~1gを1日2~3回用いるが, 使用経験の報告が限られている薬剤に位置づけられる.\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 重症肺炎・耐性グラム陰性菌での位置づけ',
        'ICU管理を要する重症市中肺炎や, ESBL産生Klebsiella, Acinetobacter baumannii感染の治療選択肢としてDRPM 0.5~1gを1日3回投与するレジメンが挙げられる.\n'
          '[出典] JAID/JSC 呼吸器感染症GL 2014',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        'アナフィラキシー再発のリスク',
      ),
      DrugContraindication(
        'バルプロ酸ナトリウムを投与中の患者',
        'バルプロ酸の血中濃度が低下し, てんかん発作が再発するおそれがあるため (併用禁忌)',
      ),
    ],
    cautiousUse: [
      'カルバペネム系・ペニシリン系・セフェム系抗生物質への過敏症の既往歴',
      'てんかんなど中枢神経系疾患の既往',
      '腎機能障害患者',
    ],
  ),
  Drug(
    name: 'ビアペネム (BIPM)',
    brand: 'オメガシン',
    category: DrugCategory.antimicrobial,
    spec: '点滴用0.3g/V, バッグ製剤0.3gあり',
    dilution: '日局生理食塩液100mLに溶解し30-60分かけて点滴静注',
    concentration: '用時溶解のため濃度は希釈量により可変',
    dose: '・成人: 1日0.6g (力価) を2回に分割し30-60分かけて点滴静脈内注射\n・年齢, 症状により適宜増減するが投与量の上限は1日1.2g (力価)',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射 (点滴静注) のみ',
    ),
    spectrum: 'グラム陽性菌・陰性菌 (緑膿菌を含む) ・嫌気性菌まで広くカバーする広域抗菌薬. MRSAには無効',
    renalAdjust: '腎機能障害患者では投与間隔の延長等の調節を考慮する (添付文書の記載に基づく)',
    periop: '重症感染症の広域治療薬として手術当日も継続する. バルプロ酸ナトリウム投与中の患者には併用禁忌であり, てんかん既往患者では周術期の痙攣誘発を避けるため抗てんかん薬の変更を検討する. 1日総量が他のカルバペネムより少なく設定されている点に留意する.',
    mechanism: 'カルバペネム系β-ラクタム. PBPに結合し細胞壁合成を阻害する',
    packageInsertReviewed: true,
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00048596',
    notes: [
      DrugNote(
        'バルプロ酸との相互作用',
        'カルバペネム系に共通の相互作用で, バルプロ酸血中濃度を低下させ発作再発のリスクがあるため併用禁忌.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '用量の特徴',
        '1日投与量は0.6g (上限1.2g) と他のカルバペネムに比べ少なく, 1回30-60分かけて点滴静注する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '薬物動態',
        '腎デヒドロペプチダーゼIに対して比較的安定でシラスタチンのような阻害薬の配合を要しない単剤製剤.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '痙攣・意識障害等の中枢神経症状, ショック・アナフィラキシー, 急性腎障害, 偽膜性大腸炎に注意.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: CDI発症リスク: カルバペネム系薬',
        'カルバペネム系薬はCDI発症のリスク因子であり, 他系統抗菌薬との比較でのリスク比は2.26 (95%CI 1.64~3.11)と, フルオロキノロン系薬 (RR 2.44)やセフェム系薬 (RR 2.24)より高い. 広域抗菌薬の長期使用時はCDIを念頭に置く.\n'
          '[出典] CDI診療GL 2022',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: ESBL高リスク敗血症の選択肢',
        'ESBL産生菌高リスクの市中発症敗血症や院内発症敗血症のempiric therapyの選択肢の一つ. BIPM 1回0.3g・1日4回点滴静注.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 添付文書上の用量上限に注意',
        'BIPMは0.3~0.6gを1日3~4回投与するが, 添付文書上の最大用量は1.2g/日とMEPMなど他のカルバペネムより低く設定されており, 超重症例では力価不足に留意する.\n'
          '[出典] JAID/JSC 呼吸器感染症GL 2014',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 重症肺炎/耐性グラム陰性菌での使いどころ',
        'ICU入室を要する重症市中肺炎, 多剤耐性菌リスクのある院内肺炎, ESBL産生Klebsiella, Acinetobacter baumannii感染の治療選択肢の一つとして挙げられる.\n'
          '[出典] JAID/JSC 呼吸器感染症GL 2014',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        'アナフィラキシー再発のリスク',
      ),
      DrugContraindication(
        'バルプロ酸ナトリウムを投与中の患者',
        'バルプロ酸の血中濃度が低下し, てんかん発作が再発するおそれがあるため (併用禁忌)',
      ),
    ],
    cautiousUse: [
      'カルバペネム系・ペニシリン系・セフェム系抗生物質への過敏症の既往歴',
      'てんかんなど中枢神経系疾患の既往',
      '腎機能障害患者',
    ],
  ),
  Drug(
    name: 'セファゾリン (CEZ)',
    brand: 'セファメジンα',
    category: DrugCategory.antimicrobial,
    spec: '注射用0.25g・0.5g・1g・2g, 点滴用キット1g・2g, 筋注用0.25g・0.5g',
    dilution: '1回量(0.25-2g)を注射用水・生理食塩液・ブドウ糖注射液 約2-3.5mLで溶解し, 静注または点滴静注用にさらに希釈. 筋注用は添付のリドカイン注射液で溶解する.',
    concentration: '力価表示. 規格は0.25g/0.5g/1g/2g(注射用・点滴用キット), 筋注用0.25g/0.5g.',
    dose: '・成人: 通常1日1g(力価)を2回に分けて点滴静注または静注\n'
        '・効果不十分時: 成人1日1.5-3g(力価)を3回に分割投与\n'
        '・重症時: 成人1日5g(力価)まで分割投与可\n'
        '・小児: 1日20-40mg/kg(力価)を2-4回に分割',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射のみ(静注・点滴静注・筋注). 国内に内服製剤はない.',
    ),
    emergencyDose: '周術期予防投与(SSI予防)の第一選択:\n'
        '・皮膚切開前60分以内(できれば執刀直前)に投与を終了する\n'
        '・標準量は1回1g. 体重80kg以上は1回2g, 体重120kg以上は1回3gに増量\n'
        '・半減期(正常腎機能で約1.6-2.5時間)の2倍を目安に, 術中3-4時間ごとに同量を再投与\n'
        '・出血量1500mL以上の大量出血時は, 定時再投与のタイミングを待たず追加投与\n'
        '・術後投与は24時間以内(施設・術式によっては48時間以内)に終了し, 漫然と継続しない',
    spectrum: 'MSSA, レンサ球菌など好気性グラム陽性球菌に強い活性. グラム陰性桿菌への活性は限定的(大腸菌・肺炎桿菌の一部には有効だがESBL産生菌・緑膿菌には無効). 嫌気性菌カバーは乏しい. 皮膚常在菌カバーの目的で周術期予防投与の第一選択薬として最も汎用される.',
    renalAdjust: '腎排泄型(尿中未変化体排泄率 約90%). 腎機能低下で半減期延長(中等度障害で約2.7時間, 高度障害で約15時間). Ccrに応じ1回量減量または投与間隔延長が必要. 重症感染症は腎機能によらず初回は常用量で開始する.',
    periop: '周術期予防投与の代表薬. 執刀前60分以内の投与で皮膚切開時に十分な組織内濃度を得る. 半減期が短いため長時間手術・大量出血時は術中の追加投与を忘れない. 術後は漫然と継続せず24時間以内に終了する(投与期間を延長してもSSI予防効果は上がらず耐性菌リスクのみ増す). MSSAカバー目的の薬であり, 術前MRSA保菌が判明していればバンコマイシン等の併用・変更を検討する. 麻酔導入前のアレルギー歴確認は必須のチェック項目.',
    mechanism: '細菌のペニシリン結合蛋白(PBP)に結合し, 細胞壁ペプチドグリカンの架橋形成(トランスペプチダーゼ反応)を阻害して殺菌的に作用する第一世代セフェム系抗菌薬.',
    packageInsertReviewed: true,
    packageInsertRevision: '2023年8月改訂(第2版)',
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00051899',
    notes: [
      DrugNote(
        '薬物動態',
        '半減期は正常腎機能で約1.6-2.5時間と短く, 尿中未変化体排泄率は約90%とほぼ完全に腎排泄される. 高度腎機能障害では半減期が約15時間まで延長するため, 減量または投与間隔の延長が必要.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        '第一世代セフェム系の代表薬. MSSA・レンサ球菌など皮膚軟部組織感染の主要起因菌に強い活性を持ち, 毒性が低く周術期予防投与に適する. 髄液移行は不良で髄膜炎の治療には用いない.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '過敏症(発疹, 蕁麻疹, ショック, アナフィラキシー), 肝機能検査値異常, 下痢, 血液障害(好酸球増多, 顆粒球減少等)が報告される. 頻度は他のセフェム系と同様に比較的少ない.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        '執刀前60分以内の投与開始, 半減期の2倍(3-4時間)ごとの術中再投与, 体重80kg以上での増量, 術後24時間以内の終了が実践ガイドラインで推奨されている. 出血量1500mL以上の大量出血時は再投与タイミングを待たず追加投与する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '禁忌・アレルギー確認',
        'ペニシリン系との交差アレルギーは数%程度とされるが既往歴は必ず確認する. 筋注用製剤はリドカインで溶解するため, 局所麻酔薬アレルギーがある場合は静注用を選択する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 執刀前投与のタイミング',
        '皮膚切開前1時間以内に投与を開始する. 帝王切開でも臍帯クランプ後ではなく, 他の手術と同様に切開前1時間以内の投与が推奨され, 母体のSSI・子宮内膜炎の予防に有用である.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 術中再投与の間隔',
        '半減期1.2~2.2時間を踏まえ, 腎機能正常例では3~4時間ごとに再投与する. eGFR-IND 20~50 mL/分は8時間, 20未満は16時間まで間隔を延長する. 初回再投与は術前投与終了時からの経過時間で判断する.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 体重による用量調節',
        '1回投与量は通常1g, 体重80kg以上は2g, 120kg以上は3gに増量する. 予防投与であっても治療量を用いることが原則である.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 大量出血時の追加投与',
        '短時間に大量出血が認められた場合は, 決められた再投与間隔を待たずに追加投与を考慮する. 長時間手術では半減期 (1.2~2.2時間) を踏まえた術中再投与も併せて行う.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 心臓手術での投与期間とMRSA対策',
        '冠動脈バイパス術・弁膜症手術ではCEZを48時間投与する. MRSAによるSSIが高率な施設では術前に鼻腔内MRSA保菌チェックを考慮し, 保菌者ではVCM併用と除菌が勧められる.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 人工心肺中は再投与しない',
        '人工心肺使用により分布容積が増大し血中濃度は低下するが, 送血開始後のCEZ再投与の有用性は証明されておらず推奨しない. アミノグリコシド系薬 (GM) は排泄遅延のため1回投与量を4mg/kgに減量する.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 人工関節・脊椎インストゥルメンテーション手術',
        '人工関節置換術は単回~48時間, 脊椎インストゥルメンテーション手術は48時間以内が目安. ターニケット使用時は加圧開始前に抗菌薬の投与を終えておく必要がある.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 開頭術・脳室シャント造設術の投与期間 (2020追補)',
        '開頭術・脳動脈瘤クリッピング術・脳室シャント造設術などでは24~48時間投与し, SSI高リスク例では72時間も考慮する. 髄液ドレナージ挿入例でもドレーン抜去まで継続する必要はない.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 追補版 2020',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: CDI発症リスク: セフェム系薬',
        'セフェム系薬はCDI発症のリスク因子であり, RCTのメタアナリシスではペニシリン系薬と比較しリスク比2.36 (95%CI 1.32~4.23), フルオロキノロン系薬と比較しリスク比2.84 (95%CI 1.60~5.06)であった. 世代間で明確なリスク差は示されていない.\n'
          '[出典] CDI診療GL 2022',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: CRBSIのde-escalation第一選択',
        'CRBSIでMSSA/メチシリン感受性CNSと判明したらCEZ 1回2g・1日3回点滴静注へde-escalationする第一選択薬. 短期留置カテーテル抜去後は合併症がなければ7-14日間の投与でよい.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 腎機能低下時の減量',
        '腎機能正常なら1~2gを8時間ごとが基本. CrCl>50では1~2gを8時間ごと, CrCl<10では0.5~1gを24時間ごとまで投与間隔を延長する. 周術期でも腎機能に応じた調節を要する.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: ペニシリンアレルギーとの交差反応',
        'IgE関与型ペニシリンアレルギー (気管支けいれん, アナフィラキシー, 血管神経性浮腫, 即時性じんま疹など) の既往がある患者にはセフェム系を投与すべきでない. 交差反応率は約10%とされる.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 骨髄炎・心内膜炎での位置づけ',
        'MSSA自己弁心内膜炎ではCEZ 2g静注8時間ごと・6週がNafcillin/Oxacillinの代替として提示され, 効果は同等でCEZの方が忍容性が高いとされる. 化膿性脊椎炎でも高用量CEZ (150mg/kg/日を8時間ごとに分割) がNafcillin/Oxacillinと同等の有効性を示す.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        'ショック, アナフィラキシーの危険性',
      ),
      DrugContraindication(
        '(筋注用) リドカイン等アニリド系局所麻酔薬に過敏症の既往歴のある患者',
        '溶解液にリドカインを含有するため',
      ),
    ],
    cautiousUse: [
      'セフェム系・ペニシリン系抗生物質に過敏症の既往歴のある患者',
      '本人または両親・兄弟に気管支喘息, 発疹, 蕁麻疹等アレルギー疾患の既往歴のある患者',
      '腎機能障害のある患者',
      '高齢者',
    ],
  ),
  Drug(
    name: 'セファレキシン (CEX)',
    brand: 'ケフレックス',
    category: DrugCategory.antimicrobial,
    spec: 'カプセル250mg, 顆粒500mg, ドライシロップ小児用50%, 細粒等',
    dilution: '内服薬のため希釈操作は不要.',
    concentration: '内服薬のため濃度設定なし(力価表示のカプセル・顆粒).',
    dose: '・成人・体重20kg以上の小児: 1回250mg(力価)を6時間ごと(1日4回)経口投与\n'
        '・重症, 感受性がやや低い場合: 1回500mg(力価)を6時間ごと\n'
        '・年齢, 症状により適宜増減',
    forms: DrugFormAvailability(
      hasInjection: false,
      hasOral: true,
      summary: '内服のみ(カプセル・顆粒・ドライシロップ). 国内に注射剤はない.',
    ),
    emergencyDose: '国内に注射剤はなく, 緊急時・重症感染症の初期治療には使用しない. 経口摂取が可能になった段階で, 点滴静注薬(セファゾリン等)から切り替える内服スイッチ(de-escalation)の選択肢として用いる.',
    spectrum: '第一世代セフェムの経口薬. MSSA・レンサ球菌などグラム陽性球菌に強い活性を持つが, グラム陰性菌への活性は限定的. 皮膚軟部組織感染症, 咽頭炎, 膀胱炎などの軽症外来感染症や, 注射薬からの内服スイッチに用いられる.',
    renalAdjust: '腎排泄型. 腎機能障害患者(特に高度)では投与量減量・投与間隔延長を考慮する. 急性腎障害等の重篤な腎障害があらわれることがあり, 定期的な腎機能検査が推奨される.',
    periop: '国内に注射剤がなく周術期の静脈内投与には使用できない. 手術当日朝の内服可否は絶食指示・誤嚥リスクを踏まえて個別に判断する. 術後感染症治療を点滴薬(セファゾリン等)から内服へ切り替える際の選択肢の一つとして, 経口摂取再開後に用いられる.',
    mechanism: 'PBPに結合し細胞壁ペプチドグリカンの架橋形成を阻害する第一世代セフェム系の経口抗菌薬.',
    packageInsertReviewed: true,
    packageInsertRevision: '2023年4月改訂(第1版)',
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00052950',
    notes: [
      DrugNote(
        '薬物動態',
        '経口吸収は良好で腎排泄型. 腎機能障害患者では蓄積し急性腎障害等の重篤な腎障害を来すことがあるため定期的な腎機能検査が推奨される.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        '第一世代セフェムの経口薬でグラム陽性球菌に対する活性が主体. 咽頭炎, 皮膚軟部組織感染症, 単純性膀胱炎など軽症の外来感染症で使用される.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '下痢, 軟便, 発疹, 肝機能検査値異常等. 重篤な腎障害の報告があり, 高齢者・腎機能障害患者では注意する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        '注射剤がないため予防投与や緊急使用には用いない. 内服スイッチの候補薬として, 術後感染症の治療期間短縮・早期退院を目的に使用されることがある.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 涙道手術ではCEZ静注が優位',
        '鼻涙管閉塞に伴う涙道手術でCEX経口とCEZ点滴を比較したRCTでは, CEZ単回投与の方が術後感染発症率を低下させた. 経口セファレキシンより静注セファゾリンが優先される場面がある.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 追補版 2020',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: CDI発症リスク: セフェム系薬',
        'セフェム系薬はCDI発症のリスク因子であり, RCTのメタアナリシスではペニシリン系薬と比較しリスク比2.36 (95%CI 1.32~4.23), フルオロキノロン系薬と比較しリスク比2.84 (95%CI 1.60~5.06)であった. 世代間で明確なリスク差は示されていない.\n'
          '[出典] CDI診療GL 2022',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 標準的な経口用量',
        'CEX (セファレキシン) は成人で1回0.25~1gを6時間ごと (最大4g/日) が目安. 軽症の皮膚軟部組織感染症や, 注射薬から経口薬へのde-escalation先として使いやすい.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: ペニシリンアレルギーとの交差反応',
        'IgE関与型ペニシリンアレルギー (気管支けいれん, アナフィラキシー, 血管神経性浮腫, 即時性じんま疹) の既往がある患者にはセフェム系を避ける. ペニシリンで麻疹様皮疹のみの既往なら, セフェム投与時の発疹リスクは5~10%程度とされる.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        '過敏症反応の危険性',
      ),
    ],
    cautiousUse: [
      'セフェム系・ペニシリン系抗生物質に過敏症の既往歴のある患者',
      'アレルギー体質の患者',
      '腎機能障害のある患者(特に高度)',
      '経口摂取不良の患者',
      '高齢者',
    ],
  ),
  Drug(
    name: 'セフォチアム (CTM)',
    brand: 'パンスポリン',
    category: DrugCategory.antimicrobial,
    spec: '静注用0.25g・0.5g・1g, 静注用1gバッグ(生食キット)',
    dilution: '1回量(0.5-2g)を生理食塩液等に溶解し静注または点滴静注. 点滴静注用バッグ製剤は生理食塩液と一体化したキットで, 隔壁を開通させて溶解後そのまま投与する.',
    concentration: '力価表示. バイアル0.25g/0.5g/1g, 点滴静注用バッグ1g(生食キット).',
    dose: '・成人: 通常1日0.5-2g(力価)を2-4回に分けて静脈内注射\n'
        '・敗血症等重症例: 成人1日4g(力価)まで増量\n'
        '・小児: 1日40-80mg/kg(力価)を3-4回に分割, 重症例は160mg/kg(力価)まで',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射のみ(静注・点滴静注). 国内に内服製剤はない(経口プロドラッグのセフォチアム ヘキセチル塩酸塩は別薬剤として存在するが本体のセフォチアムには内服製剤なし).',
    ),
    emergencyDose: 'セファゾリン供給不足時の周術期予防投与代替候補の一つ(MSSAへの感受性は概ね良好). 投与法はセファゾリンに準じ, 執刀前60分以内に投与を終了し, 半減期を踏まえ術中3-4時間ごとに再投与する.',
    spectrum: '第二世代セフェム. グラム陽性球菌(MSSA等)への活性はCEZにやや劣るが, 大腸菌・クレブシエラ・インフルエンザ菌など主要なグラム陰性桿菌への活性が拡大している. 緑膿菌, ESBL産生菌には無効. 嫌気性菌カバーはない. セファゾリン供給不安時の周術期予防投与代替薬候補にも挙げられる.',
    renalAdjust: '腎排泄型. 腎機能低下に伴い血中濃度上昇, 半減期延長, 尿中排泄率低下が生じるため, 腎機能障害患者では投与量・投与間隔の調節が必要.',
    periop: 'セファゾリンと並び周術期予防投与に用いられうる第二世代セフェム. グラム陰性菌カバーはやや広い一方でMSSAへの活性はCEZにやや劣るため, 通常の清潔手術での第一選択はCEZであり, CTMは主に代替・供給調整時の選択肢. 半減期が短いため長時間手術では術中の再投与間隔に留意する.',
    mechanism: 'PBPに結合し細胞壁合成を阻害する第二世代セフェム系抗菌薬. 第一世代よりグラム陰性桿菌への活性が拡大している.',
    packageInsertReviewed: true,
    packageInsertRevision: '2026年6月改訂(第2版)',
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00056944',
    notes: [
      DrugNote(
        '薬物動態',
        '腎排泄型で, 0.5g静注後の尿中濃度は投与後2時間以内で高値を示す. 腎機能低下により血中濃度上昇・半減期延長・尿中排泄率低下が生じる.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        '第二世代セフェムでグラム陰性桿菌への活性が第一世代より拡大している. 敗血症, 呼吸器感染症, 尿路感染症, 婦人科感染症など幅広い適応を持つ.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '過敏症(発疹, 蕁麻疹, ショック), 下痢, 肝機能検査値異常, 血液障害等. セフェム系に共通する副作用プロファイル.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        'セファゾリンの供給不足時に周術期予防投与の代替候補として位置づけられている. 投与タイミング・再投与間隔の考え方はセファゾリンに準じる.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '経口プロドラッグとの違い',
        '経口薬「セフォチアム ヘキセチル塩酸塩(パンスポリンT)」はエステル型プロドラッグであり, 注射用セフォチアムそのものに内服製剤があるわけではない点に注意.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 半減期と再投与間隔',
        '半減期60~68分と短く, 術中再投与は2時間ごと (腎機能正常時) を目安とする. eGFR-IND 20~50 mL/分では5時間, 20未満では10時間まで延長する.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 肝胆膵外科での使用',
        '膵頭十二指腸切除ではCEZまたはCTMを48時間, 胆道再建を伴う胆道手術では24時間投与する. 肝切除で胆道再建を伴う場合は24~48時間が目安.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 尿路系開放を伴う泌尿器科手術',
        '腎尿管摘除術・根治的前立腺摘除術など尿路系を開放する手術ではCEZ, CTM, SBT/ABPCのいずれかを単回~24時間投与する.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: CDI発症リスク: セフェム系薬',
        'セフェム系薬はCDI発症のリスク因子であり, RCTのメタアナリシスではペニシリン系薬と比較しリスク比2.36 (95%CI 1.32~4.23), フルオロキノロン系薬と比較しリスク比2.84 (95%CI 1.60~5.06)であった. 世代間で明確なリスク差は示されていない.\n'
          '[出典] CDI診療GL 2022',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: ESBL非産生腸内細菌のCRBSIで選択',
        'CRBSIでESBL非産生の大腸菌/肺炎桿菌と判明した場合の第一選択の一つ. CTM 1回2g・1日3回点滴静注でde-escalationを行う.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 重症腎盂腎炎での位置づけ',
        '重症腎盂腎炎の第一選択の1つとしてCTM 点滴静注1回1~2gを1日3~4回投与する (2g・3~4回は保険適応外). CTRXやCAZと並ぶ選択肢である.\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 肺炎 (ESBL非産生Klebsiella等) の入院治療での位置づけ',
        'ESBL非産生Klebsiella属などによる肺炎の入院治療では, CTX, CTRXと並ぶ第一選択としてCTM 点滴静注1回1~2gを1日2~3回 (添付文書上限4g/日) で使用する.\n'
          '[出典] JAID/JSC 呼吸器感染症GL 2014',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        '過敏症反応の危険性',
      ),
    ],
    cautiousUse: [
      'セフェム系・ペニシリン系抗生物質に過敏症の既往歴のある患者',
      'アレルギー体質の患者',
      '高度の腎障害のある患者',
      '妊婦・授乳婦',
      '高齢者',
    ],
  ),
  Drug(
    name: 'セフメタゾール (CMZ)',
    brand: 'セフメタゾン',
    category: DrugCategory.antimicrobial,
    spec: '静注用0.25g・0.5g・1g・2g, 筋注用0.5g',
    dilution: '1g(力価)あたり日局注射用水・生理食塩液・ブドウ糖注射液10mLで溶解する. 点滴時は注射用水を単独で用いると等張にならないため使用しない.',
    concentration: '力価表示. 規格0.25g/0.5g/1g/2g.',
    dose: '・成人: 通常1日1-2g(力価)を2回に分けて静脈内注射または点滴静注\n'
        '・重症・難治性感染症: 成人1日4g(力価)まで増量\n'
        '・小児: 1日25-100mg/kg(力価)を2-4回に分割',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射のみ(静注・点滴静注・筋注). 国内に内服製剤はない.',
    ),
    emergencyDose: '大腸・直腸手術など嫌気性菌カバーを要する消化管手術の周術期予防投与に用いられる代表薬: 入室時(執刀前)1g投与, 手術が3時間を超える場合は3時間ごとに1g追加投与するレジメンが報告されている.',
    spectrum: '大腸菌・肺炎桿菌などのESBL産生腸内細菌科細菌や, Bacteroides属を中心とした嫌気性菌に良好な活性を持つ. 好気性グラム陽性球菌への活性は第一世代セフェムより劣る. 緑膿菌には無効. 腹腔内感染症, 胆道感染症, 婦人科感染症, 大腸手術の周術期予防投与(嫌気性菌カバー目的)に用いられる.',
    renalAdjust: '腎排泄型. Ccrに応じた減量・間隔延長が必要(例: Ccr30-60mL/minで1000mgを24時間ごと, 10-30mL/minで48時間ごと). 腎機能良好例では相対的に血中濃度が低くなりSSI予防効果に影響しうるとの報告がある.',
    periop: '3位側鎖にN-メチルチオテトラゾール(MTT)基を持ち, 投与中から投与後少なくとも1週間の飲酒でジスルフィラム様反応(顔面紅潮, 動悸, めまい, 頭痛, 嘔気等)を起こしうるため, 周術期は本人・家族に飲酒回避を説明する. MTT基は肝でのビタミンK依存性凝固因子合成を阻害し, ビタミンK欠乏・低プロトロンビン血症による出血傾向を来すことがあり, 高齢・腎障害・低栄養例や長期投与では特に注意し, 必要に応じビタミンK補充を検討する. 大腸手術等, 嫌気性菌カバーを要する消化管手術の予防投与で選択されることが多い.',
    mechanism: 'セファマイシン系(7α-メトキシ基を持つ広義のセフェム系)抗菌薬. PBPに結合し細胞壁合成を阻害する. 7α-メトキシ基によりグラム陰性菌の産生するβ-ラクタマーゼ(ESBLを含む)に対して安定である.',
    packageInsertReviewed: true,
    packageInsertRevision: '2022年10月改訂(第1版)',
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00067982',
    notes: [
      DrugNote(
        '薬物動態',
        '血中濃度半減期は約1時間前後で腎排泄型. 尿中排泄率は85-92%と高い.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        'セファマイシン系はβ-ラクタマーゼに安定な7α-メトキシ基を持ち, ESBL産生菌や嫌気性菌に有効. 腹腔内・婦人科感染症, 大腸手術の周術期予防投与に用いられる.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用: ジスルフィラム様反応とビタミンK欠乏',
        'MTT基により, 飲酒でジスルフィラム様反応, 長期・高用量投与でビタミンK依存性凝固因子低下による出血傾向(低プロトロンビン血症)を来しうる. まれに重篤な出血例の報告がある.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        '大腸手術など嫌気性菌カバーが必要な予防投与に選択される. 経口摂取再開後の飲酒には注意喚起する. 高齢・低栄養・腎障害患者では出血傾向の観察を要する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '耐性菌カバー',
        'ESBL産生大腸菌・肺炎桿菌による軽症-中等症感染症でカルバペネム温存目的に使用されることがある一方, 腎機能良好な患者では組織内濃度が相対的に低くなりやすく, 重症例への単独使用は推奨されない.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 半減期・再投与・用量',
        '半減期1~1.3時間, 再投与間隔は2~3時間 (腎機能正常) , eGFR-IND 20~50 mL/分で6時間, 20未満で12時間. 1回投与量1g, 80kg以上は2gに増量する.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 下部消化管手術の第一選択',
        '結腸切除・虫垂切除など下部消化管手術で第一選択. 単回~24時間が基本だが, 直腸切除術で機械的腸管処置のみの場合は48~72時間投与する.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 破水後帝王切開・食道結腸再建',
        '腟周辺B群溶連菌陰性の破水後帝王切開ではCMZまたはFMOXを単回投与する. 胸部食道切除で結腸再建を行う場合はCMZ+MNZなどを48時間投与する.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: CDI発症リスク: セフェム系薬',
        'セフェム系薬はCDI発症のリスク因子であり, RCTのメタアナリシスではペニシリン系薬と比較しリスク比2.36 (95%CI 1.32~4.23), フルオロキノロン系薬と比較しリスク比2.84 (95%CI 1.60~5.06)であった. 世代間で明確なリスク差は示されていない.\n'
          '[出典] CDI診療GL 2022',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 腎機能低下時の投与間隔調整',
        '腎機能正常なら2g静注を8~12時間ごとに投与する. CrCl 50~90では1~2gを12時間ごと, CrCl 30~49では1gを12時間ごと, CrCl<10では1~2gを48時間ごとまで投与間隔を延長する.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 小児での使用経験は限定的',
        '小児の複雑性尿路感染症でP. aeruginosaが想定される場合の選択肢として, CMZ 点滴静注1回30~40mg/kg・1日3回・7~14日間が挙げられるが, 使用経験の報告は限られ成人での報告のみとされる.\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        '過敏症反応の危険性',
      ),
    ],
    cautiousUse: [
      'セフェム系・ペニシリン系抗生物質に過敏症の既往歴のある患者',
      'アレルギー体質の患者',
      '腎機能障害のある患者',
      '経口摂取不良・非経口栄養中の患者(ビタミンK欠乏リスク)',
      '高齢者',
      '常習飲酒者(ジスルフィラム様反応)',
    ],
  ),
  Drug(
    name: 'フロモキセフ (FMOX)',
    brand: 'フルマリン',
    category: DrugCategory.antimicrobial,
    spec: '静注用0.5g・1g, キット静注用1g',
    dilution: '1瓶(0.5g/1g)に日局注射用水・5%ブドウ糖注射液・生理食塩液4mL以上を加えて溶解する. 点滴時は注射用水を単独で用いない.',
    concentration: '力価表示. 規格0.5g/1g(静注用), 1g(キット静注用, 生食付).',
    dose: '・成人: 通常1日1-2g(力価)を2回に分割し静脈内注射または点滴静注\n'
        '・重症・難治性感染症: 成人1日4g(力価)まで増量, 2-4回に分割\n'
        '・小児: 1日60-80mg/kg(力価)を3-4回に分割\n'
        '・未熟児・新生児: 1回20mg/kgを日齢により1日2-4回',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射のみ(静注・点滴静注). 国内に内服製剤はない.',
    ),
    emergencyDose: '腹腔内感染症・婦人科感染症など嫌気性菌カバーを要する重症例の初期治療に用いられる. セフメタゾンと同様に消化器外科手術の周術期予防投与に用いられることがあるが, 本邦のガイドラインでの標準は施設プロトコルにより異なり, CMZ/FMOXは代替選択肢としての位置づけが多い.',
    spectrum: '大腸菌・肺炎桿菌などのESBL産生腸内細菌科細菌やBacteroides属など嫌気性菌に良好な活性を持つ. MSSA等グラム陽性球菌にも活性を持つがCEZほど強くはない. 緑膿菌には無効. 開発時よりジスルフィラム様作用・腎毒性を持たないよう設計された点がセフメタゾールとの違い.',
    renalAdjust: '腎排泄型(投与量の大部分が未変化体として尿中排泄される). 腎機能障害患者では投与量減量または投与間隔延長が必要.',
    periop: 'セフメタゾンと同じ嫌気性菌カバー目的で消化器外科・婦人科手術の周術期予防投与に用いられることがある. MTT基を持たずジスルフィラム様反応のリスクは低いとされるが, 腸内細菌叢抑制によるビタミンK欠乏には注意する. 半減期が短い(約40-70分)ため長時間手術では術中の再投与間隔に留意する.',
    mechanism: 'オキサセフェム系(セフェム骨格の1位硫黄が酸素に置換された構造)抗菌薬. PBPに結合し細胞壁合成を阻害する. β-ラクタマーゼに対する安定性が高い.',
    packageInsertReviewed: true,
    packageInsertRevision: '2022年1月改訂(第1版)',
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00047379',
    notes: [
      DrugNote(
        '薬物動態',
        '健康成人での半減期は約40-73分と短い. 大部分が未変化体として尿中に排泄される.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        'オキサセフェム系として, ジスルフィラム様作用と腎毒性を持たないことを目指して開発された. ESBL産生菌・嫌気性菌を含む広いスペクトラムを持つ.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '過敏症, 下痢, 肝機能検査値異常等. MTT基を持たないためセフメタゾールに比べジスルフィラム様反応の懸念は小さいとされるが, 長期投与時のビタミンK欠乏には留意する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        '半減期が短いため長時間手術では術中の再投与間隔に留意する. 嫌気性菌カバーを要する腹部・婦人科手術の予防投与や治療に用いられる.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 半減期と再投与間隔',
        '半減期50分と短く, 術中再投与は2時間ごと (腎機能正常) を目安とする. eGFR-IND 20~50 mL/分で5時間, 20未満で10時間まで延長する.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 下部消化管・婦人科手術',
        '結腸・直腸切除, 子宮全摘術, 破水後帝王切開などでCMZと並ぶ第一選択薬. B. fragilisや大腸菌の耐性化が指摘されており, 腸管利用尿路変向術ではTAZ/PIPCへの変更も検討される.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: CDI発症リスク: セフェム系薬',
        'セフェム系薬はCDI発症のリスク因子であり, RCTのメタアナリシスではペニシリン系薬と比較しリスク比2.36 (95%CI 1.32~4.23), フルオロキノロン系薬と比較しリスク比2.84 (95%CI 1.60~5.06)であった. 世代間で明確なリスク差は示されていない.\n'
          '[出典] CDI診療GL 2022',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 新生児・低出生体重児への適応',
        'FMOXは低出生体重児・新生児にも適応のある数少ない抗菌薬の1つ (ABPC, CAZ, CZOP, FMOX, AZT, AMK, VCMなど). 新生児尿路感染症の選択肢になる.\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 重症前立腺炎での位置づけ',
        '重症の急性前立腺炎ではFMOX点滴静注1回1gを1日2~4回・3~7日間投与するのがCTM, CAZと並ぶ第一選択の1つ. 症状軽快後は経口薬に切り替え合計14~28日間治療する.\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        '過敏症反応の危険性',
      ),
    ],
    cautiousUse: [
      'セフェム系・ペニシリン系抗生物質に過敏症の既往歴のある患者',
      'アレルギー体質の患者',
      '腎機能障害のある患者',
      '心疾患のある患者',
      '経口摂取不良・非経口栄養中の患者(ビタミンK欠乏)',
      '高齢者',
    ],
  ),
  Drug(
    name: 'セフトリアキソン (CTRX)',
    brand: 'ロセフィン',
    category: DrugCategory.antimicrobial,
    spec: '静注用0.5g・1g, 点滴静注用1gバッグ',
    dilution: '1回量(0.5-2g)を注射用水・生理食塩液・ブドウ糖注射液に溶解して緩徐に静注, または点滴静注用に希釈する. カルシウムを含有する注射剤・輸液とは同一ルートはもちろん, 異なるルート・時間帯であっても新生児では併用しない.',
    concentration: '力価表示. 規格0.5g/1g(静注用), 1g(点滴静注用バッグ).',
    dose: '・成人: 通常1日1-2g(力価)を1回または2回に分けて静脈内注射または点滴静注\n'
        '・重症・難治性感染症: 適宜増量(髄膜炎等では1日4gまで)\n'
        '・小児: 1日20-60mg/kg(力価), 重症時120mg/kg(力価)まで',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射のみ(静注・点滴静注). 国内に内服製剤はない.',
    ),
    emergencyDose: '1日1回投与が可能で通常は腎機能による用量調節が不要なため, 敗血症性ショック等の初期経験的治療やICUでの投与管理が容易. 細菌性髄膜炎が疑われる緊急例では成人1回2gを速やかに点滴静注する運用が多い(施設プロトコルによる). カルシウム含有輸液との配合禁忌に注意.',
    spectrum: '肺炎球菌・レンサ球菌・淋菌・髄膜炎菌等のグラム陽性・陰性菌, 大腸菌・肺炎桿菌等の腸内細菌科細菌に広い活性を持つ. 髄液移行が良好で細菌性髄膜炎の第一選択の一つ. 緑膿菌, MRSA, ESBL産生菌, 多くの嫌気性菌には無効.',
    renalAdjust: '肝・腎の二経路排泄(尿中約40-65%, 胆汁中約35-45%)のため, 腎機能単独の低下では通常, 用量調節は不要. ただし高度腎機能障害で血中濃度を頻回に測定できない場合は投与量が1g/日を超えないようにする. 重度の肝機能障害と腎機能障害を合併する例では減量を考慮する.',
    periop: '腎機能調節がほぼ不要で1日1回投与で周術期の血中濃度管理がしやすい一方, カルシウム含有輸液(乳酸リンゲル液, カルチコール, 高カロリー輸液の一部等)とは配合・同時投与を避ける必要があり, 周術期に多用する輸液ラインの選択に注意する. 胆汁排泄型のため胆石・胆嚢内沈殿物(偽胆石)を形成することがあり, 上腹部症状が出た場合は本剤投与中の胆道系合併症として鑑別に挙げる. 腎機能調節が不要な点から, 通常の清潔手術予防投与よりも術後感染症治療で選択される場面が多い.',
    mechanism: '第三世代セフェム系. PBPに結合し細胞壁合成を阻害する. 血中半減期が長く1日1回投与が可能で, 尿と胆汁の二経路から排泄される.',
    packageInsertReviewed: true,
    packageInsertRevision: '2026年6月改訂(第2版)',
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00049429',
    notes: [
      DrugNote(
        '薬物動態',
        '半減期は成人で約5.8時間と長い. 新生児では約10.9時間, 腎機能障害患者では13.5-21.3時間まで延長する. 尿・胆汁の二経路排泄.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        '第三世代セフェムの中で半減期が長く, 髄液移行が良好で細菌性髄膜炎の第一選択の一つ. 淋菌感染症にも高い有効性を持つ.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '配合変化・胆泥',
        'カルシウム含有輸液との配合・同時投与は結晶沈殿のリスクがあり禁忌. 胆汁中濃度が高くカルシウム塩として胆石・胆泥(偽胆石)を形成することがあり, 多くは小児の重症感染症への大量投与例で報告されている.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        '腎機能調節が不要で扱いやすい一方, 輸液ラインのカルシウム含有製剤との配合禁忌を必ず確認する. 高ビリルビン血症のある新生児には禁忌である.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '過敏症, 下痢(広域抗菌薬に共通するClostridioides difficile関連下痢症リスク), 血液障害, 肝機能検査値異常等.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 半減期が長く再投与間隔も長い',
        '半減期5.4~10.9時間と長く, 術中再投与は12時間ごとで足りる. 開放骨折 (Gustilo IIIA, 受傷6時間以内) ではCEZ+GMまたはCTRXを48~72時間投与する.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 淋菌陽性の産婦人科手術',
        '淋菌陽性が判明している流産手術・子宮内膜掻爬術ではCTRX+MNZを単回投与する (β-ラクタムアレルギー時の代替はAZM+CLDM) .\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 髄液漏合併例での選択',
        '経蝶形骨洞手術 (経鼻的下垂体手術) や頭蓋底外科手術で術後髄液漏を合併した症例では, 髄液移行の良好なCTRXへの変更を考慮する.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 追補版 2020',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: CDI発症リスク: セフェム系薬',
        'セフェム系薬はCDI発症のリスク因子であり, RCTのメタアナリシスではペニシリン系薬と比較しリスク比2.36 (95%CI 1.32~4.23), フルオロキノロン系薬と比較しリスク比2.84 (95%CI 1.60~5.06)であった. 世代間で明確なリスク差は示されていない.\n'
          '[出典] CDI診療GL 2022',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 市中発症敗血症empiricの第一選択',
        '市中発症敗血症のempiric therapy第一選択の一つ. CTRX 1回2g・1日1-2回点滴静注. 敗血症を疑ったら1時間以内の投与開始を最大限努力する.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 外来治療開始時の単回投与',
        '軽症~中等症の腎盂腎炎など外来治療可能な症例では, 経口薬による治療開始時にone-time intravenous agentとしてCTRX (またはAMK, PZFX, LVFX) を単回点滴静注することが推奨される.\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 半減期が長く1日1~2回投与でよい',
        '重症腎盂腎炎の第一選択としてCTRX 点滴静注1回1~2gを1日1~2回投与する. 半減期が長いため他のセフェムより投与回数を減らせる実務上の利点がある.\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 妊婦の腎盂腎炎での位置づけ',
        '妊婦の腎盂腎炎ではキノロン系薬は催奇形性のため禁忌. セフェム系薬が推奨され, 治療開始時のone-time intravenous agentとしてもCTRXが推奨される.\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 抗緑膿菌活性はない',
        'CTRXはPseudomonasが疑われる場合には使用しないこと. 緑膿菌カバーが必要な場面ではPIPC/TAZなど抗緑膿菌活性のある薬剤を選択する.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        '過敏症反応の危険性',
      ),
      DrugContraindication(
        '高ビリルビン血症の低出生体重児・新生児',
        'セフトリアキソンが血清アルブミン結合ビリルビンを遊離させ, 未熟な血液脳関門を通過して核黄疸を起こすおそれがあるため',
      ),
      DrugContraindication(
        'カルシウムを含有する注射剤・輸液(特に新生児での併用)',
        'セフトリアキソン-カルシウム塩の結晶沈殿を生じ, 肺・腎に沈着して死亡した新生児例が海外で報告されているため',
      ),
    ],
    cautiousUse: [
      'セフェム系・ペニシリン系抗生物質に過敏症の既往歴のある患者',
      '胆道閉塞のある患者(胆汁うっ滞増悪の懸念)',
      '腎機能障害・肝機能障害のある患者',
      '経口摂取不良の患者',
      '高齢者',
    ],
  ),
  Drug(
    name: 'セフォタキシム (CTX)',
    brand: 'クラフォラン',
    category: DrugCategory.antimicrobial,
    spec: '注射用0.5g・1g',
    dilution: '静脈内注射: 注射用水・生理食塩液・ブドウ糖注射液に溶解し緩徐に注射する. 筋肉内注射: 0.5%リドカイン注射液に溶解する.',
    concentration: '力価表示. 規格0.5g/1g.',
    dose: '・成人: 通常1日1-2g(力価)を2回に分けて静脈内または筋肉内注射\n'
        '・重症・難治性感染症: 成人1日4g(力価)まで増量, 2-4回に分割\n'
        '・小児: 1日50-100mg/kg(力価)を3-4回に分割\n'
        '・小児化膿性髄膜炎: 1日300mg/kg(力価)まで',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射のみ(静脈内注射・筋肉内注射). 国内に内服製剤はない.',
    ),
    emergencyDose: '新生児・乳児の敗血症, 細菌性髄膜炎の経験的治療で, セフトリアキソンのビリルビン置換リスク・カルシウム配合禁忌を避けたい場面での代替第三世代セフェムとして使用される. 腎排泄型のため, 腎機能に応じた用量調節を要する点はセフトリアキソンと異なる.',
    spectrum: '肺炎球菌・レンサ球菌等グラム陽性菌および大腸菌・肺炎桿菌・インフルエンザ菌等グラム陰性菌に広い活性を持つ. 髄液移行が良好で新生児・小児の髄膜炎, 敗血症に頻用される. セフトリアキソンと異なり胆汁排泄比率が低く主に腎排泄で, 高ビリルビン血症のリスクが低いため新生児にも使用しやすい. 緑膿菌には無効.',
    renalAdjust: '主に腎排泄. 腎機能障害患者では減量または投与間隔の延長を考慮する.',
    periop: 'セフトリアキソンと異なりカルシウム含有輸液との配合禁忌がなく, ビリルビン置換による核黄疸リスクも低いため, 新生児・未熟児の周術期感染症治療で使用しやすい. 腎排泄型のため腎機能に応じた調節が必要な点は周術期の輸液・尿量管理と合わせて確認する.',
    mechanism: 'PBPに結合し細胞壁合成を阻害する第三世代セフェム系抗菌薬. グラム陰性菌への活性拡大と中枢神経系への移行性を併せ持つ.',
    packageInsertReviewed: true,
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med_product?id=00052381-002',
    notes: [
      DrugNote(
        '一般的性質',
        '第三世代セフェムでグラム陽性・陰性菌に広い活性を持ち, 中枢神経系への移行性が良好. 新生児・小児の敗血症, 髄膜炎に頻用される.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'セフトリアキソンとの違い',
        '主に腎排泄でカルシウム含有輸液との配合禁忌がなく, ビリルビン置換作用も弱いため, 高ビリルビン血症リスクのある新生児にも使用しやすい. 半減期はセフトリアキソンより短く1日2回以上の投与が必要.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '過敏症, 下痢, 肝機能検査値異常, 血液障害等. セフェム系に共通するプロファイル.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        '新生児・小児の周術期敗血症・髄膜炎疑いでの経験的治療に用いられる. 腎機能に応じた用量調節が必要であり, 周術期の腎機能変動を踏まえて評価する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: CDI発症リスク: セフェム系薬',
        'セフェム系薬はCDI発症のリスク因子であり, RCTのメタアナリシスではペニシリン系薬と比較しリスク比2.36 (95%CI 1.32~4.23), フルオロキノロン系薬と比較しリスク比2.84 (95%CI 1.60~5.06)であった. 世代間で明確なリスク差は示されていない.\n'
          '[出典] CDI診療GL 2022',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 市中発症敗血症empiricの選択肢',
        '市中発症敗血症のempiric therapy第一選択の一つ. CTX 1回2g・1日3回点滴静注. CTRXが使用できない場合の代替としてMEPMも考慮される.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 脳膿瘍のempiric therapy',
        '原発性/隣接病巣由来の脳膿瘍では, CTX 2g静注4時間ごと (またはCTRX 2g静注12時間ごと) にMNZ (メトロニダゾール) を併用する. 術後・外傷後ではS. aureusや腸内細菌を考慮しNafcillin/Oxacillinを追加する.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 髄液移行性が必要な場面での選択',
        'ウロセプシスなどで髄膜炎への波及が疑われる場合は, 髄液移行性の良い第3世代セフェム (CTX, CTRXなど) を選択する.\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 緑膿菌疑い時は変更が必要',
        '脳膿瘍治療でP. aeruginosaが疑われる場合はCTX/CTRXに代えてCFPMまたはCAZを用いる. CTX自体には抗緑膿菌活性がない.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        '過敏症反応の危険性',
      ),
      DrugContraindication(
        '(筋注時) リドカイン等アニリド系局所麻酔薬に過敏症の既往歴のある患者',
        '溶解液にリドカインを使用するため',
      ),
    ],
    cautiousUse: [
      'セフェム系・ペニシリン系抗生物質に過敏症の既往歴のある患者',
      'アレルギー体質の患者',
      '腎機能障害のある患者',
      '新生児・低出生体重児(用量調節)',
      '高齢者',
    ],
  ),
  Drug(
    name: 'セフジニル (CFDN)',
    brand: 'セフゾン',
    category: DrugCategory.antimicrobial,
    spec: 'カプセル50mg・100mg, 細粒小児用10%',
    dilution: '内服薬のため希釈操作は不要.',
    concentration: '内服薬のため濃度設定なし(力価表示のカプセル・細粒).',
    dose: '・成人: 通常1回100mg(力価)を1日3回経口投与\n・小児: 1日9-18mg/kg(力価)を3回に分割経口投与\n・年齢, 症状により適宜増減',
    forms: DrugFormAvailability(
      hasInjection: false,
      hasOral: true,
      summary: '内服のみ(カプセル・細粒). 国内に注射剤はない.',
    ),
    emergencyDose: '国内に注射剤はなく緊急時・重症例の初期治療には用いない. 注射薬(セフトリアキソン等)からの内服スイッチ(de-escalation)の選択肢の一つ.',
    spectrum: '肺炎球菌・レンサ球菌等グラム陽性菌からインフルエンザ菌・モラクセラ等グラム陰性菌まで比較的広いスペクトラムを持つ経口第三世代セフェム. 呼吸器感染症, 皮膚感染症, 尿路感染症などに用いられる. 緑膿菌には無効.',
    renalAdjust: '腎排泄型. 腎機能障害患者では投与量減量・投与間隔延長を考慮する.',
    periop: '国内に注射剤はなく周術期の静脈内投与には使用できない. 鉄剤・制酸剤(アルミニウム・マグネシウム含有)と同時服用すると吸収が著しく低下するため, 周術期に併用薬(鉄剤, 制酸剤)がある場合は服用間隔をあける. 手術当日朝の内服可否は絶食指示に従い判断する.',
    mechanism: 'PBPに結合し細胞壁合成を阻害する第三世代セフェム系の経口抗菌薬.',
    packageInsertReviewed: true,
    packageInsertRevision: '2026年1月改訂(第2版)',
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00052668',
    notes: [
      DrugNote(
        '薬物動態・相互作用',
        '鉄剤との併用で吸収が約1/10に低下するため, 本剤投与後3時間以上の間隔をあける. アルミニウム・マグネシウム含有制酸剤も吸収を低下させるため2時間以上あける. 食後投与は空腹時よりCmaxがやや低下する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        '経口第三世代セフェムでグラム陽性・陰性菌に比較的広いスペクトラムを持つ. 小児科領域でも汎用される.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '下痢, 発疹, 鉄との複合体形成により便が赤色を呈することがある, 偽膜性大腸炎等.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        '注射剤がないため予防投与や緊急使用には用いない. 鉄剤・制酸剤との服用間隔の指導が周術期の内服管理で重要となる.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: CDI発症リスク: セフェム系薬',
        'セフェム系薬はCDI発症のリスク因子であり, RCTのメタアナリシスではペニシリン系薬と比較しリスク比2.36 (95%CI 1.32~4.23), フルオロキノロン系薬と比較しリスク比2.84 (95%CI 1.60~5.06)であった. 世代間で明確なリスク差は示されていない.\n'
          '[出典] CDI診療GL 2022',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 透析患者での投与間隔',
        '透析患者の難治性膀胱炎ではCFDN 経口1回100mgを1日1回, 透析日は透析終了後に投与する. 腎排泄型薬剤のため透析患者では投与間隔調整が必須.\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 妊婦の尿路感染症での位置づけ',
        '妊婦の膀胱炎・無症候性細菌尿ではキノロン系薬が禁忌のため, CFDN 経口100mgを1日3回・5~7日間などセフェム系薬が第一選択となる.\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        '過敏症反応の危険性',
      ),
    ],
    cautiousUse: [
      'セフェム系・ペニシリン系抗生物質に過敏症の既往歴のある患者',
      'アレルギー体質の患者',
      '経口摂取不良の患者',
      '腎機能障害のある患者',
    ],
  ),
  Drug(
    name: 'セフタジジム (CAZ)',
    brand: 'モダシン',
    category: DrugCategory.antimicrobial,
    spec: '静注用0.5g・1g',
    dilution: '0.5gは注射用水・生理食塩液・5%ブドウ糖注射液約3mLで溶解し10mLに希釈, 1gは約5mLで溶解し20mLに希釈する. 調製後は室温6時間, 冷蔵72時間以内に使用する.',
    concentration: '力価表示. 規格0.5g/1g.',
    dose: '・成人: 通常1日1-2g(力価)を2回に分けて静脈内注射\n'
        '・重症・難治性感染症: 成人1日4g(力価)まで増量, 2-4回に分割\n'
        '・小児: 1日40-100mg/kg(力価)を2-4回に分割, 重症時150mg/kg(力価)まで\n'
        '・未熟児・新生児: 1回20mg/kgを日齢により1日2-4回',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射のみ(静注・点滴静注). 国内に内服製剤はない.',
    ),
    emergencyDose: '発熱性好中球減少症(FN)の経験的治療における抗緑膿菌薬の選択肢の一つ. 敗血症性ショックが疑われる場合は緑膿菌カバーを含む広域抗菌薬の初回投与を遅らせないことが優先される.',
    spectrum: '緑膿菌を含むグラム陰性桿菌に強い活性を持つ第三世代セフェム. グラム陽性球菌(ブドウ球菌・レンサ球菌)への活性は他の第三世代セフェムより弱い. 嫌気性菌カバーはない. 発熱性好中球減少症の経験的治療, 緑膿菌感染症, 髄膜炎(緑膿菌疑い時)などに用いられる.',
    renalAdjust: '腎排泄型で腎機能低下時の調節が特に重要: Ccr 50-31mL/minで1.0g/12時間, 30-16mL/minで1.0g/24時間, 15-6mL/minで0.5g/24時間, 5mL/min未満で0.5g/48時間が目安として示されている.',
    periop: '抗緑膿菌活性を要する腹腔内感染症合併例や, 免疫抑制状態(好中球減少)での周術期感染症治療に用いられる. 通常の清潔手術の予防投与としては用いない(スペクトラムが広すぎ耐性菌誘導のリスクがあるため). 腎機能に応じた用量調節が必須であり, 周術期の腎機能変動(出血・脱水・造影剤使用)を踏まえて用量を再評価する.',
    mechanism: 'PBPに結合し細胞壁合成を阻害する第三世代セフェム系抗菌薬. 緑膿菌を含む抗菌スペクトラムの広さが特徴.',
    packageInsertReviewed: true,
    packageInsertRevision: '2023年11月改訂(第1版)',
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00060175',
    notes: [
      DrugNote(
        '薬物動態',
        '健康成人の半減期は約1.6時間, 小児(腎機能正常)では約1.2時間. 腎排泄型で腎機能低下時に大きく延長する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        '第三世代セフェムの中で最も強い抗緑膿菌活性を持つが, グラム陽性球菌への活性は弱い. 発熱性好中球減少症の主要な選択肢の一つ.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '腎機能別投与量',
        'クレアチニンクリアランス別の投与量・間隔の目安が添付文書に示されており, 腎機能障害患者では厳密な調節が必要.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        '通常の清潔手術の予防投与には用いない. 免疫抑制患者や腹腔内感染症合併例での治療に位置づけられる. 高用量・腎機能障害時は痙攣等の中枢神経系副作用にも留意する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: CDI発症リスク: セフェム系薬',
        'セフェム系薬はCDI発症のリスク因子であり, RCTのメタアナリシスではペニシリン系薬と比較しリスク比2.36 (95%CI 1.32~4.23), フルオロキノロン系薬と比較しリスク比2.84 (95%CI 1.60~5.06)であった. 世代間で明確なリスク差は示されていない.\n'
          '[出典] CDI診療GL 2022',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 院内発症敗血症の抗緑膿菌薬',
        '院内発症敗血症のempiric therapyで抗緑膿菌作用のあるβ-ラクタム系薬の一つ. CAZ 1回1g・1日3-4回点滴静注とし, 自施設のアンチバイオグラムで感受性を確認して選択する.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 緑膿菌カバーが必要な場面',
        'CAZは抗緑膿菌活性をもつ第3世代セフェム. 複雑性尿路感染症やウロセプシスでP. aeruginosaを想定する場合の第一選択の1つとして1回1~2gを1日3回点滴静注する (2g・3~4回は保険適応外).\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 新生児への適応',
        '低出生体重児・新生児にも適応のある抗菌薬の1つ (ABPC, CAZ, CZOP, FMOX, AZT, AMK, VCM). 新生児尿路感染症でP. aeruginosa等を想定する際の選択肢になる.\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: Enterococcus属には無効',
        'セフェム系薬はEnterococcus属には無効. 複雑性尿路感染症でEnterococcus属が想定される場合はCAZではなくペニシリン系薬や抗MRSA薬を選択する.\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        '過敏症反応の危険性',
      ),
    ],
    cautiousUse: [
      'セフェム系・ペニシリン系抗生物質に過敏症の既往歴のある患者',
      'アレルギー体質の患者',
      '腎機能障害のある患者(用量調節必須)',
      '経口摂取不良の患者',
      '高齢者',
    ],
  ),
  Drug(
    name: 'セフェピム (CFPM)',
    brand: 'マキシピーム',
    category: DrugCategory.antimicrobial,
    spec: '静注用0.5g・1g',
    dilution: '注射用水・生理食塩液・ブドウ糖注射液に溶解し緩徐に注射, または糖液・電解質液・アミノ酸製剤などの補液に加え30分-1時間かけて点滴静注する.',
    concentration: '力価表示. 規格0.5g/1g.',
    dose: '・成人: 通常1日1-2g(力価)を2回に分けて静脈内注射または点滴静注\n'
        '・重症・難治性感染症: 成人1日4g(力価)まで増量, 2回に分割\n'
        '・発熱性好中球減少症: 1日4g(力価)を2回に分割し静脈内注射または点滴静注',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射のみ(静注・点滴静注). 国内に内服製剤はない.',
    ),
    emergencyDose: '発熱性好中球減少症や重症院内感染症(緑膿菌カバーを要する)の経験的治療の中心的選択肢. 腎機能低下患者では蓄積により意識障害・痙攣等の「セフェピム脳症」を起こしうるため, 腎機能に応じた減量が必須(特に高齢者・ICU患者).',
    spectrum: '緑膿菌を含むグラム陰性桿菌への活性と, MSSA・レンサ球菌等グラム陽性球菌への活性を併せ持つ広域抗菌薬(第四世代セフェム). AmpC型β-ラクタマーゼ過剰産生菌にもセフタジジムより安定. 嫌気性菌カバーはない. 発熱性好中球減少症, 院内肺炎, 重症敗血症の経験的治療に用いられる.',
    renalAdjust: '腎排泄型で腎機能低下時に半減期が大きく延長するため, クレアチニンクリアランスに応じた投与量・間隔の調節が必須. 減量不十分な腎機能障害患者ではセフェピム脳症(意識障害, 昏睡, 痙攣)のリスクが上昇する.',
    periop: '重症敗血症・発熱性好中球減少症の周術期併存感染症治療で使用されうる広域薬. 腎機能低下例(急性腎障害を含む)への減量不足はセフェピム脳症(意識障害, 痙攣)を招くため, 周術期の腎機能変動(出血, 脱水, 造影剤使用等)を踏まえてこまめに用量を見直す. 通常の清潔手術の予防投与としては用いない.',
    mechanism: 'PBPに結合し細胞壁合成を阻害する第四世代セフェム系抗菌薬. 双性イオン構造によりグラム陰性菌外膜の透過性が高く, AmpC型β-ラクタマーゼにも比較的安定である.',
    packageInsertReviewed: true,
    packageInsertRevision: '2024年3月改訂(第1版)',
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00058732',
    notes: [
      DrugNote(
        '薬物動態',
        '健常成人での半減期は約1.82時間. 腎排泄型で腎機能低下時に大きく延長する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        '緑膿菌を含むグラム陰性桿菌とグラム陽性球菌の双方に活性を持つ第四世代セフェム. AmpC過剰産生菌にも比較的安定で, 発熱性好中球減少症の主要な選択肢の一つ.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'セフェピム脳症',
        '腎機能障害患者で減量不十分なまま投与すると, 意識障害, ミオクローヌス, 痙攣, 脳症様脳波所見(セフェピム脳症)を来すことがある. 中止と支持療法(重症例では血液透析)で多くは可逆的に回復する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        '腎機能低下例での用量調節がとりわけ重要. 高齢者, 急性腎障害合併例, 造影剤使用後などは腎機能を再評価し, 用量・間隔を見直す.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: CDI発症リスク: セフェム系薬',
        'セフェム系薬はCDI発症のリスク因子であり, RCTのメタアナリシスではペニシリン系薬と比較しリスク比2.36 (95%CI 1.32~4.23), フルオロキノロン系薬と比較しリスク比2.84 (95%CI 1.60~5.06)であった. 世代間で明確なリスク差は示されていない.\n'
          '[出典] CDI診療GL 2022',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 院内発症敗血症/緑膿菌CRBSIで使用',
        '院内発症敗血症のempiric therapy第一選択の一つ. CFPM 1回1g・1日3-4回点滴静注に抗MRSA薬を併用する. 緑膿菌によるCRBSIのdefinitive therapyでは高用量の1回2g・1日3回を選択することがある.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 緑膿菌感染症での位置づけ',
        'CFPMは抗緑膿菌活性をもつ第4世代セフェム. 複雑性尿路感染症・ウロセプシスでP. aeruginosaを想定する場合, CAZと並ぶ選択肢として1回1~2gを1日3回点滴静注する (2g・3回は保険適応外).\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 骨髄炎でグラム陰性菌合併が疑われる場合',
        '成人の化膿性脊椎炎でグラム染色でグラム陰性菌が疑われる場合, MSSA/MRSAレジメンにCAZまたはCFPMを追加する.\n[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        '過敏症反応の危険性',
      ),
    ],
    cautiousUse: [
      'セフェム系・ペニシリン系抗生物質に過敏症の既往歴のある患者',
      'アレルギー体質の患者',
      '腎機能障害のある患者(セフェピム脳症リスク, 用量調節必須)',
      '高齢者',
    ],
  ),
  Drug(
    name: 'セフォゾプラン (CZOP)',
    brand: 'ファーストシン',
    category: DrugCategory.antimicrobial,
    spec: '静注用0.5g・1g, 静注用1gバッグG(5%ブドウ糖付)・バッグS(生理食塩液付)',
    dilution: '0.5gは通常10mLに, 1gは通常20mLに希釈して静注する. 点滴時は注射用水を単独で用いない.',
    concentration: '力価表示. 規格0.5g/1g, 点滴静注用1gバッグ(生食/ブドウ糖キット).',
    dose: '・成人: 通常1日1-2g(力価)を2回に分けて静脈内注射または点滴静脈内注射\n'
        '・重症・難治性感染症: 成人1日4g(力価)まで増量, 2-4回に分割\n'
        '・小児: 1日40-80mg/kg(力価)を3-4回に分割',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射のみ(静注・点滴静注). 国内に内服製剤はない.',
    ),
    emergencyDose: '発熱性好中球減少症や緑膿菌を含む重症院内感染症の経験的治療に用いられる. 投与開始後3日を目安に継続要否を判定し, 投与期間は原則14日以内とする(添付文書上の使用上の注意).',
    spectrum: '緑膿菌を含むグラム陰性桿菌とMSSA・レンサ球菌等グラム陽性球菌の双方に活性を持つ第四世代セフェム(国内で開発された薬剤). 発熱性好中球減少症, 重症院内感染症の経験的治療に用いられる. 嫌気性菌カバーはない.',
    renalAdjust: '腎排泄型. 腎機能障害患者では投与量減量・投与間隔延長が必要. セフェピムと同様, 高度腎障害での蓄積・中枢神経系副作用に注意する.',
    periop: 'セフェピムと同様, 緑膿菌カバーを要する重症周術期感染症(発熱性好中球減少症, 院内肺炎等)の経験的治療に用いられる広域第四世代セフェム. 通常の清潔手術の予防投与には用いない. 腎機能障害患者での減量不足は中枢神経系副作用(意識障害, 痙攣)のリスクとなるため, 周術期の腎機能変動を踏まえて用量を再評価する. 血液毒性(顆粒球減少, 血小板減少)の報告があり長期投与時は血算を確認する.',
    mechanism: 'PBPに結合し細胞壁合成を阻害する第四世代セフェム系抗菌薬. セフェピムと同様に双性イオン構造を持ちグラム陰性菌への浸透性が高い.',
    packageInsertReviewed: true,
    packageInsertRevision: '2026年1月改訂(第4版)',
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00071694',
    notes: [
      DrugNote(
        '一般的性質',
        '国内で開発された第四世代セフェムで, セフェピムと同様に緑膿菌を含む広域グラム陰性菌活性とグラム陽性球菌活性を併せ持つ.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '投与期間の目安',
        '投与開始後3日を目安に継続の要否を判定し, より適切な他剤への変更を検討する. 投与期間は原則14日以内とされている.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '過敏症, 顆粒球減少, 血小板減少, 貧血などの血液障害, 下痢, 肝機能検査値異常等が報告されている.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        '重症敗血症や好中球減少患者の周術期感染症治療に用いられる. 腎機能障害患者では中枢神経系副作用のリスクを念頭に置き用量調節を徹底する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: CDI発症リスク: セフェム系薬',
        'セフェム系薬はCDI発症のリスク因子であり, RCTのメタアナリシスではペニシリン系薬と比較しリスク比2.36 (95%CI 1.32~4.23), フルオロキノロン系薬と比較しリスク比2.84 (95%CI 1.60~5.06)であった. 世代間で明確なリスク差は示されていない.\n'
          '[出典] CDI診療GL 2022',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: CFPMと並ぶ第4世代セフェム',
        '院内発症敗血症のempiric therapyでCFPMと並ぶ第4世代セフェムの選択肢. CZOP 1回1g・1日3-4回点滴静注が基本だが, 緑膿菌によるCRBSIのdefinitive therapyでは1回2g・1日3回に増量することがある.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 院内肺炎・耐性菌リスク時の位置づけ',
        '晩期院内肺炎やVAPなど耐性菌リスクが高い場合, ブドウ糖非発酵菌を想定しCZOP 1~2gを1日2~4回点滴静注する. cephalosporinase恒常発現株が疑われる場合は第4世代セフェム (CZOP/CFPM) かカルバペネムを選択する.\n'
          '[出典] JAID/JSC 呼吸器感染症GL 2014',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 重症急性精巣上体炎での使用',
        '重症の急性精巣上体炎ではCZOP 点滴静注1回1gを1日2~3回・3~7日間投与するのがCTRXと並ぶ第一選択. 症状軽快後は経口薬に切り替え合計14~21日間治療する.\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        '過敏症反応の危険性',
      ),
    ],
    cautiousUse: [
      'セフェム系・ペニシリン系抗生物質に過敏症の既往歴のある患者',
      'アレルギー体質の患者',
      '高度の腎機能障害のある患者(投与間隔の延長等が必要)',
      '肝機能障害のある患者',
      '高齢者',
    ],
  ),
  Drug(
    name: 'バンコマイシン (VCM)',
    brand: '塩酸バンコマイシン (点滴静注用) / バンコマイシン塩酸塩散 (経口用, 先発品名称は各社共通の一般名処方が中心, 後発品多数: サワイ, トーワ, 明治, ファイザー等)',
    category: DrugCategory.antimicrobial,
    spec: '点滴静注用0.5g/1gバイアル, 経口散0.5g/1g',
    dilution: '0.5gバイアルに注射用水, 生理食塩液または5%ブドウ糖注射液10mLを加えて溶解し, さらに100mL以上の輸液で希釈する (1gの場合は200mL以上が目安). 調製後は速やかに使用する.',
    concentration: '投与時濃度は5mg/mL以下が目安 (高濃度・急速投与はred man症候群の誘因となる)',
    dose: '・成人 (注射, 敗血症/感染性心内膜炎/肺炎等): 1日2g (力価) を0.5g×6時間毎または1g×12時間毎に分割し, 60分以上かけて点滴静注\n'
        '・高齢者 (注射): 0.5g×12時間毎または1g×24時間毎を目安に腎機能に応じ調整\n'
        '・小児/乳児 (注射): 1日40mg (力価) /kgを2~4回に分割し点滴静注\n'
        '・新生児 (注射): 1回10~15mg (力価) /kg, 生後1週までは12時間毎, 生後1ヵ月までは8時間毎\n'
        '・感染性腸炎/CDI (経口散): 成人1回0.125~0.5g (力価) を1日4回経口投与 (通常0.5g/日で開始し重症度に応じ増減)\n'
        '・実臨床では上記を初期投与量とし, TDMに基づき個別に調整することが強く推奨される',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: true,
      summary: '点滴静注用 (0.5g/1gバイアル, 用時溶解) と経口散 (0.5g/1g, 用時溶解) の両方が国内にある. 経口散はCDI治療専用でほとんど吸収されないため全身感染症には無効, 全身投与が必要な場合は必ず注射用を用いる.',
    ),
    emergencyDose: '緊急時でも急速静注は避け, 60分以上 (目安10mg/分以下) かけて投与する. 早期に有効血中濃度に到達させたい重症例では初回負荷投与 (25~30mg/kg程度) を行う施設もあるが, その場合も投与速度は変えず投与時間を延長して対応する.',
    spectrum: 'MRSA, MRCNS, PRSP等のグラム陽性球菌に有効. グラム陰性菌には無効.',
    renalAdjust: '腎機能低下患者では投与間隔の延長または1回量の減量が必要 (添付文書のクレアチニンクリアランスに基づく投与量換算図を参照). TDMでトラフ値/AUCを確認しながら調整する. 血液透析 (特に高流量膜) ではある程度除去されるため透析後投与を考慮する.',
    periop: '手術当日も原則継続する. MRSA保菌患者等でVCMを術前予防投与として用いる場合は執刀開始120分前を目安に投与を開始し, 60分以上かけて投与を終え皮膚切開時に組織内濃度がピークとなるよう逆算する (他の予防抗菌薬より早めに開始が必要). 麻酔導入前後の急速投与はred man症候群 (ヒスタミン遊離による顔面/頸部/体幹の紅斑, 掻痒, 低血圧) を誘発しやすく, 全身麻酔中は症状が仮面化されアナフィラキシーとの鑑別が困難になるため, 必ず規定の投与時間を守る. NSAIDs, 利尿薬, ヨード造影剤等腎毒性のある薬剤の周術期使用時は腎機能への影響に注意する.',
    mechanism: '細菌細胞壁ペプチドグリカン前駆体末端のD-Ala-D-Alaに結合し, トランスペプチダーゼによる架橋形成を阻害してグラム陽性菌の細胞壁合成を阻害する (殺菌的, 時間依存性かつAUC/MIC依存性).',
    packageInsertReviewed: true,
    packageInsertRevision: '先発・後発品により改訂時期が異なる (製品数が多い). 使用時は必ず最新の電子添文 (PMDA医薬品医療機器情報提供ホームページ) を確認すること.',
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00057054',
    notes: [
      DrugNote(
        '薬物動態',
        '経口投与ではほとんど吸収されず全身感染症の治療には無効である (腸管病変があると吸収され得る). 静注では主に糸球体ろ過により腎排泄され (24時間で未変化体として約85%排泄), 半減期は腎機能正常者で4~6時間程度. 蛋白結合率は約30~55%.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        'グリコペプチド系の代表的な抗MRSA薬であり, 骨, 関節液, 腹水, 胸水, 心嚢液に良好に移行する. 髄液移行は炎症時にやや改善するが不良であり, 髄膜炎では高用量またはくも膜下/脳室内投与を要することがある.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '腎障害 (急性腎障害, 間質性腎炎), 第8脳神経障害 (難聴, 耳鳴, アミノグリコシド併用で増強), 汎血球減少, 薬剤性過敏症症候群 (DIHS), 中毒性表皮壊死融解症等の重篤な皮膚障害が知られる.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        '術中は血圧低下や紅斑の原因が出血・アナフィラキシー・red man症候群のいずれか判別しにくいため, VCM投与中/投与直後の血行動態変化はまずred man症候群を疑い, 投与速度・濃度を確認する. 造影剤やNSAIDs等他の腎毒性薬剤と重ならないよう周術期のタイミングを調整する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: TDMの目標',
        '2020年改訂の投与ガイドライン以降はトラフ値単独ではなくAUC24/MICで用量調整することが推奨されている. 目標AUC24は400-600μg・h/mLで, ピーク値とトラフ値の2点採血による台形モデルで算出する.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 腎機能低下時の減量',
        '維持量はCrCl 20-49で15-20mg/kg 24時間ごと, CrCl<20で15-20mg/kg 48時間ごとへ延長する. 初回投与量は腎機能によらず通常量 (15-20mg/kg)で開始してよい.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 投与経路と適応',
        '静注: S. aureus菌血症・心内膜炎・侵襲性感染症, 経口: C. difficile感染症, 髄腔内: 髄膜炎, というように経路で適応が明確に区別されている. 経口投与はほぼ全身移行せずCDIの局所治療専用.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: β-ラクタムアレルギー時の使い分け',
        'グラム陽性菌のみが標的の清潔創ではCLDMまたはVCM単独, グラム陰性菌も考慮する準清潔創ではアミノグリコシド系薬・キノロン系薬・AZTのいずれかを併用する.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 半減期・再投与間隔',
        '半減期4~8時間, 再投与間隔8時間 (腎機能正常) , eGFR-IND 20~50 mL/分で16時間, 20未満は投与間隔の設定が適応外となるため薬剤師と相談する.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 投与量とレッドネック症候群対策',
        '1回投与量は実測体重で15mg/kg (上限2g) , 複数回投与時は1日2回とする. レッドネック症候群を避けるため緩徐に投与する.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: MRSA保菌者への併用と除菌',
        'MRSA保菌が判明している患者や, 心臓手術・人工関節置換術・脊椎インストゥルメンテーション手術でMRSAによるSSI多発施設ではCEZとVCMの併用と, 鼻腔ムピロシン軟膏による1日2回5日間の除菌を検討する.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: CDIでの経口投与量と期間',
        'CDIの標準治療として125mgを1日4回, 10日間経口投与する. 125mgと500mgの1日4回投与で有効性に差はなく, ルーチンでの高用量投与は推奨されない. 経口摂取不可の場合は経鼻胃管投与や, 500mg/生理食塩液100mLを1日4回経腸投与を行う.\n'
          '[出典] CDI診療GL 2022',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 経口投与時の腸管内高濃度と静注製剤との違い',
        '経口投与時は消化管からほとんど吸収されずそのまま大腸に到達し, 125mg 1日4回投与時の糞便中濃度はMIC90の約30~10,000倍に達する. この局所高濃度がCDI治療の要であり, 血中に留まる静注用製剤は腸管内へ移行しないためCDI治療の目的では用いない.\n'
          '[出典] CDI診療GL 2022',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 重症複雑性CDIでの高用量投与',
        'ショック, 低血圧, 中毒性巨大結腸症, 麻痺性イレウスを伴う重症複雑性CDIでは, 500mgを1日4回, 経口または経鼻胃管投与 (もしくは500mg/生理食塩液100mLを1日4回経腸投与)し, メトロニダゾール点滴静注の併用を考慮する.\n'
          '[出典] CDI診療GL 2022',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 再発例へのパルス・漸減療法とVRE化リスク',
        '再発を繰り返すCDIには, 125mgを1日4回投与から数週間かけて漸減し, 最終的に2~3日に1回投与へ減らすパルス・漸減療法を考慮する. ただし使用量増加はバンコマイシン耐性腸球菌 (VRE)発現のリスク因子となりうる点に留意する.\n'
          '[出典] CDI診療GL 2022',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: MRSAカバーの中心薬, TDM必須',
        '敗血症やCRBSIのempiric therapyでMRSAをカバーする中心的な抗MRSA薬. VCM 1回1g(または15mg/kg)・1日2回点滴静注とし, 必ずTDMを実施して至適血中濃度を維持する.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: CRBSIは発症1時間以内に投与開始',
        'CRBSI(カテーテル関連血流感染症)を疑ったら血液培養採取後, 発症1時間以内の抗菌薬投与開始が予後改善に重要である. VCMは広域抗菌薬と併用してempiric therapyを開始し, LZDはVCMと有効性に差がないため通常はempiric therapyに用いない.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: TDM目標はAUCガイド',
        'TDMの指標はAUC/MICで, 目標AUCは400-600 μg・h/mL. トラフ値15-20 μg/mLを指標とするトラフガイド法は腎障害の発現率が高く, トラフはAUCの代替指標にならないためAUCガイドでの投与設計が推奨される.\n'
          '[出典] MRSA感染症 診療GL 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 初期負荷投与と採血タイミング',
        '初回負荷投与は25-30 mg/kg (実測体重) を1回, 維持量は15-20 mg/kg を12時間ごと (腎機能正常例では20 mg/kgとする報告もある). 初回TDMは投与3日目が基本だが, 重症/複雑性感染や腎機能低下例では定常状態前のTDMも考慮する.\n'
          '[出典] MRSA感染症 診療GL 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: PIPC/TAZ併用時のAKIリスク',
        'タゾバクタム/ピペラシリン, アミノグリコシド系薬, アムホテリシンB, 造影剤, NSAIDs, フロセミド等の併用でVCMによる腎機能低下のリスクが上昇するとの報告がある. 併用時は腎機能モニタリングを強化する.\n'
          '[出典] MRSA感染症 診療GL 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 投与速度とred man症候群',
        '急速に投与するとヒスタミン遊離による血圧低下等の投与時関連反応 (red man症候群) が発現することがあるため, 60分以上かけて点滴静注する.\n'
          '[出典] MRSA感染症 診療GL 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 術後感染予防(SSI予防)投与',
        'MRSA保菌患者やハイリスク手術 (心臓手術, 人工関節置換術, 脊椎インストゥルメンテーション等) でのSSI予防投与では, 執刀前1-2時間に投与を開始し1時間以上かけて点滴する. 通常単回投与とし, β-ラクタム系薬アレルギー以外はβ-ラクタム系薬を併用する.\n'
          '[出典] MRSA感染症 診療GL 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: MIC 2の菌血症は要注意',
        'VCMのMICが2 μg/mLの株はCLSI/EUCAST基準では感性と判定されるが, 臨床効果は期待できないとの報告が多い. MICが1 μg/mLを超えるMRSA菌血症では感染源のリスク評価のうえダプトマイシンへの変更が弱く推奨される.\n'
          '[出典] MRSA感染症 診療GL 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        'アナフィラキシー等重篤な過敏反応のリスクがあるため',
      ),
    ],
    cautiousUse: [
      '腎機能障害患者 (排泄遅延により過量蓄積, 腎毒性増強)',
      'アミノグリコシド系, ループ利尿薬等の腎毒性/第8脳神経毒性のある薬剤との併用患者',
      '高齢者 (生理機能低下により過量になりやすい)',
      '低出生体重児, 新生児, 乳児 (腎機能未熟)',
      '難聴の既往歴のある患者',
    ],
  ),
  Drug(
    name: 'テイコプラニン (TEIC)',
    brand: 'タゴシッド',
    category: DrugCategory.antimicrobial,
    spec: '注射用200mg/バイアル (400mgもあり)',
    dilution: '1バイアル (200mg) に注射用水または生理食塩液約5mLを加え, 泡立てないよう静かに溶解する (泡立つと力価が低下するため注意). その後100mL以上の生理食塩液等で希釈する.',
    concentration: '溶解液は概ね20mg/mL以下となるよう調製し, さらに100mL以上の輸液で希釈して30分以上かけて投与する',
    dose: '・成人: 初日400mg (力価) または800mg (力価, 重症・敗血症例) を2回に分けて投与し, 以後1日1回200mg (力価) または400mg (力価) を30分以上かけて点滴静注\n'
        '・小児: 10mg (力価) /kgを12時間毎に3回 (初日負荷投与), 以後6~10mg (力価) /kg (重症例では10mg (力価) /kg) を24時間毎に30分以上かけて点滴静注\n'
        '・初期の負荷投与を省略すると有効血中濃度到達が遅れるため, 重症感染症では必ず負荷投与を行う',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射用 (200mg/バイアル等) のみが国内にあり, 内服製剤はない.',
    ),
    spectrum: 'MRSA, MRCNS, PRSP等のグラム陽性球菌に有効. グラム陰性菌には無効.',
    renalAdjust: '中等度以上の腎機能障害 (CLcr低下) では維持投与の間隔を延長 (48時間毎など) または減量する. 添付文書の腎機能別投与法を参照し, TDM (トラフ値5~10μg/mL, 重症感染症では10μg/mL以上を目安) で確認する.',
    periop: '手術当日も通常継続する. VCMと異なり投与時間は30分以上でよく, red man症候群の頻度も低いため周術期の予防投与としても使いやすい. 腎機能に応じた維持量調整とTDMが重要であり, 周術期に急性腎障害 (出血, 造影剤, 低血圧等) が生じた場合は速やかに用量を再評価する.',
    mechanism: 'バンコマイシンと同様に細胞壁ペプチドグリカン前駆体のD-Ala-D-Alaに結合し, トランスペプチダーゼによる架橋形成を阻害して細胞壁合成を阻害する (殺菌的). 半減期が長く蛋白結合率が高いのが特徴.',
    packageInsertReviewed: true,
    packageInsertRevision: '先発品 (タゴシッド) ・後発品により改訂時期が異なる. 使用時は必ず最新の電子添文を確認すること.',
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00052365',
    notes: [
      DrugNote(
        '薬物動態',
        '終末半減期は約46~56時間と非常に長く, 蛋白結合率は約90%と高い. 主に腎排泄 (46~54%) される. 半減期が長いため定常状態到達に時間を要し, 重症例では負荷投与が必須.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        'VCMに比べ投与時間が短く (30分以上), red man症候群の頻度が低く, 腎障害の頻度もVCMより少ないとされる. 一方で組織移行や有効性のエビデンスはVCMほど蓄積していない領域もある.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '第8脳神経障害 (難聴), 急性腎障害, 中毒性表皮壊死融解症, 肝機能障害, 血小板減少等が報告されている.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        '半減期が非常に長いため, 一度過量になると副作用 (腎障害, 血球減少) が遷延しやすい. 周術期に腎機能が変動する患者では頻回のTDMと用量再評価が望ましい.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 半減期と負荷投与',
        '半減期85.7時間と非常に長い. 術前単回使用時は12mg/kgを執刀前に投与するが, 通常の負荷投与法では血中濃度が不十分となりやすく, 1回投与量の増量が必要との報告が多い.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 心臓・整形外科手術でのVCM代替',
        '心臓手術・人工関節置換術・脊椎インストゥルメンテーション手術でβ-ラクタムアレルギー時やMRSA対策としてVCMと並ぶ選択肢. 術翌日以降も使用する場合は通常維持量に切り替える.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: VCMの代替となる抗MRSA薬',
        '院内発症敗血症でMRSAをカバーする際, VCMの代替となる抗MRSA薬. TEIC 初日1回400mg・1日2回, 2日目以降400mg・1日1回点滴静注とし, TDMを実施する.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 初期ローディングが必須',
        '十分な治療効果を得るには投与初期のローディング (負荷投与) が必須で, 初期3日間の負荷投与を行う. TDMは定常状態に近づく投与4日目の実施が推奨される.\n'
          '[出典] MRSA感染症 診療GL 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 目標トラフ値',
        'TDMはトラフ値ガイドで行い, 非複雑性感染では目標トラフ値15-30 μg/mL, 重症例や複雑性感染では20-40 μg/mLとする. トラフ40 μg/mL以上で血小板減少や発熱, 60 μg/mL以上で腎障害の発現増加が報告されている.\n'
          '[出典] MRSA感染症 診療GL 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: VCMより低いred man症候群リスク',
        'VCMと比較しヒスタミン遊離作用が少なくred man症候群等の投与時関連反応のリスクが低い. 複数の比較試験のメタ解析でVCMより有意に腎障害の発現率が低いことも報告されている.\n'
          '[出典] MRSA感染症 診療GL 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: MRSA肺炎でのloading',
        'MRSA肺炎ではTEIC点滴静注を最初の2日間は1回400mg・1日2回でloadingし, 3日目以降は1回400mg・1日1回とする (添付文書上限は初日800mg, 以降400mg/日). VCM・TEICともにtrough 15-20μg/mLを目標にTDMを行う.\n'
          '[出典] JAID/JSC 呼吸器感染症GL 2014',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 心内膜炎でのtrough目標',
        'S. aureus心内膜炎にはトラフ値>20μg/mLが必要とされ, 初期は12mg/kgを12時間ごと3回負荷した後12mg/kg 24時間ごとへ切り替える. 各回1時間以上かけて点滴する.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 副作用',
        '高用量 (15mg/kg/日)では著明な血小板減少に注意する. 発熱などの過敏症は用量依存性 (3mg/kgで2.2%, 24mg/kgで8.2%)で, レッドネック (レッドマン)症候群の頻度はVCMより少ない.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 腎機能低下時の投与間隔',
        'CrCl 30-80では初回通常量投与後6-12mg/kg 48時間ごと, CrCl<30では初回通常量投与後6-12mg/kg 72時間ごとへ延長する (血液透析では血中からほとんど除去されない).\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        'アナフィラキシー等重篤な過敏反応のリスク',
      ),
    ],
    cautiousUse: [
      '腎機能障害患者 (排泄遅延, 過量蓄積)',
      'アミノグリコシド系等腎毒性/第8脳神経毒性のある薬剤との併用患者',
      '高齢者',
      '難聴の既往歴のある患者',
      '肝機能障害患者',
    ],
  ),
  Drug(
    name: 'リネゾリド (LZD)',
    brand: 'ザイボックス',
    category: DrugCategory.antimicrobial,
    spec: '注射液600mg (300mL/バッグ), 錠600mg',
    dose: '・成人・12歳以上小児: 1日1200mgを2回に分け, 1回600mgを12時間毎に30分~2時間かけて点滴静注または経口投与\n'
        '・12歳未満小児: 1回10mg/kgを8時間毎 (1回600mgを超えない)\n'
        '・投与期間は原則28日を超えない (28日超の安全性・有効性は確立していない)\n'
        '・腎機能・肝機能による用量調整は基本的に不要 (代謝物の蓄積は透析患者等で考慮)',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: true,
      summary: '注射液 (600mg/バッグ) と錠 (600mg) の両方が国内にある. 経口/静注のバイオアベイラビリティはほぼ同等 (経口生物学的利用率約100%) であり, 病状改善後は静注から経口へのスイッチ療法が可能. 細粒等の小児用剤形はない.',
    ),
    spectrum: 'MRSA, バンコマイシン耐性腸球菌 (VRE, E. faecium) を含むグラム陽性球菌に有効. グラム陰性菌には無効.',
    renalAdjust: '腎機能正常時と同一用量でよい (主要活性代謝物は腎排泄されるため, 高度腎障害・血液透析患者では代謝物蓄積の可能性があり注意, 透析日は透析後投与を考慮する).',
    periop: '手術当日も基本的に継続する. 周術期に併用しやすいオピオイド (フェンタニル, ペチジン, トラマドール) やセロトニン作動性制吐薬 (オンダンセトロン等) はセロトニン症候群のリスクを高めるため, LZD投与中の患者では薬剤選択 (特にペチジンやトラマドールの反復使用) に注意し, 錯乱・振戦・高体温等の徴候があれば速やかに中止する. MAO阻害様作用により昇圧薬 (アドレナリン, ノルアドレナリン等) への反応が増強される可能性があるため, 周術期の血圧管理では少量から漸増する.',
    mechanism: '細菌リボソーム50Sサブユニットの23S rRNA (開始因子複合体形成部位) に結合し, mRNA翻訳の開始段階を阻害してタンパク質合成を阻害する (他の蛋白合成阻害薬と作用点が異なり交差耐性が少ない).',
    packageInsertReviewed: true,
    packageInsertRevision: '先発品 (ザイボックス, ファイザー) が中心. 使用時は必ず最新の電子添文を確認すること.',
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00047838',
    notes: [
      DrugNote(
        '薬物動態',
        '経口生物学的利用率は約100%と極めて高く, 半減期は健康成人で約5時間 (日本人健康成人5.3±0.6時間), 血漿蛋白結合率は約31%. 主に非酵素的酸化により代謝され, 尿中に未変化体約30%, 代謝物として排泄される.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        'MRSAだけでなくVREにも有効な数少ない薬剤であり, 組織移行 (肺, 皮膚軟部組織) が良好. 経口/静注の切り替えが容易でスイッチ療法に適する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '可逆性の骨髄抑制 (血小板減少症11.9%等, 長期投与で頻度上昇), 乳酸アシドーシス (代謝性アシドーシス), 末梢神経障害・視神経症 (28日超投与で視力喪失に進行する可能性), セロトニン症候群, 偽膜性大腸炎等.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        'セロトニン症候群のリスクから術前にSSRI等の中止可否が話題になることがあるが自己判断で中止しない. 血小板減少がある場合は硬膜外/脊髄くも膜下麻酔等の区域麻酔前に血小板数を確認する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: CRBSIの第二選択, empiricには非推奨',
        'CRBSIのempiric therapy第二選択: LZD 1回600mg・1日2回点滴静注. 過去の臨床試験でVCMとの有効性に差はなく, empiric therapyでのルーチン使用は推奨されない.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 経口switch therapyに適する',
        '経口薬のバイオアベイラビリティが極めて高く, 静注薬と遜色ない血中濃度が得られるため, 全身状態が改善した患者で注射薬から経口薬へのswitch therapyに適する.\n'
          '[出典] 抗菌薬適正使用支援(AS)ガイダンス 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 長期投与と血小板減少',
        '投与期間が14日間を超えると血小板減少の頻度が増加するため, 投与中は週1回程度の血液検査の実施が望ましい. 28日を超えて投与した場合は視神経障害があらわれることがある.\n'
          '[出典] MRSA感染症 診療GL 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 経口/静注のstep down',
        '点滴静注用剤・経口剤ともに1回600 mgを1日2回投与する. 経口剤の生物学的利用率はほぼ100%で食事の影響を受けないため, 病状安定後は経口剤へのstep downが行いやすい.\n'
          '[出典] MRSA感染症 診療GL 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 腎機能低下例とRFP併用',
        '腎機能低下患者では血小板減少の発現頻度が高まるとの報告があり, 副作用の観察を十分に行い慎重に投与する. リファンピシンとの併用ではLZDの血漿中濃度が低下するとの報告がある.\n'
          '[出典] MRSA感染症 診療GL 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: セロトニン症候群と適応外',
        'セロトニン作動薬との併用でセロトニン症候群 (錯乱, せん妄, 情緒不安, 振戦, 潮紅, 発汗, 高熱) がまれに報告されている. LZDは感染性心内膜炎には適応がない.\n'
          '[出典] MRSA感染症 診療GL 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: IVから経口へのスイッチ',
        '生体利用率が高く経口薬でも静注とほぼ同等の血中濃度が得られるため, 速やかな改善が見られれば経口へのスイッチが可能. MRSA肺炎の第一選択の一つとして600mg 1日2回, 点滴静注または経口で用いる.\n'
          '[出典] JAID/JSC 呼吸器感染症GL 2014',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 人工物感染での併用',
        '人工関節・脊椎インプラント感染では600mg 12時間ごと (静注/経口)にRFP 300mg 1日2回を併用すると再発率が減少するとされる.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 小児量',
        '小児のMRSA骨髄炎/髄膜炎では10mg/kg 8時間ごと (静注または経口)が用いられ, 重症のペニシリンアレルギーがある新生児ではLZD+AZTが代替として挙げられている.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        '過敏反応のリスク',
      ),
    ],
    cautiousUse: [
      'SSRI, SNRI, 三環系抗うつ薬, トリプタン系薬剤, ペチジン, メサドン, トラマドール等セロトニン作動性薬剤との併用中の患者 (セロトニン症候群リスク)',
      'MAO阻害薬 (セレギリン等) やアドレナリン作動薬併用患者 (血圧上昇, 動悸)',
      '血液毒性 (血小板減少等) のリスクがある患者, 特に14日を超える長期投与例',
      '高チラミン食品の大量摂取 (通常量なら問題ないが血圧上昇のリスク)',
      '末梢神経障害/視神経障害の既往がある患者 (長期投与で視神経症のリスク)',
    ],
  ),
  Drug(
    name: 'ダプトマイシン (DAP)',
    brand: 'キュビシン',
    category: DrugCategory.antimicrobial,
    spec: '静注用350mg/バイアル (500mgもあり)',
    dose: '・敗血症, 感染性心内膜炎: 成人1日1回6mg/kgを24時間毎に30分かけて点滴静注\n'
        '・深在性皮膚感染症等: 成人1日1回4mg/kgを24時間毎に30分かけて点滴静注\n'
        '・小児 (敗血症): 年齢により7mg/kg (12~18歳) ~12mg/kg (1~7歳), 30~60分かけて点滴静注\n'
        '・小児 (皮膚軟部組織感染症等): 年齢により5mg/kg (12~18歳) ~10mg/kg (1~2歳未満)\n'
        '・肺炎には使用しないこと (肺サーファクタントにより不活化され無効)',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '静注用 (350mg/バイアル) のみが国内にあり, 内服製剤はない.',
    ),
    spectrum: 'MRSAを含むグラム陽性球菌 (黄色ブドウ球菌, 腸球菌等) に有効. グラム陰性菌には無効.',
    renalAdjust: 'CLcr 30mL/min未満の高度腎機能障害患者では投与間隔を24時間毎から48時間毎に延長する. 血液透析患者では可能な場合透析後に投与し, 週3回投与とすることがある.',
    periop: '手術当日も継続するが, 肺炎 (誤嚥性肺炎含む) には無効なため周術期に肺炎を合併・疑う場合は本剤を継続せず他剤へ変更する. 週1回以上のCK測定を継続し, 周術期に横紋筋融解症のリスクとなる不動化・脱水・スタチン併用がある場合は特に注意する. 好酸球性肺炎は投与2~4週後に発症しうるため, 術後に原因不明の発熱・低酸素血症が出た場合の鑑別に入れる.',
    mechanism: 'カルシウム依存性に細菌の細胞膜に結合し, 膜を脱分極させてカリウム流出を引き起こし細胞膜機能を破壊する (濃度依存性殺菌作用). 肺サーファクタントにより不活化されるため肺炎には無効である.',
    packageInsertReviewed: true,
    packageInsertRevision: '先発品 (キュビシン, MSD). 使用時は必ず最新の電子添文を確認すること.',
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00059760',
    notes: [
      DrugNote(
        '薬物動態',
        '半減期は約9~10時間 (単回投与時), 血漿蛋白結合率は90~93% (濃度非依存的). 主に腎排泄 (未変化体として約73%) される.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        '濃度依存性の殺菌作用を示す環状リポペプチド系抗菌薬で, MRSA菌血症/感染性心内膜炎に用いられる. 肺サーファクタントに結合し不活化されるため肺炎には無効という際立った特徴を持つ.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        'CK上昇, ミオパチー・横紋筋融解症 (週1回以上のCKモニタリングが必須), 好酸球性肺炎, 末梢神経障害等.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        '横紋筋融解症のマーカーであるCK上昇と, 手術・体位・止血帯等による筋原性CK上昇との鑑別に注意する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: MRSA敗血症/CRBSIの第一選択',
        'MRSAによる敗血症やCRBSIの第一選択薬の一つ. DAP 1回6mg/kg・1日1回, 24時間ごとに緩徐に静注または30分かけて点滴静注する. 適応菌種はMRSAのみで, 肺炎を合併する例には選択できない.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 肺炎には無効(適応なし)',
        '肺サーファクタントと結合する性質があるため肺炎に対して有効性を期待できず, DAPはMRSA肺炎に適応がない.\n[出典] MRSA感染症 診療GL 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: CK値の定期モニタリング',
        '骨格筋への影響が知られているため, DAP治療中は週1回以上のCK値のモニタリングを行う. 腎機能障害例やHMG-CoA還元酵素阻害薬 (スタチン) の前治療・併用例ではさらに頻回にモニタリングする.\n'
          '[出典] MRSA感染症 診療GL 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 菌血症・心内膜炎の用量',
        '非複雑性の成人菌血症では6 mg/kg 1日1回が第一選択. 感染性心内膜炎や複雑性菌血症で耐性化抑止と有効性向上を狙う場合は8-10 mg/kgの高用量投与 (保険適応外) を考慮する.\n'
          '[出典] MRSA感染症 診療GL 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 皮膚軟部組織感染症の用量',
        '皮膚軟部組織感染症では4 mg/kgを1日1回点滴静注/静注する. Sepsis/敗血症性ショック, 壊死性筋膜炎, 重症熱傷, 骨髄炎合併等の重症例では6-8 mg/kg/日の高用量投与を考慮する.\n'
          '[出典] MRSA感染症 診療GL 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: MRSA肺炎には無効',
        '肺サーファクタントで不活化されるためMRSA肺炎には使用してはならない. ただし敗血症性肺塞栓症はこの限りではない.\n[出典] JAID/JSC 呼吸器感染症GL 2014',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 心内膜炎/VRE菌血症での高用量',
        '右心系・左心系心内膜炎では8-10mg/kg/日の高用量投与が奏効した症例シリーズが報告されている. VRE菌血症ではレトロスペクティブ研究で10mg/kg/日の用量のほうが標準用量より生存率が高かった.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 腎機能低下時の用量',
        'CrCl 30-90では4-6mg/kg 24時間ごとのまま, CrCl<30では6mg/kg 48時間ごとへ延長する. 血液透析日は透析後投与とし, 透析中に投与する場合は7-9mg/kgを考慮する.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 難治性MRSA菌血症でのサルベージ',
        'DAP+Ceftarolineの併用は, 治療抵抗性MRSA菌血症に対するサルベージ治療として有効な可能性が報告されている.\n[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        '過敏反応のリスク',
      ),
    ],
    cautiousUse: [
      '腎機能障害患者 (排泄遅延, 蓄積によるミオパチーリスク増加)',
      'HMG-CoA還元酵素阻害薬 (スタチン) 等ミオパチーを起こしうる薬剤との併用患者 (横紋筋融解症リスク上昇, 可能なら休薬を検討)',
      '高齢者',
      '末梢神経障害の既往がある患者',
    ],
  ),
  Drug(
    name: 'アルベカシン (ABK)',
    brand: 'ハベカシン',
    category: DrugCategory.antimicrobial,
    spec: '注射液25mg, 75mg, 100mg, 200mg (力価)',
    dilution: '添付溶解液または生理食塩液等で溶解し, 100mL前後の輸液で希釈して30分~2時間かけて点滴静注する.',
    dose: '・成人: 1日1回150~200mg (力価) を30分~2時間かけて点滴静注\n'
        '・小児: 1日1回4~6mg (力価) /kgを30分かけて点滴静注\n'
        '・腎機能障害患者は投与量・間隔を減量/延長して調整する',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射液 (25/75/100/200mg) のみが国内にあり, 内服製剤はない (アミノグリコシド系は消化管からほとんど吸収されないため経口製剤が存在しない).',
    ),
    spectrum: 'MRSAに限定した適応 (適応症も敗血症, 肺炎のみ). 一般のグラム陰性桿菌感染症には他のアミノグリコシドほど汎用されない.',
    renalAdjust: '腎機能低下例では投与量減量または投与間隔延長が必要. TDM (ピーク, トラフ) に基づき調整する.',
    periop: 'MRSA感染症 (敗血症, 肺炎) 治療中は手術当日も継続する. 本剤とベクロニウム等の非脱分極性筋弛緩薬は互いに神経筋遮断作用を増強し, 術後の遷延性呼吸抑制・抜管遅延の原因となり得るため, 周術期に新規開始・増量する場合は筋弛緩モニタリング (TOF等) を用いて残存筋弛緩がないことを確認してから抜管する. 腎毒性のある造影剤, NSAIDs, VCM等との併用時は腎機能を要フォローする.',
    mechanism: '細菌リボソーム30Sサブユニットに結合しmRNAの誤読・タンパク質合成阻害を引き起こす (濃度依存性殺菌作用, post-antibiotic effectを有する).',
    packageInsertReviewed: true,
    packageInsertRevision: '先発品 (ハベカシン, Meiji Seikaファルマ) ・後発品あり. 使用時は必ず最新の電子添文を確認すること.',
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00054512',
    notes: [
      DrugNote(
        '薬物動態',
        '健康成人に200mgを30分点滴投与時, 最高血中濃度約13.2μg/mL, 半減期約2.3時間. 主に腎排泄 (24時間尿中排泄率約80%) される.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        '国内で開発されたMRSA専用のアミノグリコシド系抗生物質で, 濃度依存性殺菌作用とpost-antibiotic effectを有し1日1回投与が基本. 適応はMRSAによる敗血症・肺炎に限定される.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '第8脳神経障害 (めまい, 耳鳴, 耳閉感, 難聴), 急性腎障害等の腎障害が主な重大な副作用.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        'TDM目安はピーク9~20μg/mL, トラフ2μg/mL未満 (トラフが繰り返し2μg/mL以上となると腎障害/第8脳神経障害のリスクが増大). 周術期の輸液管理による腎機能変動でトラフが上昇しやすいため注意する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: MRSA肺炎での位置づけとTDM',
        'MRSA肺炎の第二選択薬として1回300mg・1日1回点滴静注で用いる. TDMでトラフ値が2μg/mL以下になるよう調整する.\n'
          '[出典] JAID/JSC 呼吸器感染症GL 2014',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 小児量',
        '小児では重症度によらず4-6mg/kg・1日1回点滴静注が用いられる (膿瘍形成がなければ有効とされる).\n[出典] JAID/JSC 呼吸器感染症GL 2014',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 院内発症敗血症の抗MRSA薬選択肢',
        '院内発症敗血症でMRSAが否定できない場合, VCM/TEICと並ぶ抗MRSA薬の選択肢. ABK 1回200mg・1日1回点滴静注(小児では4-6mg/kg・1日1回)とし, TDMでピーク/トラフ値を確認する.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: ピーク値/トラフ値の目標',
        '1日1回投与とし, TDMはトラフ値<2 μg/mL (腎障害回避), ピーク値≧15 μg/mLを目標とする. 初回TDMは投与2日目の実施が推奨される.\n'
          '[出典] MRSA感染症 診療GL 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 適応と副作用',
        '国内での適応は敗血症・肺炎に限定される. 主な副作用は腎障害と第8脳神経障害 (聴覚・平衡覚障害) で, 血中トラフ濃度2 μg/mL以上が繰り返されると腎障害発現の危険性が大きくなる.\n'
          '[出典] MRSA感染症 診療GL 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分, 他のアミノグリコシド系抗生物質またはバシトラシンに対し過敏症の既往歴のある患者',
        '交差過敏反応のリスク',
      ),
    ],
    cautiousUse: [
      '腎機能障害患者 (蓄積による腎毒性/第8脳神経毒性増強)',
      '難聴等の第8脳神経障害の既往がある患者',
      '重症筋無力症の患者 (神経筋遮断作用の増強)',
      '非脱分極性筋弛緩薬 (ベクロニウム等) や吸入麻酔薬併用患者 (呼吸抑制増強)',
      '高齢者',
    ],
  ),
  Drug(
    name: 'アミカシン (AMK)',
    brand: 'アミカシン硫酸塩 (後発品中心: 日医工, サワイ, 明治, 富士製薬等)',
    category: DrugCategory.antimicrobial,
    spec: '注射液100mg, 200mg (力価)',
    dilution: '点滴静脈内投与の場合, 通常100~500mLの補液中に100~200mg (力価) の割合で溶解し, 30分~1時間かけて投与する.',
    dose: '・筋肉内投与: 成人1回100~200mg (力価) を1日1~2回, 小児1日4~8mg (力価) /kgを1日1~2回\n'
        '・点滴静脈内投与: 成人1回100~200mg (力価) を1日2回, 小児1日4~8mg (力価) /kgを1日2回, 100~500mLの輸液に溶解し30分~1時間かけて投与\n'
        '・添付文書上の承認用法は分割投与だが, 近年は有効性・安全性の観点から1日1回の高用量投与 (拡大間隔投与, 15~20mg/kg/日程度) がガイドラインで推奨されており, TDMに基づく個別化が広く行われている',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射液 (筋注用/点滴静注用, 100mg/200mg) のみが国内にあり, 内服製剤はない.',
    ),
    spectrum: '緑膿菌を含むグラム陰性桿菌に強い活性を持ち, ゲンタマイシン/トブラマイシン耐性菌にも有効なことがある. 一部グラム陽性菌 (黄色ブドウ球菌等) にも活性.',
    renalAdjust: '腎機能低下患者では投与量減量または投与間隔延長が必要. TDM (ピーク値35μg/mL未満, トラフ値10μg/mL未満を目安) を行い, 超過時は減量・間隔延長する.',
    periop: '手術当日も治療スケジュールに沿って継続する. 麻酔薬 (特に吸入麻酔薬) や非脱分極性筋弛緩薬との併用で神経筋遮断作用が増強し呼吸抑制を来しうるため, アミカシン投与中の患者では筋弛緩薬を減量し, 筋弛緩モニタリングを行った上で抜管前に十分な拮抗/回復を確認する. 周術期の脱水・低血圧・造影剤使用は腎毒性を増強するため輸液管理に注意する.',
    mechanism: '細菌リボソーム30Sサブユニットに結合しタンパク質合成を阻害する (濃度依存性殺菌作用). ゲンタマイシン等を修飾する不活化酵素の多くに対し安定なため耐性菌に有効な場合がある.',
    packageInsertReviewed: true,
    packageInsertRevision: '後発品が中心で製品ごとに改訂時期が異なる. 使用時は必ず最新の電子添文を確認すること.',
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00059742',
    notes: [
      DrugNote(
        '薬物動態',
        '半減期は健康成人で約1.7~2.2時間, 主に腎排泄 (8時間までの尿中排泄率約70~72%) される. 蛋白結合率は低い.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        'アミノグリコシド系の中でも修飾酵素に対し比較的安定であり, 他のアミノグリコシド耐性のグラム陰性桿菌感染症 (緑膿菌等) にも使用される.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '急性腎障害等の腎障害, 第8脳神経障害 (難聴, 耳鳴, めまい), 神経筋遮断作用による呼吸抑制.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        'TDMのトラフ値目標は投与法 (分割投与か拡大間隔投与か) により異なるため, 周術期に投与法を変更する場合は薬剤師と連携してTDM計画を再設定する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 尿路性敗血症/複雑性UTIでの位置づけ',
        '複雑性尿路感染症・尿路性敗血症の第二選択としてAMK 15mg/kg 1日1回筋注/点滴静注を用いる. β-ラクタム耐性菌が疑われる重症例では, 培養結果が判明するまでアミノグリコシド系薬を併用しておいた方が安全とされる.\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 脳室内投与量',
        '髄膜炎/シャント感染への脳室内投与量はAMK 30mgが目安. 投与回数は髄液排液量に応じて調整し, 排液が多いほど増量/頻回とする.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 安全域の狭さ',
        'アミノグリコシド系は安全域が狭く, 腎機能低下時には特に注意が必要である. 必要に応じてTDMを施行する.\n[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 緑膿菌CRBSIでβ-ラクタムに併用',
        '緑膿菌によるCRBSIのdefinitive therapyでβ-ラクタム系薬に併用を考慮する. AMK 1回15mg/kg・1日1回点滴静注.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分, 他のアミノグリコシド系抗生物質またはバシトラシンに対し過敏症の既往歴のある患者',
        '交差過敏反応のリスク',
      ),
    ],
    cautiousUse: [
      '腎機能障害患者',
      '第8脳神経障害の既往がある患者',
      '重症筋無力症の患者',
      '非脱分極性筋弛緩薬併用患者 (呼吸抑制増強)',
      '高齢者',
      '脱水患者 (腎血流低下で腎毒性増強)',
    ],
  ),
  Drug(
    name: 'ゲンタマイシン (GM)',
    brand: 'ゲンタシン (注射液)',
    category: DrugCategory.antimicrobial,
    spec: '注射液10mg, 40mg, 60mg',
    dose: '・成人: 1日3mg (力価) /kgを3回に分割し筋肉内注射または点滴静注. 重症例では1日5mg (力価) /kgを限度に3~4回に分割\n'
        '・小児: 1回2.0~2.5mg (力価) /kgを1日2~3回, 点滴時は30分~2時間かけて投与\n'
        '・添付文書上は分割投与が基本だが, 実臨床 (特に敗血症等の重症感染症) ではPK/PDの観点から1日1回投与 (拡大間隔投与) がガイドラインで広く推奨されており, TDMを併用して調整する',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射液 (10mg/40mg/60mg) が国内にある. 軟膏, クリーム, 点眼液等の外用剤は別製剤であり, 全身投与できるのは注射液のみ.',
    ),
    spectrum: '緑膿菌を含むグラム陰性桿菌および黄色ブドウ球菌等に活性. 腸球菌にはβラクタム系との併用で相乗効果.',
    renalAdjust: '腎機能低下患者では投与量減量または投与間隔延長が必要. 半減期は腎機能正常者で約2.2~4.3時間だが, 腎障害例では著明に延長する (例: 7時間程度).',
    periop: '手術当日も治療目的の投与は継続する. 麻酔薬・筋弛緩薬との併用で神経筋遮断作用が増強され, 術後の遷延性呼吸抑制のリスクとなるため, 筋弛緩モニタリングを行い残存筋弛緩がないことを確認してから抜管する. 消化器外科等の術野汚染リスクが高い手術で単回予防投与に用いられることもあるが, その場合は執刀前の適切なタイミングでの投与が必要である.',
    mechanism: '細菌リボソーム30Sサブユニットに結合しタンパク質合成を阻害する (濃度依存性殺菌作用, post-antibiotic effectを有する).',
    packageInsertReviewed: true,
    packageInsertRevision: '先発品 (ゲンタシン) ・後発品あり. 使用時は必ず最新の電子添文を確認すること.',
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00051220',
    notes: [
      DrugNote(
        '薬物動態',
        '腎機能正常成人で半減期約2.2~4.3時間, 主に尿中排泄 (6時間以内に83~96.5%) される. 組織移行は概ね良好だが髄液移行は不良.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        '古くから使用されるアミノグリコシド系の代表薬で, 緑膿菌を含むグラム陰性桿菌感染症やβラクタム系との併用による腸球菌性心内膜炎治療に用いられる.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '急性腎障害等の腎障害, 第8脳神経障害 (めまい, 耳鳴, 難聴), 神経筋遮断作用増強による呼吸抑制.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        '腎毒性・耳毒性は蓄積性かつ不可逆的になり得るため, 周術期に反復投与や他の腎毒性薬剤 (VCM, NSAIDs, 造影剤) と重複させる場合は腎機能を頻回にモニタリングする.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 腸球菌性心内膜炎での相乗効果用量',
        '腸球菌性心内膜炎の相乗効果目的では低用量のGM 1mg/kg 8時間ごとを併用する (治療用量ではない). ABPC+GM併用2週間後にABPC単独へ切り替える方法は, 標準的な4-6週間併用と同等の有効性で毒性が少ないとの報告がある.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 腎障害/聴神経障害リスク時の代替',
        '腎機能低下や第8脳神経障害のリスクがある場合はGM併用よりABPC+CTRXを優先する. VCM+GM併用は腎毒性が強く, 可能であればペニシリン脱感作を検討する.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 新生児敗血症/髄膜炎の経験的治療',
        '新生児の重症敗血症/髄膜炎の経験的治療にはABPC+CTX+GM (2.5mg/kg 8時間ごとまたは5-7mg/kg 24時間ごと)が用いられる.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 脳室内投与量',
        '髄膜炎/シャント感染への脳室内投与量は成人4-8mg, 乳児/小児1-2mgが目安. 髄液排液量が多いほど投与間隔を短縮または増量する.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 標準用量と肥満時の調整',
        '1回投与量5mg/kg. 肥満患者では理想体重に超過体重×0.4を加えた調整体重を用いて用量を決定する.\n[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 半減期と心臓手術での減量',
        '半減期2~3時間, 再投与間隔5時間 (腎機能正常) . 人工心肺使用時は排泄が遅延するため, 1回投与量を4mg/kgへ減量する.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: Enterococcus感染でVCMに併用',
        'ABPC耐性かつVCM感受性のEnterococcusによるCRBSIでVCMに併用することがある: GM 1回60mg・1日3回点滴静注. 腎機能障害のリスクからβ-ラクタム系薬へのルーチン併用は推奨されていない.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: IEでのVCM併用の可否',
        '感染性心内膜炎で自己弁の場合, VCMとGMの併用は推奨されない. 人工弁心内膜炎ではVCM+GMの2剤にさらにRFPを加えた3剤併用療法が行われることがある.\n'
          '[出典] MRSA感染症 診療GL 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤, 他のアミノグリコシド系抗生物質またはバシトラシンに対し過敏症の既往歴のある患者',
        '交差過敏反応のリスク',
      ),
    ],
    cautiousUse: [
      '腎機能障害患者',
      '高齢者',
      '第8脳神経障害の既往がある患者',
      '重症筋無力症の患者',
      '麻酔薬・非脱分極性筋弛緩薬併用患者 (呼吸抑制増強)',
    ],
  ),
  Drug(
    name: 'トブラマイシン (TOB)',
    brand: 'トブラシン (注射液)',
    category: DrugCategory.antimicrobial,
    spec: '注射液60mg, 90mg, 小児用10mg',
    dose: '・成人: 1日120~180mg (力価) を2~3回に分割し筋肉内注射または点滴静注 (点滴時間30分~2時間)\n'
        '・小児: 1日3mg (力価) /kgを2~3回に分割投与\n'
        '・実臨床では他のアミノグリコシドと同様, 重症感染症では1日1回投与 (拡大間隔投与) がガイドラインで推奨されPK/PDに基づき調整される',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射液 (60mg/90mg/小児用10mg) が国内にある (点眼液は別製剤). なお製造ライン事情により出荷停止・供給不安定となった時期があるため, 使用時は入手可能性を確認すること.',
    ),
    spectrum: '緑膿菌を含むグラム陰性桿菌に活性 (ゲンタマイシンと同等かやや強い抗緑膿菌活性).',
    renalAdjust: '腎機能低下患者では投与量減量または投与間隔延長が必要 (腎障害患者では半減期が著明に延長する).',
    periop: '手術当日も治療目的の投与は継続するが, 出荷停止等で入手できない場合は他のアミノグリコシド (アミカシン等) への変更を検討する. 麻酔薬・筋弛緩薬との相互作用 (神経筋遮断増強) は他のアミノグリコシドと同様に想定し, 周術期に使用する場合は筋弛緩モニタリングを行う.',
    mechanism: '細菌リボソーム30Sサブユニットに結合しタンパク質合成を阻害する (濃度依存性殺菌作用).',
    packageInsertReviewed: true,
    packageInsertRevision: '先発品 (トブラシン). 東和薬品による製造ライン一時停止 (2023年8月) に伴う出荷停止情報あり, 使用時は必ず最新の入手可能性・電子添文を確認すること.',
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00048522',
    notes: [
      DrugNote(
        '薬物動態',
        '健康成人に90mgを筋注後, 最高血中濃度約5.28μg/mL, 半減期約1.4時間. 腎機能正常者では8時間で尿中排泄率約70%以上.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        'ゲンタマイシンと同様の適応を持つアミノグリコシド系抗生物質で, 緑膿菌感染症に用いられる. 点眼液等の外用剤は別途流通しているが全身投与できるのは注射液のみ.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '急性腎障害等の腎障害, 第8脳神経障害 (めまい, 耳鳴, 難聴), ショック (頻度0.1%未満).',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        '近年供給不安定の報告があるため, 周術期に本剤を計画使用する場合は事前に薬剤部へ在庫確認することが望ましい.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 小児の緑膿菌CRBSIで併用',
        '小児のP.aeruginosaによるCRBSIでβ-ラクタム系薬に併用することがある. TOB 1回2-2.5mg/kg・1日3回点滴静注.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 緑膿菌性心内膜炎/グラム陰性菌感染での位置づけ',
        'P. aeruginosaによる感染性心内膜炎やグラム陰性菌感染では, アミノグリコシド系の中でもTOBがβ-ラクタム系 (CFPMまたはMEPM)との併用薬として選択されることが多い.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 脳室内投与量',
        '髄膜炎/シャント感染への脳室内投与量はTOB 5-20mgが目安で, 髄液排液量に応じて投与回数を調整する.\n[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤, 他のアミノグリコシド系抗生物質またはバシトラシンに対し過敏症の既往歴のある患者',
        '交差過敏反応のリスク',
      ),
    ],
    cautiousUse: [
      '腎機能障害患者',
      '高齢者',
      '第8脳神経障害の既往がある患者',
      '重症筋無力症の患者',
      '麻酔薬・非脱分極性筋弛緩薬併用患者 (呼吸抑制増強のおそれ, アミノグリコシド系のクラス効果)',
    ],
  ),
  Drug(
    name: 'ストレプトマイシン (SM)',
    brand: 'ストレプトマイシン硫酸塩 (注射用, 明治等)',
    category: DrugCategory.antimicrobial,
    spec: '注射用1g/バイアル (用時溶解)',
    dose: '・結核: 成人1日1g (力価) を筋肉内注射 (高齢者60歳以上は1回0.5~0.75g)\n'
        '・非結核性抗酸菌症 (MAC症含む): 成人1日0.75~1g (力価) を週2~3回筋肉内注射\n'
        '・感染性心内膜炎 (腸球菌等, ペニシリン/アンピシリン併用): 添付文書の用法に準じ主治医の判断で用量調整\n'
        '・その他感染症 (ペスト, 野兎病, ワイル病等): 成人1日1~2g (力価) を1~2回に分割筋肉内注射',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射用 (筋肉内注射用) のみが国内にある. 内服製剤はない. 添付文書上の用法は筋肉内注射に限定されており, 静脈内注射 (静注・点滴静注) としての承認された用法はない点に注意 (他のアミノグリコシドと異なり緊急時にも静脈内投与はできない).',
    ),
    spectrum: '結核菌, MAC等の非結核性抗酸菌, ペスト菌, 野兎病菌, レプトスピラ等. 腸球菌性感染性心内膜炎にはペニシリン/アンピシリンとの併用で使用.',
    renalAdjust: '腎機能低下患者では投与量減量または投与間隔延長 (週1~2回投与への変更等) が必要.',
    periop: '結核治療中の患者では手術のために自己判断で中断せず, 主治医 (呼吸器内科等) と相談の上, 可能な限り継続する (中断は治療失敗・耐性化のリスクを高める). 筋注のみのため周術期の絶食・意識レベル低下下でも投与経路自体には影響しないが, 他のアミノグリコシド同様, 麻酔薬・筋弛緩薬との相互作用 (神経筋遮断増強) に注意し, 筋弛緩モニタリングを行う. 結核患者の周術期は感染対策 (空気予防策) も重要である.',
    mechanism: '細菌リボソーム30Sサブユニットに結合しタンパク質合成を阻害する (殺菌的). 抗結核薬としては細胞壁合成阻害薬ではなく蛋白合成阻害薬に分類される.',
    packageInsertReviewed: true,
    packageInsertRevision: '明治製「ストレプトマイシン硫酸塩注射用1g」等. 使用時は必ず最新の電子添文を確認すること.',
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00071158',
    notes: [
      DrugNote(
        '薬物動態',
        '筋注後の最高血中濃度は0.5g投与時25~30μg/mL, 1g投与時約40μg/mL程度で, 5時間程度で約半減する. 尿中排泄率は24時間で約50~75%.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        'アミノグリコシド系の中でも古くから抗結核薬として用いられ, 現在も多剤耐性結核や非結核性抗酸菌症の治療に位置づけられる. 感染性心内膜炎の腸球菌治療ではペニシリン系との併用で相乗効果を狙って使用されることがある (現在はゲンタマイシンが優先されることが多い).',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '第8脳神経障害 (難聴, 耳鳴, めまい, 5%以上と高頻度), 急性腎障害, アナフィラキシー, 中毒性表皮壊死融解症, 間質性肺炎.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        '静脈内投与の用法が承認されていないため, 緊急時や経口摂取不可の周術期であっても投与経路は筋注に限られる点に留意する (出血傾向がある患者では筋注部位からの出血・血腫にも注意する).',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: GM耐性腸球菌性心内膜炎での併用',
        'GM耐性だがSM感受性の腸球菌性心内膜炎では, (ABPC 2g 4時間ごとまたはPCG 2400万単位)+SM 15mg/kg 24時間ごとを4-6週間投与する. 相乗効果目的で併用する前にSMのMICを確認しておく必要がある.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 腎機能低下/聴神経障害リスク時の代替',
        'CrCl<50mL/分や第8脳神経障害のリスクがある場合はSM併用よりABPC+CTRXを優先する (ただしE. faeciumへの有効性は確立されていない).\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤, 他のアミノグリコシド系抗生物質またはバシトラシンに対し過敏症の既往歴のある患者',
        '交差過敏反応のリスク',
      ),
    ],
    cautiousUse: [
      '腎機能障害患者',
      '第8脳神経障害 (前庭・蝸牛) の既往がある患者',
      '重症筋無力症の患者',
      '妊婦 (胎児の第8脳神経障害のリスク, 治療上の有益性が危険性を上回る場合のみ投与)',
      '麻酔薬・非脱分極性筋弛緩薬併用患者 (呼吸抑制増強)',
    ],
  ),
  Drug(
    name: 'クラリスロマイシン (CAM)',
    brand: 'クラリシッド/クラリス',
    category: DrugCategory.antimicrobial,
    concentration: '該当なし (内服剤のみ, 注射剤は国内未承認)',
    dose: '・一般感染症: 通常成人1日400mg (力価) を2回に分割経口投与\n'
        '・非結核性抗酸菌症: 1日400~800mg (力価) を分1~2\n'
        '・H. ピロリ除菌: クラリスロマイシン1回200mg + アモキシシリン1回750mg + PPIを1日2回7日間, 除菌不成功例は1回400mgへ増量可\n'
        '・小児用量はドライシロップで別途規定',
    forms: DrugFormAvailability(
      hasInjection: false,
      hasOral: true,
      summary: '国内に注射剤 (静注) は存在しない. 経口剤 (錠200mg, ドライシロップ小児用10%) のみ. 緊急時の静注はできない.',
    ),
    spectrum: '肺炎球菌, 溶血性レンサ球菌等のグラム陽性球菌, インフルエンザ菌等一部グラム陰性桿菌, マイコプラズマ, クラミジア, レジオネラ等の非定型病原体, 非結核性抗酸菌, ヘリコバクター・ピロリ',
    renalAdjust: '高度腎機能障害 (CCr<30) では投与量・投与間隔に留意し減量を考慮する',
    periop: '経口剤のみで緊急静注は不可. 継続中の感染症治療目的であれば当日朝まで内服可とし, 絶飲食で内服できない期間は中断, 術後速やかに再開する. 最大の注意点はCYP3A4/P糖蛋白質の強力な阻害作用で, ミダゾラム, フェンタニル, カルシウム拮抗薬, タクロリムス等の血中濃度が上昇し作用が増強するおそれがあるため, 併用薬の減量や慎重なモニタリングを要する. QT延長薬 (オンダンセトロン, ドロペリドール等の制吐薬含む) との併用でTdPリスクが加算される可能性があり, 術中心電図モニタリングに留意する.',
    mechanism: '細菌の50Sリボソームサブユニットに結合し蛋白合成を阻害する (静菌的, 高濃度では殺菌的).',
    packageInsertReviewed: true,
    packageInsertRevision: '2026年03月17日 改訂版 (クラリシッド錠200mg)',
    packageInsertUrl: 'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/530213_6149003F2020_3_05',
    notes: [
      DrugNote(
        '薬物動態',
        '主にCYP3A4で代謝され, かつCYP3A4/P糖蛋白質の強力な阻害薬でもある. 併用薬 (ミダゾラム, スタチン, カルシウム拮抗薬, タクロリムス等) の血中濃度を上昇させる. 活性代謝物14-ヒドロキシクラリスロマイシンを生成する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        'マクロライド系の中でも組織移行性が良く, ヘリコバクター・ピロリ除菌や非結核性抗酸菌症治療の中心的薬剤. 国内に注射剤の設定はない.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '下痢, 味覚異常 (苦味), 悪心などの消化器症状が多い. QT延長, 心室性頻脈 (Torsade de pointesを含む) が重大な副作用として記載されている. 肝機能障害.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        '注射剤がないため緊急時の代替にはならない. 主要な相互作用はCYP3A4阻害によるベンゾジアゼピン系, オピオイド, カルシウム拮抗薬等の作用増強であり, 周術期の併用薬リストを必ず確認する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: IE高リスク患者の抜歯での代替薬',
        '感染性心内膜炎高リスク患者の抜歯でペニシリン内服が使えない場合, 代替としてCLDM, AZM, CAMのいずれかを経口で手術1時間前に単回服用する.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: QT延長のリスク',
        'サンフォードのQTc延長作用のある抗菌薬リストにクラリスロマイシン(CAM)が含まれる. 女性, 徐脈, 低カリウム/低マグネシウム血症, 他のQT延長薬併用などのリスク因子がある患者では注意する.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: CYP3A4を介した相互作用',
        'マクロライド系薬は血清中濃度を上昇させうる併用薬(CYP3A4基質など)を処方する際は常に薬物相互作用を確認する. 適切な代替薬がない場合は影響を受ける薬物の血中濃度測定と副作用モニタリングを行う.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        'ピモジド, エルゴタミン含有製剤, スボレキサント, ダリドレキサント, タダラフィル (アドシルカ), チカグレロル, イブルチニブ, ロミタピド, ベネトクラクス (用量漸増期), ルラシドン, フィネレノン, イサブコナゾニウム等CYP3A基質薬多数',
        'CYP3A阻害による血中濃度上昇で重篤な副作用 (不整脈, 過度の血圧低下等) のリスク',
      ),
      DrugContraindication(
        'コルヒチン (肝または腎障害患者)',
        'コルヒチン中毒 (骨髄抑制, 多臓器不全) のリスク上昇',
      ),
      DrugContraindication(
        '本剤に対し過敏症の既往歴のある患者',
        'アレルギー',
      ),
    ],
    cautiousUse: [
      'QT延長のある患者, 低カリウム血症の患者',
      '高度腎機能障害患者',
      '高度肝機能障害患者',
      '妊婦 (有益性投与)',
      '重症筋無力症患者 (症状悪化の報告)',
    ],
  ),
  Drug(
    name: 'アジスロマイシン (AZM)',
    brand: 'ジスロマック',
    category: DrugCategory.antimicrobial,
    dilution: '注射用水4.8mLで完全に溶解し (100mg/mL) を確認後, 輸液500mLで希釈し1mg/mLとする. 1mg/mLを超える濃度では投与しない (注射部位疼痛の発現頻度が上昇). 5%ブドウ糖注射液等の配合変化のない輸液を使用し, 溶解後は速やかに使用する.',
    concentration: '1バイアル524.1mg (アジスロマイシン水和物, アジスロマイシンとして500.0mg力価) の凍結乾燥末. 注射用水4.8mLで溶解すると100mg/mL',
    dose: '・注射: 成人にはアジスロマイシンとして500mg (力価) を1日1回, 2時間かけて点滴静注する\n'
        '・肺炎: 注射剤2~5日間の後, 経口剤500mg (力価) 1日1回に切替, 総投与期間は合計7~10日間\n'
        '・骨盤内炎症性疾患: 注射剤1~2日間の後, 経口剤250mg (力価) 1日1回に切替, 総投与期間は合計7日間\n'
        '・経口単独: 適応症により250~500mg (力価) 1日1回, SR製剤 (単回用ドライシロップ2g) は多くの適応症で1回のみ投与',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: true,
      summary: '注射剤 (ジスロマック点滴静注用500mg) と経口剤 (錠250mg, 小児用細粒, SR成人用ドライシロップ2g) の両方が国内にある. 緊急時に静注可能.',
    ),
    emergencyDose: '急速静注 (ボーラス) は行わない. 必ず2時間かけて点滴静注する. 通常用量500mg/日が上限.',
    spectrum: '肺炎球菌, レンサ球菌属, ブドウ球菌属, インフルエンザ菌, モラクセラ・カタラーリス, 淋菌, レジオネラ, マイコプラズマ, クラミジア, ペプトストレプトコッカス属等',
    renalAdjust: '腎機能障害患者での体内動態への有意な影響は報告されておらず, 添付文書上は通常用量で投与可',
    periop: '組織内半減期が長いため (t1/2は単回投与でおよそ65~90時間), 手術当日休薬しても組織内濃度は数日間維持される. 緊急感染症治療で静注が必要な場合に選択できる数少ない静注可能マクロライドだが, 必ず2時間かけて点滴し急速静注はできないため即効的な使い方はできない. QT延長のある患者や他のQT延長薬 (制吐薬, 一部抗不整脈薬) 併用時は術中心電図モニターを強化する.',
    mechanism: '細菌の70Sリボソーム50Sサブユニットに結合し蛋白合成を阻害する.',
    packageInsertReviewed: true,
    packageInsertRevision: '2026年2月改訂 (第2版), ジスロマック点滴静注用500mg',
    packageInsertUrl: 'https://www.pmda.go.jp/PmdaSearch/rdDetail/iyaku/6149400D1021_2?user=1',
    notes: [
      DrugNote(
        '薬物動態',
        '組織移行性が非常に高く分布容積33.3L/kgと大きい. 血中濃度は速やかに低下するが組織内には数日間高濃度を維持する. チトクロームP450による代謝は確認されていない (クラリスロマイシンよりCYP3A4阻害は弱い).',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        '国内で静注可能な数少ないマクロライド. 適応は肺炎, 骨盤内炎症性疾患. 組織内半減期が長いため副作用も投与終了後に遅発することがある.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '下痢, 注射部位疼痛が比較的多い. 重大な副作用としてショック, アナフィラキシー, TEN/皮膚粘膜眼症候群, 薬剤性過敏症症候群, 肝炎, 急性腎障害, 偽膜性大腸炎, 間質性肺炎, QT延長・Torsade de pointes, 白血球/顆粒球/血小板減少, 横紋筋融解症.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        'ワルファリン (プロトロンビン時間延長), シクロスポリン, ジゴキシン, ネルフィナビル, ベネトクラクスとの相互作用が報告されている. クラリスロマイシンに比べCYP3A4阻害は弱いが, QT延長リスクは他のマクロライドと同様に留意する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: QT延長のリスク',
        'サンフォードのQTc延長作用のある抗菌薬リストにアジスロマイシン(AZM)が含まれる. 先天性QT延長症候群, 低K/Mg血症, 他のQT延長薬併用例では注意する.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 淋菌陽性の産婦人科手術',
        '淋菌陽性の流産手術・子宮内膜掻爬術でβ-ラクタムアレルギーがある場合, 代替薬としてAZM+CLDMを用いる. AZMはAZM-SR 2g経口が望ましい.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: IE高リスク患者の抜歯での代替薬',
        'IE高リスク患者の抜歯でペニシリンアレルギーがある場合, CLDM, AZM, CAMのいずれかの経口薬を手術1時間前に単回投与する.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        'アレルギー, アナフィラキシーのリスク',
      ),
    ],
    cautiousUse: [
      '他のマクロライド系またはケトライド系薬剤に過敏症の既往歴のある患者',
      '心疾患のある患者 (QT延長, Torsade de pointesを含む心室性頻脈のリスク)',
      '高度肝機能障害のある患者 (肝機能悪化のおそれ)',
      '妊婦 (有益性投与)',
    ],
  ),
  Drug(
    name: 'シプロフロキサシン (CPFX)',
    brand: 'シプロキサン',
    category: DrugCategory.antimicrobial,
    dilution: '希釈せず投与可能な濃度に調製済み. 水分制限時は無希釈投与も可 (太い静脈を選択). 最低投与時間は1時間 (30分以内の急速投与は避ける).',
    concentration: '200mg/100mLバッグ, 400mg/200mLバッグ, pH3.9~4.5',
    dose: '・注射: 通常成人1回400mgを1日2回, 1時間以上かけて点滴静注 (患者の状態により1日3回まで増量可)\n'
        '・経口: 通常成人1回100~200mgを1日2~3回経口投与, 感染症の種類・症状により適宜増減',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: true,
      summary: '注射剤 (シプロキサン注200mg/100mL, 400mg/200mL) と経口剤 (シプロキサン錠100mg, 200mg) の両方が国内にある.',
    ),
    spectrum: '緑膿菌を含むグラム陰性桿菌に強い抗菌力を持つ. グラム陽性球菌にも活性はあるが, 呼吸器領域ではレボフロキサシンに劣る.',
    renalAdjust: '腎機能低下患者では投与量・投与間隔の調整が必要. 高齢者・血液透析患者では腎機能に十分注意し観察しながら慎重に投与する (血液透析による除去率は限定的, 約10%程度).',
    periop: '緊急静注可能な広域抗菌薬で緑膿菌カバーが必要な場面で有用. NSAIDs併用による痙攣リスクに留意 (周術期はNSAIDsが多用されるため注意). 経口剤は制酸剤 (Ca, Mg, Al含有) や経管栄養剤とキレートを形成し吸収が低下するため, 経管投与時は前後2時間程度あける. QT延長薬 (制吐薬等) との併用時はTdPリスクに注意する.',
    mechanism: '細菌のDNAジャイレース (トポイソメラーゼII) およびトポイソメラーゼIVを阻害しDNA複製を阻害する (殺菌的).',
    packageInsertReviewed: true,
    packageInsertRevision: '2022年09月12日版, シプロキサン注200mg/400mg',
    packageInsertUrl: 'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/630004_6241400A4021_1_16',
    notes: [
      DrugNote(
        '薬物動態',
        'CYP1A2代謝薬 (テオフィリン, チザニジン) の代謝を阻害し血中濃度を上昇させる. 未変化体中心の腎排泄型.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        '緑膿菌を含むグラム陰性桿菌への抗菌力が強く, 静注・経口とも国内で使用できる緑膿菌カバー薬の一つ.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '痙攣 (特にNSAIDs併用時), 腱障害・腱断裂 (アキレス腱に多く, 高齢者・ステロイド併用でリスク増), 大動脈瘤/解離, QT延長, 光線過敏症, 低血糖 (糖尿病患者).',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        'NSAIDs併用による痙攣誘発, 制酸剤・経管栄養による吸収低下 (経口時), ワルファリン作用増強, テオフィリン中毒に注意する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 半減期・再投与間隔',
        '半減期3~7時間, 再投与間隔8時間 (腎機能正常) , eGFR-IND 20~50 mL/分で12時間, 20未満は適応外.\n[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 子宮頸管クラミジア陽性/不明例',
        '子宮頸管クラミジア陽性/不明の子宮内膜掻爬術・流産手術ではCPFX+MNZを用いる. 高いbioavailabilityのため経口投与も可能で, 手術2時間前に内服する.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: CDI発症リスク: フルオロキノロン系薬',
        '市中発症CDIのメタアナリシスでは, フルオロキノロン系薬はクリンダマイシンに次いでCDI発症リスクが高く, オッズ比5.65 (95%CI 4.38~7.28)と報告されている. 広域抗菌薬として漫然と長期投与しない.\n'
          '[出典] CDI診療GL 2022',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: β-ラクタムアレルギー時の代替',
        'β-ラクタム系薬アレルギー時の代替や, 緑膿菌感染, CRBSIの第二選択. CPFX 1回400mg・1日3回点滴静注. 小児では関節障害の頻度が2-3%とされ, 使用は限定的に考慮する.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: QT延長のリスク',
        'サンフォードのQTc延長作用のある抗菌薬リストにシプロフロキサシン(CPFX)が含まれる. リスク因子を有する患者や他のQT延長薬併用時は注意する.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: キノロン耐性への注意',
        '地域のE.coliキノロン耐性率が20%以上, または直近6ヶ月以内にキノロン系薬投与歴がある場合, 尿路感染症の経験的治療でCPFXを第一選択とせず, セフェム系や広域β-ラクタム系を検討する.\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        'ケトプロフェン (注射剤・坐剤) 投与中の患者',
        '痙攣誘発のおそれ',
      ),
      DrugContraindication(
        'チザニジン塩酸塩投与中の患者',
        'CYP1A2阻害によりチザニジンの血中濃度が著しく上昇し, 過度の降圧・傾眠のおそれ',
      ),
      DrugContraindication(
        'ロミタピドメシル酸塩投与中の患者',
        'CYP3A4阻害によりロミタピドの血中濃度が上昇するおそれ',
      ),
      DrugContraindication(
        '本剤成分に対し過敏症の既往歴のある患者',
        'アレルギー',
      ),
      DrugContraindication(
        '炭疽等の重篤な疾患以外での妊婦・妊娠している可能性のある女性, 小児等',
        '動物実験で関節軟骨障害の報告がある',
      ),
    ],
    cautiousUse: [
      'NSAIDs併用患者 (痙攣誘発リスク上昇)',
      '重症筋無力症患者 (症状悪化のおそれ)',
      'QT延長のある患者・QT延長薬併用患者',
      '腱障害の既往, 高齢者, ステロイド併用患者 (腱断裂リスク)',
      '大動脈瘤・大動脈解離の既往またはリスク因子を有する患者',
      '腎機能障害患者 (減量要)',
    ],
  ),
  Drug(
    name: 'レボフロキサシン (LVFX)',
    brand: 'クラビット',
    category: DrugCategory.antimicrobial,
    dilution: 'バッグ製剤はそのまま使用可能. バイアル製剤は添付文書の指示に従い希釈して使用する.',
    concentration: 'バッグ製剤500mg/100mL, バイアル製剤500mg/20mL',
    dose: '・通常成人: レボフロキサシンとして1回500mgを1日1回, 経口または点滴静注 (点滴静注は約60分かけて投与)\n'
        '・生物学的利用率がほぼ100%のため, 経口・注射で同一用量として切り替え可能',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: true,
      summary: '注射剤 (クラビット点滴静注500mg/20mLバイアル, 500mg/100mLバッグ) と経口剤 (錠250mg, 500mg, 細粒) の両方が国内にある.',
    ),
    emergencyDose: '通常用量500mgが最大量. 60分かけて点滴静注し, 急速投与は避ける.',
    spectrum: '肺炎球菌等グラム陽性球菌, インフルエンザ菌等グラム陰性桿菌, マイコプラズマ, クラミジア, レジオネラ等の非定型病原体に幅広い活性を持つレスピラトリーキノロン.',
    renalAdjust: 'CCr 20~50: 初日500mg, 2日目以降250mg1日1回 / CCr<20: 初日500mg, 3日目以降250mgを2日に1回に減量',
    periop: '注射・経口とも生物学的利用率が高く用量を変えず切り替えられるため, 術前後の継続感染症治療 (肺炎, 尿路感染症等) に使いやすい. NSAIDs併用時の痙攣リスク, 糖尿病患者での低血糖 (周術期の血糖変動と紛らわしい) に注意する. 大動脈手術予定患者や大動脈瘤リスクのある患者では投与の要否を再検討する.',
    mechanism: 'DNAジャイレース, トポイソメラーゼIVを阻害しDNA複製を阻害する (殺菌的). オフロキサシンの光学活性体 (S体).',
    packageInsertReviewed: true,
    packageInsertRevision: '2025年05月20日版, クラビット点滴静注500mg',
    packageInsertUrl: 'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/430574_6241402A1021_1_16',
    notes: [
      DrugNote(
        '薬物動態',
        '経口吸収率がほぼ100%で, 静注と経口でAUCがほぼ同等でありスイッチ療法に適する. 主に腎排泄 (未変化体).',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        '呼吸器感染症で最も汎用されるレスピラトリーキノロンの一つで, 肺組織移行性が良好.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '痙攣, 腱障害, 大動脈瘤/解離, QT延長, 低血糖 (特に高齢糖尿病患者), 意識障害.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        'ワルファリンの作用増強, ステロイド併用時の腱断裂リスク増加, QT延長薬 (制吐薬含む) 併用時のTdPリスクに留意する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: QT延長のリスク',
        'サンフォードのQTc延長作用のある抗菌薬リストにレボフロキサシン(LVFX)が含まれる. リスク因子を有する患者や他のQT延長薬併用時は注意する.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: キノロン耐性への注意',
        '地域のE.coliキノロン耐性率が20%以上, または直近6ヶ月以内にキノロン系薬投与歴がある場合, 尿路感染症の経験的治療でLVFXを第一選択とせず, セフェム系や広域β-ラクタム系を検討する.\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 泌尿器科手術での経口投与',
        '尿路系開放のない泌尿器科手術では経口/静注キノロン系薬として推奨され, 経口の場合はbioavailabilityを考慮し手術1~2時間前に服用する. 半減期は6~8時間.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 耳鼻科手術での報告',
        '鼓膜形成術・鼓室形成術ではCEZ静注が基本だが, SBT/ABPC注射や経口LVFXによる予防投与の報告もある.\n[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: CDI発症リスク: フルオロキノロン系薬',
        '市中発症CDIのメタアナリシスでは, フルオロキノロン系薬はクリンダマイシンに次いでCDI発症リスクが高く, オッズ比5.65 (95%CI 4.38~7.28)と報告されている. 広域抗菌薬として漫然と長期投与しない.\n'
          '[出典] CDI診療GL 2022',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: β-ラクタムアレルギー時の代替',
        'β-ラクタム系薬アレルギー時や緑膿菌感染, CRBSIの第二選択. LVFX 1回500mg・1日1回点滴静注.\n[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤またはオフロキサシンに対し過敏症の既往歴のある患者',
        'アレルギー',
      ),
      DrugContraindication(
        '炭疽等の重篤な疾患以外での妊婦・妊娠している可能性のある女性',
        '動物実験で関節軟骨障害の報告がある',
      ),
      DrugContraindication(
        '炭疽等の重篤な疾患以外での小児等',
        '関節軟骨への影響',
      ),
    ],
    cautiousUse: [
      'NSAIDs併用患者 (痙攣誘発リスク)',
      '重症筋無力症患者',
      'QT延長・心疾患のある患者',
      '腱障害リスク患者 (高齢者, ステロイド併用)',
      '大動脈瘤・大動脈解離リスク因子を有する患者',
      '糖尿病患者 (低血糖リスク, 特にSU薬併用時)',
      '腎機能障害患者 (減量要)',
    ],
  ),
  Drug(
    name: 'パズフロキサシン (PZFX)',
    brand: 'パシル/パズクロス',
    category: DrugCategory.antimicrobial,
    dilution: '既に希釈済みのバッグ製剤としてそのまま投与する. 他剤・輸液との配合変化が報告されており混注は避ける.',
    concentration: '300mg/100mL, 500mg/100mL (いずれもNa 15.4mEq/100mL含有)',
    dose: '・通常: 1日1000mgを2回に分けて点滴静注 (30分~1時間かけて), 症状により1日600mgも選択可\n'
        '・重症 (敗血症, 肺炎球菌性肺炎, 重症呼吸器感染症等): 1日2000mgを2回に分けて点滴静注 (1時間かけて)',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '国内には注射剤 (パシル/パズクロス点滴静注液300mg, 500mg) のみで, 経口剤は存在しない.',
    ),
    emergencyDose: '重症感染症では1日2000mg (1回1000mgを1日2回, 1時間かけて) まで増量可能',
    spectrum: 'グラム陽性・陰性菌に広域で緑膿菌にも活性を持つ. 経口剤がないため入院治療・重症例に用いられる.',
    renalAdjust: '腎機能障害患者では添付文書に基づき投与量・間隔の調整を行う (高度腎障害では投与間隔延長等を検討)',
    periop: '経口剤がなく静注専用のため, 絶飲食下でも継続投与しやすい重症感染症治療薬. Na含有量が比較的多く (300~500mgあたりNa 15.4mEq), 心不全患者や厳格な塩分制限が必要な患者では総投与量・総Na負荷に留意する. NSAIDs併用時の痙攣リスクに注意する.',
    mechanism: 'DNAジャイレース, トポイソメラーゼIVを阻害しDNA複製を阻害する (殺菌的).',
    packageInsertReviewed: true,
    packageInsertRevision: '2025年05月19日版, パシル点滴静注液300mg/500mg',
    packageInsertUrl: 'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/400022_6241401G1020_2_11',
    notes: [
      DrugNote(
        '薬物動態',
        '主に腎排泄. Na塩を含有するため大量投与時はNa負荷に注意する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        '国内で経口剤のない注射剤専用のニューキノロン. 緑膿菌を含む重症院内感染症に用いられる.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '痙攣 (NSAIDs併用時リスク増), 腱障害, QT延長, 血液障害, 肝機能障害.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        'テオフィリン, NSAIDs, ワルファリン, 副腎皮質ホルモン剤との相互作用に注意する. 経口移行ができないため, 感染症治療継続が必要な場合は静注のまま継続する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 投与経路と重症例での増量',
        'パズフロキサシン(PZFX)は経口剤がなく注射薬のみのキノロン系抗菌薬. 尿路感染症では通常500mgを1日2回だが, 敗血症合併の重症例では1,000mgを1日2回まで増量できる(ただし保険適応は敗血症合併症例に限る).\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 子宮頸管クラミジア陽性/不明例',
        '子宮頸管クラミジア陽性/不明の子宮内膜掻爬術・流産手術ではPZFX+MNZが選択肢の一つとなる (代替はマクロライド系薬+アミノグリコシド系薬など) .\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: CDI発症リスク: フルオロキノロン系薬',
        '市中発症CDIのメタアナリシスでは, フルオロキノロン系薬はクリンダマイシンに次いでCDI発症リスクが高く, オッズ比5.65 (95%CI 4.38~7.28)と報告されている. 広域抗菌薬として漫然と長期投与しない.\n'
          '[出典] CDI診療GL 2022',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: β-ラクタムアレルギー時の代替',
        'β-ラクタム系薬アレルギー時やCRBSI, ESBL産生の大腸菌/肺炎桿菌感染などの第二選択. PZFX 1回1,000mg・1日2回点滴静注.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        'アレルギー',
      ),
      DrugContraindication(
        '妊婦または妊娠している可能性のある女性',
        '動物実験で関節軟骨障害の報告がある',
      ),
      DrugContraindication(
        '小児等',
        '関節軟骨への影響',
      ),
    ],
    cautiousUse: [
      'NSAIDs併用患者 (痙攣誘発リスク)',
      '高齢者, 腎機能障害患者 (減量要)',
      'てんかん等痙攣性疾患の既往歴のある患者',
      'QT延長・心疾患のある患者',
    ],
  ),
  Drug(
    name: 'スルファメトキサゾール・トリメトプリム (ST)',
    brand: 'バクタ (経口) / バクトラミン (注射)',
    category: DrugCategory.antimicrobial,
    dilution: '注射剤は1アンプルあたり輸液125mLの割合で希釈 (水分制限患者では75mL), 1~2時間かけて点滴静注する.',
    concentration: '注射: 1アンプル5mL中トリメトプリム80mg/スルファメトキサゾール400mg. 経口: バクタ配合錠1錠中スルファメトキサゾール400mg/トリメトプリム80mg (比率5:1)',
    dose: '・一般感染症 (経口): 通常成人1日4錠を2回に分割経口投与\n'
        '・ニューモシスチス肺炎治療 (経口): 1日9~12錠を3~4回に分割経口投与\n'
        '・ニューモシスチス肺炎予防 (経口): 1~2錠を1回, 連日または週3日投与\n'
        '・注射 (PCP治療, 経口不能時): トリメトプリムとして1日15~20mg/kgを3回に分け, 1~2時間かけて点滴静注',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: true,
      summary: '経口剤 (バクタ配合錠, 配合顆粒) と注射剤 (バクトラミン注, 1アンプル5mL: スルファメトキサゾール400mg/トリメトプリム80mg) の両方が国内にある. 経口不能な重症PCP等には静注が可能.',
    ),
    emergencyDose: 'PCP治療の重症例で経口不能な場合はトリメトプリム換算15~20mg/kg/日を3分割で静注する',
    spectrum: 'ニューモシスチス・イロベチイ (PCP) の治療・予防における第一選択. 一部グラム陽性・陰性菌, ノカルジア等にも活性.',
    renalAdjust: 'クレアチニンクリアランス値に応じた用量調節が必要. CCr<15mL/minでは投与しないことが望ましい',
    periop: '高カリウム血症, 低ナトリウム血症を起こしうるため, 周術期の輸液・電解質管理下では血清カリウムのモニタリングに留意する (特に腎機能低下例, RAS阻害薬併用例). トリメトプリムのCYP2C8阻害によりメトトレキサート, ワルファリン, スルホニル尿素薬, レパグリニドの作用が増強される. PCP治療継続が必要な免疫抑制患者で経口不能時は静注へ切り替え可能.',
    mechanism: 'スルファメトキサゾールがジヒドロプテロイン酸合成酵素を, トリメトプリムがジヒドロ葉酸還元酵素を阻害し, 葉酸合成を二段階で遮断する (相乗的抗菌作用).',
    packageInsertReviewed: true,
    packageInsertRevision: '2026年06月16日版 (バクタ配合錠), 注射剤は2025年頃改訂版 (バクトラミン注)',
    packageInsertUrl: 'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/343018_6290100D1088_2_09',
    notes: [
      DrugNote(
        '薬物動態',
        'トリメトプリムはCYP2C8を阻害し, レパグリニド, スルホニル尿素薬, ワルファリンの血中濃度・作用を増強する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        'ニューモシスチス肺炎 (PCP) の治療・予防の第一選択薬. サルファ剤アレルギーのスクリーニングが重要.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '高カリウム血症, 低ナトリウム血症, 骨髄抑制 (巨赤芽球性貧血, 白血球減少), 重篤な皮膚障害 (SJS/TEN), 腎機能悪化, 溶血性貧血 (G6PD欠乏).',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        '高カリウム血症のリスクがあるため, 周術期は血清カリウムのモニタリングを行う. ワルファリン, メトトレキサート等との相互作用に留意する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: まれなグラム陰性桿菌CRBSIで選択',
        'Chryseobacterium属やOchrobacterium属などまれなグラム陰性桿菌によるCRBSIで選択肢となる. ST合剤 1回3-5mg/kg・1日3回点滴静注.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 適応外使用とDAP併用',
        'CA-MRSAによる皮膚軟部組織感染症の内服治療に用いられるが, 国内添付文書上はブドウ球菌属や皮膚軟部組織感染症への適応を取得していない. VCMのMICが2 μg/mLのMRSA菌血症では, 高用量DAPとの併用で臨床的・微生物学的改善が期待される.\n'
          '[出典] MRSA感染症 診療GL 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 新生児への投与',
        '小児の尿路感染症の治療・予防投与に用いられるが, 低出生体重児, 新生児への投与は禁忌とされている.\n[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 妊娠初期の回避',
        '妊娠初期はキノロン系薬, テトラサイクリン系薬とともにST合剤の使用を避けるべき抗菌薬とされる(妊娠後期に注意すべきはサルファ剤).\n'
          '[出典] JAID/JSC 尿路感染症GL 2015',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤またはサルファ剤に対し過敏症の既往歴のある患者',
        'アレルギー, SJS/TEN等重篤な皮膚障害のリスク',
      ),
      DrugContraindication(
        '妊婦または妊娠している可能性のある女性',
        '葉酸代謝拮抗による胎児への影響',
      ),
      DrugContraindication(
        '低出生体重児, 新生児',
        '核黄疸 (ビリルビン脳症) のリスク',
      ),
      DrugContraindication(
        'グルコース-6-リン酸脱水素酵素 (G6PD) 欠乏患者',
        '溶血性貧血のリスク',
      ),
    ],
    cautiousUse: [
      '腎機能障害患者 (用量調整要, CCr<15では投与非推奨)',
      '高カリウム血症のリスクがある患者, ACE阻害薬/ARB/カリウム保持性利尿薬併用患者',
      '葉酸欠乏のある患者 (巨赤芽球性貧血のリスク)',
      '高齢者',
    ],
  ),
  Drug(
    name: 'ミノサイクリン (MINO)',
    brand: 'ミノマイシン',
    category: DrugCategory.antimicrobial,
    dilution: '100~500mLの糖液, 電解質液, アミノ酸製剤等に溶解する (注射用水のみでは等張とならず単独使用不可). 溶解後は12時間以内に投与を終了し, 注射速度はできるだけ遅くする.',
    concentration: '1バイアル100mg (力価)',
    dose: '・注射: 初回100~200mg (力価), 以後12時間ないし24時間ごとに100mg (力価) を補液に溶解し, 30分~2時間かけて点滴静注する. 経口投与不能な患者及び救急の場合に行い, 経口投与が可能になれば経口用剤に切り替える\n'
        '・経口: 通常成人1回100mgを12時間ごと (1日200mg)',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: true,
      summary: '注射剤 (ミノマイシン点滴静注用100mg, ジェネリックあり) と経口剤 (カプセル50mg/100mg, 顆粒) の両方が国内にある. 経口投与不能な患者及び救急の場合に静注する.',
    ),
    emergencyDose: '経口不能な重症感染症・救急時は初回100~200mgを静注可能',
    spectrum: 'グラム陽性・陰性菌, リケッチア, クラミジア, マイコプラズマ, 一部の耐性菌に活性. 多剤耐性グラム陰性菌 (Stenotrophomonas maltophilia, Acinetobacter属等) にも使用される.',
    renalAdjust: '肝代謝・胆汁排泄が主で腎排泄への依存度が低いため, 他のテトラサイクリン系と異なり腎機能障害患者でも比較的減量不要とされるが, 重度腎障害では血中濃度上昇に注意し慎重投与する',
    periop: '経口・注射どちらも使用可能で切り替えが容易. 前庭障害 (めまい, ふらつき) の副作用があり, 術後の意識・平衡機能評価と紛らわしい可能性があるため留意する. 光線過敏症があるため皮膚保護にも注意する. テトラサイクリン系は非脱分極性筋弛緩薬の作用を軽度増強する可能性が文献的に指摘されており, 高用量・多剤併用時は筋弛緩モニタリングを意識する.',
    mechanism: '細菌の30Sリボソームサブユニットに結合し, アミノアシルtRNAのリボソームへの結合を阻害して蛋白合成を阻害する (静菌的).',
    packageInsertReviewed: true,
    packageInsertRevision: 'ミノサイクリン塩酸塩点滴静注用100mg (後発品) 添付文書に基づく (先発ミノマイシン点滴静注用100mgと同一用法用量)',
    packageInsertUrl: 'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/581120_6152401F1162_1_05',
    notes: [
      DrugNote(
        '薬物動態',
        '脂溶性が高く組織移行性に優れる. 主に肝で代謝され胆汁排泄されるため, 腎機能障害の影響を受けにくい (他のテトラサイクリン系との相違点).',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        'テトラサイクリン系の中で唯一, 国内に注射剤がある. 経口投与不能例や重症例, 多剤耐性グラム陰性菌感染症に用いられる.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        'めまい, ふらつき等の前庭障害 (女性に多い), 光線過敏症, 歯牙着色 (小児・胎児), 肝機能障害, 好酸球性肺炎.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        '前庭症状は術後回復期のせん妄・めまい評価と紛らわしいことがある. ワルファリン, スルホニル尿素薬, メトトレキサート, ビタミンA製剤との相互作用に注意する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 前庭症状に注意',
        'めまい, 運動失調, 悪心, 嘔吐などの前庭症状の頻度が高く(報告により30~90%), 男性より女性に多いとされる. 術後のふらつきや悪心を麻酔・鎮痛薬の遷延と誤認しないよう注意する.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: Mgモニタリングと頭蓋内圧上昇',
        '製剤にMgを含有し, 腎障害がある場合は血清Mg濃度をモニターする. 長期使用で頭蓋内圧上昇のリスクもあるとされる.\n[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 腎不全でも使用可',
        '他のテトラサイクリン系薬と異なり, 腎不全の患者にも使用可能とされる. 光線毒性や歯への沈着も他のTC系より少ないとされる.\n[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 通常投与量',
        '通常成人量は初回200mgを経口/静注, その後100mgを経口/静注で12時間ごと. 静注製剤も入手可能.\n[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 婦人科手術でのβ-ラクタムアレルギー代替',
        '円錐切除術・子宮内膜掻爬術でβ-ラクタムアレルギーがある場合, DOXYまたはMINOの経口薬を術前・術後に分服する方法も選択肢に挙げられている.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 多剤耐性Acinetobacter感染で併用',
        '多剤耐性Acinetobacter属によるCRBSIでカルバペネム系薬に併用する: MINO 1回100mg・1日2回点滴静注. Chryseobacterium属感染では単剤の第一選択にもなる.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 8歳未満は使用不可',
        'CA-MRSAによる皮膚軟部組織感染症の内服治療薬の一つだが, 8歳未満の小児 (特に歯牙形成期) には歯牙の着色・エナメル質形成不全や一過性の骨発育不全のリスクがあるため, 他剤が無効な場合以外は使用しない.\n'
          '[出典] MRSA感染症 診療GL 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤またはテトラサイクリン系抗生物質に対し過敏症の既往歴のある患者',
        'アレルギー',
      ),
      DrugContraindication(
        '妊婦または妊娠している可能性のある女性',
        '胎児の歯牙着色, 骨形成不全のリスク',
      ),
      DrugContraindication(
        '授乳婦',
        '母乳中への移行, 乳児の歯牙着色のリスク',
      ),
      DrugContraindication(
        '低出生体重児, 新生児, 乳児, 8歳未満の小児',
        '歯牙の着色, エナメル質形成不全, 骨発育不全のリスク',
      ),
    ],
    cautiousUse: [
      '重症筋無力症患者 (症状悪化の報告)',
      '肝障害のある患者',
      'めまい・ふらつきの副作用があり, 自動車運転等危険を伴う作業に注意が必要な患者',
    ],
  ),
  Drug(
    name: 'クリンダマイシン (CLDM)',
    brand: 'ダラシンS',
    category: DrugCategory.antimicrobial,
    dilution: '本剤300~600mg (力価) あたり100~250mLの日局5%ブドウ糖注射液, 生理食塩液またはアミノ酸製剤等の補液に溶解し, 30分~1時間かけて点滴静注する.',
    concentration: '300mg/2mL, 600mg/4mL (ベンジルアルコール含有)',
    dose: '・注射 (点滴静注): 通常成人1日600~1200mg (力価) を2~4回に分割. 難治性・重症感染症では1日最大2400mg (力価) まで増量可\n'
        '・注射 (筋注): 1日600~1200mg (力価) を2~4回に分割\n'
        '・経口: 通常成人1回150mgを1日3~4回',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: true,
      summary: '注射剤 (ダラシンS注射液300mg, 600mg) と経口剤 (ダラシンカプセル75mg, 150mg) の両方が国内にある.',
    ),
    emergencyDose: '壊死性軟部組織感染症・トキシックショック症候群では毒素産生抑制目的で高用量が海外ガイドラインで推奨されることがあるが, 国内添付文書上の上限は1日2400mg (力価)',
    spectrum: 'グラム陽性球菌 (MRSAの一部にも活性), 嫌気性菌 (Bacteroides属等) に強い活性を持つ. 骨・軟部組織感染症, 誤嚥性肺炎, 壊死性軟部組織感染症 (毒素産生抑制目的) に用いられる.',
    renalAdjust: '腎排泄はわずかで, 腎機能障害による用量調整は通常不要 (添付文書上特段の規定なし)',
    periop: '神経筋遮断作用を有し, ロクロニウム等の非脱分極性筋弛緩薬の作用を増強するため, 術中投与時は筋弛緩モニタリング (TOF) を強化し, 抜管時の残存筋弛緩に注意する. Clostridioides difficile感染症 (CDI) のリスクが抗菌薬の中でも高いため, 術後下痢の原因として念頭に置く. 壊死性筋膜炎やペニシリンアレルギー患者の代替薬として周術期に使用されることがある.',
    mechanism: '細菌の50Sリボソームサブユニットに結合し蛋白合成を阻害する (静菌的, 高濃度で殺菌的). マクロライドと結合部位が近接し交差耐性がある.',
    packageInsertReviewed: true,
    packageInsertRevision: '2026年02月10日版, ダラシンS注射液300mg/600mg',
    packageInsertUrl: 'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/672212_6112401A1100_3_04',
    notes: [
      DrugNote(
        '薬物動態',
        '主に肝代謝 (CYP3A4) され胆汁排泄される. 骨組織, 膿瘍への移行性が良好.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        '嫌気性菌カバーの中心薬剤の一つ. 壊死性軟部組織感染症では毒素産生抑制効果も期待され, ペニシリン系と併用されることがある.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '偽膜性大腸炎 (Clostridioides difficile感染症) の頻度が抗菌薬の中でも高い. 肝機能障害, 血球減少, 注射部位反応.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        '非脱分極性筋弛緩薬 (ロクロニウム, ベクロニウム等) の作用を増強するため, 術中筋弛緩モニタリングと術後の残存筋弛緩 (遅発性呼吸抑制) に特に注意する. 麻酔科領域で重要な相互作用である.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 半減期と再投与間隔',
        '半減期2~4時間, 術中再投与間隔は6時間を目安とする (腎機能低下例は延長を考慮) .\n[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: β-ラクタムアレルギー時の基本代替薬',
        'グラム陽性菌のみの清潔創ではCLDM単独, グラム陰性菌も考慮する準清潔創ではアミノグリコシド系薬・キノロン系薬・AZTのいずれかと併用する.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 歯科・口腔外科での経口投与',
        '歯科インプラント埋入・下顎埋伏智歯抜歯でペニシリンアレルギーの場合, CLDM経口を手術1時間前から服用する (単回~48時間) .\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 整形外科でのVCM・TEICと並ぶ代替薬',
        '人工関節置換術・脊椎インストゥルメンテーション手術ではCEZが第一選択だが, β-ラクタムアレルギー時はVCM, TEICとともにCLDMも代替薬として推奨される.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: CDI発症リスクが最も高い抗菌薬の一つ',
        'CDI発症との関連が最も強い抗菌薬の一つ. RCTのメタアナリシスでは他の抗菌薬群と比較しリスク比3.92 (95%CI 1.15~13.43), 市中発症CDIのメタアナリシスではオッズ比20.43 (95%CI 8.50~49.09)と報告されている. 使用時はCDI発症を念頭に置く.\n'
          '[出典] CDI診療GL 2022',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: Bacillus属CRBSIの第二選択',
        'Bacillus属によるCRBSIでVCMが使えない場合の第二選択: CLDM 1回600mg・1日3回点滴静注.\n[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: CA-MRSAの内服選択肢',
        'CA-MRSAによる皮膚軟部組織感染症の内服治療薬の一つとして用いられる. 骨・関節感染症でも感受性があれば, 初期の経静脈的治療後にCLDM内服への切り替えが可能.\n'
          '[出典] MRSA感染症 診療GL 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 投与量',
        '経口は0.15~0.45gを6時間ごと, 静注/筋注は600~900mgを8時間ごと. 肥満患者での用量計算は実体重に基づく.\n[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: C. difficile関連下痢のリスク',
        'クロラムフェニコール, クリンダマイシン, エリスロマイシン系の中でも, クリンダマイシンはC. difficile関連下痢/偽膜性大腸炎の原因薬剤として最も頻度が高いとされる.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: ペニシリンアレルギー時の代替',
        '小児の血行性骨髄炎などでペニシリン系にアレルギーや毒性の懸念がある場合の代替選択肢の一つとして使用される(高用量経口治療への早期切り替えも同様に有効とされる).\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤またはリンコマイシン系抗生物質に対し過敏症の既往歴のある患者',
        'アレルギー',
      ),
      DrugContraindication(
        'エリスロマイシン投与中の患者',
        '拮抗作用により抗菌力が減弱するおそれ',
      ),
    ],
    cautiousUse: [
      '偽膜性大腸炎の既往歴のある患者',
      '高齢者 (重篤な大腸炎に至りやすい)',
      '肝機能障害患者',
      '筋弛緩薬併用患者 (作用増強)',
    ],
  ),
  Drug(
    name: 'リファンピシン (RFP)',
    brand: 'リファジン',
    category: DrugCategory.antimicrobial,
    concentration: '該当なし (内服剤のみ, 注射剤は国内未承認)',
    dose: '・結核症: 通常成人1日450mgを1日1回, 食前 (空腹時) に経口投与 (体重により300~600mgの範囲で調整)\n'
        '・非結核性抗酸菌症等では他剤併用療法の一部として使用されることもある',
    forms: DrugFormAvailability(
      hasInjection: false,
      hasOral: true,
      summary: '国内にはカプセル剤 (リファジンカプセル150mg) のみで, 注射剤は存在しない. 緊急時に静注はできない.',
    ),
    spectrum: '結核菌, 非結核性抗酸菌, 一部グラム陽性球菌 (MRSA併用薬として), レジオネラ等',
    renalAdjust: '主に胆汁排泄のため腎機能障害患者での用量調整は通常不要',
    periop: '強力なCYP3A4・CYP2C9等薬物代謝酵素誘導薬であり, 周術期に使用する多数の薬剤 (ミダゾラム, フェンタニル, ロクロニウム等の非脱分極性筋弛緩薬, ワルファリン, カルシウム拮抗薬, ステロイド, 一部オピオイド) の代謝を促進し作用を減弱させるため, 麻酔薬・筋弛緩薬の必要量増加を想定した投与量調整とモニタリングを行う. 結核治療の継続性が重要なため通常は術前休薬せず継続する. 体液 (尿, 汗, 涙, 唾液) が橙赤色に着色するため, 術中の尿量・体液の色調変化を出血や病態変化と誤認しないよう周知する.',
    mechanism: '細菌のDNA依存性RNAポリメラーゼを阻害しRNA合成を阻害する (殺菌的).',
    packageInsertReviewed: true,
    packageInsertRevision: '2026年06月16日版, リファジンカプセル150mg',
    packageInsertUrl: 'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/430574_6164001M1216_1_18',
    notes: [
      DrugNote(
        '薬物動態',
        '肝の薬物代謝酵素 (CYP3A4, CYP2C9, CYP2C19等) を強力に誘導し, 自身の代謝も自己誘導 (オートインダクション) する. 胆汁排泄型.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        '結核治療の中心薬剤で多剤併用療法の基本薬. 国内に注射剤はなく経口カプセルのみ.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '体液の橙赤色着色 (尿, 汗, 涙, 唾液, コンタクトレンズの変色), 肝機能障害・薬剤性肝炎, インフルエンザ様症候群 (間欠投与時), 血小板減少.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        'CYP誘導により周術期に使用する麻酔薬・筋弛緩薬・鎮痛薬・抗凝固薬の効果が減弱する可能性があり, 薬剤選択・用量調整時に念頭に置く必要がある. 体液の着色を異常所見と誤認しないよう注意する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: インプラント感染での併用',
        '整形外科インプラント感染 (人工関節, 脊椎インストゥルメンテーション, 骨折インプラント) では抗MRSA薬へのRFP併用が有効な可能性がある. 単独使用は耐性化しやすいため必ず併用とし, 投与期間は症例ごとに慎重に検討する.\n'
          '[出典] MRSA感染症 診療GL 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 心内膜炎・髄膜炎での併用量',
        '人工弁心内膜炎ではVCM+ゲンタマイシンにRFPを加えた3剤併用療法が行われることがある. 髄膜炎ではVCMにRFP 600 mg/日, または300-450 mgを1日2回併用するとよいとの報告がある.\n'
          '[出典] MRSA感染症 診療GL 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: CYP誘導による相互作用',
        'リファマイシン系は代謝を誘導する薬剤であり, 併用薬(特に他の抗微生物薬)の血中濃度を低下させ治療失敗につながることが知られている. 適切な代替薬がない場合は影響を受ける薬剤の血中濃度測定・副作用モニタリングを行う.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 人工物関連感染症での併用',
        '人工物関連の骨・関節感染症などでバンコマイシン, ダプトマイシン, リネゾリドにリファンピシン300~450mgを1日2回併用すると再発率が減少するとされる.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分または他のリファマイシン系薬剤に対し過敏症の既往歴のある患者',
        'アレルギー',
      ),
      DrugContraindication(
        '胆道閉塞のある患者',
        '胆汁排泄が主であり肝障害・黄疸増悪のおそれ',
      ),
    ],
    cautiousUse: [
      '肝機能障害のある患者 (肝毒性)',
      'アルコール常飲者 (肝障害リスク増加)',
      '高齢者',
    ],
  ),
  Drug(
    name: 'メトロニダゾール (MNZ)',
    brand: 'フラジール (経口) / アネメトロ (静注)',
    category: DrugCategory.antimicrobial,
    dilution: 'アネメトロは希釈不要のプレフィルド製剤であり, 20分以上かけて点滴静注する.',
    concentration: '注射: 1バイアル100mL中メトロニダゾール500mgの既溶解製剤',
    dose: '・注射 (嫌気性菌感染症): 成人1回500mgを1日3回, 20分以上かけて点滴静注 (重症・難治性では1日4回まで)\n'
        '・経口 (嫌気性菌感染症, 感染性腸炎等): 適応症に応じた用法用量が規定されている\n'
        '・トリコモナス症: 経口剤で規定期間投与\n'
        '・ヘリコバクター・ピロリ二次除菌: クラリスロマイシンの代わりにメトロニダゾールを用いる3剤併用療法',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: true,
      summary: '経口剤 (フラジール内服錠250mg) と注射剤 (アネメトロ点滴静注液500mg) の両方が国内にある.',
    ),
    emergencyDose: '重症・難治性嫌気性菌感染症では1日4回投与まで増量可',
    spectrum: '嫌気性菌 (Bacteroides属, Clostridioides difficile等), 原虫 (トリコモナス, アメーバ, ランブル鞭毛虫), ヘリコバクター・ピロリ (除菌併用).',
    renalAdjust: '腎機能障害患者での特段の減量規定はないが, 高度腎障害・透析患者では代謝物の蓄積に注意し慎重投与する',
    periop: 'アルコール (消毒用エタノールを含む輸液・薬剤, 口腔ケア用アルコール含嗽剤等) との併用でジスルフィラム様反応 (顔面紅潮, 頭痛, 嘔気, 動悸) を起こすため, 周術期はエタノール含有製剤 (リトナビル内用液等) や皮膚消毒用アルコールの経静脈的混入に注意する. ワルファリン作用増強の報告があり, 抗凝固療法中の患者では留意する.',
    mechanism: '嫌気性菌・原虫内でニトロ基が還元されフリーラジカル等の細胞毒性物質を生成し, DNAを損傷して殺菌的に作用する.',
    packageInsertReviewed: true,
    packageInsertRevision: '2025年11月20日版, アネメトロ点滴静注液500mg',
    packageInsertUrl: 'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/672212_6419401A1027_2_06',
    notes: [
      DrugNote(
        '薬物動態',
        '経口吸収率が高く, 静注と経口でほぼ同等のバイオアベイラビリティを持ちスイッチ療法に適する. 肝代謝され, 主に尿中排泄される.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        '嫌気性菌感染症, 軽症~中等症の偽膜性大腸炎, 腹腔内感染症の主要な嫌気性菌カバー薬. 経口・静注両方あり使い分けが容易.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '末梢神経障害 (長期投与・累積投与量増加で発現しやすい, しびれ等), 中枢神経症状 (痙攣, 脳症), ジスルフィラム様反応, 金属味・味覚異常, 悪心.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        'アルコール (消毒薬, 含嗽剤, 一部薬剤の溶媒) によるジスルフィラム様反応のリスクを麻酔科医・看護師間で共有する. ワルファリンの作用増強に注意する. 10日を超える投与では末梢神経障害の発現に十分注意する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 用量・半減期・再投与',
        '1回投与量500mg, 術中再投与を行わない場合は1000mgへ増量する. 半減期6~8時間, 再投与間隔は8時間.\n[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 嫌気性菌カバーが必要な術式での併用',
        '下部消化管手術・婦人科手術など嫌気性菌カバーが必要な準清潔創で, アミノグリコシド系薬またはキノロン系薬にMNZを併用する.\n[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 帝王切開では不使用, 流産手術では使用可',
        '帝王切開では新生児への影響を考慮しMNZを使用しないが, 流産手術では胎児への影響を考える必要がないためMNZの使用が可能である.\n'
          '[出典] 術後感染予防抗菌薬 実践GL 2016',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: CDIでの位置づけと標準用量',
        '非重症の初発CDIに対する第一選択薬. 1回500mgを1日3回, 10日間経口投与する (経口不可時は点滴静注も可). 重症例や再発を繰り返す難治例には推奨されず, 症状改善が乏しい場合はバンコマイシン内服へ変更する.\n'
          '[出典] CDI診療GL 2022',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 重症CDIでは死亡率上昇のため非推奨',
        '重症と判断されたCDIでは, メトロニダゾール内服治療は他の抗C. difficile薬 (バンコマイシン, フィダキソマイシン)と比較して死亡率が高いとの報告があり, 重症例には使用しない.\n'
          '[出典] CDI診療GL 2022',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 長期・高用量投与時の神経毒性',
        '長期・高用量投与で末梢神経障害や中枢神経障害 (脳症)が生じうる. 国内報告では脳症発現までの平均投与期間61.3日, 平均総投与量95.9gだが, 短期間・低用量でも発現した例がある. 重度肝障害 (Child-Pugh C)ではAUCが健常人の約2倍に増大し, 重度腎障害でも活性代謝物のAUCが増大するため慎重投与が必要.\n'
          '[出典] CDI診療GL 2022',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 嫌気性菌感染症の投与量',
        '通常7.5mg/kg(~500mg)を静注6時間ごと. 半減期が長いため15mg/kg静注12時間ごとも可. 重症例では初回15mg/kgの負荷投与とし, 1日総量4gを超えないようにする.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分またはニトロイミダゾール系薬剤に対し過敏症の既往歴のある患者',
        'アレルギー',
      ),
      DrugContraindication(
        '脳, 脊髄に器質的疾患のある患者への大量・長期投与',
        '中枢神経障害 (痙攣, 運動失調等) のリスク上昇',
      ),
    ],
    cautiousUse: [
      '妊婦 (特に妊娠3ヵ月以内は治療上の有益性を考慮)',
      '血液障害の既往歴のある患者',
      '末梢神経障害のある患者',
      '重篤な肝障害のある患者',
    ],
  ),
  Drug(
    name: 'コリスチン (CL)',
    brand: 'オルドレブ',
    category: DrugCategory.antimicrobial,
    dilution: '1バイアルに注射用水または生理食塩液2mLを加え, 泡立てないように穏やかに溶解し, 生理食塩液で希釈して総量50mLとし, 30分以上かけて点滴静注する.',
    concentration: '1バイアル150mg (力価) (コリスチンメタンスルホン酸ナトリウムとしてコリスチン172.5mg含有, 調製時の損失を考慮した過量充填)',
    dose: '・成人: コリスチンとして1回1.25~2.5mg (力価) /kgを1日2回, 30分以上かけて点滴静注 (腎機能に応じて調整)',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '国内には注射剤 (オルドレブ点滴静注用150mg) のみ. 全身感染症に用いる経口製剤はない (コリマイシン散は選択的消化管除菌用の局所作用製剤で全身感染症には用いない).',
    ),
    emergencyDose: '多剤耐性菌による重症感染症 (敗血症等) では通常用量の上限 (1回2.5mg/kgを1日2回) で早期から十分量を投与する',
    spectrum: '多剤耐性グラム陰性桿菌 (緑膿菌, アシネトバクター, カルバペネム耐性腸内細菌目細菌等) に対する最終手段的抗菌薬.',
    renalAdjust: '腎機能 (CCr) に応じた詳細な減量が必要: CCr80以上は1回1.25~2.5mg/kgを1日2回, CCr50~79は1回1.25~1.9mg/kgを1日2回, CCr30~49は1回1.25mg/kgを1日2回または1回2.5mg/kgを1日1回, CCr10~29は1回1.5mg/kgを36時間ごと',
    periop: '神経筋遮断作用 (非脱分極性) を有し, 非脱分極性筋弛緩薬の作用を増強するため, 術中の筋弛緩モニタリングと術後の残存筋弛緩・呼吸抑制に注意する. 腎毒性が高頻度であり, 周術期の腎機能変動 (脱水, 造影剤, 他の腎毒性薬剤併用) と相まって急性腎障害のリスクが上昇するため, 腎機能・尿量を厳重にモニタリングする. 多剤耐性菌感染症治療の最終手段薬であり, 自己判断での中断は避け, 感染症科・薬剤師と連携して継続の可否を判断する.',
    mechanism: '細菌外膜のリポ多糖 (LPS) に結合し, 細胞膜の透過性を変化させて細胞内容物を漏出させ殺菌的に作用する (界面活性剤様作用).',
    packageInsertReviewed: true,
    packageInsertRevision: '2024年05月08日版, オルドレブ点滴静注用150mg',
    packageInsertUrl: 'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/340278_6125400D4029_1_05',
    notes: [
      DrugNote(
        '薬物動態',
        '腎排泄型で, 腎機能低下時には蓄積し腎毒性・神経毒性のリスクが上昇する. 前駆物質 (コリスチンメタンスルホン酸) が体内で徐々に活性体コリスチンに変換される.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '一般的性質',
        '多剤耐性グラム陰性菌感染症に対する最終手段 (last resort) の抗菌薬. 古い薬剤だが薬剤耐性菌の増加により再評価されている.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '副作用',
        '腎毒性 (急性尿細管壊死) が高頻度. 神経毒性 (異常感覚, めまい, 稀に呼吸筋麻痺). 気管支痙攣 (吸入投与時).',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の注意',
        '神経筋遮断作用により筋弛緩薬の効果が増強・遷延するため, 術中モニタリングと抜管判断に注意する. 腎毒性のため周術期の脱水・低血圧・造影剤使用を避け, 腎機能を保護する.',
        type: DrugNoteType.packageInsert,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分またはポリミキシンBに対し過敏症の既往歴のある患者',
        'アレルギー',
      ),
    ],
    cautiousUse: [
      '腎機能障害患者 (腎毒性が高頻度, 用量調整必須)',
      '重症筋無力症患者 (神経筋遮断作用による症状悪化)',
      '他の腎毒性・神経毒性薬剤 (アミノグリコシド系等) 併用患者',
    ],
  ),
  Drug(
    name: 'リポソーマルアムホテリシンB (L-AMB)',
    brand: 'アムビゾーム',
    category: DrugCategory.antimicrobial,
    spec: 'アムビゾーム点滴静注用50mg (1バイアル中アムホテリシンB 50mg)',
    dilution: '注射用水12mLで溶解し4mg/mLとする. さらに5%ブドウ糖注射液で希釈する (生理食塩液は不可, 沈殿を生じる). 2.5mg/kg/日未満投与時は100mL, 2.5mg/kg/日以上投与時は250mLへの希釈が望ましい',
    concentration: '溶解後4mg/mL, 希釈後は概ね0.2-2mg/mL',
    dose: '・深在性真菌症: アムホテリシンBとして1日1回2.5mg/kgを1-2時間以上かけて点滴静注. 症状に応じ1日総投与量5mg/kgまで増量可\n'
        '・クリプトコッカス髄膜炎の重症例: 1日6mg/kgまで増量可\n'
        '・造血幹細胞移植等における発熱性好中球減少症のエンピリック治療: 1日1回2.5mg/kgを点滴静注\n'
        '・投与時間: 1回1-2時間以上かけて点滴静注 (急速静注は不可)',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射のみ (点滴静注用の凍結乾燥製剤). 内服薬はない',
    ),
    emergencyDose: '急速静注により重篤な心停止に至った報告があり, 緊急時であっても急速投与は行わない. 投与時反応 (発熱, 悪寒, 血圧低下等) が出現した場合は減速または中止し, 解熱薬・抗ヒスタミン薬の前投与や投与速度の緩徐化で対応する',
    renalAdjust: '明確な用量換算表はないが, 腎排泄はわずかで, 尿細管障害による腎機能悪化・低K血症の頻度が高いため, 定期的な腎機能・電解質モニタリングを行い, Cr上昇時は減量・休薬を考慮する',
    periop: '深在性真菌症の治療中は手術当日も継続する. アムホテリシンB自体はCYP代謝を受けずCYPの阻害・誘導もないため, ミダゾラムやフェンタニルなど麻酔薬との直接的な薬物相互作用は乏しい. 一方で腎毒性・低K血症が高頻度に出現するため, 術前に腎機能と血清K値を確認し補正しておく. 低K血症は非脱分極性筋弛緩薬の作用遷延, 不整脈, ジギタリス中毒のリスクを高めるため術中も電解質をフォローする. 腎毒性のあるアミノグリコシド系, シクロスポリン, シスプラチン, 造影剤との併用時は腎機能を特に注意して観察する. リポソーマル製剤は従来のアムホテリシンBデオキシコール酸塩 (ファンギゾン) に比べ腎毒性・投与時反応が有意に軽減されており, 周術期管理も比較的容易である',
    mechanism: '真菌細胞膜のエルゴステロールに結合して細孔を形成し, 膜透過性を亢進させ細胞内容物を漏出させることで殺菌的に作用する. リポソーム製剤化により腎細胞への取り込みが減少し, 腎毒性・投与時反応が従来製剤より軽減される',
    packageInsertReviewed: true,
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00051538',
    notes: [
      DrugNote(
        '薬物動態',
        '肝・脾に高濃度に取り込まれ長時間貯留する. 消失半減期は投与量2.5mg/kg時で約9.8時間 (β相) だが, 組織からの緩徐な放出により組織内では数週間残留するとされる. 明確な肝代謝経路はなく, 尿中・糞中排泄は合計で約10%とわずかである',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '投与時反応 (infusion reaction)',
        '発熱, 悪寒, 頭痛, 血圧低下, 頻脈などが投与開始中-投与後数時間以内に出現しうる. 従来型アムホテリシンBデオキシコール酸塩に比べ発現頻度・重症度は低いが, 初回投与時は特に注意深く観察する',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '腎毒性と電解質異常',
        '尿細管障害による低K血症, 低Mg血症, 腎性尿崩症様症状, 急性腎障害が重大な副作用として記載されている. 定期的な腎機能・電解質検査を行い, 他の腎毒性薬との併用は慎重に行う',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '禁忌: 白血球輸注との併用',
        '白血球 (顆粒球) 輸注中の患者には投与禁忌である. 重篤な肺傷害 (急性呼吸窮迫症候群様の呼吸障害) を来した症例が報告されている',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'リポソーマル製剤の位置づけ',
        '腎機能障害のある患者, 高用量・長期投与が必要な深在性真菌症, 従来製剤で忍容性不良な症例において第一選択となる. 大豆由来成分を含むため大豆・落花生アレルギー患者では慎重投与とする',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 使いどころ',
        'リポソーマル製剤 (アムビゾーム) は抗真菌薬の標準型とされる. 高価で副作用も問題になるが, 使えない症例は少なくエース級の位置づけ.\n[出典] 抗菌薬の考え方, 使い方',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 副作用 (infusion reaction)',
        '投与開始5分以内に胸痛・呼吸困難・低酸素や腹部/側腹部/下肢の激痛が生じる急性infusion reactionが20-40%にみられる. 投与終盤にほてり・じんま疹が出ることも(14%). ジフェンヒドラミン投与と減速/中断で軽快する.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 投与速度',
        '初回は約120分かけて静注し, 忍容性良好なら60分まで短縮可. 投与前後の輸液で腎毒性を軽減できる. 通常製剤より腎毒性は軽いが, infusion reaction率(59% vs 38%)はむしろ高い.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        '重篤な過敏反応 (ショック, アナフィラキシー) を起こすおそれがあるため',
      ),
      DrugContraindication(
        '白血球 (顆粒球) 輸注中の患者',
        '重篤な肺傷害 (急性呼吸窮迫症候群様の呼吸障害) を来すおそれがあるため',
      ),
    ],
    cautiousUse: [
      '薬物過敏症の既往歴のある患者',
      '大豆・落花生アレルギーのある患者 (添加物由来)',
      '腎機能障害のある患者',
      '高齢者',
      '妊婦',
    ],
  ),
  Drug(
    name: 'フルコナゾール (FLCZ)',
    brand: 'ジフルカン (ジェネリック医薬品多数)',
    category: DrugCategory.antimicrobial,
    spec: 'ジフルカンカプセル50mg, 100mg. フルコナゾール静注液50mg/50mL, 100mg/50mL, 200mg/100mL (ジェネリック)',
    dilution: '静注液は溶解済みのプレフィルドバッグ/ボトル製剤で希釈操作は不要. アムホテリシンBとの混注は避ける',
    concentration: '静注液は1mg/mL',
    dose: '・カンジダ症: 50-100mgを1日1回経口または静注. 重症例は最大400mg/日\n'
        '・クリプトコッカス症: 50-200mgを1日1回, 重症例は最大400mg/日\n'
        '・造血幹細胞移植時の真菌感染予防: 400mgを1日1回\n'
        '・腟炎: 150mgを1回経口投与\n'
        '・静注時の投与速度: 1分間に10mLを超えない速度で緩徐に投与 (急速静注は行わない)',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: true,
      summary: '内服 (カプセル) と注射 (静注液, ジェネリックあり) の両方. 経口・静注とも生物学的利用率がほぼ同じでありスイッチ療法が可能',
    ),
    renalAdjust: 'クレアチニンクリアランス50mL/min以下 (透析患者を除く) では維持量を半量に減量する. 血液透析患者は透析終了後に通常用量を投与する',
    periop: '真菌感染症治療中は手術当日も原則継続する. 内服・静注とも生物学的利用率がほぼ同等でありNPO期間中は静注へのスイッチが容易である. 麻酔科的に最重要なのはCYP2C9, CYP2C19, CYP3A4の強い阻害作用で, ミダゾラム, フェンタニル, スタチン系薬剤, タクロリムス・シクロスポリン等の免疫抑制薬, ワルファリン, スルホニル尿素薬の血中濃度・作用が増強しうる点である. 特にミダゾラムは鎮静遷延, フェンタニルは作用遷延のリスクがあるため, 術中の鎮静・鎮痛薬は少量から漸増し反応をみながら調節する. QT延長のリスクがあるため電解質異常やQT延長作用のある薬剤との併用時は心電図モニタリングを行う',
    mechanism: '真菌のCYP51 (ラノステロール14α-脱メチル化酵素) を選択的に阻害しエルゴステロール合成を阻害することで, 細胞膜の透過性を変化させ抗真菌作用 (静菌的) を発揮する',
    packageInsertReviewed: true,
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00001295',
    notes: [
      DrugNote(
        '薬物動態',
        '血漿消失半減期は約30時間と長く1日1回投与が可能. 血漿蛋白結合率は約10%と低い. 髄液移行が良好 (血中濃度の60-80%) で, 尿中に約70-80%が未変化体のまま排泄される',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '重大な副作用',
        'ショック, Stevens-Johnson症候群, 中毒性表皮壊死融解症, 薬剤性過敏症症候群, 血液障害, 急性腎障害, 肝障害, QT延長・心室頻拍, 間質性肺炎, 偽膜性大腸炎が記載されている',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'CYP相互作用と併用禁忌',
        'CYP2C9, CYP2C19, CYP3A4を阻害する. トリアゾラム, エルゴタミン系薬剤, ジヒドロエルゴタミン, キニジン, ピモジド等は併用禁忌であり, ワルファリン, スタチン系, カルバマゼピン等は併用注意となる薬剤が多数ある',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'スペクトラムの限界',
        'Candida albicans等には有効だがCandida glabrata, Candida kruseiには自然耐性ないし低感受性であり, Aspergillus属には無効である. 経験的治療では起因菌カバーに注意する',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '剤形の使い分け',
        '経口カプセルと静注液 (ジェネリック含む) の生物学的利用率はほぼ同等であり, 患者の状態に応じて相互にスイッチできる. ホスフルコナゾール (プロジフ) は同じ活性本体を持つ静注専用のプロドラッグである',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: カンジダ血症CRBSIの選択肢',
        'カンジダ血症を疑うCRBSIのdefinitive therapyの選択肢. FLCZ 1回400mg・1日1回点滴静注. non-albicans Candidaの検出が多い施設ではMCFG/CPFGを優先する.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 注射薬から経口への step-down',
        '侵襲性カンジダ症で治療経過が良好かつ原因菌がFLCZ感受性, 消化管機能に問題がなければ, 注射薬から経口FLCZへのstep-downを検討してよい.\n'
          '[出典] 抗菌薬適正使用支援(AS)ガイダンス 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 軽症例の第一選択と用量',
        '軽症例で最近1か月以内のアゾール系使用歴がなく高齢者・担癌患者でない場合の第一選択. 初日800mg (12mg/kg) 1日1回, 2日目以降400mg (6mg/kg) 1日1回点滴静注 (保険適応は400mg/日まで).\n'
          '[出典] 侵襲性カンジダ症の診断・治療ガイドライン Executive summary集 (日本医真菌学会)',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 使えない菌種に注意',
        'C. albicans, C. tropicalis, C. parapsilosisには有効だが, C. glabrataは低感受性, C. kruseiは本質的に耐性のため第一選択にできない. 菌種未同定時はこの点を踏まえ重症度で薬剤を選ぶ.\n'
          '[出典] 侵襲性カンジダ症の診断・治療ガイドライン Executive summary集 (日本医真菌学会)',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 併用禁忌薬と治療期間',
        'CYP2C9, 2C19, 3A4を阻害し, トリアゾラム, エルゴタミン, ジヒドロエルゴタミン, キニジン, ピモジドとは併用禁忌. カンジダ血症は血液培養陰性化・症状消失後さらに2週間投与する.\n'
          '[出典] 侵襲性カンジダ症の診断・治療ガイドライン Executive summary集 (日本医真菌学会)',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: de-escalationでの位置づけ',
        'キャンディン系薬やアムホテリシンB製剤で初期治療し臨床的に改善, C. albicans等の感受性菌と判明した場合はフルコナゾールへのstep-down治療が推奨される.\n'
          '[出典] 侵襲性カンジダ症の診断・治療ガイドライン Executive summary集 (日本医真菌学会)',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 使いどころ',
        'カンジダ (C. albicans, C. tropicalis, C. parapsilosis) とクリプトコッカスに対するファーストチョイス. PK/PDと安全性に優れた第一選択薬.\n'
          '[出典] 抗菌薬の考え方, 使い方',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: スペクトラムの穴',
        'C. glabrata, C. kruseiのほとんどはフルコナゾール耐性. これらの真菌感染にはアムホテリシンBやキャンディン系を選択する. アスペルギルスなど糸状菌にも無効.\n'
          '[出典] 抗菌薬の考え方, 使い方',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 相互作用/QT延長',
        'QTc延長を来しうる抗真菌薬の一つ. 他のQT延長薬併用時や電解質異常のある患者では注意し, 治療前後の心電図モニタリングを考慮する.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        'トリアゾラム, エルゴタミン系薬剤, ジヒドロエルゴタミン, キニジン, ピモジドを投与中の患者',
        'CYP3A4阻害により併用薬の血中濃度が上昇し, 重篤な不整脈や麦角中毒を来すおそれがあるため',
      ),
      DrugContraindication(
        '妊婦',
        '動物実験で催奇形性が報告されているため',
      ),
    ],
    cautiousUse: [
      '腎機能障害のある患者',
      '肝機能障害のある患者',
      '心疾患・電解質異常のある患者',
      '高齢者',
    ],
  ),
  Drug(
    name: 'ホスフルコナゾール',
    brand: 'プロジフ',
    category: DrugCategory.antimicrobial,
    spec: 'プロジフ静注液100 (1.25mL), 200 (2.5mL), 400 (5mL) - いずれもホスフルコナゾールとしての含量',
    concentration: '約80mg/mL',
    dose: '・カンジダ症: 初日・2日目にホスフルコナゾール126.1-252.3mg (フルコナゾール換算100-200mg相当) を1日1回, 3日目以降は維持量として63.1-126.1mg (フルコナゾール換算50-100mg相当) を1日1回静注. 重症例は維持量を倍量まで増量可\n'
        '・クリプトコッカス症: 初日・2日目に126.1-504.5mgを1日1回, 3日目以降は63.1-252.3mgを1日1回静注. 重症例は倍量まで増量可\n'
        '・投与速度: 10mL/分を超えない速度で緩徐に静注する. 他剤・輸液との混合は避ける',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射のみ (静注液). フルコナゾールの水溶性プロドラッグであり, 内服製剤はない',
    ),
    renalAdjust: '活性代謝物であるフルコナゾールが腎排泄型であるため, 腎機能障害患者ではフルコナゾール換算に準じた減量または投与間隔の延長を考慮する. 具体的な換算は電子添文のクレアチニンクリアランス別投与量を参照する',
    periop: '経口摂取不能な周術期患者において静注のみでフルコナゾール相当の血中濃度を得られる薬剤であり, 術前後の真菌感染症治療・予防に有用である. 加水分解後のフルコナゾールがCYP2C9, CYP2C19, CYP3A4を強力に阻害するため, ミダゾラム, フェンタニル, スタチン, 免疫抑制薬 (タクロリムス, シクロスポリン) の血中濃度上昇に注意し, 術中の鎮静・鎮痛薬は少量から漸増する. 禁忌薬 (トリアゾラム, エルゴタミン系, キニジン, ピモジド等) を持参薬として服用していないか術前に確認する',
    mechanism: '体内でアルカリホスファターゼにより速やかに加水分解されフルコナゾールとなり, 真菌のCYP51を阻害してエルゴステロール合成を阻害する',
    packageInsertReviewed: true,
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00049849',
    notes: [
      DrugNote(
        'プロドラッグとしての薬物動態',
        'ホスフルコナゾール自体の消失半減期は1.5-2.5時間と短いが, 速やかに活性本体のフルコナゾールに変換される. フルコナゾールの半減期は約30-35時間で1日1回投与が可能',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '負荷投与を伴う用法',
        '初日・2日目は維持量の倍量を投与するローディングレジメンが特徴で, 早期に有効血中濃度に到達させる設計になっている',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '重大な副作用',
        'ショック, アナフィラキシー, 重篤な皮膚障害 (中毒性表皮壊死融解症, Stevens-Johnson症候群), 薬剤性過敏症症候群, 血液障害, 急性腎障害, 肝障害, 意識障害・痙攣, 高カリウム血症, 心室頻拍・QT延長・不整脈, 間質性肺炎, 偽膜性大腸炎が記載されている',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'CYP相互作用の広さ',
        'フルコナゾールと同様にCYP2C9, CYP2C19, CYP3A4を阻害し, トリアゾラム, エルゴタミン系, キニジン, ピモジドを含む多数の薬剤が併用禁忌または併用注意となる',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期における意義',
        '経口製剤がなく静注専用薬であるため, NPO期間中の真菌感染症治療・予防が必要な場合にフルコナゾール錠からの切替, あるいは初期治療薬として選択される',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: プロドラッグとしての特性',
        'フルコナゾールのプロドラッグで, 静注後アルカリホスファターゼによりほぼ完全にFLCZへ加水分解される. 溶解性が高くボーラス投与が可能で, loading doseにより投与3日目に定常状態へ到達する.\n'
          '[出典] 侵襲性カンジダ症の診断・治療ガイドライン Executive summary集 (日本医真菌学会)',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 初期負荷投与と適応菌種',
        '最初の2日間は800mg (12mg/kg) 1日1回静注, 3日目以降400mg (6mg/kg) 1日1回静注. FLCZ注射薬と異なり800mgのローディングも保険適応内で, 適応菌種やstep-downの考え方はFLCZと同じ.\n'
          '[出典] 侵襲性カンジダ症の診断・治療ガイドライン Executive summary集 (日本医真菌学会)',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 使いどころ',
        'フルコナゾールのプロドラッグ. 輸液量が少ないことが唯一の利点とされるが, 同量のフルコナゾール注射薬(7156円)に対し200mgバイアルで1万円以上と高価で, 臨床的な必然性は乏しいとの指摘がある.\n'
          '[出典] 抗菌薬の考え方, 使い方',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        'トリアゾラム, エルゴタミン系薬剤, ジヒドロエルゴタミン, キニジン, ピモジドを投与中の患者',
        'CYP3A4阻害により併用薬の血中濃度が上昇し, 重篤な不整脈や麦角中毒を来すおそれがあるため',
      ),
      DrugContraindication(
        '妊婦',
        '動物実験で催奇形性が報告されているため',
      ),
    ],
    cautiousUse: [
      '腎機能障害のある患者',
      '心疾患・電解質異常のある患者',
      '肝機能障害のある患者',
      '高齢者',
    ],
  ),
  Drug(
    name: 'イトラコナゾール (ITCZ)',
    brand: 'イトリゾール',
    category: DrugCategory.antimicrobial,
    spec: 'イトリゾールカプセル50, イトリゾール注1% (250mg/25mL). イトリゾール内用液1%は販売中止',
    concentration: '注1%は10mg/mL',
    dose: '・内臓真菌症 (経口): 100-200mgを1日1回食直後経口投与\n'
        '・表在性皮膚真菌症 (経口): 50-100mgを1日1回食直後経口投与\n'
        '・爪白癬パルス療法 (経口): 1回200mgを1日2回食直後, 1週間投与後3週間休薬を1サイクルとし3サイクル反復\n'
        '・注射剤: 投与開始2日間は1日400mgを2回に分割し必ず専用フィルターセットを用いて1時間かけて点滴静注, 3日目以降は1日1回200mgを1時間かけて点滴静注\n'
        '・注射剤の投与期間: 添加物シクロデキストリンの蓄積を避けるため長期連用は避け, 経口投与が可能になれば速やかに切替える',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: true,
      summary: '内服 (カプセル) と注射 (注1%) の両方. 内用液 (懸濁液) は販売中止. 注射剤は腎機能障害患者では添加物の蓄積により推奨されない',
    ),
    renalAdjust: '経口剤は腎機能による用量調節の明確な基準はない. 注射剤は添加物ヒドロキシプロピル-β-シクロデキストリンが腎排泄されるため, 中等度以上の腎機能障害では推奨されず経口剤への切替を考慮する',
    periop: '抗真菌薬治療中は可能な限り継続するが, 内服から注射剤へ切替える場合は腎機能を確認したうえで判断する. 麻酔科的にはCYP3A4の強力な阻害作用が最重要で, ミダゾラム, フェンタニル, スタチン系薬剤 (シンバスタチンは併用禁忌), 免疫抑制薬 (タクロリムス, シクロスポリン) の血中濃度が著明に上昇しうるため, 周術期の鎮静・鎮痛薬は減量・慎重投与とする. QT延長のリスクがある禁忌薬 (ピモジド, キニジン等) を持参薬として服用していないか術前に確認する. 陰性変力作用 (うっ血性心不全) の報告があるため心機能低下患者では注意する',
    mechanism: '真菌のCYP51を阻害しエルゴステロール合成を阻害する. 自身もCYP3A4により代謝されるとともにCYP3A4及びP糖蛋白に対して強い阻害作用を示すため, 他のアゾール系より相互作用が広範である',
    packageInsertReviewed: true,
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00001445',
    notes: [
      DrugNote(
        '薬物動態と剤形の違い',
        'β相消失半減期は約14-28時間, 主活性代謝物ヒドロキシイトラコナゾールは約10-21時間である. 脂溶性が高く組織移行性が良好で, カプセルは食直後投与で吸収が向上する. 内用液 (懸濁液) は国内で販売中止となっている',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '重大な副作用',
        'うっ血性心不全, 肝障害, 中毒性表皮壊死融解症, 低カリウム血症, 偽アルドステロン症が記載されている',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'CYP3A4阻害と相互作用の広さ',
        'ピモジド, キニジン, ベプリジル, トリアゾラム, シンバスタチン, コルヒチン (腎・肝機能障害患者) など多数の薬剤が併用禁忌である',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '注射剤特有の注意',
        '添加物ヒドロキシプロピル-β-シクロデキストリンの蓄積により, 腎機能障害患者で胃腸障害・腎機能障害が生じやすい. 必ず専用フィルターセットを用いて投与する',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '周術期の意義',
        '深在性真菌症治療中でNPOとなる患者において静注剤で治療継続が可能だが, 腎機能に応じて経口剤への早期切替を検討する',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 代替薬としての用法用量',
        '深在性カンジダ症では代替薬という位置づけ. 注射薬は開始2日間1回200mg 1日2回, 3日目以降200mg 1日1回点滴静注し, 14日を超える場合は内用液20mL 1日1回空腹時投与に切替える.\n'
          '[出典] 侵襲性カンジダ症の診断・治療ガイドライン Executive summary集 (日本医真菌学会)',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: CYP3A4相互作用と腎機能',
        '主にCYP3A4で代謝され, 同酵素を阻害・誘導する薬剤との相互作用に十分な注意が必要. 注射剤は添加物HP-β-CDの腎毒性のためCcr 30mL/分未満の患者では投与禁忌となっている.\n'
          '[出典] 侵襲性カンジダ症の診断・治療ガイドライン Executive summary集 (日本医真菌学会)',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 剤形による吸収の違い',
        'カプセルは胃内pHの影響を受け空腹時や制酸剤併用下では血中濃度が上がりにくいが, 内用液・注射剤はHP-β-CDで可溶化され食事・制酸剤の影響を受けにくい. 造血器悪性腫瘍での予防投与時は血中濃度モニタリングが推奨される.\n'
          '[出典] 侵襲性カンジダ症の診断・治療ガイドライン Executive summary集 (日本医真菌学会)',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 投与実務',
        'カプセル・錠剤は食直後の服用で吸収が増すが, 液剤は空腹時に服用する. PPI/H2ブロッカーで吸収低下, 逆に酸性飲料(コーラなど)で吸収が向上する. 血中濃度が不安定なため, 使用2週間後のTDMが推奨されることがある.\n'
          '[出典] 抗菌薬の考え方, 使い方',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 落とし穴',
        '眼内移行, 中枢神経系透過性がいずれも不良で, 真菌性髄膜炎やカンジダ眼内炎には向かない. In vitro感受性だけで選べる薬ではない典型例とされる.\n'
          '[出典] 抗菌薬の考え方, 使い方',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        'ピモジド, キニジン, ベプリジル, トリアゾラム, シンバスタチン等CYP3A4基質薬を投与中の患者',
        'CYP3A4阻害により血中濃度が上昇し, QT延長・心室頻拍・横紋筋融解症等の重篤な副作用を来すおそれがあるため',
      ),
      DrugContraindication(
        '肝機能障害または肝疾患の既往のある患者',
        '肝毒性が増強するおそれがあるため',
      ),
      DrugContraindication(
        '妊婦',
        '動物実験で催奇形性が報告されているため',
      ),
      DrugContraindication(
        'コルヒチンを投与中の腎機能障害または肝機能障害患者',
        'CYP3A4阻害によりコルヒチンの血中濃度が上昇し中毒症状 (骨髄抑制, 多臓器不全) を来すおそれがあるため',
      ),
    ],
    cautiousUse: [
      '腎機能障害のある患者 (特に注射剤)',
      'うっ血性心不全の既往やそのリスクのある患者',
      '好中球減少症の患者',
      '高齢者',
    ],
  ),
  Drug(
    name: 'ボリコナゾール (VRCZ)',
    brand: 'ブイフェンド',
    category: DrugCategory.antimicrobial,
    spec: 'ブイフェンド静注用200mg, 錠50mg・200mg, ドライシロップ2800mg (溶解後28mg/mL)',
    dilution: '注射用水19mLで溶解し10mg/mLとした後, 生理食塩液等で0.5-5mg/mLに希釈する',
    dose: '・静注 (成人): 初日6mg/kgを1日2回, 2日目以降は3-4mg/kgを1日2回, いずれも点滴静注\n'
        '・静注の投与速度: 1時間あたり3mg/kgを超えない速度で点滴 (急速静注は不可)\n'
        '・経口 (成人, 体重40kg以上): 初日400mgを1日2回, 2日目以降は150-200mgを1日2回食間投与 (効果不十分時は300mg/回まで増量可)\n'
        '・腎機能障害 (CCr50未満) では注射剤中の添加物蓄積により経口剤への切替を優先する',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: true,
      summary: '注射 (静注用) と内服 (錠, ドライシロップ) の両方. 腎機能障害 (CCr50未満) では注射剤中の添加物SBECDが蓄積するため経口剤を優先する',
    ),
    renalAdjust: '静注時, CCr50mL/min未満では添加物SBECD (スルホブチルエーテルβシクロデキストリンナトリウム) の蓄積により腎機能をさらに悪化させるおそれがあるため, 治療上やむを得ない場合を除き注射剤は投与せず経口剤を考慮する. 経口剤自体はボリコナゾールが主にCYP代謝されるため腎機能による用量調節は不要',
    periop: '深部真菌症治療中は手術当日も継続するが, 腎機能低下例では静注から経口へのタイミングを術前に確認する. 麻酔科的に最重要なのはCYP2C19, CYP2C9, CYP3A4を介した強い阻害作用で, ミダゾラム, フェンタニルの鎮静・鎮痛作用が著明に増強・遷延しうるため大幅な減量が必要となることがある. 免疫抑制薬 (タクロリムス, シクロスポリン, シロリムス) の濃度上昇, スタチン, ワルファリンの作用増強にも注意する. QT延長のリスクがあり電解質異常やQT延長作用のある薬剤の併用に注意する. 視覚異常 (羞明, 霧視) は投与中-投与直後に出現しうるため, 術後の意識状態評価や神経学的評価と混同しないよう申し送りする',
    mechanism: '真菌のCYP51を阻害しエルゴステロール合成を阻害する. 主にCYP2C19, CYP2C9, CYP3A4で代謝され, 特にCYP2C19の遺伝子多型により代謝能が大きく異なるため血中濃度の個人差が大きく, 薬物動態は用量に対して非線形である',
    packageInsertReviewed: true,
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00050557',
    notes: [
      DrugNote(
        '薬物動態と非線形性',
        '半減期は約4.4-6.4時間だが, AUCは用量に対して非線形に増加する. CYP2C19の遺伝子多型 (高活性型, 中間代謝型, 低活性型) により血中濃度が数倍単位で変動する',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'TDM (治療薬物モニタリング)',
        '血中濃度の個人差が大きいため, 投与期間中は血中トラフ濃度のモニタリングが望ましいとされる. 肝機能障害例など高濃度が懸念される場合はトラフ値をもとに用量調整を検討する',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '視覚異常',
        '羞明, 霧視, 視覚障害等が投与中に出現しやすく, 投与中止後も症状が持続することがある',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '肝障害',
        '重篤な肝障害 (肝炎, 黄疸, 肝不全, 肝性昏睡等) があらわれることがあり, 死亡例も報告されている. 定期的な肝機能検査が必要である',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'CYP3A4阻害と腎機能に関する注意',
        '本剤はCYP3Aに対する強い阻害作用を有するため併用薬に注意する. リファンピシン, カルバマゼピン, ピモジド, キニジン, 麦角アルカロイド, トリアゾラム等多数の薬剤が併用禁忌である',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: TDM実施が推奨される抗真菌薬',
        '深在性真菌症治療で数少ないTDM実施が推奨される抗真菌薬. 代謝酵素CYP2C19の遺伝子多型によるpoor metabolizerがアジア人に多く, 血中濃度と有害事象/治療効果に一定の相関がみられる.\n'
          '[出典] 抗菌薬適正使用支援(AS)ガイダンス 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 経口switch時も再TDMを推奨',
        'バイオアベイラビリティが高く注射薬から経口薬へのstep-downが可能だが, 切替時には血中濃度が変動しうるため, 経口薬へのstep-down時にも再度TDMを実施することが推奨される.\n'
          '[出典] 抗菌薬適正使用支援(AS)ガイダンス 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: TDMとトラフ値の目安',
        '投与期間中は血中濃度モニタリングが望ましい. 日本人健常成人で肝機能異常が出た症例のトラフ値はすべて4.5μg/mLを超えており, 日本TDM学会はトラフ値4~5μg/mL超で肝障害に注意するよう促している.\n'
          '[出典] 侵襲性カンジダ症の診断・治療ガイドライン Executive summary集 (日本医真菌学会)',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 視覚障害と代謝の個人差',
        '羞明・霧視などの視覚障害が知られ, 症状が回復するまで自動車運転など危険を伴う機械操作をさせない. 日本人の約15~20%はCYP2C19のpoor metabolizerで血中濃度が高くなりやすい.\n'
          '[出典] 侵襲性カンジダ症の診断・治療ガイドライン Executive summary集 (日本医真菌学会)',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 腎機能障害時の注射剤禁忌',
        '注射剤の添加物スルホブチルエーテル-β-シクロデキストリンナトリウムが腎排泄されるため, 重度腎機能障害例では注射剤は原則禁忌. 経口薬はバイオアベイラビリティ約96%でスイッチ療法が可能.\n'
          '[出典] 侵襲性カンジダ症の診断・治療ガイドライン Executive summary集 (日本医真菌学会)',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 耐性菌への代替薬としての用量',
        'C. krusei, C. glabrataなどFLCZ低感受性菌の代替薬. 初日1回6mg/kg 1日2回点滴静注, 2日目以降1回3~4mg/kg 1日2回点滴静注, 経口切替は1回200mg 1日2回 (体重40kg未満は減量).\n'
          '[出典] 侵襲性カンジダ症の診断・治療ガイドライン Executive summary集 (日本医真菌学会)',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 用法',
        'アスペルギルス属など糸状菌感染の第一選択トリアゾール. 静注は初日6mg/kg 12時間ごと(loading)の後4mg/kg 12時間ごと(カンジダ血症では3mg/kg 12時間ごと). 経口は食事の前後1時間を空けて服用する.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: TDM',
        '目標トラフ値1-6μg/mLでTDMを行う. 経口投与では約20%の患者で治療域に届かない血中濃度しか得られないため, 治療失敗が疑われる場合や重症例では血中濃度を確認する.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 肝機能調節・副作用',
        '中等度肝不全では維持量を半量に減量する. まれに重度の肝毒性(肝炎, 胆汁うっ滞, 劇症肝炎)が出るため治療中は肝機能をモニターし, 異常があれば中止する. 光線過敏症も多く重篤化しうる.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        'リファンピシン, リファブチン, カルバマゼピン, 長時間作用型バルビツール酸系, 高用量リトナビル, エファビレンツを投与中の患者',
        '強力な酵素誘導によりボリコナゾールの血中濃度が著減し効果が失われるため',
      ),
      DrugContraindication(
        'ピモジド, キニジン, 麦角アルカロイド, トリアゾラムを投与中の患者',
        'CYP3A4阻害により併用薬の血中濃度が上昇し, 重篤なQT延長や麦角中毒を来すおそれがあるため',
      ),
      DrugContraindication(
        '妊婦',
        '動物実験で催奇形性が報告されているため',
      ),
    ],
    cautiousUse: [
      '肝機能障害のある患者',
      '光線過敏症の既往のある患者',
      '腎機能障害のある患者 (特に注射剤)',
      '高齢者',
    ],
  ),
  Drug(
    name: 'ミカファンギン (MCFG)',
    brand: 'ファンガード',
    category: DrugCategory.antimicrobial,
    spec: 'ファンガード点滴用25mg, 50mg, 75mg',
    dilution: '生理食塩液またはブドウ糖注射液で溶解する (注射用水では力価が低下するため不可)',
    dose: '・アスペルギルス症: 50-150mg (重症例は300mgまで) を1日1回点滴静注\n'
        '・カンジダ症: 50mg (重症例は300mgまで) を1日1回点滴静注\n'
        '・造血幹細胞移植時の真菌感染予防: 50mgを1日1回点滴静注\n'
        '・投与速度: 75mg以下は30分以上, 75mgを超える場合は1時間以上かけて点滴静注',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射 (点滴静注用) のみ. 内服製剤はない',
    ),
    renalAdjust: '主に糞中に排泄され, 腎機能障害による明確な用量調節基準は示されていない',
    periop: '他のアゾール系と異なりCYP代謝をほとんど受けず, CYPを阻害・誘導しないため, ミダゾラムやフェンタニル等の麻酔薬, タクロリムス・シクロスポリン等の免疫抑制薬との相互作用が乏しい. このため薬物相互作用リスクを避けたい周術期・多剤併用中のカンジダ症治療において第一選択となりうる. 手術当日も継続してよく休薬の必要性は乏しい. シロリムスとの併用でシロリムスのAUCが上昇する点のみ注意する',
    mechanism: '真菌細胞壁の主要構成成分である1,3-β-D-グルカンの合成酵素を選択的に阻害し, 細胞壁合成を阻害することで抗真菌作用を示す. 哺乳類細胞には細胞壁が存在しないため選択毒性が高い',
    packageInsertReviewed: true,
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00051442',
    notes: [
      DrugNote(
        '薬物動態',
        '消失半減期は約13.9時間, 血漿蛋白結合率は99.8%以上と高い. 主に糞中に排泄される (約43.8%)',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '相互作用の少なさとキャンディン系の位置づけ',
        'CYP代謝を受けずCYP阻害・誘導もないため相互作用が少なく, 肝・腎機能障害患者や多剤併用中のICU患者でも使いやすい. カンジダ血症の初期治療の第一選択の一つとされる',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '重大な副作用',
        'ショック・アナフィラキシー, 血液障害 (白血球減少, 好中球減少, 溶血性貧血, 血小板減少), 肝機能障害・黄疸, 急性腎障害, 中毒性表皮壊死融解症・Stevens-Johnson症候群・多形紅斑が記載されている',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'スペクトラムの位置づけ',
        'Candida属 (耐性株を含む) やAspergillus属に有効だが, Cryptococcus属やムーコル (接合菌) には無効である',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '希釈時の注意',
        '注射用水では力価が低下するため生理食塩液またはブドウ糖注射液で溶解する. 他の輸液・薬剤との配合変化に注意する',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 使いどころ',
        'カンジダ血症に対するエンピリック治療薬としてカスポファンギンと並び使用頻度が高い. PK/PDにやや課題はあるが安全性は高く, 採用は通常どちらか一方でよいとされる.\n'
          '[出典] 抗菌薬の考え方, 使い方',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 用量',
        '造血幹細胞移植後の予防投与は50mg静注24時間ごと, カンジダ血症の治療では100mg静注24時間ごとを用いる.\n[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 重症敗血症/CRBSIのCandida第一選択',
        '重症敗血症やCRBSIでCandida感染が疑われる場合のempiric/definitive therapyの第一選択. MCFG 1回100mg・1日1回点滴静注とし, より重症例では1回150mg・1日1回に増量する.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: カンジダ血症の第一選択薬',
        'カンジダ血症で菌種未同定の中等症以上や, C. glabrata・C. kruseiなどFLCZ低感受性菌には第一選択薬. ローディング不要で100mg 1日1回点滴静注を開始でき, 効果不十分なら300mgまで増量できる.\n'
          '[出典] 侵襲性カンジダ症の診断・治療ガイドライン Executive summary集 (日本医真菌学会)',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 相互作用が少ない',
        '他の抗真菌薬と比べ薬物相互作用が少なく, 添付文書上も併用禁忌薬・併用注意薬の設定がない. 主な副作用は肝機能障害で, 高齢者や肝機能障害患者への投与は慎重投与とされる.\n'
          '[出典] 侵襲性カンジダ症の診断・治療ガイドライン Executive summary集 (日本医真菌学会)',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 眼内炎併発時の増量とstep-down',
        'カンジダ眼内炎を合併する場合は150~300mg 1日1回に増量する. 初期治療で本剤を使用し臨床的に安定, 感受性菌と判明した場合はフルコナゾールへのstep-down治療への変更を検討する.\n'
          '[出典] 侵襲性カンジダ症の診断・治療ガイドライン Executive summary集 (日本医真菌学会)',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        '重篤な過敏反応を起こすおそれがあるため',
      ),
    ],
    cautiousUse: [
      '薬物過敏症の既往歴のある患者',
      '肝機能障害のある患者',
      '妊婦',
      '小児, 高齢者',
    ],
  ),
  Drug(
    name: 'カスポファンギン',
    brand: 'カンサイダス',
    category: DrugCategory.antimicrobial,
    spec: 'カンサイダス点滴静注用50mg, 70mg',
    dilution: '生理食塩液または乳酸リンゲル液を用いて希釈する (ブドウ糖液とは配合不可)',
    dose: '・発熱性好中球減少症のエンピリック治療, 侵襲性カンジダ症, 侵襲性アスペルギルス症のサルベージ療法: 投与初日に70mgを, 2日目以降は50mgを1日1回点滴静注 (体重80kg超では2日目以降も70mgを考慮)\n'
        '・食道カンジダ症等: 50mgを1日1回点滴静注\n'
        '・投与速度: 約1時間かけて緩徐に点滴静注 (急速投与は不可)',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射 (点滴静注用) のみ. 内服製剤はない',
    ),
    renalAdjust: '軽度-中等度の腎機能障害では用量調節は不要とされる. 重度腎機能障害での確立した基準はない',
    periop: 'ミカファンギンと同様のキャンディン系薬剤であり, CYPを介した麻酔薬との相互作用は乏しいため周術期も継続しやすい. シクロスポリン併用でカスポファンギンのAUCが増加し肝障害リスクが上がる点, タクロリムス併用でタクロリムス血中濃度が低下する点に注意し, 免疫抑制薬内服中の移植患者では血中濃度モニタリングを行う. リファンピシン等の酵素誘導薬との併用でカスポファンギンの血中濃度が低下することがあり, 併用時は維持量を70mgへ増量することが添付文書上考慮されている',
    mechanism: '1,3-β-D-グルカン合成酵素を阻害し真菌細胞壁合成を阻害する (ミカファンギンと同じキャンディン系)',
    packageInsertReviewed: true,
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00060341',
    notes: [
      DrugNote(
        '薬物動態',
        'β相の消失半減期は9.62-10.37時間, γ相は41.64-41.93時間である. 加水分解及びN-アセチル化により緩徐に代謝され, 投与後27日間で約41%が尿中, 約34%が糞中に排泄される',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '重大な副作用',
        'アナフィラキシー, 肝機能障害 (AST/ALT上昇), 中毒性表皮壊死融解症・皮膚粘膜眼症候群 (Stevens-Johnson症候群) が記載されている',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '相互作用',
        'シクロスポリン併用でカスポファンギンのAUCが増加し, タクロリムス併用でタクロリムス血中濃度が約26%低下する. リファンピシン, カルバマゼピン等の酵素誘導薬併用時は血中濃度低下に注意する',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'スペクトラムと適応の位置づけ',
        'Candida属及びAspergillus属 (サルベージ療法) に有効でCryptococcus属には無効である. 国内では発熱性好中球減少症のエンピリック治療薬としての位置づけが大きい',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '肝機能障害時の減量',
        'Child-Pugh分類B以上の肝機能障害では維持量の減量が必要である',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 用量・肝機能調節',
        '初日70mg静注のローディング後, 50mg静注24時間ごとを維持量とする. 中等度以上の肝不全では35mg静注24時間ごとまで減量する.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 使いどころ・スペクトラムの穴',
        '他の抗真菌薬に耐性のカンジダにも殺菌的で, アスペルギルスにも活性がある. 発熱性好中球減少症のエンピリック治療やカンジダ血症, 難治性侵襲性アスペルギルス症に用いる. ただし髄液・尿・眼の硝子体液へは移行せず, 中枢神経系や眼内, 尿路の感染には無効.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 安全性',
        'AMPH-Bに比べ腎毒性が低い(血清Cr上昇8% vs 21%). 主な副作用は静注部位の掻痒感, 頭痛, 発熱, 悪寒など軽度なものが中心で忍容性は良好.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: Candida感染疑いの敗血症/CRBSIで選択',
        'Candida感染を疑う敗血症やCRBSIのempiric/definitive therapyの選択肢の一つ. CPFG 初日(loading dose)70mg・1日1回, 2日目以降50mg・1日1回点滴静注.\n'
          '[出典] JAID/JSC 敗血症・CRBSI GL 2017',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 初日ローディングで速やかに目標濃度',
        'カンジダ血症・眼内炎の第一選択薬の一つ. 初日はローディングとして70mg, 2日目以降50mg 1日1回点滴静注し, 投与初日から目標血中濃度に到達することが確認されている.\n'
          '[出典] 侵襲性カンジダ症の診断・治療ガイドライン Executive summary集 (日本医真菌学会)',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 相互作用は少ないが酵素誘導薬に注意',
        'CYPに対する阻害作用がなくP糖蛋白の基質・阻害薬でもないため他系統薬より相互作用が少ない. ただしリファンピシン, デキサメタゾン, フェニトイン, カルバマゼピン併用時は70mg 1日1回への増量を検討する.\n'
          '[出典] 侵襲性カンジダ症の診断・治療ガイドライン Executive summary集 (日本医真菌学会)',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 肝障害時の減量と適応',
        '中等度の肝障害 (Child-Pughスコア7~9) では減量が必要. 国内のキャンディン系薬で唯一, 真菌感染が疑われる発熱性好中球減少症の適応を取得している.\n'
          '[出典] 侵襲性カンジダ症の診断・治療ガイドライン Executive summary集 (日本医真菌学会)',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        '重篤な過敏反応を起こすおそれがあるため',
      ),
    ],
    cautiousUse: [
      '肝機能障害のある患者 (Child-Pugh B以上で減量)',
      '妊婦',
    ],
  ),
  Drug(
    name: 'アシクロビル (ACV)',
    brand: 'ゾビラックス',
    category: DrugCategory.antimicrobial,
    spec: 'ゾビラックス点滴静注用250 (バイアル), ゾビラックス錠200・400, ゾビラックス顆粒40%',
    dilution: '注射用水または生理食塩液10mLで溶解後, 100mL以上の輸液で希釈する (高濃度での急速投与は結晶化・腎障害のリスクとなる)',
    dose: '・単純ヘルペスウイルス感染症 (静注): 5mg/kgを1日3回 (8時間毎), 1時間以上かけて点滴静注, 通常5-7日間\n'
        '・単純ヘルペス脳炎, 免疫低下患者の帯状疱疹 (静注): 10mg/kgを1日3回, 1時間以上かけて点滴静注\n'
        '・単純疱疹 (経口): 200mgを1日5回経口投与\n'
        '・帯状疱疹, 造血幹細胞移植時の発症抑制 (経口): 800mg (発症抑制は200mg) を1日5回経口投与',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: true,
      summary: '注射 (点滴静注用) と内服 (錠, 顆粒) の両方',
    ),
    renalAdjust: '静注 (体重換算) はクレアチニンクリアランス50超で8時間毎, 25-50で12時間毎, 10-25で24時間毎, 10未満で24時間毎に半量とする. 経口はクレアチニンクリアランス25超で通常投与, 10-25で単純疱疹は1日5回のまま・帯状疱疹は1日3回に減回, 10未満はいずれも1日2回に減量する. 血液透析患者は透析後に投与する',
    periop: 'ヘルペス脳炎・重症帯状疱疹などの治療中は手術当日も継続する. 麻酔科的に最重要なのは (1) 急速静注や高濃度投与による急性腎障害・結晶尿のリスクで, 周術期は十分な補液 (尿量確保) のもとで1時間以上かけてゆっくり投与し, 脱水状態 (絶飲食・出血) では特に注意する, (2) 高用量や腎機能低下時に振戦, 傾眠, せん妄, 痙攣などの精神神経症状 (神経毒性) が出現しうるため, 術後のせん妄や覚醒遅延との鑑別に留意する, (3) プロベネシド, テオフィリン, ミコフェノール酸モフェチルとの相互作用がある, の3点である. CYPを介した麻酔薬との直接的相互作用は乏しい',
    mechanism: 'ウイルスのチミジンキナーゼによりリン酸化され活性型 (三リン酸体) となり, ウイルスDNAポリメラーゼを競合的に阻害するとともにDNA鎖に取り込まれて鎖伸長を停止させる. ヒト細胞のキナーゼによるリン酸化効率は低く選択毒性が高い',
    packageInsertReviewed: true,
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00051720',
    notes: [
      DrugNote(
        '薬物動態',
        '半減期は約2.5-3時間と短く腎排泄型である. 投与後48時間以内に尿中に約68.6-76.0%が未変化体として排泄される',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '急性腎障害・結晶尿',
        '尿細管腔内での結晶化により急性腎障害・尿細管間質性腎炎を来しうる. 十分な補液と緩徐な投与 (1時間以上) で予防する',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '神経毒性',
        '高用量投与時や腎機能低下時に意識障害, せん妄, 幻覚, 痙攣等の精神神経症状 (発現率約0.2%) が出現しうる. 多くは可逆性である',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '相互作用',
        'プロベネシド, シメチジンでアシクロビルのAUCが上昇する. テオフィリン中毒を増強し, ミコフェノール酸モフェチルとは腎排泄経路で競合する',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '剤形と切替',
        '静注と経口の使い分けは重症度に応じる. 経口プロドラッグのバラシクロビルは静注アシクロビルに近い血中濃度が得られる',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 使いどころ',
        '単純ヘルペスウイルスによる脳炎/髄膜炎が疑われる場合は, 髄液PCRの結果を待たずに経験的にアシクロビル静注を開始する. HSV髄膜炎にはアシクロビル10mg/kg静注8時間ごとを用いる.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤またはバラシクロビル塩酸塩に対し過敏症の既往歴のある患者',
        '重篤な過敏反応を起こすおそれがあるため',
      ),
    ],
    cautiousUse: [
      '腎機能障害のある患者',
      '脱水状態にある患者・高齢者',
      'てんかん等の中枢神経疾患の既往のある患者',
    ],
  ),
  Drug(
    name: 'バラシクロビル',
    brand: 'バルトレックス',
    category: DrugCategory.antimicrobial,
    spec: 'バルトレックス錠500, バルトレックス顆粒50%',
    dose: '・単純疱疹: 500mgを1日2回経口投与\n'
        '・帯状疱疹: 1000mgを1日3回経口投与\n'
        '・水痘: 1000mgを1日3回経口投与\n'
        '・性器ヘルペスの再発抑制: 500mgを1日1回経口投与',
    forms: DrugFormAvailability(
      hasInjection: false,
      hasOral: true,
      summary: '内服のみ (錠, 顆粒). 国内に注射剤はない. アシクロビルの経口プロドラッグで, 経口投与でもアシクロビル静注に近い血中濃度が得られる',
    ),
    renalAdjust: 'クレアチニンクリアランス50以上は通常量. 30-49は投与間隔を12時間毎に延長. 10-29は500mgを24時間毎など大幅減量. 10未満はさらに減量 (250mgを24時間毎など). 血液透析で約70%除去されるため透析後に投与する',
    periop: '帯状疱疹・水痘の治療中は手術当日朝まで内服を継続し, 術後の絶食期間は国内に注射剤がないため静注アシクロビルへ切替える. 麻酔科的にはアシクロビルと同様, 高用量・腎機能低下時の精神神経症状 (意識障害, せん妄, 痙攣) に注意し, 術後せん妄との鑑別を要する. 脱水状態では腎機能が低下しアシクロビルの蓄積・神経毒性のリスクが高まるため, 術前絶飲食下では補液を確保する. CYPを介した麻酔薬との直接的相互作用はない',
    mechanism: 'アシクロビルのL-バリルエステルプロドラッグである. 経口吸収後, 主に腸管・肝臓のバラシクロビル加水分解酵素によりアシクロビルに変換され, アシクロビルと同じ機序 (ウイルスDNAポリメラーゼ阻害) で抗ウイルス作用を示す',
    packageInsertReviewed: true,
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00046311',
    notes: [
      DrugNote(
        '薬物動態',
        '速やかにアシクロビルへ加水分解され, 経口バイオアベイラビリティはアシクロビル単体の3-5倍に改善する (約54-70%). アシクロビルとしての半減期は約2.96時間である',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '精神神経症状',
        '意識障害 (昏睡), せん妄, 妄想, 幻覚, 錯乱, 痙攣, てんかん発作, 麻痺, 脳症が報告される (発現率約1.09%). 腎機能低下患者・高齢者でリスクが高い',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '相互作用',
        'プロベネシド (AUC約48%上昇), シメチジン (AUC約27%上昇) でアシクロビルの血中濃度が上昇する. テオフィリン中毒を増強するおそれがある',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '国内に静注製剤がない',
        '経口摂取不能時や重症・免疫抑制状態で高い血中濃度を要する場合はアシクロビル静注への切替が必要である',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '適応',
        '単純疱疹, 帯状疱疹, 水痘, 性器ヘルペスの再発抑制等に用いられる',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 使いどころ',
        '重症のVZV眼合併症や免疫不全患者では, 静注アシクロビルによる導入後にバラシクロビル1000mg 1日3回などへ経口ステップダウンする. 帯状疱疹の再発予防にはバラシクロビル500mg 1日1回を用いることがある.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤またはアシクロビルに対し過敏症の既往歴のある患者',
        '重篤な過敏反応を起こすおそれがあるため',
      ),
    ],
    cautiousUse: [
      '腎機能障害のある患者',
      '脱水リスクのある患者 (高齢者含む)',
      '肝機能障害のある患者',
    ],
  ),
  Drug(
    name: 'ガンシクロビル (GCV)',
    brand: 'デノシン',
    category: DrugCategory.antimicrobial,
    spec: 'デノシン点滴静注用500mg',
    dilution: '生理食塩液, 5%ブドウ糖液, リンゲル液または乳酸リンゲル液で希釈し10mg/mLを超えない濃度とする',
    dose: '・初期治療: ガンシクロビルとして1回体重1kg当たり5mgを1日2回 (12時間毎), 1時間以上かけて点滴静注, 14-21日間\n'
        '・維持治療: 体重1kg当たり1日6mgを週5日, または1日5mgを週7日, いずれも1時間以上かけて点滴静注\n'
        '・投与経路: 組織刺激性が強く急速静注・筋注・皮下注は禁忌. 必ず末梢または中心静脈から緩徐に点滴する',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射 (点滴静注用) のみ. 国内に経口ガンシクロビル製剤はなく, 経口の位置づけはプロドラッグのバルガンシクロビル (バリキサ) が担う',
    ),
    renalAdjust: 'クレアチニンクリアランス70以上: 初期治療5.0mg/kg 12時間毎, 維持治療5.0mg/kg 24時間毎. 50-69: 初期2.5mg/kg 12時間毎, 維持2.5mg/kg 24時間毎. 25-49: 初期2.5mg/kg 24時間毎, 維持1.25mg/kg 24時間毎. 10-24: 初期1.25mg/kg 24時間毎, 維持0.625mg/kg 24時間毎. 10未満: 初期1.25mg/kgを透析後週3回, 維持0.625mg/kgを透析後週3回',
    periop: 'サイトメガロウイルス感染症 (臓器移植後等) の治療・予防中は手術当日も継続するが, 強い骨髄抑制作用 (好中球減少, 血小板減少, 貧血) があるため, 術前に直近の血算を確認し, 高度の血球減少があれば執刀医・感染症科と休薬・減量を相談する. 血小板減少がある場合は硬膜外麻酔・脊髄くも膜下麻酔などの区域麻酔の適応を慎重に判断する. ジドブジンとの併用で好中球減少が相加的に増強し, イミペネム・シラスタチンとの併用で痙攣の報告があるため周術期の抗菌薬選択にも注意する. CYPを介した麻酔薬との直接的な相互作用はない',
    mechanism: 'ウイルスのUL97キナーゼ等によりリン酸化され活性型三リン酸体となり, ウイルスDNAポリメラーゼを競合的に阻害してDNA合成を停止させる. アシクロビルよりサイトメガロウイルスに対する活性が強いが, 骨髄毒性・生殖毒性が強い',
    packageInsertReviewed: true,
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00051509',
    notes: [
      DrugNote(
        '薬物動態',
        '半減期は腎機能正常時で約3.6時間, 腎機能障害では約11.5時間に延長する. 大部分が未変化体で尿中に排泄され, 血漿蛋白結合率は1-2%と低い',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '骨髄抑制',
        '白血球減少, 好中球減少, 貧血, 血小板減少, 汎血球減少, 再生不良性貧血が重大な副作用であり, 血小板減少に伴う重篤な出血も報告されている. 定期的な血算モニタリングが必須である',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '相互作用',
        'マリバビルとの併用は禁忌である (本剤の活性化に必要なウイルス由来UL97を阻害し拮抗するため). ジドブジンで好中球減少が増強し, イミペネム・シラスタチンナトリウムとの併用で痙攣の報告がある',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '投与経路の注意',
        'pH・浸透圧が高く組織刺激性が強いため, 太い血管から緩徐に点滴し血管外漏出に注意する. 筋注・皮下注・急速静注は禁忌である',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '妊娠・生殖への影響',
        '動物実験で精子形成抑制・催奇形性が示されており, 妊婦及び妊娠する可能性のある女性には投与禁忌, 授乳婦は投与中止とする',
        type: DrugNoteType.packageInsert,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '好中球数500/mm³未満または血小板数25,000/mm³未満の著しい骨髄抑制のある患者',
        '骨髄抑制をさらに悪化させ, 重篤な感染症や出血を来すおそれがあるため',
      ),
      DrugContraindication(
        'ガンシクロビルまたはバルガンシクロビルに対し過敏症の既往歴のある患者',
        '重篤な過敏反応を起こすおそれがあるため',
      ),
      DrugContraindication(
        'マリバビルを投与中の患者',
        '本剤の活性化に必要なウイルス由来UL97を阻害し, 抗ウイルス効果に拮抗するため',
      ),
      DrugContraindication(
        '妊婦, 妊娠する可能性のある女性',
        '動物実験で催奇形性・生殖毒性が報告されているため',
      ),
    ],
    cautiousUse: [
      '骨髄抑制の既往・薬剤による白血球減少の既往のある患者',
      '血小板減少 (25,000-100,000/mm³) のある患者',
      '腎機能障害のある患者',
      '肝機能障害のある患者',
      '精神病の既往歴のある患者',
    ],
  ),
  Drug(
    name: 'オセルタミビル',
    brand: 'タミフル',
    category: DrugCategory.antimicrobial,
    spec: 'タミフルカプセル75, タミフルドライシロップ3%',
    dose: '・治療: 1回75mgを1日2回, 5日間経口投与\n・予防: 1回75mgを1日1回, 7-10日間経口投与',
    forms: DrugFormAvailability(
      hasInjection: false,
      hasOral: true,
      summary: '内服のみ (カプセル, ドライシロップ). 国内に注射剤はない',
    ),
    renalAdjust: 'クレアチニンクリアランス30超: 通常量. 10-30: 治療は1回75mgを1日1回, 予防は1回75mgを隔日投与とする. 透析患者は専門的な用量調節を要する',
    periop: 'インフルエンザ罹患中の周術期患者では, 待機手術は治癒後まで延期するのが原則である. やむを得ず手術が必要な場合, 内服のみの薬剤であるため周術期の絶飲食期間中は経鼻胃管等での投与を検討するか, 静注可能なペラミビルへの切替を考慮する. 異常行動 (特に小児・未成年) が重大な副作用として注意喚起されており, 術後の覚醒時興奮やせん妄との鑑別に留意し, 投与後少なくとも2日間は転落防止などの観察を行う. CYPを介した麻酔薬との相互作用は乏しい',
    mechanism: 'ウイルスのノイラミニダーゼを選択的に阻害し, 感染細胞表面からの新生ウイルス粒子の遊離を阻止することで体内でのウイルス増殖・拡散を抑制する. プロドラッグであり肝エステラーゼにより活性代謝物オセルタミビルカルボキシラートに変換される',
    packageInsertReviewed: true,
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00050037',
    notes: [
      DrugNote(
        '薬物動態',
        '消化管吸収後速やかに活性代謝物へ変換される. 活性体の半減期は約6-9時間で, 未変化のまま腎排泄される (約70-80%)',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '異常行動',
        '転落等の重大事故につながる異常行動 (急に走り出す, 飛び降りようとする等) が報告され, 特に未成年者では注意が必要である. インフルエンザ自体でも異常行動は起こりうる',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '重大な副作用',
        'ショック, 肺炎, 劇症肝炎, 肝機能障害, 皮膚粘膜眼症候群 (Stevens-Johnson症候群), 急性腎障害, 出血性大腸炎, 白血球減少, 血小板減少が記載されている',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '剤形の限界',
        '内服のみで注射剤がなく, 重症例や経口摂取不能例ではペラミビル静注が代替となる',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'ワクチンとの相互作用',
        '経鼻弱毒生インフルエンザワクチンの効果を減弱させるおそれがあるため, 接種前後の投与間隔に注意する',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 投与タイミング',
        '発症後48時間以内の投与開始が原則だが, 入院患者では発症後5日以内の治療開始でも生存率改善につながる. 重症/進行性インフルエンザや合併症高リスクの入院患者では, 検査結果を待たず全例で経験的投与を開始する.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 腎機能調節',
        '腎排泄型のため, CrCl 30mL/分未満では減量が必要(通常量75mgから30-45mgへ). 病的肥満患者では150mg 1日2回が使用されることがあるが, FDA未承認である.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 高用量の限界',
        'A型H1N1に対して高用量(150mg 1日2回)にしても通常量より効果が増大するわけではない.\n[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        '重篤な過敏反応を起こすおそれがあるため',
      ),
    ],
    cautiousUse: [
      '腎機能障害のある患者',
      '高齢者',
      '妊婦・授乳婦',
    ],
  ),
  Drug(
    name: 'ペラミビル',
    brand: 'ラピアクタ',
    category: DrugCategory.antimicrobial,
    spec: 'ラピアクタ点滴静注液バッグ300mg (300mg/60mL, 生食希釈済み), ラピアクタ点滴静注液バイアル150mg (150mg/15mL)',
    dose: '・通常: 300mgを15分以上かけて単回点滴静注\n・重症化リスクの高い患者・重症患者: 1日1回600mgを点滴静注し, 症状に応じ連日反復投与可能',
    forms: DrugFormAvailability(
      hasInjection: true,
      hasOral: false,
      summary: '注射 (点滴静注用) のみの抗インフルエンザ薬. 経口摂取不能な重症例や周術期患者に有用',
    ),
    renalAdjust: 'クレアチニンクリアランス50以上: 通常量 (300mg, 重症化リスク患者600mg). 30-50: 100mg (重症化リスク患者200mg). 10-30: 50mg (重症化リスク患者100mg). さらなる腎機能低下例や血液透析患者は添付文書のクレアチニンクリアランス別投与量に従いさらに減量するか透析後に投与する',
    periop: '単回静注で治療が完結しうる唯一の抗インフルエンザ薬であり, 経口摂取不能な周術期・ICU患者や, 緊急手術が避けられないインフルエンザ罹患患者において内服薬 (オセルタミビル等) の代替として有用である. CYP酵素の阻害・誘導作用がなくP糖蛋白との相互作用も報告されていないため, 麻酔薬・鎮静薬との薬物相互作用は乏しい. 待機手術ではインフルエンザ治癒後まで延期するのが原則だが, 緊急手術が必要な場合は本剤投与後の呼吸器合併症・二次感染のリスクを念頭に周術期管理を行う',
    mechanism: 'ウイルスのノイラミニダーゼを選択的かつ持続的に阻害し, 感染細胞からの新生ウイルス粒子の遊離を阻止することで増殖を抑制する. オセルタミビルと異なりプロドラッグではなく, 静注により速やかに有効血中濃度に達する',
    packageInsertReviewed: true,
    packageInsertUrl: 'https://www.kegg.jp/medicus-bin/japic_med?japic_code=00060652',
    notes: [
      DrugNote(
        '薬物動態',
        '平均滞留時間 (MRT) は約3時間と短く速やかに消失する腎排泄型の薬剤で, 尿中排泄率は86-95%, 血漿蛋白結合率は低い',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '単回投与の特徴',
        '通常例では300mgの単回静注で治療が完結するが, 重症例・免疫低下例では連日反復投与が可能で, 経口薬に比べコンプライアンスの問題がない',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '重大な副作用',
        'ショック, アナフィラキシー, 白血球減少, 肝機能障害, 急性腎障害, 異常行動, 肺炎, 皮膚粘膜眼症候群がオセルタミビルと同様に注意喚起されている',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '相互作用の少なさ',
        'CYP酵素の阻害・誘導作用がなく, P糖蛋白との相互作用も報告されていないため, 多剤併用中の重症患者でも使いやすい',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '適応の位置づけ',
        '経口・吸入薬が使用できない重症患者, 経口摂取不能例, 耐性ウイルス感染疑い例などで選択される',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        'GL/成書: 用法',
        '急性で合併症のないインフルエンザには600mg静注1回投与がFDA承認用量. 入院患者への承認用量はないが, 200-400mg静注1日1回を5日間投与する使用法が臨床試験で用いられている.\n'
          '[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
      DrugNote(
        'GL/成書: 耐性',
        'オセルタミビル耐性株(H275Y変異)はペラミビルに対しても中等度耐性を示すため, 単純な切り替えでは効果不十分なことがある.\n[出典] サンフォード感染症治療ガイド 2024',
        type: DrugNoteType.literature,
      ),
    ],
    contraindications: [
      DrugContraindication(
        '本剤の成分に対し過敏症の既往歴のある患者',
        '重篤な過敏反応を起こすおそれがあるため',
      ),
    ],
    cautiousUse: [
      '心臓・循環器系機能障害のある患者',
      '腎機能障害のある患者',
      '妊婦・授乳婦',
      '高齢者',
    ],
  ),
];
