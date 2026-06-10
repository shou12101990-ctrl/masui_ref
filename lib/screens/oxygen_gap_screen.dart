import 'package:flutter/material.dart';

import '../domain/calculators/oxygen_gap.dart';

/// 酸素較差計算機（シンプル版）
/// Hb・SaO2・SvO2 から 動静脈酸素含量較差 (CaO2 − CvO2) と O2ER を算出する。
/// 計算ロジックは lib/domain/calculators/oxygen_gap.dart に分離。
class OxygenGapScreen extends StatefulWidget {
  const OxygenGapScreen({super.key});

  @override
  State<OxygenGapScreen> createState() => _OxygenGapScreenState();
}

class _OxygenGapScreenState extends State<OxygenGapScreen> {
  static const _accent = Color(0xFF1976D2);

  final _hbCtrl   = TextEditingController(text: '14');
  final _sao2Ctrl = TextEditingController(text: '98');
  final _svo2Ctrl = TextEditingController(text: '70');

  List<TextEditingController> get _all => [_hbCtrl, _sao2Ctrl, _svo2Ctrl];

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

  double? _v(TextEditingController c) => double.tryParse(c.text.trim());

  // 計算ロジックは domain 層へ分離 (純粋関数)
  OxygenGapResult? get _result => computeOxygenGap(
        hb: _v(_hbCtrl),
        sao2: _v(_sao2Ctrl),
        svo2: _v(_svo2Ctrl),
      );

  (String, Color, Color) _evalGap(double v) {
    if (v < 3.5) return ('低い', Colors.blue.shade700, Colors.blue.shade50);
    if (v <= 5.5) return ('正常', Colors.green.shade700, Colors.green.shade50);
    return ('開大', Colors.red.shade700, Colors.red.shade50);
  }

  (String, Color, Color) _evalO2er(double v) {
    if (v < 22) return ('低い', Colors.blue.shade700, Colors.blue.shade50);
    if (v <= 30) return ('正常', Colors.green.shade700, Colors.green.shade50);
    if (v <= 50) return ('代償域', Colors.orange.shade700, Colors.orange.shade50);
    return ('供給依存', Colors.red.shade700, Colors.red.shade50);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = _result;
    final hasResult = r != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('酸素較差計算機'),
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _Field('Hb', 'g/dL', _hbCtrl)),
                        const SizedBox(width: 8),
                        Expanded(child: _Field('SaO₂', '%', _sao2Ctrl)),
                        const SizedBox(width: 8),
                        Expanded(child: _Field('SvO₂', '%', _svo2Ctrl)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── 結果 ──
            if (hasResult)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('結果',
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      _ResultRow('CaO₂', r.caO2.toStringAsFixed(2), 'mL/dL'),
                      _ResultRow('CvO₂', r.cvO2.toStringAsFixed(2), 'mL/dL'),
                      const Divider(height: 18),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _BigResult(
                              label: '酸素較差',
                              value: r.gap.toStringAsFixed(2),
                              unit: 'mL/dL',
                              badge: _evalGap(r.gap),
                              accent: _accent,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _BigResult(
                              label: 'O₂ER',
                              value: r.o2er.toStringAsFixed(1),
                              unit: '%',
                              badge: _evalO2er(r.o2er),
                              accent: _accent,
                            ),
                          ),
                        ],
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
                    child: Text('Hb・SaO₂・SvO₂ を入力してください',
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
                    Text('計算式・正常値',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey.shade700)),
                    const SizedBox(height: 6),
                    const Text(
                      'CaO₂ = 1.34 × Hb × SaO₂/100\n'
                      'CvO₂ = 1.34 × Hb × SvO₂/100\n'
                      '酸素較差 = CaO₂ − CvO₂　（正常 3.5〜5.5 mL/dL）\n'
                      'O₂ER = 較差 / CaO₂ × 100　（正常 25〜30%）\n\n'
                      '・較差/O₂ER 開大 → 供給不足 or 需要増加（低心拍出・貧血・低酸素）\n'
                      '・較差/O₂ER 低下 → 末梢利用障害・シャント（敗血症など）',
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

class _Field extends StatelessWidget {
  final String label;
  final String unit;
  final TextEditingController ctrl;
  const _Field(this.label, this.unit, this.ctrl);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 4),
        TextField(
          controller: ctrl,
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            suffixText: unit,
            suffixStyle:
                const TextStyle(fontSize: 11, color: Colors.black45),
            isDense: true,
            filled: true,
            fillColor: const Color(0xFFF7F9FA),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 11),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(label,
            style: const TextStyle(fontSize: 13, color: Colors.black54)),
        const SizedBox(width: 8),
        Text(value,
            style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(width: 4),
        Text(unit,
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ]),
    );
  }
}

class _BigResult extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final (String, Color, Color) badge;
  final Color accent;
  const _BigResult({
    required this.label,
    required this.value,
    required this.unit,
    required this.badge,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final (badgeText, badgeFg, badgeBg) = badge;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: accent)),
              const SizedBox(width: 4),
              Text(unit,
                  style:
                      const TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(badgeText,
                style: TextStyle(
                    fontSize: 12,
                    color: badgeFg,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
