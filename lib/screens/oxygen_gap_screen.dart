import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _fio2Opts = [0.21, 0.30, 0.40, 0.50, 0.60, 0.70, 0.80, 0.90, 1.00];

class OxygenGapScreen extends StatefulWidget {
  const OxygenGapScreen({super.key});

  @override
  State<OxygenGapScreen> createState() => _OxygenGapScreenState();
}

class _OxygenGapScreenState extends State<OxygenGapScreen> {
  double _fio2 = 0.40;

  final _pao2C  = TextEditingController(text: '100'); // mmHg
  final _paco2C = TextEditingController(text: '40');  // mmHg
  final _hbC    = TextEditingController(text: '10');  // g/dL
  final _sao2C  = TextEditingController(text: '97');  // %
  final _svo2C  = TextEditingController(text: '65');  // %
  final _hrC    = TextEditingController(text: '80');  // bpm
  final _svC    = TextEditingController(text: '60');  // mL/beat

  @override
  void initState() {
    super.initState();
    for (final c in [_pao2C, _paco2C, _hbC, _sao2C, _svo2C, _hrC, _svC]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in [_pao2C, _paco2C, _hbC, _sao2C, _svo2C, _hrC, _svC]) {
      c.dispose();
    }
    super.dispose();
  }

  double? _p(TextEditingController c) =>
      double.tryParse(c.text.trim());

  // ── 計算 ──────────────────────────────────────────────────────
  /// 肺胞気酸素分圧  PAO2 = FiO2 × 713 − PaCO2/0.8
  double? get _PAO2 {
    final co2 = _p(_paco2C);
    if (co2 == null) return null;
    return _fio2 * 713.0 - co2 / 0.8;
  }

  /// A-aDO2 = PAO2 − PaO2
  double? get _AaDO2 {
    final pa = _p(_pao2C);
    if (_PAO2 == null || pa == null) return null;
    return _PAO2! - pa;
  }

  /// P/F比
  double? get _PF {
    final pa = _p(_pao2C);
    if (pa == null) return null;
    return pa / _fio2;
  }

  /// 動脈血酸素含有量 CaO2 (mL/dL) = 1.34×Hb×SaO2/100 + 0.0031×PaO2
  double? get _CaO2 {
    final hb = _p(_hbC), sa = _p(_sao2C), pa = _p(_pao2C);
    if (hb == null || sa == null || pa == null) return null;
    return 1.34 * hb * sa / 100.0 + 0.0031 * pa;
  }

  /// 混合静脈血酸素含有量 CvO2 ≈ 1.34×Hb×SvO2/100
  double? get _CvO2 {
    final hb = _p(_hbC), sv = _p(_svo2C);
    if (hb == null || sv == null) return null;
    return 1.34 * hb * sv / 100.0;
  }

  /// 心拍出量 CO (L/min)
  double? get _CO {
    final hr = _p(_hrC), sv = _p(_svC);
    if (hr == null || sv == null) return null;
    return hr * sv / 1000.0;
  }

  /// 酸素供給量 DO2 (mL/min)
  double? get _DO2 {
    if (_CO == null || _CaO2 == null) return null;
    return _CO! * _CaO2! * 10.0;
  }

  /// 酸素消費量 VO2 (mL/min)
  double? get _VO2 {
    if (_CO == null || _CaO2 == null || _CvO2 == null) return null;
    return _CO! * (_CaO2! - _CvO2!) * 10.0;
  }

  /// 酸素摂取率 O2ER (%)
  double? get _O2ER {
    if (_VO2 == null || _DO2 == null || _DO2! <= 0) return null;
    return _VO2! / _DO2! * 100.0;
  }

  // ── 評価バッジ ─────────────────────────────────────────────────
  (String, Color, Color) _evalAaDO2() {
    final v = _AaDO2;
    if (v == null) return ('', Colors.transparent, Colors.transparent);
    if (v < 0) return ('確認', Colors.grey.shade200, Colors.grey.shade600);
    final thresh = _fio2 <= 0.21 ? 15.0 : _fio2 * 100.0;
    if (v < thresh) return ('正常範囲', Colors.green.shade100, Colors.green.shade700);
    if (v < thresh * 2) return ('軽度上昇', Colors.orange.shade100, Colors.orange.shade800);
    return ('上昇', Colors.red.shade100, Colors.red.shade700);
  }

  (String, Color, Color) _evalPF() {
    final v = _PF;
    if (v == null) return ('', Colors.transparent, Colors.transparent);
    if (v >= 300) return ('正常', Colors.green.shade100, Colors.green.shade700);
    if (v >= 200) return ('軽度低下', Colors.orange.shade100, Colors.orange.shade800);
    if (v >= 100) return ('中等度 ARDS', Colors.red.shade100, Colors.red.shade700);
    return ('重症 ARDS', Colors.red.shade200, Colors.red.shade900);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('酸素較差計算機'),
        backgroundColor: scheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [

          // ── 入力 ──────────────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('入力値',
                      style: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(child: _ddFio2()),
                    const SizedBox(width: 8),
                    Expanded(child: _nf(_pao2C,  'PaO₂',  'mmHg')),
                    const SizedBox(width: 8),
                    Expanded(child: _nf(_paco2C, 'PaCO₂', 'mmHg')),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(child: _nf(_hbC,   'Hb',   'g/dL')),
                    const SizedBox(width: 8),
                    Expanded(child: _nf(_sao2C, 'SaO₂', '%')),
                    const SizedBox(width: 8),
                    Expanded(child: _nf(_svo2C, 'SvO₂', '%')),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(child: _nf(_hrC, 'HR', 'bpm')),
                    const SizedBox(width: 8),
                    Expanded(child: _nf(_svC, 'SV', 'mL/回')),
                    const Expanded(child: SizedBox()),
                  ]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ── ガス交換 ──────────────────────────────────────────────
          _sectionCard(
            scheme: scheme,
            title: 'ガス交換',
            child: Column(children: [
              _row('PAO₂',   _PAO2,  'mmHg', ''),
              const Divider(height: 14),
              _rowBadge('A-aDO₂', _AaDO2, 'mmHg', _evalAaDO2()),
              const Divider(height: 14),
              _rowBadge('P/F',    _PF,    '',     _evalPF()),
            ]),
          ),
          const SizedBox(height: 10),

          // ── 酸素需給 ──────────────────────────────────────────────
          _sectionCard(
            scheme: scheme,
            title: '酸素需給',
            child: Column(children: [
              _row('CaO₂', _CaO2, 'mL/dL', '正常 18–20'),
              const Divider(height: 14),
              _row('CO',   _CO,   'L/min',  '正常 4–8'),
              const Divider(height: 14),
              _row('DO₂',  _DO2,  'mL/min', '正常 700–1400'),
              const Divider(height: 14),
              _row('VO₂',  _VO2,  'mL/min', '正常 150–250'),
              const Divider(height: 14),
              _row('O₂ER', _O2ER, '%',       '正常 20–30'),
            ]),
          ),
        ],
      ),
    );
  }

  // ── helpers ─────────────────────────────────────────────────────
  Widget _ddFio2() {
    return DropdownButtonFormField<double>(
      value: _fio2,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'FiO₂',
        isDense: true, filled: true, fillColor: Color(0xFFF7F9FA),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide.none),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      ),
      items: _fio2Opts
          .map((v) => DropdownMenuItem(
                value: v,
                child: Text('${(v * 100).toInt()}%',
                    style: const TextStyle(fontSize: 13)),
              ))
          .toList(),
      onChanged: (v) {
        if (v != null) setState(() => _fio2 = v);
      },
    );
  }

  Widget _nf(TextEditingController c, String label, String suffix) {
    return TextField(
      controller: c,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
      ],
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        isDense: true, filled: true, fillColor: const Color(0xFFF7F9FA),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide.none),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      ),
    );
  }

  Widget _sectionCard({
    required ColorScheme scheme,
    required String title,
    required Widget child,
  }) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border(left: BorderSide(color: scheme.primary, width: 4)),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    color: scheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  Widget _row(String label, double? val, String unit, String note) {
    return Row(
      children: [
        SizedBox(
          width: 54,
          child: Text(label,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54)),
        ),
        Expanded(
          child: Text(
            val == null ? '—' : _fmt(label, val),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: 52,
          child: Text(unit,
              style: const TextStyle(fontSize: 11, color: Colors.black45)),
        ),
        if (note.isNotEmpty)
          Text(note,
              style: const TextStyle(fontSize: 10, color: Colors.black38)),
      ],
    );
  }

  Widget _rowBadge(
    String label,
    double? val,
    String unit,
    (String, Color, Color) eval,
  ) {
    final (text, bg, fg) = eval;
    return Row(
      children: [
        SizedBox(
          width: 54,
          child: Text(label,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54)),
        ),
        Expanded(
          child: Text(
            val == null ? '—' : _fmt(label, val),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: 52,
          child: Text(unit,
              style: const TextStyle(fontSize: 11, color: Colors.black45)),
        ),
        if (text.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
                color: bg, borderRadius: BorderRadius.circular(4)),
            child: Text(text,
                style: TextStyle(
                    fontSize: 10, fontWeight: FontWeight.w600, color: fg)),
          ),
      ],
    );
  }

  String _fmt(String label, double v) {
    if (label == 'CO') return v.toStringAsFixed(2);
    if (label == 'CaO₂' || label == 'O₂ER') return v.toStringAsFixed(1);
    if (label == 'P/F') return v.toStringAsFixed(0);
    return v.toStringAsFixed(1);
  }
}
