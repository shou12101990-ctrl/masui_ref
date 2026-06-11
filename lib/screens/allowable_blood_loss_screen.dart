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

class _AllowableBloodLossScreenState extends State<AllowableBloodLossScreen> {
  static const _accent = Color(0xFFC2185B);

  final _patient = PatientStore.instance;
  final _hb0Ctrl = TextEditingController();
  final _hbtCtrl = TextEditingController(text: '7');

  _EbvCoef _coef = _coefs.first;

  List<TextEditingController> get _all => [_hb0Ctrl, _hbtCtrl];

  void _onPatient() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    for (final c in _all) {
      c.addListener(() => setState(() {}));
    }
    _patient.addListener(_onPatient);
  }

  @override
  void dispose() {
    _patient.removeListener(_onPatient);
    for (final c in _all) {
      c.dispose();
    }
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
                    const SizedBox(height: 10),
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
                      'EBV（循環血液量）= 体重 × 係数\n'
                      '許容出血量 = EBV × (Hb初期 − Hb許容) / Hb平均\n'
                      '　Hb平均 = (Hb初期 + Hb許容) / 2\n\n'
                      '・許容Hbのデフォルトは 7 g/dL（心疾患・出血進行中は高めに設定）。\n'
                      '・あくまで目安。実際は出血速度・心予備能・凝固を考慮して輸血を判断する。',
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
