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
              child: Text('緊急対応',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                children: const [
                  _EmergencySection(
                    title: '術中不整脈',
                    icon: Icons.favorite,
                    color: Color(0xFFB71C1C),
                    protocols: [
                      _Protocol(
                        title: '洞性徐脈 (HR < 50)',
                        body: '■ 原因を除外\n'
                            '・迷走神経反射（牽引刺激），高カリウム血症，局所麻酔薬中毒，低体温，高度徐脈性不整脈（AVB）\n\n'
                            '■ 治療\n'
                            '① アトロピン 0.5mg iv → 無効なら 0.5mg 追加（最大 2mg）\n'
                            '② エフェドリン 4〜8mg iv（低血圧合併時）\n'
                            '③ ドパミン 5〜15γ（持続性低血圧の場合）\n'
                            '④ 上記無効 → アドレナリン 0.01〜0.1γ 開始\n'
                            '⑤ ペーシング適応（3度AVBなど）→ 心臓外科コール',
                      ),
                      _Protocol(
                        title: '上室性頻拍 (SVT, narrow QRS)',
                        body: '■ 血行動態が安定している場合\n'
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
                        body: '■ まず: 誘因を除去\n'
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
                        body: '■ VT（wide QRS，規則的）\n'
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
                    color: Color(0xFFE65100),
                    protocols: [
                      _Protocol(
                        title: '術中アナフィラキシー対応プロトコル',
                        body: '■ Step 1: 原因薬の中止\n'
                            '疑われる薬剤（筋弛緩薬，ラテックス，抗菌薬，造影剤）を直ちに中止\n\n'
                            '■ Step 2: アドレナリン（最優先）\n'
                            '成人 0.3〜0.5mg 筋注（大腿中央外側），小児 0.01mg/kg\n'
                            '重篤/循環虚脱 → アドレナリン 0.1〜1mg iv（1mg/10mL に希釈して少量ずつ）\n'
                            '持続 → NAd 0.05〜0.1γ から開始\n\n'
                            '■ Step 3: 輸液\n'
                            '生食 1〜2L 急速投与（血管拡張・血液分布異常による循環虚脱に対応）\n\n'
                            '■ Step 4: 追加治療\n'
                            '・ポララミン 5mg iv（抗ヒスタミン）\n'
                            '・ファモチジン 20mg iv（H2ブロッカー）\n'
                            '・ヒドロコルチゾン 100〜200mg iv（ステロイド，遅発反応予防）\n'
                            '・気管支痙攣 → サルブタモール吸入 or アミノフィリン 250mg/20min\n\n'
                            '■ 注意点\n'
                            '・アドレナリンを躊躇しない（遅れは死亡リスク↑）\n'
                            '・β2作用でマスト細胞脱顆粒を抑制する効果もある\n'
                            '・II誘導でST低下を認めることがある（低血圧によるcoronary flow↓）\n'
                            '・ラテックスアレルギーが疑われる場合は術野のゴム製品も除去',
                      ),
                      _Protocol(
                        title: 'アスピリン喘息（NSAIDs過敏性）',
                        body: '■ 特徴\n'
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
                    color: Color(0xFF1565C0),
                    protocols: [
                      _Protocol(
                        title: '術中急性肺塞栓症の診断と初期対応',
                        body: '■ 疑うサイン\n'
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
                    color: Color(0xFF6A1B9A),
                    protocols: [
                      _Protocol(
                        title: '悪性高熱症の診断と対応',
                        body: '■ 診断: 下記のいずれかが突然出現\n'
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
                            '⑧ ダントロレン 1mg/kg/h 持続 × 24〜48h（再発予防）\n\n'
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
                    color: Color(0xFF00695C),
                    protocols: [
                      _Protocol(
                        title: '局所麻酔薬全身毒性 (LAST) の対応',
                        body: '■ 症状（通常は血管内誤注入後すぐ，場合により20-30分後）\n'
                            '神経系: 口唇しびれ・耳鳴り・金属味 → 振戦・痙攣 → 意識消失\n'
                            '循環器: 徐脈・QRS拡大・VT/VF・心停止\n'
                            '※ブピバカインは特に循環毒性が強く，心室性不整脈が先行することも\n\n'
                            '■ 初期対応\n'
                            '① 原因薬中止，応援コール，蘇生準備\n'
                            '② 気道確保 + 純酸素（過換気で pH 改善 → 毒性↓）\n'
                            '③ 痙攣 → ミダゾラム 2〜5mg iv or プロポフォール 0.5〜1mg/kg iv\n\n'
                            '■ 脂肪乳剤（イントラリピッド 20%）投与\n'
                            '① ボーラス 1.5mL/kg（70kgなら 105mL）ivを1〜2分かけて\n'
                            '② 持続 0.25mL/kg/min（循環回復するまで，最大累積 10mL/kg まで）\n'
                            '③ 無効なら 5分後にボーラス 2回目\n\n'
                            '■ 心停止時\n'
                            '→ CPR 開始 + 脂肪乳剤\n'
                            '→ アドレナリンは少量（< 1μg/kg）に\n'
                            '→ 上記無効 → ECMO 導入考慮\n'
                            '→ リドカインで LAST が起きた場合：アミオダロン/リドカイン 禁忌，プロポフォールは慎重に',
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    child: const Icon(Icons.expand_more,
                        color: Colors.white, size: 24),
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
                        protocol: widget.protocols[i], color: widget.color),
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
        border: Border(
          left: BorderSide(color: color, width: 3.5),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          childrenPadding:
              const EdgeInsets.fromLTRB(14, 0, 14, 12),
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
