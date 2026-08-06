import '../../models/drug.dart';

/// 薬剤データ: 吸入麻酔薬. 電子添文確認済み薬剤から新形式へ移行する.
const List<Drug> kInhalationalDrugs = [
  Drug(
    name: 'セボフルラン',
    brand: 'セボフレン',
    category: DrugCategory.inhalational,
    dose:
        '導入: 通常0.5-5.0%.\n'
        '維持: 臨床徴候を観察しながら最小有効濃度に調節. 通常4.0%以下.',
        doseLimit: '・維持濃度は通常4.0%以下\n・導入濃度は5.0%以下 (0.5-5.0%の範囲)',
    mechanism:
        '中枢神経系を可逆的に抑制し, 意識消失, 鎮痛, 筋弛緩を生じる. GABA-A受容体促進やグルタミン酸受容体抑制などが関与する.',
    packageInsertReviewed: true,
    packageInsertRevision: '2023年6月改訂 第1版',
    packageInsertUrl:
        'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/730119_1119702G1062_1_10',
    contraindications: [
      DrugContraindication(
        'ハロゲン化麻酔剤使用後に黄疸または原因不明の発熱がみられた患者',
        '再投与で同様の症状があらわれるおそれがある.',
      ),
      DrugContraindication('本剤成分に対する過敏症の既往', '再投与で重篤な過敏反応を起こすおそれがある.'),
    ],
    cautiousUse: [
      '胆道疾患',
      'スキサメトニウム投与で筋強直の既往',
      '悪性高熱の家族歴',
      'てんかんの既往',
      '心疾患・心電図異常',
      'セントラルコア病等の悪性高熱関連筋疾患',
      '筋ジストロフィー',
      '腎・肝機能障害',
      '妊娠・産科麻酔・授乳中',
      '高齢者',
    ],
    notes: [
      DrugNote(
        '麻酔中の管理',
        '麻酔の深度は必要最小限にとどめ, 呼吸・循環を連続監視する. 高濃度導入時, 特に過換気下で異常脳波や異常運動がみられることがある.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '悪性高熱と重大な副作用',
        '原因不明の終末呼気CO2上昇, 頻脈, 不整脈, 筋強直, 急激な体温上昇などで悪性高熱を疑う. 直ちに投与を中止し, ダントロレン, 冷却, 純酸素過換気等の緊急対応へ移行する. 横紋筋融解, 痙攣, 重篤な不整脈, 肝機能障害にも注意する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '年齢補正と終末呼気濃度',
        '年齢によるMAC低下を考慮した濃度設定を用いる施設がある. 当アプリの成人導入画面にある etSev = 1.7 - 0.01 × 年齢 は施設運用上の目安であり, 電子添文の固定用量ではない. 手術刺激, 併用薬, 血圧, 脳波指標に応じて調節する.',
        type: DrugNoteType.facilityPractice,
      ),
      DrugNote(
        'Low flowと消費量',
        '吸入濃度と新鮮ガス流量から消費量を見積もる方法があるが, ソーダライム, 回路漏れ, 患者摂取量により差が生じる. Low flowへの移行は呼気濃度と麻酔深度を確認し, 院内運用に従う.',
        type: DrugNoteType.facilityPractice,
      ),
      DrugNote(
        'MEP・循環・呼吸への影響',
        '揮発性吸入麻酔薬はMEPを濃度依存性に抑制しうるが, 「MEPなら必ずTIVA」とは限らない. 信号条件と手術目的を神経生理チームと共有する. 用量依存性の呼吸抑制・血圧低下を前提に投与し, 「脳保護作用がある」と一律に判断しない.',
        type: DrugNoteType.literature,
      ),
    ],
  ),
  Drug(
    name: 'デスフルラン',
    brand: 'スープレン',
    category: DrugCategory.inhalational,
    dose: '全身麻酔の維持のみ: 成人は3.0%で開始し, 臨床徴候に応じて調節. 亜酸化窒素併用の有無にかかわらず7.6%以下.',
    doseLimit: '・維持濃度は亜酸化窒素併用の有無にかかわらず7.6%以下',
    mechanism: '低い血液/ガス分配係数により, 麻酔深度の調節と角醒が比較的速い揮発性吸入麻酔薬.',
    packageInsertReviewed: true,
    packageInsertRevision: '2024年1月改訂 第3版',
    packageInsertUrl:
        'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/641754_1119703G1024_2_01',
    contraindications: [
      DrugContraindication(
        '本剤または他のハロゲン化麻酔剤に対する過敏症の既往',
        '再投与で重篤な過敏反応を起こすおそれがある.',
      ),
      DrugContraindication('悪性高熱の既往または家族歴', '悪性高熱があらわれやすいと報告されている.'),
    ],
    cautiousUse: [
      '脳に器質的障害',
      '冠動脈疾患',
      '心疾患・心電図異常',
      '胆道疾患',
      '筋ジストロフィー',
      'スキサメトニウム投与で筋強直の既往',
      '肝機能障害',
      '妊娠・産科麻酔・授乳中',
      '小児',
      '高齢者',
    ],
    notes: [
      DrugNote(
        '導入に使用しない',
        '気道刺激性が強いため, 承認効能は全身麻酔の維持のみであり, 麻酔導入には使用しない.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '循環・気道への影響',
        '急激な濃度上昇で心拍数増加や血圧上昇をきたすことがある. 特に冠動脈疾患では急激な増量を避ける. 咳嗽, 嗄声, 喉頭痙攣などの気道有害事象に注意する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '小児への投与',
        '国内の小児等を対象とした臨床試験は実施されていない. 海外で6歳以下のフェイスマスクまたはラリンジアルマスク使用時に, 咳嗽, 喉頭痙攣, 分泌亢進等が多く報告されている. 一律の年齢禁忌とは表記しない.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '年齢補正と終末呼気濃度',
        '当アプリの成人導入画面にある etDes = 6.0 - 0.04 × 年齢 は施設運用上の目安であり, 電子添文の固定用量ではない. 手術刺激, 併用薬, 循環, 脳波指標に応じて調節する.',
        type: DrugNoteType.facilityPractice,
      ),
      DrugNote(
        'MEP・神経麻酔',
        'デスフルランは角醒が比較的速いが, それだけで脳神経外科に最適とは限らない. 揮発性麻酔薬によるMEP抑制, 頭蓋内コンプライアンス, 循環状態を考慮して麻酔法を選ぶ.',
        type: DrugNoteType.literature,
      ),
    ],
  ),
  Drug(
    name: '笑気 (亜酸化窒素)',
    brand: '液化亜酸化窒素',
    category: DrugCategory.inhalational,
    dose: '酸素と併用し, 酸素の吸気中濃度は必ず20%以上に保つ. 目的・患者状態に応じて酸素濃度を増加する.',
    doseLimit: '・吸気酸素濃度を20%以上に保つ (亜酸化窒素は残り80%以下が上限の目安)',
    mechanism: 'NMDA受容体抑制等を介して鎮痛・麻酔作用を示す吸入ガス.',
    packageInsertReviewed: true,
    packageInsertRevision: '2024年1月改訂 第2版',
    packageInsertUrl:
        'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/530097_1116700X1061_1_10',
    cautiousUse: [
      'ビタミンB12欠乏症',
      '造血機能障害',
      '耳管閉塞・気胸・腸閉塞・気脳症等の閉鎖腔',
      '眼内ガス残存中 (電子添文9.1.4で使用しない)',
      '妊娠初期',
    ],
    notes: [
      DrugNote(
        '酸素濃度と基本管理',
        '酸素を必ず併用し, 吸気中酸素濃度を20%以上に保つ. 気道, 呼吸, 循環, 麻酔深度を連続監視する. ビタミンB12不活性化による造血障害・神経障害に注意する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '閉鎖腔と眼内ガス',
        '耳管閉塞, 気胸, 腸閉塞, 気脳症などでは閉鎖腔の容積・内圧を上昇させる. パーフルオロプロパンや六フッ化硫黄等の眼内ガスが残存する患者では, 急激な眼圧上昇と失明のおそれがあるため使用しない. これは電子添文の「2. 禁忌」ではなく9.1.4の使用回避指示である.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '使用濃度の例',
        '50%前後を併用する施設運用があるが, 電子添文は固定濃度を示していない. 必要なFiO2, 閉鎖腔, PONVリスク, 併用麻酔薬を考慮する.',
        type: DrugNoteType.facilityPractice,
      ),
      DrugNote(
        '二次ガス効果・拡散性低酸素血症',
        '二次ガス効果と投与終了時の拡散性低酸素血症は薬理学的特徴である. 投与終了後は患者の酸素化と換気を監視し, 必要な酸素を投与する. 「循環抑制はない」と断定しない.',
        type: DrugNoteType.literature,
      ),
    ],
  ),
  Drug(
    name: 'ダントロレン',
    brand: 'ダントリウム静注用',
    category: DrugCategory.inhalational,
    spec: '20mg/V',
    dilution: '1V + 注射用水60mL',
    concentration: '0.333mg/mL',
    dose:
        '悪性高熱症: 初回1mg/kgを静注. 改善がなければ1mg/kgずつ追加し, 総量7mg/kgまで.\n'
        '悪性症候群: 成人初回40mg, 改善がなければ20mgずつ追加. 1日200mgまで, 通常7日以内.',
        doseLimit: '・悪性高熱症: 総量7mg/kgまで\n・悪性症候群: 1日200mgまで, 通常7日以内',
    mechanism: '骨格筋の筋小胞体RyR1からのCa放出を抑制し, 過剰な筋収縮と代謝亢進を抑える.',
    packageInsertReviewed: true,
    packageInsertRevision: '2023年11月改訂 第1版',
    packageInsertUrl:
        'https://www.pmda.go.jp/PmdaSearch/iyakuDetail/181251_1229402D1039_2_03',
    cautiousUse: [
      '肺機能障害, 特に閉塞性肺疾患',
      '心筋疾患による重篤な心機能障害',
      '筋無力症状',
      'イレウス',
      '肝機能障害',
      '妊娠・授乳中',
      '高齢者',
    ],
    notes: [
      DrugNote(
        '電子添文の用量',
        '本邦電子添文の悪性高熱症用量は初回1mg/kg, 改善がなければ1mg/kgずつ追加, 総量7mg/kgまでである. 1Vに日局注射用水60mLを加え, 澄明になったことを確認して使用する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '緊急投与する理由',
        '悪性高熱症は筋細胞内Ca過負荷により高代謝, 高炭酸ガス血症, 高カリウム血症, 横紋筋融解, 致死性不整脈が急速に進行する. 原因薬を中止し, ダントロレン調製と投与を最優先で開始する. 並行して純酸素過換気, 冷却, 電解質・酸塩基異常へ対応する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '肝機能と重大な副作用',
        '投与開始後は肝機能検査を行う. 救命を最優先とし, 異常時も有益性が危険性を上回る場合のみ継続を検討する. 呼吸不全, イレウス, ショック, 肝機能障害, 血管外漏出に注意する.',
        type: DrugNoteType.packageInsert,
      ),
      DrugNote(
        '国際ガイドラインとの用量差',
        'MHAUS等の国際的な悪性高熱症手順では, 初回2.5mg/kgを急速静注し, 反応をみて追加する手順が用いられる. これは本邦電子添文の1mg/kg開始・総量7mg/kgと異なるため, 両者を同一の承認用量として混在させない. 実際は院内悪性高熱手順と専門家の指示を優先する.',
        type: DrugNoteType.literature,
      ),
    ],
  ),
];
