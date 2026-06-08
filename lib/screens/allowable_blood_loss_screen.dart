import 'package:flutter/material.dart';

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

  final _wtCtrl  = TextEditingController(text: '60');
  final _hb0Ctrl = TextEditingController();
  final _hbtCtrl = TextEditingController(text: '7');

  _EbvCoef _coef = _coefs.first;

  List<TextEditingController> get _all => [_wtCtrl, _hb0Ctrl, _hbtCtrl];

  @override
  void initState() {
    super.initState();
    for (final c in _all) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in _all) {
      c.dispose();
    }
    super.dispose();
  }

  double? _p(TextEditingController c) {
    final v = double.tryParse(c.text.trim());
    return (v != null && v > 0) ? v : null;
  }

  double? get _wt  => _p(_wtCtrl);
  double? get _hb0 => _p(_hb0Ctrl);
  double? get _hbt => _p(_hbtCtrl);

  // 循環血液量 (mL)
  double? get _ebv => _wt != null ? _wt! * _coef.mlPerKg : null;

  // 許容出血量 (mL) — Gross の式（平均Hbで除す）
  double? get _abl {
    if (_ebv == null || _hb0 == null || _hbt == null) return null;
    if (_hb0! <= _hbt!) return 0;
    final mean = (_hb0! + _hbt!) / 2.0;
    return _ebv! * (_hb0! - _hbt!) / mean;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasResult = _abl != null;

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
                    _InputRow('体重 (kg)', _wtCtrl),
                    _InputRow('現在の Hb (g/dL)', _hb0Ctrl),
                    _InputRow('許容 Hb (g/dL)', _hbtCtrl),
                    const SizedBox(height: 14),
                    const Text('循環血液量 係数',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _coefs
                          .map((c) => _ChoiceBtn(
                                label: c.label,
                                sub: '${c.mlPerKg} mL/kg',
                                selected: _coef == c,
                                color: _accent,
                                onTap: () => setState(() => _coef = c),
                              ))
                          .toList(),
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
                      if (_ebv != null)
                        _ResultRow('循環血液量 (EBV)',
                            _ebv!.toStringAsFixed(0), 'mL'),
                      const SizedBox(height: 8),
                      const Text('許容出血量',
                          style:
                              TextStyle(fontSize: 13, color: Colors.black54)),
                      const SizedBox(height: 2),
                      Text(
                        '${_abl!.toStringAsFixed(0)} mL',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: _accent,
                        ),
                      ),
                      if (_abl == 0)
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

// ─── ヘルパーウィジェット ─────────────────────────────────────

class _InputRow extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  const _InputRow(this.label, this.ctrl);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(children: [
        SizedBox(
            width: 130,
            child: Text(label, style: const TextStyle(fontSize: 14))),
        Expanded(
          child: TextField(
            controller: ctrl,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              border: OutlineInputBorder(),
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
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(label,
          style: const TextStyle(fontSize: 13, color: Colors.black54)),
      const SizedBox(width: 8),
      Text(value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(width: 4),
      Text(unit, style: const TextStyle(fontSize: 12, color: Colors.black54)),
    ]);
  }
}

class _ChoiceBtn extends StatelessWidget {
  final String label;
  final String sub;
  final bool selected;
  final Color color;
  final VoidCallback onTap;
  const _ChoiceBtn({
    required this.label,
    required this.sub,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color:
              selected ? color.withValues(alpha: 0.14) : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected ? color : Colors.transparent, width: 1.6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                    color: selected ? Colors.black87 : Colors.black54)),
            const SizedBox(height: 1),
            Text(sub,
                style: TextStyle(
                    fontSize: 10,
                    color: selected ? color : Colors.black38)),
          ],
        ),
      ),
    );
  }
}
