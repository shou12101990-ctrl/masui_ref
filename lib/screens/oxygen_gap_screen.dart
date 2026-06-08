import 'package:flutter/material.dart';

// ─── 計算画面 ─────────────────────────────────────────────────

class OxygenGapScreen extends StatefulWidget {
  const OxygenGapScreen({super.key});

  @override
  State<OxygenGapScreen> createState() => _OxygenGapScreenState();
}

class _OxygenGapScreenState extends State<OxygenGapScreen> {
  // FiO2 (0.21〜1.00)
  double _fio2 = 0.21;

  final _pao2Ctrl  = TextEditingController();
  final _paco2Ctrl = TextEditingController();
  final _hbCtrl    = TextEditingController();
  final _sao2Ctrl  = TextEditingController();
  final _svo2Ctrl  = TextEditingController();
  final _hrCtrl    = TextEditingController();
  final _svCtrl    = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (final c in _allCtrl) c.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    for (final c in _allCtrl) c.dispose();
    super.dispose();
  }

  List<TextEditingController> get _allCtrl =>
      [_pao2Ctrl, _paco2Ctrl, _hbCtrl, _sao2Ctrl, _svo2Ctrl, _hrCtrl, _svCtrl];

  double? _parse(TextEditingController c) {
    final v = double.tryParse(c.text.trim());
    return (v != null && v > 0) ? v : null;
  }

  double? get _pao2  => _parse(_pao2Ctrl);
  double? get _paco2 => _parse(_paco2Ctrl);
  double? get _hb    => _parse(_hbCtrl);
  double? get _sao2  => _parse(_sao2Ctrl);
  double? get _svo2  => _parse(_svo2Ctrl);
  double? get _hr    => _parse(_hrCtrl);
  double? get _sv    => _parse(_svCtrl);

  // 肺胞気酸素分圧 (FiO2*713 - PaCO2/0.8)
  double? get _PAO2 {
    if (_paco2 == null) return null;
    return _fio2 * 713.0 - _paco2! / 0.8;
  }

  // A-aDO2
  double? get _AaDO2 {
    if (_PAO2 == null || _pao2 == null) return null;
    return _PAO2! - _pao2!;
  }

  // P/F ratio
  double? get _PF {
    if (_pao2 == null) return null;
    return _pao2! / _fio2;
  }

  // 動脈血酸素含量 CaO2 (mL/dL)
  double? get _CaO2 {
    if (_hb == null || _sao2 == null || _pao2 == null) return null;
    return 1.34 * _hb! * (_sao2! / 100.0) + 0.0031 * _pao2!;
  }

  // 混合静脈血酸素含量 CvO2
  double? get _CvO2 {
    if (_hb == null || _svo2 == null) return null;
    return 1.34 * _hb! * (_svo2! / 100.0) + 0.0031 * (_pao2 ?? 40.0);
  }

  // 心拍出量 CO (L/min)
  double? get _CO {
    if (_hr == null || _sv == null) return null;
    return _hr! * _sv! / 1000.0;
  }

  // 酸素供給量 DO2 (mL/min)
  double? get _DO2 {
    if (_CO == null || _CaO2 == null) return null;
    return _CO! * _CaO2! * 10.0;
  }

  // 酸素消費量 VO2 (mL/min)
  double? get _VO2 {
    if (_CO == null || _CaO2 == null || _CvO2 == null) return null;
    return _CO! * (_CaO2! - _CvO2!) * 10.0;
  }

  // 酸素摂取率 O2ER (%)
  double? get _O2ER {
    if (_DO2 == null || _VO2 == null || _DO2! <= 0) return null;
    return _VO2! / _DO2! * 100.0;
  }

  // ─── バッジ評価 ───────────────────────────────────────────────

  (String, Color, Color) _evalAaDO2(double v) {
    if (v < 10) return ('正常', Colors.green.shade700, Colors.green.shade50);
    if (v < 35) return ('軽度上昇', Colors.orange.shade700, Colors.orange.shade50);
    return ('著明上昇', Colors.red.shade700, Colors.red.shade50);
  }

  (String, Color, Color) _evalPF(double v) {
    if (v >= 300) return ('正常', Colors.green.shade700, Colors.green.shade50);
    if (v >= 200) return ('軽度低下', Colors.orange.shade700, Colors.orange.shade50);
    return ('ARDS基準以下', Colors.red.shade700, Colors.red.shade50);
  }

  (String, Color, Color) _evalDO2(double v) {
    if (v >= 900) return ('十分', Colors.green.shade700, Colors.green.shade50);
    if (v >= 600) return ('やや低下', Colors.orange.shade700, Colors.orange.shade50);
    return ('低下', Colors.red.shade700, Colors.red.shade50);
  }

  (String, Color, Color) _evalO2ER(double v) {
    if (v <= 30) return ('正常', Colors.green.shade700, Colors.green.shade50);
    if (v <= 50) return ('代償範囲', Colors.orange.shade700, Colors.orange.shade50);
    return ('供給依存', Colors.red.shade700, Colors.red.shade50);
  }

  static final _fio2Opts = [
    for (double f = 0.21; f <= 1.005; f += 0.01) double.parse(f.toStringAsFixed(2)),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

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
            // ─ 入力カード ─
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
                    // FiO2
                    Row(crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      const SizedBox(
                          width: 120,
                          child: Text('FiO₂',
                              style: TextStyle(fontSize: 13))),
                      DropdownButton<double>(
                        value: _fio2,
                        items: _fio2Opts
                            .map((f) => DropdownMenuItem(
                                value: f,
                                child: Text(f.toStringAsFixed(2))))
                            .toList(),
                        onChanged: (v) => setState(() => _fio2 = v!),
                      ),
                    ]),
                    const Divider(height: 16),
                    _InputRow('PaO₂ (mmHg)', _pao2Ctrl),
                    _InputRow('PaCO₂ (mmHg)', _paco2Ctrl),
                    _InputRow('Hb (g/dL)', _hbCtrl),
                    _InputRow('SaO₂ (%)', _sao2Ctrl),
                    _InputRow('SvO₂ (%) ※任意', _svo2Ctrl),
                    const Divider(height: 16),
                    _InputRow('HR (bpm)', _hrCtrl),
                    _InputRow('SV (mL)', _svCtrl),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ─ ガス交換 ─
            if (_AaDO2 != null || _PF != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ガス交換',
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      if (_PAO2 != null)
                        _ResultRow('PAO₂', _PAO2!.toStringAsFixed(1), 'mmHg'),
                      if (_AaDO2 != null) ...[
                        _ResultRowWithBadge(
                          'A-aDO₂',
                          _AaDO2!.toStringAsFixed(1),
                          'mmHg',
                          _evalAaDO2(_AaDO2!),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, bottom: 4),
                          child: Text(
                            '正常: < 10 mmHg（室内気）, 年齢補正: (年齢/4) + 4',
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey.shade600),
                          ),
                        ),
                      ],
                      if (_PF != null)
                        _ResultRowWithBadge(
                          'P/F 比',
                          _PF!.toStringAsFixed(0),
                          '',
                          _evalPF(_PF!),
                        ),
                    ],
                  ),
                ),
              ),
            if (_AaDO2 != null || _PF != null) const SizedBox(height: 12),

            // ─ 酸素需給 ─
            if (_CaO2 != null || _DO2 != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('酸素需給',
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      if (_CaO2 != null)
                        _ResultRow('CaO₂', _CaO2!.toStringAsFixed(2), 'mL/dL'),
                      if (_CvO2 != null)
                        _ResultRow('CvO₂', _CvO2!.toStringAsFixed(2), 'mL/dL'),
                      if (_CO != null)
                        _ResultRow('CO', _CO!.toStringAsFixed(2), 'L/min'),
                      if (_DO2 != null)
                        _ResultRowWithBadge(
                          'DO₂',
                          _DO2!.toStringAsFixed(0),
                          'mL/min',
                          _evalDO2(_DO2!),
                        ),
                      if (_VO2 != null)
                        _ResultRow('VO₂', _VO2!.toStringAsFixed(0), 'mL/min'),
                      if (_O2ER != null)
                        _ResultRowWithBadge(
                          'O₂ER',
                          _O2ER!.toStringAsFixed(1),
                          '%',
                          _evalO2ER(_O2ER!),
                        ),
                    ],
                  ),
                ),
              ),
            if (_CaO2 != null || _DO2 != null) const SizedBox(height: 12),

            // ─ 参考値 ─
            Card(
              color: Colors.grey.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('正常値・解釈の目安',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey.shade700)),
                    const SizedBox(height: 6),
                    const Text(
                      'PAO₂   : FiO₂×713 − PaCO₂/0.8\n'
                      'A-aDO₂ : < 10 mmHg（室内気）\n'
                      'P/F比  : ≥300 正常, <200 ARDS\n'
                      'CaO₂   : 1.34×Hb×SaO₂/100 + 0.0031×PaO₂\n'
                      'DO₂    : CO × CaO₂ × 10　（正常: 900〜1200 mL/min）\n'
                      'VO₂    : CO × (CaO₂−CvO₂) × 10　（正常: 200〜300 mL/min）\n'
                      'O₂ER   : VO₂/DO₂ × 100　（正常: 25〜30%）',
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        SizedBox(
            width: 140,
            child: Text(label, style: const TextStyle(fontSize: 13))),
        Expanded(
          child: TextField(
            controller: ctrl,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(fontSize: 13),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(children: [
        SizedBox(
            width: 80,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13, color: Colors.black54))),
        Text(value,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(width: 4),
        Text(unit,
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ]),
    );
  }
}

class _ResultRowWithBadge extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final (String, Color, Color) badge;
  const _ResultRowWithBadge(
      this.label, this.value, this.unit, this.badge);

  @override
  Widget build(BuildContext context) {
    final (badgeText, badgeFg, badgeBg) = badge;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(children: [
        SizedBox(
            width: 80,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13, color: Colors.black54))),
        Text(value,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(width: 4),
        Text(unit,
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(width: 8),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: badgeBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(badgeText,
              style: TextStyle(
                  fontSize: 11,
                  color: badgeFg,
                  fontWeight: FontWeight.bold)),
        ),
      ]),
    );
  }
}
