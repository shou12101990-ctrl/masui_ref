import 'package:flutter/material.dart';

import '../domain/calculators/be_correction.dart';
import '../state/patient_store.dart';
import '../widgets/calc_parts.dart';

/// メイロン（重炭酸Na）による BE 補正計算機
/// HCO3⁻不足分 = 0.3 × 体重 × |BE|
/// 推奨補正量は不足分の半分（BE < −10 の代謝性アシドーシス時）
class BeCorrectionScreen extends StatefulWidget {
  const BeCorrectionScreen({super.key});

  @override
  State<BeCorrectionScreen> createState() => _BeCorrectionScreenState();
}

class _BeCorrectionScreenState extends State<BeCorrectionScreen> {
  static const _accent = Color(0xFF5E35B1);

  final _patient = PatientStore.instance;
  final _beCtrl = TextEditingController(text: '10');

  List<TextEditingController> get _all => [_beCtrl];

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

  // 計算ロジックは domain 層へ分離 (純粋関数). 体重は患者情報から自動連携.
  // 入力は正の数 (塩基不足の大きさ). BE = −入力 として扱う.
  BeCorrectionResult? get _result => computeBeCorrection(
        beMagnitude: double.tryParse(_beCtrl.text.trim()),
        weightKg: _patient.weightOr,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = _result;
    final hasResult = r != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('メイロン BE補正'),
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
                    _InputRow('BE（正の数で入力）', _beCtrl,
                        hint: '例: 10 → BE −10'),
                    const SizedBox(height: 10),
                    PatientLinkedChip(
                      '体重 ${_patient.weightOr % 1 == 0 ? _patient.weightOr.toStringAsFixed(0) : _patient.weightOr} kg',
                      usingDefault: _patient.weightKg == null,
                      accent: _accent,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── 結果 ──
            if (hasResult && r.deficitMEq > 0) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ResultRow('HCO₃⁻ 不足分',
                          r.deficitMEq.toStringAsFixed(0), 'mEq'),
                      const SizedBox(height: 4),
                      Text('= 0.3 × 体重 × |BE|',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade500)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                color: _accent.withValues(alpha: 0.06),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('半量補正（推奨）',
                              style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _accent)),
                          const SizedBox(width: 8),
                          Text('${r.halfMEq.toStringAsFixed(0)} mEq',
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _MeiRow('メイロン 8.4%', r.meylon84mL, '(1 mEq/mL)', _accent),
                      const Divider(height: 18),
                      _MeiRow('メイロン 7%', r.meylon7mL, '(0.83 mEq/mL)', _accent),
                    ],
                  ),
                ),
              ),
            ] else if (hasResult && r.deficitMEq == 0)
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 24),
                  child: Center(
                    child: Text('入力が 0 のため補正不要',
                        style: TextStyle(color: Colors.grey.shade600)),
                  ),
                ),
              )
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 24),
                  child: Center(
                    child: Text('BE・体重 を入力してください',
                        style: TextStyle(color: Colors.grey.shade500)),
                  ),
                ),
              ),
            const SizedBox(height: 12),

            // ── 参考 ──
            Card(
              color: Colors.amber.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.info_outline,
                          color: Colors.amber.shade800, size: 18),
                      const SizedBox(width: 6),
                      Text('考え方',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.amber.shade900,
                              fontSize: 13)),
                    ]),
                    const SizedBox(height: 6),
                    const Text(
                      '・BE < −10 の代謝性アシドーシスを認めたら、不足分の半分の mEq の重炭酸（メイロン）で補正する。\n'
                      '・過補正は代謝性アルカローシス・低K・Na負荷をきたすため、投与後は血液ガスを再評価する。\n'
                      '・呼吸性に代償されている場合、CO₂排出が追いつかないと一過性にアシドーシスが悪化しうる。',
                      style: TextStyle(fontSize: 12, height: 1.6),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── カテコラミン禁忌 警告（下部）──
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade300),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.red.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text.rich(
                      TextSpan(children: [
                        const TextSpan(
                            text: 'カテコラミンとメイロンの同一ルートからの投与は',
                            style: TextStyle(fontSize: 12.5, height: 1.5)),
                        TextSpan(
                            text: 'カテコラミンが失活するため禁止',
                            style: TextStyle(
                                fontSize: 12.5,
                                height: 1.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade700)),
                        const TextSpan(
                            text: '。別ルートから投与すること。',
                            style: TextStyle(fontSize: 12.5, height: 1.5)),
                      ]),
                    ),
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

// ─── ヘルパーウィジェット ─────────────────────────────────────

class _InputRow extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final String? hint;
  final bool signed;
  const _InputRow(this.label, this.ctrl, {this.hint, this.signed = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(children: [
        SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(fontSize: 14))),
        Expanded(
          child: TextField(
            controller: ctrl,
            keyboardType: TextInputType.numberWithOptions(
                decimal: true, signed: signed),
            decoration: InputDecoration(
              isDense: true,
              hintText: hint,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 10),
              border: const OutlineInputBorder(),
            ),
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ]),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  const _ResultRow(this.label, this.value, this.unit);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: Text(label,
              style: const TextStyle(fontSize: 14, color: Colors.black54))),
      Text(value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(width: 4),
      Text(unit, style: const TextStyle(fontSize: 12, color: Colors.black54)),
    ]);
  }
}

class _MeiRow extends StatelessWidget {
  final String label;
  final double ml;
  final String note;
  final Color accent;
  const _MeiRow(this.label, this.ml, this.note, this.accent);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
              Text(note,
                  style: TextStyle(
                      fontSize: 10, color: Colors.grey.shade500)),
            ],
          ),
        ),
        Text(ml.toStringAsFixed(0),
            style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.bold, color: accent)),
        const SizedBox(width: 4),
        const Text('mL',
            style: TextStyle(fontSize: 13, color: Colors.black54)),
      ],
    );
  }
}
