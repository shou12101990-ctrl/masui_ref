import 'package:flutter/material.dart';

// ── 薬剤定義 ──────────────────────────────────────────────────────────────
enum _LADrug {
  lidocaine(
    'リドカイン', 'キシロカイン',
    maxMgKg: 4.0, maxEpiMgKg: 7.0,
    concs: [0.5, 1.0, 2.0],
    epiNote: 'E添加で7mg/kgまで増加（エピネフリン含有製剤を使用）',
  ),
  bupivacaine(
    'ブピバカイン', 'マーカイン',
    maxMgKg: 2.0, maxEpiMgKg: 2.0,
    concs: [0.25, 0.5],
    epiNote: 'E添加でも極量は変わらない. 心毒性が強く少量でも致死的不整脈に注意',
  ),
  levobupivacaine(
    'レボブピバカイン', 'ポプスカイン',
    maxMgKg: 3.0, maxEpiMgKg: 3.0,
    concs: [0.25],
    epiNote: null,
  ),
  ropivacaine(
    'ロピバカイン', 'アナペイン',
    maxMgKg: 3.0, maxEpiMgKg: 3.0,
    concs: [0.2, 0.75, 1.0],
    epiNote: null,
  ),
  mepivacaine(
    'メピバカイン', 'カルボカイン',
    maxMgKg: 7.0, maxEpiMgKg: 7.0,
    concs: [0.5, 1.0, 1.5, 2.0],
    epiNote: null,
  );

  final String name;
  final String brand;
  final double maxMgKg;
  final double maxEpiMgKg;
  final List<double> concs;
  final String? epiNote;
  const _LADrug(
    this.name, this.brand, {
    required this.maxMgKg,
    required this.maxEpiMgKg,
    required this.concs,
    required this.epiNote,
  });

  double effectiveMax(bool epi) => epi ? maxEpiMgKg : maxMgKg;
}

final _wtOpts = List.generate(19, (i) => 30 + i * 5); // 30–120 kg

class LocalAnestheticMaxScreen extends StatefulWidget {
  const LocalAnestheticMaxScreen({super.key});

  @override
  State<LocalAnestheticMaxScreen> createState() =>
      _LocalAnestheticMaxScreenState();
}

class _LocalAnestheticMaxScreenState
    extends State<LocalAnestheticMaxScreen> {
  int _wt       = 60;
  _LADrug _drug = _LADrug.lidocaine;
  bool _epi     = false;

  double get _maxMg => _drug.effectiveMax(_epi) * _wt;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('局所麻酔薬 極量'),
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
                  Row(children: [
                    Expanded(child: _dd<int>(
                      label: '体重', suffix: 'kg',
                      value: _wt, items: _wtOpts,
                      onChanged: (v) => setState(() => _wt = v),
                    )),
                    const SizedBox(width: 8),
                    Expanded(child: _dd<_LADrug>(
                      label: '薬剤', suffix: '',
                      value: _drug, items: _LADrug.values.toList(),
                      itemLabel: (d) => d.name,
                      onChanged: (v) => setState(() {
                        _drug = v;
                        _epi = false;
                      }),
                    )),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    const Text('エピネフリン', style: TextStyle(fontSize: 13)),
                    const SizedBox(width: 10),
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(value: true,  label: Text('あり')),
                        ButtonSegment(value: false, label: Text('なし')),
                      ],
                      selected: {_epi},
                      onSelectionChanged: (s) =>
                          setState(() => _epi = s.first),
                      style: ButtonStyle(
                        visualDensity: VisualDensity.compact,
                        textStyle: WidgetStateProperty.all(
                            const TextStyle(fontSize: 12)),
                      ),
                    ),
                  ]),
                  if (_drug.epiNote != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber.shade300),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline,
                              size: 13, color: Colors.amber.shade800),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(_drug.epiNote!,
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.amber.shade900,
                                    height: 1.4)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ── 結果 ──────────────────────────────────────────────────
          Card(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border:
                    Border(left: BorderSide(color: scheme.primary, width: 4)),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('極量',
                      style: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('${_maxMg.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 6),
                      const Text('mg',
                          style: TextStyle(
                              fontSize: 16, color: Colors.black54)),
                    ],
                  ),
                  Text(
                    '${_drug.effectiveMax(_epi)} mg/kg × $_wt kg'
                    '  (${_drug.brand})',
                    style: const TextStyle(
                        fontSize: 11, color: Colors.black45),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  Text('製剤別 最大投与量',
                      style: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                  const SizedBox(height: 8),
                  for (final conc in _drug.concs) ...[
                    _concRow(conc, scheme),
                    if (conc != _drug.concs.last)
                      const Divider(height: 10),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _concRow(double conc, ColorScheme scheme) {
    final mgPerMl = conc * 10.0;
    final maxMl   = _maxMg / mgPerMl;
    return Row(
      children: [
        Container(
          width: 52,
          padding:
              const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text('${conc.toStringAsFixed(conc < 1.0 ? 2 : 1)}%',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: scheme.primary)),
        ),
        const SizedBox(width: 6),
        Text('(${_fmtVal(mgPerMl)} mg/mL)',
            style: const TextStyle(fontSize: 11, color: Colors.black38)),
        const Spacer(),
        Text(_fmtVal(maxMl),
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(width: 4),
        const Text('mL',
            style: TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }

  Widget _dd<T>({
    required String label,
    required String suffix,
    required T value,
    required List<T> items,
    required ValueChanged<T> onChanged,
    String Function(T)? itemLabel,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      ),
      items: items
          .map((v) => DropdownMenuItem<T>(
                value: v,
                child: Text(
                  itemLabel != null ? itemLabel(v) : '$v',
                  style: const TextStyle(fontSize: 13),
                ),
              ))
          .toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}

String _fmtVal(double v) {
  if (v == v.truncateToDouble()) return v.toInt().toString();
  final s = v.toStringAsFixed(1);
  return s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
}
