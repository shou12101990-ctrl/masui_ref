import 'package:flutter/material.dart';

import '../domain/calculators/allowable_blood_loss.dart';
import '../state/patient_store.dart';
import '../widgets/calc_parts.dart';

/// 許容出血量計算機
/// 体重・現在Hb・許容Hb から循環血液量(EBV)と許容出血量(ABL)を算出する。
/// ABL = EBV × (Hb初期 − Hb許容) / Hb平均   （Gross の式）
class AllowableBloodLossScreen extends StatefulWidget {
  const AllowableBloodLossScreen({super.key});

  @override
  State<AllowableBloodLossScreen> createState() =>
      _AllowableBloodLossScreenState();
}

class _EbvCoef {
  final String label;
  final int mlPerKg;
  const _EbvCoef(this.label, this.mlPerKg);
}

const _coefs = [
  _EbvCoef('成人 男性', 70),
  _EbvCoef('成人 女性', 65),
  _EbvCoef('小児', 80),
  _EbvCoef('新生児', 85),
];

/// 患者背景プリセット → 許容Hb (輸血トリガー)のオートフィル.
/// 値は「血液製剤の使用指針」(厚労省 H29) と AABB 2023 に基づく目安.
class _HbPreset {
  final String label;
  final String hb; // g/dL
  final String sub; // 根拠の短いメモ
  const _HbPreset(this.label, this.hb, this.sub);
}

const _hbPresets = [
  _HbPreset('標準 (制限的)', '7', '心肺脳/出血なし'),
  _HbPreset('心疾患・冠動脈 既往', '8', '虚血性心疾患'),
  _HbPreset('脳梗塞・脳血管 既往', '8', '脳循環障害'),
  _HbPreset('急性冠症候群・心術後', '10', 'ACS/弁・CABG後'),
  _HbPreset('敗血症・重症', '7', 'TRISS'),
];

class _AllowableBloodLossScreenState extends State<AllowableBloodLossScreen> {
  static const _accent = Color(0xFFC2185B);

  final _patient = PatientStore.instance;
  final _hb0Ctrl = TextEditingController();
  final _hbtCtrl = TextEditingController(text: '7');

  _EbvCoef _coef = _coefs.first;
  String? _bgLabel = '標準 (制限的)'; // 選択中の患者背景プリセット

  void _rebuild() {
    if (mounted) setState(() {});
  }

  void _onPatient() {
    if (mounted) setState(() {});
  }

  _HbPreset? _selectedPreset() {
    for (final p in _hbPresets) {
      if (p.label == _bgLabel) return p;
    }
    return null;
  }

  // 許容Hbを手動編集したらプリセット選択を解除する.
  void _onHbtChanged() {
    final sel = _selectedPreset();
    if (sel != null && _hbtCtrl.text.trim() != sel.hb) {
      _bgLabel = null;
    }
    if (mounted) setState(() {});
  }

  void _applyPreset(_HbPreset p) {
    setState(() {
      _bgLabel = p.label;
      _hbtCtrl.text = p.hb;
    });
  }

  @override
  void initState() {
    super.initState();
    _hb0Ctrl.addListener(_rebuild);
    _hbtCtrl.addListener(_onHbtChanged);
    _patient.addListener(_onPatient);
  }

  @override
  void dispose() {
    _patient.removeListener(_onPatient);
    _hb0Ctrl.dispose();
    _hbtCtrl.dispose();
    super.dispose();
  }

  double? _v(TextEditingController c) => double.tryParse(c.text.trim());

  // 計算ロジックは domain 層へ分離 (純粋関数). 体重は患者情報から自動連携.
  AllowableBloodLossResult? get _result => computeAllowableBloodLoss(
        weightKg: _patient.weightOr,
        hb0: _v(_hb0Ctrl),
        hbTarget: _v(_hbtCtrl),
        mlPerKg: _coef.mlPerKg,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = _result;
    final hasResult = r != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('許容出血量'),
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── 入力 ──
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('入力',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    PatientLinkedChip(
                      '体重 ${_patient.weightOr % 1 == 0 ? _patient.weightOr.toStringAsFixed(0) : _patient.weightOr} kg',
                      usingDefault: _patient.weightKg == null,
                      accent: _accent,
                    ),
                    const SizedBox(height: 14),
                    // ── 患者背景 → 許容Hb オートフィル ──
                    const Text('患者背景 (輸血トリガー)',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text('タップで許容Hbに反映 (使用指針/AABB の目安・手動上書き可)',
                        style: TextStyle(
                            fontSize: 10.5, color: Colors.grey.shade600)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _hbPresets
                          .map((p) => CalcChoiceBtn(
                                label: p.label,
                                sub: 'Hb ${p.hb} · ${p.sub}',
                                selected: _bgLabel == p.label,
                                color: _accent,
                                onTap: () => _applyPreset(p),
                                fontSize: 12.5,
                                hPad: 10,
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: CalcField('現在Hb', 'g/dL', _hb0Ctrl)),
                        const SizedBox(width: 8),
                        Expanded(child: CalcField('許容Hb', 'g/dL', _hbtCtrl)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('循環血液量 係数',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: _coefs
                                .map((c) => CalcChoiceBtn(
                                      label: c.label,
                                      sub: '${c.mlPerKg} mL/kg',
                                      selected: _coef == c,
                                      color: _accent,
                                      onTap: () =>
                                          setState(() => _coef = c),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── 結果 ──
            if (hasResult)
              Card(
                color: _accent.withValues(alpha: 0.06),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CalcResultRow('循環血液量 (EBV)',
                          r.ebv.toStringAsFixed(0), 'mL'),
                      const SizedBox(height: 8),
                      const Text('許容出血量',
                          style:
                              TextStyle(fontSize: 13, color: Colors.black54)),
                      const SizedBox(height: 2),
                      Text(
                        '${r.abl.toStringAsFixed(0)} mL',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: _accent,
                        ),
                      ),
                      if (r.abl == 0)
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text('※ 現在Hb ≤ 許容Hb',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.black45)),
                        ),
                    ],
                  ),
                ),
              )
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 24),
                  child: Center(
                    child: Text('体重・現在Hb・許容Hb を入力してください',
                        style: TextStyle(color: Colors.grey.shade500)),
                  ),
                ),
              ),
            const SizedBox(height: 12),

            // ── 参考 ──
            Card(
              color: Colors.grey.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('計算式',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey.shade700)),
                    const SizedBox(height: 6),
                    const Text(
                      'EBV (循環血液量)= 体重 × 係数\n'
                      '許容出血量 = EBV × (Hb初期 − Hb許容) / Hb平均\n'
                      '　Hb平均 = (Hb初期 + Hb許容) / 2\n\n'
                      '■ 許容Hb (輸血トリガー)の目安\n'
                      '・標準 (制限的): 7 g/dL — 使用指針 7-8, TRICC/TRISS\n'
                      '・心疾患・冠動脈疾患既往: 8 g/dL — 虚血性心疾患の非心臓手術 8-10 の下限, AABB 8\n'
                      '・脳梗塞・脳血管障害既往: 8 g/dL — 使用指針は脳循環障害で「10維持」とも\n'
                      '・急性冠症候群/心臓術後急性期: 10 g/dL — 使用指針「心疾患10維持」, 弁/CABG後 9-10, MINT\n'
                      '・敗血症・重症: 7 g/dL — TRISS\n\n'
                      '※あくまで目安. 出血速度・心予備能・凝固・症候を考慮して個別に判断する. ',
                      style: TextStyle(fontSize: 12, height: 1.7),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// (入力欄/結果行/選択ボタンは lib/widgets/calc_parts.dart の共通実装を使用)
