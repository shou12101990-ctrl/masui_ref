import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// γ（ガンマ = mcg/kg/min）計算機。
/// 流量(ml/h) ⇄ γ ⇄ mg/kg/h などを相互変換する。
class GammaCalculatorScreen extends StatefulWidget {
  const GammaCalculatorScreen({super.key});

  @override
  State<GammaCalculatorScreen> createState() => _GammaCalculatorScreenState();
}

enum _InputMode { flow, gamma }

class _GammaCalculatorScreenState extends State<GammaCalculatorScreen> {
  final _drugMg = TextEditingController(text: '150');
  final _totalMl = TextEditingController(text: '50');
  final _weight = TextEditingController(text: '60');
  final _value = TextEditingController(text: '3');

  _InputMode _mode = _InputMode.flow;

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

  double? get _num0 => double.tryParse(_drugMg.text);
  double? get _numTotal => double.tryParse(_totalMl.text);
  double? get _numWeight => double.tryParse(_weight.text);
  double? get _numValue => double.tryParse(_value.text);

  /// 濃度 (mcg/ml)
  double? get _concMcgPerMl {
    final mg = _num0, ml = _numTotal;
    if (mg == null || ml == null || ml <= 0) return null;
    return mg * 1000 / ml;
  }

  /// 濃度 (mg/ml)
  double? get _concMgPerMl {
    final mg = _num0, ml = _numTotal;
    if (mg == null || ml == null || ml <= 0) return null;
    return mg / ml;
  }

  _Result? get _result {
    final conc = _concMcgPerMl;
    final w = _numWeight;
    final v = _numValue;
    final mgPerMl = _concMgPerMl;
    if (conc == null || conc <= 0 || w == null || w <= 0 || v == null) {
      return null;
    }

    double flow; // ml/h
    double gamma; // mcg/kg/min
    if (_mode == _InputMode.flow) {
      flow = v;
      gamma = flow * conc / (w * 60);
    } else {
      gamma = v;
      flow = gamma * w * 60 / conc;
    }
    final mgPerH = flow * mgPerMl!;
    return _Result(
      flow: flow,
      gamma: gamma,
      mgPerKgPerH: mgPerH / w,
      mgPerH: mgPerH,
      mgPerDay: mgPerH * 24,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final res = _result;
    final mgPerMl = _concMgPerMl;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            Text('γ計算機',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('流量 (ml/h) ⇄ γ (mcg/kg/min) を相互変換',
                style:
                    theme.textTheme.bodySmall?.copyWith(color: Colors.black54)),
            const SizedBox(height: 16),

            // 薬剤濃度
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('薬液濃度', scheme),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _numField(_drugMg, '薬剤量', 'mg'),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('/', style: TextStyle(fontSize: 18)),
                        ),
                        Expanded(
                          child: _numField(_totalMl, '総液量', 'ml'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        mgPerMl == null
                            ? '濃度： —'
                            : '濃度：${_fmt(mgPerMl)} mg/ml （${_fmt(mgPerMl * 1000)} mcg/ml）',
                        style: TextStyle(
                            color: scheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 体重
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('体重', scheme),
                    const SizedBox(height: 10),
                    _numField(_weight, '体重', 'kg'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 入力モード + 値
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('入力値', scheme),
                    const SizedBox(height: 10),
                    SegmentedButton<_InputMode>(
                      segments: const [
                        ButtonSegment(
                            value: _InputMode.flow,
                            label: Text('流量 ml/h'),
                            icon: Icon(Icons.water_drop_outlined, size: 16)),
                        ButtonSegment(
                            value: _InputMode.gamma,
                            label: Text('γ'),
                            icon: Icon(Icons.speed, size: 16)),
                      ],
                      selected: {_mode},
                      onSelectionChanged: (s) =>
                          setState(() => _mode = s.first),
                    ),
                    const SizedBox(height: 12),
                    _numField(
                      _value,
                      _mode == _InputMode.flow ? '流量' : 'γ',
                      _mode == _InputMode.flow ? 'ml/h' : 'mcg/kg/min',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 結果
            _ResultCard(result: res),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text, ColorScheme scheme) => Text(text,
      style: TextStyle(
          color: scheme.primary, fontWeight: FontWeight.bold, fontSize: 14));

  Widget _numField(TextEditingController c, String label, String suffix) {
    return TextField(
      controller: c,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
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

class _Result {
  final double flow; // ml/h
  final double gamma; // mcg/kg/min
  final double mgPerKgPerH;
  final double mgPerH;
  final double mgPerDay;
  const _Result({
    required this.flow,
    required this.gamma,
    required this.mgPerKgPerH,
    required this.mgPerH,
    required this.mgPerDay,
  });
}

class _ResultCard extends StatelessWidget {
  final _Result? result;
  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (result == null) {
      return Card(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          alignment: Alignment.center,
          child: const Text('数値を入力してください',
              style: TextStyle(color: Colors.black45)),
        ),
      );
    }
    final r = result!;
    final rows = [
      ('流量', _fmt(r.flow), 'ml/h'),
      ('γ', _fmt(r.gamma), 'mcg/kg/min'),
      ('投与量', _fmt(r.mgPerKgPerH), 'mg/kg/h'),
      ('投与量', _fmt(r.mgPerH), 'mg/h'),
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
                Icon(Icons.checklist, size: 18, color: scheme.primary),
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
              Row(
                children: [
                  SizedBox(
                    width: 64,
                    child: Text(rows[i].$1,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black54)),
                  ),
                  Expanded(
                    child: Text(rows[i].$2,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 90,
                    child: Text(rows[i].$3,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54)),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

String _fmt(double v) {
  if (v.isNaN || v.isInfinite) return '—';
  if (v == 0) return '0';
  final abs = v.abs();
  int digits;
  if (abs >= 100) {
    digits = 1;
  } else if (abs >= 1) {
    digits = 2;
  } else {
    digits = 3;
  }
  var s = v.toStringAsFixed(digits);
  if (s.contains('.')) {
    s = s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }
  return s;
}
