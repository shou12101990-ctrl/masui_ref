import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── 入力単位 ──────────────────────────────────────────────────────────────
enum _Unit {
  gamma('γ', 'μg/kg/min'),
  mlPerH('流量', 'ml/h'),
  mgPerH('投与量', 'mg/h'),
  mgPerKgPerH('投与量', 'mg/kg/h'),
  mcgPerKgPerH('投与量', 'μg/kg/h');

  final String rowLabel;
  final String unitLabel;
  const _Unit(this.rowLabel, this.unitLabel);

  String get dropdownLabel => '$rowLabel  ($unitLabel)';
}

// ── 計算結果 ──────────────────────────────────────────────────────────────
class _Result {
  final double? mlPerH; // null when concentration unknown
  final double gamma; // μg/kg/min
  final double mgPerKgPerH;
  final double mgPerH;
  final double mcgPerKgPerH;
  final double mgPerDay;
  const _Result({
    required this.mlPerH,
    required this.gamma,
    required this.mgPerKgPerH,
    required this.mgPerH,
    required this.mcgPerKgPerH,
    required this.mgPerDay,
  });
}

// ── メイン Widget ─────────────────────────────────────────────────────────
class GammaCalculatorScreen extends StatefulWidget {
  const GammaCalculatorScreen({super.key});

  @override
  State<GammaCalculatorScreen> createState() => _GammaCalculatorScreenState();
}

class _GammaCalculatorScreenState extends State<GammaCalculatorScreen> {
  final _drugMg = TextEditingController(text: '150');
  final _totalMl = TextEditingController(text: '50');
  final _weight = TextEditingController(text: '60');
  final _value = TextEditingController(text: '3');
  _Unit _inputUnit = _Unit.mlPerH;

  @override
  void initState() {
    super.initState();
    for (final c in [_drugMg, _totalMl, _weight, _value]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in [_drugMg, _totalMl, _weight, _value]) {
      c.dispose();
    }
    super.dispose();
  }

  // ── 濃度 (mg/ml) ─────────────────────────────────────────────────────
  double? get _concMgPerMl {
    final mg = double.tryParse(_drugMg.text);
    final ml = double.tryParse(_totalMl.text);
    if (mg == null || ml == null || ml <= 0) return null;
    return mg / ml;
  }

  // ── 入力値をいったん mg/h に正規化 ──────────────────────────────────
  double? get _normalizedMgPerH {
    final v = double.tryParse(_value.text);
    final w = double.tryParse(_weight.text);
    final c = _concMgPerMl;
    if (v == null) return null;
    switch (_inputUnit) {
      case _Unit.mlPerH:
        if (c == null || c <= 0) return null;
        return v * c; // ml/h × mg/ml = mg/h
      case _Unit.gamma:
        // μg/kg/min → mg/h: × W × 60 / 1000
        if (w == null || w <= 0) return null;
        return v * w * 60 / 1000;
      case _Unit.mgPerH:
        return v;
      case _Unit.mgPerKgPerH:
        if (w == null || w <= 0) return null;
        return v * w;
      case _Unit.mcgPerKgPerH:
        // μg/kg/h → mg/h: × W / 1000
        if (w == null || w <= 0) return null;
        return v * w / 1000;
    }
  }

  // ── 全単位の結果 ──────────────────────────────────────────────────────
  _Result? get _result {
    final mgH = _normalizedMgPerH;
    final w = double.tryParse(_weight.text);
    final c = _concMgPerMl;
    if (mgH == null || w == null || w <= 0) return null;
    return _Result(
      mlPerH: (c != null && c > 0) ? mgH / c : null,
      gamma: mgH * 1000 / (w * 60), // mg/h → μg/kg/min
      mgPerKgPerH: mgH / w,
      mgPerH: mgH,
      mcgPerKgPerH: mgH * 1000 / w,
      mgPerDay: mgH * 24,
    );
  }

  // ── UI ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final conc = _concMgPerMl;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            Text('γ計算機',
                style:
                    theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('単位を選んで相互変換 (γ = μg/kg/min)',
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54)),
            const SizedBox(height: 16),

            // ── 薬液設定 ────────────────────────────────────────────────
            _SectionCard(
              title: '薬液設定',
              scheme: scheme,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(child: _numField(_drugMg, '薬剤量', 'mg')),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 10),
                        child: Text('/', style: TextStyle(fontSize: 20, color: Colors.black38)),
                      ),
                      Expanded(child: _numField(_totalMl, '希釈後総液量', 'ml')),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _ConcBadge(conc: conc, scheme: scheme),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── 体重 ────────────────────────────────────────────────────
            _SectionCard(
              title: '体重',
              scheme: scheme,
              child: _numField(_weight, '体重', 'kg'),
            ),
            const SizedBox(height: 12),

            // ── 投与量入力 + 単位選択 ────────────────────────────────────
            _SectionCard(
              title: '投与量',
              scheme: scheme,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // 数値
                  Expanded(
                    flex: 5,
                    child: _numField(_value, '入力値', ''),
                  ),
                  const SizedBox(width: 10),
                  // 単位ドロップダウン
                  Expanded(
                    flex: 6,
                    child: DropdownButtonFormField<_Unit>(
                      value: _inputUnit,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: '単位',
                        isDense: true,
                        filled: true,
                        fillColor: const Color(0xFFF7F9FA),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      items: _Unit.values
                          .map((u) => DropdownMenuItem(
                                value: u,
                                child: Text(u.dropdownLabel,
                                    style: const TextStyle(fontSize: 13)),
                              ))
                          .toList(),
                      onChanged: (u) {
                        if (u != null) setState(() => _inputUnit = u);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── 換算結果 ─────────────────────────────────────────────────
            _ResultCard(result: _result, inputUnit: _inputUnit),
          ],
        ),
      ),
    );
  }

  Widget _numField(TextEditingController c, String label, String suffix) {
    return TextField(
      controller: c,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix.isEmpty ? null : suffix,
        isDense: true,
        filled: true,
        fillColor: const Color(0xFFF7F9FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// ── 共通カードラッパー ─────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final ColorScheme scheme;
  final Widget child;
  const _SectionCard({required this.title, required this.scheme, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    color: scheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

// ── 濃度バッジ ────────────────────────────────────────────────────────────
class _ConcBadge extends StatelessWidget {
  final double? conc;
  final ColorScheme scheme;
  const _ConcBadge({required this.conc, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        conc == null
            ? '濃度：—'
            : '濃度：${_fmt(conc!)} mg/ml（${_fmt(conc! * 1000)} μg/ml）',
        style: TextStyle(
            color: scheme.primary, fontWeight: FontWeight.w600, fontSize: 13),
      ),
    );
  }
}

// ── 結果カード ────────────────────────────────────────────────────────────
class _ResultCard extends StatelessWidget {
  final _Result? result;
  final _Unit inputUnit;
  const _ResultCard({required this.result, required this.inputUnit});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (result == null) {
      return Card(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          alignment: Alignment.center,
          child:
              const Text('数値を入力してください', style: TextStyle(color: Colors.black45)),
        ),
      );
    }

    final r = result!;

    // 表示する行 (入力単位を除いた残り + mg/day は常表示)
    final rows = <(String, String, String)>[
      if (inputUnit != _Unit.gamma) ('γ', _fmt(r.gamma), 'μg/kg/min'),
      if (inputUnit != _Unit.mlPerH)
        ('流量', r.mlPerH != null ? _fmt(r.mlPerH!) : '—', 'ml/h'),
      if (inputUnit != _Unit.mgPerH) ('投与量', _fmt(r.mgPerH), 'mg/h'),
      if (inputUnit != _Unit.mgPerKgPerH) ('投与量', _fmt(r.mgPerKgPerH), 'mg/kg/h'),
      if (inputUnit != _Unit.mcgPerKgPerH) ('投与量', _fmt(r.mcgPerKgPerH), 'μg/kg/h'),
      ('投与量', _fmt(r.mgPerDay), 'mg/day'),
    ];

    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border(left: BorderSide(color: scheme.primary, width: 4)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.checklist_rounded, size: 18, color: scheme.primary),
                const SizedBox(width: 6),
                Text('換算結果',
                    style: TextStyle(
                        color: scheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ],
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0) const Divider(height: 16),
              _ResultRow(
                label: rows[i].$1,
                value: rows[i].$2,
                unit: rows[i].$3,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  const _ResultRow({required this.label, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        SizedBox(
          width: 56,
          child: Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.black45)),
        ),
        Expanded(
          child: Text(value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 88,
          child:
              Text(unit, style: const TextStyle(fontSize: 12, color: Colors.black45)),
        ),
      ],
    );
  }
}

// ── 数値フォーマット ──────────────────────────────────────────────────────
String _fmt(double v) {
  if (v.isNaN || v.isInfinite) return '—';
  if (v == 0) return '0';
  final abs = v.abs();
  final int digits;
  if (abs >= 100) {
    digits = 1;
  } else if (abs >= 10) {
    digits = 2;
  } else if (abs >= 1) {
    digits = 3;
  } else {
    digits = 4;
  }
  var s = v.toStringAsFixed(digits);
  if (s.contains('.')) {
    s = s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }
  return s;
}
