import 'package:flutter/material.dart';

/// 緊急対応タブ — 術中緊急プロトコルの一覧
class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                '緊急対応',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                children: const [
                  Card(
                    color: Color(0xFFFFEBEE),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        '緊急時は応援要請・院内緊急プロトコルの起動を最優先とする. 本画面は記憶補助であり, 患者状態と最新ガイドラインに基づき上級医が判断する.',
                        style: TextStyle(
                          color: Color(0xFFB71C1C),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  _EmergencySection(
                    title: '術中不整脈',
                    icon: Icons.favorite,
                    color: Color(0xFFE57373),
                    protocols: [
                      _Protocol(
                        title: '洞性徐脈 (HR < 50)',
                        body:
                            '■ 原因を除外\n'
                            '・迷走神経反射（牽引刺激），高カリウム血症，局所麻酔薬中毒，低体温，高度徐脈性不整脈（AVB）\n\n'
                            '■ 治療\n'
                            '① 心肺虚脱を伴う場合: アトロピン 1mg iv, 3〜5分毎（最大3mg）\n'
                            '② 無効なら経皮ペーシングを準備し, ドパミン 5〜20mcg/kg/min またはアドレナリン 2〜10mcg/minを滴定\n'
                            '③ 高度房室ブロックではアトロピンに固執せず, 早期にペーシング・循環器コール\n'
                            '④ 低酸素, 虚血, 薬剤, 電解質異常など可逆的原因を治療\n\n'
                            'AHA 2025成人徐脈アルゴリズムに準拠. 無症候性徐脈へ一律に投薬しない.',
                      ),
                      _Protocol(
                        title: '上室性頻拍 (SVT, narrow QRS)',
                        body:
                            '■ 血行動態が安定している場合\n'
                            '① 迷走神経刺激（バルサルバ，頸動脈洞マッサージ）\n'
                            '② アデノシン 6mg 急速 iv（末梢静脈可）→ 無効なら 12mg → 再度 12mg\n'
                            '   ※気管支痙攣・房室ブロック・顔面紅潮に注意\n'
                            '③ ベラパミル 5mg iv（WPW禁忌，ΔWが見えたら絶対使わない）\n'
                            '④ ジルチアゼム 0.3mg/kg iv（心機能低下なら注意）\n\n'
                            '■ 血行動態が不安定な場合\n'
                            '→ 同期直流通電 50〜100J（DC カルディオバージョン）\n'
                            '   全身麻酔中であれば通電前の鎮静は省略可',
                      ),
                      _Protocol(
                        title: '心房細動 (AF, 術中新規発症)',
                        body:
                            '■ まず: 誘因を除去\n'
                            '・低酸素, 高CO2, 低体温, 電解質異常（K・Mg）, 疼痛刺激\n\n'
                            '■ Rate control（心拍 < 110 を目標）\n'
                            '① ランジオロール 0.04〜0.06mg/kg iv（心機能低下時も使いやすい）\n'
                            '② ジルチアゼム 0.3mg/kg iv（心機能保たれている場合）\n\n'
                            '■ Rhythm control（発症 < 48h）\n'
                            'アミオダロン 150mg/10min iv → 1mg/min × 6h → 0.5mg/min × 18h\n\n'
                            '■ 血行動態不安定\n'
                            '→ 同期直流通電 200J（両相性）\n\n'
                            '■ 術前AF既往あり → 抗凝固の継続確認',
                      ),
                      _Protocol(
                        title: '心室頻拍/細動 (VT/VF)',
                        body:
                            '■ VT（wide QRS，規則的）\n'
                            '① 血行動態安定 → アミオダロン 150mg/10min iv\n'
                            '② 血行動態不安定 → 同期直流通電 200J（両相性）\n'
                            '③ Torsades de Pointes（QT延長型） → 硫酸Mg 2g/5min iv\n\n'
                            '■ VF / pulseless VT → CPR 開始\n'
                            '① 胸骨圧迫 100〜120回/min，深さ 5〜6cm，解除完全\n'
                            '② 電気的除細動 200J（両相性）→ CPR 2min → 再評価\n'
                            '③ アドレナリン 1mg iv（3〜5分毎）\n'
                            '④ 3回除細動後も無効 → アミオダロン 300mg iv\n'
                            '⑤ 可逆的原因（6H-6T）を検索・治療\n\n'
                            '6H: 低酸素, 低血液量, 低体温, H+（アシドーシス）, 低K/高K, 低血糖\n'
                            '6T: 気胸, 心タンポナーデ, 血栓（PE/MI）, 薬物中毒',
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  _EmergencySection(
                    title: 'アナフィラキシー',
                    icon: Icons.warning_amber,
                    color: Color(0xFFFFA726),
                    protocols: [
                      _Protocol(
                        title: '術中アナフィラキシー対応プロトコル',
                        body:
                            '■ Step 1: 原因薬の中止\n'
                            '疑われる薬剤（筋弛緩薬，ラテックス，抗菌薬，造影剤）を直ちに中止\n\n'
                            '■ Step 2: アドレナリン（最優先）\n'
                            '静脈路あり: 成人・12歳超は50mcg iv, 12歳未満は1mcg/kg ivを慎重に希釈し, 反応をみて滴定\n'
                            '静脈路なし: 10mcg/kg im（最大500mcg, 1mg/mL製剤）後, IV/IOを確保\n'
                            '反応不良なら院内手順でアドレナリン持続投与. 難治性ではノルアドレナリン/バソプレシン等を追加検討\n'
                            '収縮期血圧 <50mmHg または心停止ではCPRを開始. 1mg ivは心停止時のALS用量であり, 脈あり患者へ投与しない\n\n'
                            '■ Step 3: 輸液\n'
                            '成人・12歳超 500〜1000mL, 12歳未満 20mL/kgを急速投与し反応で反復. 膠質液は避ける\n\n'
                            '■ Step 4: 追加治療\n'
                            '・気管支痙攣: サルブタモール＋イプラトロピウム吸入, 必要時iv気管支拡張薬\n'
                            '・抗ヒスタミン薬は循環安定後の皮膚症状に対する二次治療\n'
                            '・ステロイドは初期蘇生の代替ではない. 難治性反応/遷延性ショックで検討\n'
                            '・安定後にトリプターゼ採血とアレルギー精査を手配\n\n'
                            '■ 注意点\n'
                            '・静注アドレナリンは麻酔科医/集中治療医が連続監視下で希釈・滴定する\n'
                            '・RCUK周術期アナフィラキシーアルゴリズムと院内手順を優先する',
                      ),
                      _Protocol(
                        title: 'アスピリン喘息（NSAIDs過敏性）',
                        body:
                            '■ 特徴\n'
                            '20〜40代女性に多い。NSAIDs投与後15〜30分で喘息発作。70%に慢性副鼻腔炎・鼻茸合併。\n\n'
                            '■ 使用可能な薬剤\n'
                            '塩基性解熱鎮痛薬（ソランタール），メロキシカム，セレコキシブ，アセトアミノフェン\n\n'
                            '■ 使用禁忌\n'
                            'アスピリン・NSAIDs（酸性）全般，コハク酸エステル型ステロイド（ソルメドロール，ソルコーテフ）\n\n'
                            '■ 発作時治療\n'
                            '挿管確認（食道挿管除外）→ 純酸素・Sev 8% → アドレナリン筋注 0.3mg\n'
                            '→ ステロイド（コハク酸型は避け，リン酸エステル型：デカドロン）を 1h 以上かけて投与\n'
                            '→ アミノフィリン 250mg/10min → ポララミン 5mg iv',
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  _EmergencySection(
                    title: '肺塞栓症 (PE)',
                    icon: Icons.air,
                    color: Color(0xFF64B5F6),
                    protocols: [
                      _Protocol(
                        title: '術中急性肺塞栓症の診断と初期対応',
                        body:
                            '■ 疑うサイン\n'
                            '突然の ETCO2 低下（死腔増大）+ SpO2↓ + 血圧↓ + 洞性頻脈\n'
                            'ECG: 洞頻脈，右軸偏位，S1Q3T3，V1-V4 のT波逆転（右心負荷）\n'
                            'TEE/TTE: 右室拡大，D-shape，IVC 拡張\n\n'
                            '■ 初期対応\n'
                            '① 原因の確認: 空気塞栓 vs 血栓塞栓（骨折・整形外科手術後に多い）\n'
                            '② 純酸素 100%\n'
                            '③ 循環サポート: NAd 0.1〜0.2γ（後負荷軽減目的の血管拡張薬は禁忌）\n'
                            '④ 右心不全: DOB 2〜5γ 追加（右室収縮力↑）\n'
                            '⑤ 輸液負荷（右室過負荷になるため慎重に，生食 250〜500mL まで）\n\n'
                            '■ 大量 PE（循環虚脱）の治療\n'
                            '血栓溶解療法（非術中）: rt-PA 100mg/2h iv\n'
                            '手術中/術直後: 外科的肺動脈血栓除去術 or ECMO 導入を考慮\n'
                            '抗凝固（非術中）: ヘパリン 5000単位ボーラス → 18単位/kg/h 持続\n\n'
                            '■ 空気塞栓の場合\n'
                            '→ N2O 使用中なら直ちに中止，純酸素へ\n'
                            '→ 術野の水浸し・骨蝋処置\n'
                            '→ Durant 体位（左側臥位・頭低位）\n'
                            '→ 右心カテーテルから空気吸引',
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  _EmergencySection(
                    title: '悪性高熱症 (MH)',
                    icon: Icons.thermostat,
                    color: Color(0xFFBA68C8),
                    protocols: [
                      _Protocol(
                        title: '悪性高熱症の診断と対応',
                        body:
                            '■ 診断: 下記のいずれかが突然出現\n'
                            '・SpEtCO2 急上昇（最初のサイン），SnO2 低下\n'
                            '・骨格筋硬直（ジョーロック・全身筋硬直）\n'
                            '・体温急上昇（> 38.8℃/15min，最大 > 44℃）\n'
                            '・代謝性+呼吸性アシドーシス，CK 著増，ミオグロビン尿（赤褐色尿）\n'
                            '原因: ハロゲン化揮発性麻酔薬・スクシニルコリン（常染色体優性 RYR1/CACNA1S 変異）\n\n'
                            '■ 緊急対応（MHAUS プロトコル）\n'
                            '① 原因薬即時中止，純酸素 10L/min（高流量），換気量増加（CO2 排出）\n'
                            '② ダントロレン 2.5mg/kg iv 急速（蒸留水 60mL に溶解）→ 症状消失まで 10mg/kg まで反復\n'
                            '③ 冷却: 冷生食 iv，体表冷却，胃/膀胱洗浄，心肺バイパス\n'
                            '④ 重炭酸 1〜2mEq/kg iv（アシドーシス補正）\n'
                            '⑤ 高K血症 → グルコース＋インスリン，Ca グルコン酸塩\n'
                            '⑥ 不整脈 → アミオダロン（Ca 拮抗薬は禁忌）\n'
                            '⑦ 腎保護 → 輸液＋フロセミド＋マンニトール\n'
                            '⑧ 再燃予防: ダントロレン 1mg/kgを4〜6時間毎, 少なくとも24時間. 代替として0.25mg/kg/h持続を検討\n\n'
                            '■ ダントロレンの溶解\n'
                            '20mg/V を蒸留水 60mL で溶解（溶解に時間がかかるため複数人で同時調製）\n'
                            '70kg 成人 2.5mg/kg = 175mg = 9バイアル',
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  _EmergencySection(
                    title: '局所麻酔薬中毒 (LAST)',
                    icon: Icons.vaccines,
                    color: Color(0xFFA5A6A8), // 局所麻酔薬に合わせた灰色（淡め）
                    protocols: [
                      _Protocol(
                        title: '局所麻酔薬全身毒性 (LAST) の対応',
                        body:
                            '■ 症状（通常は血管内誤注入後すぐ，場合により20-30分後）\n'
                            '神経系: 口唇しびれ・耳鳴り・金属味 → 振戦・痙攣 → 意識消失\n'
                            '循環器: 徐脈・QRS拡大・VT/VF・心停止\n'
                            '※ブピバカインは特に循環毒性が強く，心室性不整脈が先行することも\n\n'
                            '■ 初期対応\n'
                            '① 原因薬中止，応援コール，蘇生準備\n'
                            '② 気道確保 + 純酸素（過換気で pH 改善 → 毒性↓）\n'
                            '③ 痙攣 → ベンゾジアゼピンを優先. プロポフォールしかない場合は20mgずつ少量投与し, 循環不安定時は避ける\n\n'
                            '■ 脂肪乳剤（イントラリピッド 20%）投与\n'
                            '① ボーラス 1.5mL/kg（70kgなら 105mL）ivを1〜2分かけて\n'
                            '② 持続 0.25mL/kg/min（循環回復するまで, 最大累積12mL/kg）\n'
                            '③ 無効なら 5分後にボーラス 2回目\n\n'
                            '■ 心停止時\n'
                            '→ CPR 開始 + 脂肪乳剤\n'
                            '→ アドレナリンは少量（< 1μg/kg）に\n'
                            '→ 心室性不整脈にはアミオダロンを検討. 局所麻酔薬（リドカインを含む）は追加しない\n'
                            '→ β遮断薬, Ca拮抗薬, バソプレシンを避ける\n'
                            '→ 上記無効 → ECMO/人工心肺を早期に検討',
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  _EmergencySection(
                    title: '高K血症の補正',
                    icon: Icons.bolt,
                    color: Color(0xFF4DD0E1),
                    protocols: [
                      _Protocol(
                        title: '高カリウム血症の対応',
                        body:
                            '■ ① 心臓の感受性を下げる（膜安定化）\n'
                            '・カルチコール（グルコン酸Ca）… 心電図変化があれば最優先。血清Kは下げないが心筋を保護する。\n\n'
                            '■ ② 細胞内へKを取り込ませる\n'
                            '・GI療法（グルコース＋インスリン）\n'
                            '・メイロン（重炭酸Na）… アシドーシス補正を介して細胞内移行\n'
                            '・メプチン（β2刺激薬）吸入 … 副作用：頻脈\n\n'
                            '■ ③ 全体的に体外へ排泄して下げる\n'
                            '・フロセミド（利尿）\n'
                            '・CRRT（血液浄化）\n'
                            '・ロケルマ … 経腸的に血中のKを吸着して排泄させる\n\n'
                            '■ 補足\n'
                            '・腎機能低下に伴う高Kではメイロンが使いやすい。\n'
                            '・ただし呼吸状態が悪いときはCO2を貯留させ呼吸性アシドーシスを助長するため注意。',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── データクラス ───────────────────────────────────────

class _Protocol {
  final String title;
  final String body;
  const _Protocol({required this.title, required this.body});
}

// ─── セクションウィジェット ────────────────────────────

class _EmergencySection extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<_Protocol> protocols;

  const _EmergencySection({
    required this.title,
    required this.icon,
    required this.color,
    required this.protocols,
  });

  @override
  State<_EmergencySection> createState() => _EmergencySectionState();
}

class _EmergencySectionState extends State<_EmergencySection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // セクションヘッダー
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Container(
              color: widget.color,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(widget.icon, color: Colors.white, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.expand_more,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // プロトコルリスト
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 220),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < widget.protocols.length; i++) ...[
                    if (i > 0) const SizedBox(height: 8),
                    _ProtocolCard(
                      protocol: widget.protocols[i],
                      color: widget.color,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProtocolCard extends StatelessWidget {
  final _Protocol protocol;
  final Color color;
  const _ProtocolCard({required this.protocol, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: color, width: 3.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
          // 展開時の中身を左詰めに(既定の中央寄せだと左が大きく空く)
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.topLeft,
          title: Text(
            protocol.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: color.withValues(alpha: 0.9),
            ),
          ),
          iconColor: color,
          collapsedIconColor: color.withValues(alpha: 0.5),
          children: [
            Text(
              protocol.body,
              style: const TextStyle(height: 1.75, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
