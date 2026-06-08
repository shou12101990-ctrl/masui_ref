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

// 体重の選択肢: 30〜100 kg, 5 kg 刻み
const _weightOptions = [
  30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100,
];

class _GammaCalculatorScreenState extends State<GammaCalculatorScreen> {
  final _drugMg = TextEditingController(text: '150');
  final _totalMl = TextEditingController(text: '50');
  final _value = TextEditingController(text: '3');
  int _weightKg = 60; // 体重 (ドロップダウン) — 両タブ共通
  _Unit _inputUnit = _Unit.mlPerH;

  // ── タブ2: 複数製剤の一括流量 ──
  final _gPhe = TextEditingController();  // フェニレフリン
  final _gDopa = TextEditingController(); // ドパミン
  final _gNad = TextEditingController();  // ノルアドレナリン
  final _gDob = TextEditingController();  // ドブタミン
  final _gLan = TextEditingController();  // ランジオロール
  final _gAdr = TextEditingController();  // アドレナリン
  double _nadConc = 100;      // ノルアド 濃度(μg/mL) 既定 5mg/50mL
  double _adrConc = 100;      // アドレナリン 濃度(μg/mL) 既定 5mg/50mL
  bool _bulkExpanded = false; // 展開セクション

  List<TextEditingController> get _bulkCtrls =>
      [_gPhe, _gDopa, _gNad, _gDob, _gLan, _gAdr];

  @override
  void initState() {
    super.initState();
    for (final c in [_drugMg, _totalMl, _value, ..._bulkCtrls]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in [_drugMg, _totalMl, _value, ..._bulkCtrls]) {
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
    final w = _weightKg.toDouble();
    final c = _concMgPerMl;
    if (v == null) return null;
    switch (_inputUnit) {
      case _Unit.mlPerH:
        if (c == null || c <= 0) return null;
        return v * c; // ml/h × mg/ml = mg/h
      case _Unit.gamma:
        // μg/kg/min → mg/h: × W × 60 / 1000
        return v * w * 60 / 1000;
      case _Unit.mgPerH:
        return v;
      case _Unit.mgPerKgPerH:
        return v * w;
      case _Unit.mcgPerKgPerH:
        // μg/kg/h → mg/h: × W / 1000
        return v * w / 1000;
    }
  }

  // ── 全単位の結果 ──────────────────────────────────────────────────────
  _Result? get _result {
    final mgH = _normalizedMgPerH;
    final w = _weightKg.toDouble();
    final c = _concMgPerMl;
    if (mgH == null) return null;
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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('γ 計算機'),
          backgroundColor: scheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'γ変換'),
              Tab(text: '一括流量'),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              _gammaTab(theme, scheme),
              _bulkTab(theme, scheme),
            ],
          ),
        ),
      ),
    );
  }

  // ── タブ1: γ変換（既存機能）────────────────────────────────
  Widget _gammaTab(ThemeData theme, ColorScheme scheme) {
    return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            Text('単位を選んで相互変換 (γ = μg/kg/min)',
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54)),
            const SizedBox(height: 16),

            // ── 体重 / 薬剤希釈 / 流速 (1行) ────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // ─ 体重 ─
                        Expanded(
                          flex: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _groupLabel('体重', scheme),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<int>(
                                value: _weightKg,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  suffixText: 'kg',
                                  isDense: true,
                                  filled: true,
                                  fillColor: const Color(0xFFF7F9FA),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 12),
                                ),
                                items: _weightOptions
                                    .map((w) => DropdownMenuItem(
                                          value: w,
                                          child: Text('$w',
                                              style: const TextStyle(fontSize: 14)),
                                        ))
                                    .toList(),
                                onChanged: (w) {
                                  if (w != null) setState(() => _weightKg = w);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // ─ 薬剤希釈 ─
                        Expanded(
                          flex: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _groupLabel('薬剤希釈', scheme),
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(child: _compactNumField(_drugMg, 'mg')),
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(4, 0, 4, 10),
                                    child: Text('/',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.black38)),
                                  ),
                                  Expanded(child: _compactNumField(_totalMl, 'ml')),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // ─ 流速 ─
                        Expanded(
                          flex: 30,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _groupLabel('流速', scheme),
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: _compactNumField(_value, ''),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    flex: 5,
                                    child: DropdownButtonFormField<_Unit>(
                                      value: _inputUnit,
                                      isExpanded: true,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        filled: true,
                                        fillColor: const Color(0xFFF7F9FA),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 12),
                                      ),
                                      items: _Unit.values
                                          .map((u) => DropdownMenuItem(
                                                value: u,
                                                child: Text(u.dropdownLabel,
                                                    style: const TextStyle(
                                                        fontSize: 12)),
                                              ))
                                          .toList(),
                                      onChanged: (u) {
                                        if (u != null)
                                          setState(() => _inputUnit = u);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── 換算結果 ─────────────────────────────────────────────────
            _ResultCard(result: _result, inputUnit: _inputUnit),
          ],
        );
  }

  // ── タブ2: 複数製剤の一括流量 ───────────────────────────────
  Widget _bulkTab(ThemeData theme, ColorScheme scheme) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        Text('体重と各製剤のγを入力 → 流量 (mL/h) を一括算出',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54)),
        const SizedBox(height: 12),
        // 体重
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Row(
              children: [
                _groupLabel('体重', scheme),
                const SizedBox(width: 14),
                SizedBox(
                  width: 120,
                  child: DropdownButtonFormField<int>(
                    value: _weightKg,
                    isExpanded: true,
                    decoration: InputDecoration(
                      suffixText: 'kg',
                      isDense: true,
                      filled: true,
                      fillColor: const Color(0xFFF7F9FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 12),
                    ),
                    items: _weightOptions
                        .map((w) => DropdownMenuItem(
                            value: w,
                            child: Text('$w',
                                style: const TextStyle(fontSize: 14))))
                        .toList(),
                    onChanged: (w) {
                      if (w != null) setState(() => _weightKg = w);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // 製剤リスト
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            child: Column(
              children: [
                _bulkHeader(),
                const Divider(height: 12),
                _flowRow('フェニレフリン', '1mg/10mL', 100, _gPhe),
                const Divider(height: 14),
                _flowRow('ドパミン', '150mg/50mL', 3000, _gDopa),
                const Divider(height: 14),
                _toggleConcRow('ノルアドレナリン', _gNad, _nadConc,
                    (v) => setState(() => _nadConc = v)),
                if (_bulkExpanded) ...[
                  const Divider(height: 14),
                  _flowRow('ドブタミン', '150mg/50mL', 3000, _gDob),
                  const Divider(height: 14),
                  _flowRow('ランジオロール', '150mg/50mL', 3000, _gLan),
                  const Divider(height: 14),
                  _toggleConcRow('アドレナリン', _gAdr, _adrConc,
                      (v) => setState(() => _adrConc = v)),
                ],
                const SizedBox(height: 2),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () =>
                        setState(() => _bulkExpanded = !_bulkExpanded),
                    icon: Icon(
                        _bulkExpanded
                            ? Icons.expand_less
                            : Icons.expand_more,
                        size: 18),
                    label: Text(_bulkExpanded
                        ? '閉じる'
                        : '展開（ドブタミン・ランジオロール・アドレナリン）'),
                    style: TextButton.styleFrom(
                        foregroundColor: scheme.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        textStyle: const TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text('流量 (mL/h) = γ × 体重 × 60 ÷ 濃度(μg/mL)',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
      ],
    );
  }

  // 流量 (mL/h) = γ × 体重 × 60 / 濃度(μg/mL)
  double? _flow(double concMcgPerMl, TextEditingController c) {
    final g = double.tryParse(c.text.trim());
    if (g == null) return null;
    return g * _weightKg * 60 / concMcgPerMl;
  }

  Widget _bulkHeader() => const Padding(
        padding: EdgeInsets.only(bottom: 2),
        child: Row(children: [
          Expanded(
              child: Text('製剤',
                  style: TextStyle(fontSize: 11, color: Colors.black45))),
          SizedBox(width: 8),
          SizedBox(
              width: 64,
              child: Text('γ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Colors.black45))),
          SizedBox(width: 8),
          SizedBox(
              width: 76,
              child: Text('mL/h',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 11, color: Colors.black45))),
        ]),
      );

  Widget _drugLabel(String name, String dilution) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          Text(dilution,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
        ],
      );

  Widget _gammaField(TextEditingController c) => SizedBox(
        width: 64,
        child: TextField(
          controller: c,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: 'γ',
            isDense: true,
            filled: true,
            fillColor: const Color(0xFFF7F9FA),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
          ),
        ),
      );

  Widget _flowValue(double? f) => SizedBox(
        width: 76,
        child: Text(f == null ? '—' : _fmt(f),
            textAlign: TextAlign.right,
            style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      );

  Widget _flowRow(
      String name, String dilution, double concMcgPerMl, TextEditingController c) {
    return Row(
      children: [
        Expanded(child: _drugLabel(name, dilution)),
        const SizedBox(width: 8),
        _gammaField(c),
        const SizedBox(width: 8),
        _flowValue(_flow(concMcgPerMl, c)),
      ],
    );
  }

  // 濃度選択肢 (μg/mL, 表示ラベル)
  static const _concOpts = <(double, String)>[
    (100.0, '5mg/50mL'),
    (60.0, '3mg/50mL'),
    (20.0, '1mg/50mL'),
  ];

  // 濃度を切替できる製剤行（ノルアド・アドレナリン用）
  Widget _toggleConcRow(String name, TextEditingController c, double conc,
      ValueChanged<double> onChanged) {
    final dilution = _concOpts
        .firstWhere((e) => e.$1 == conc, orElse: () => _concOpts.first)
        .$2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _drugLabel(name, dilution)),
            const SizedBox(width: 8),
            _gammaField(c),
            const SizedBox(width: 8),
            _flowValue(_flow(conc, c)),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<double>(
            segments: _concOpts
                .map((e) =>
                    ButtonSegment(value: e.$1, label: Text(e.$2)))
                .toList(),
            selected: {conc},
            onSelectionChanged: (s) => onChanged(s.first),
            showSelectedIcon: false,
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 6)),
              textStyle:
                  WidgetStateProperty.all(const TextStyle(fontSize: 10.5)),
            ),
          ),
        ),
      ],
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

  Widget _compactNumField(TextEditingController c, String suffix) {
    return TextField(
      controller: c,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        suffixText: suffix.isEmpty ? null : suffix,
        suffixStyle: const TextStyle(fontSize: 12),
        isDense: true,
        filled: true,
        fillColor: const Color(0xFFF7F9FA),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _groupLabel(String text, ColorScheme scheme) {
    return Text(
      text,
      style: TextStyle(
          color: scheme.primary, fontWeight: FontWeight.bold, fontSize: 12),
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
              if (i > 0) const SizedBox(height: 5),
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
          width: 50,
          child: Text(label,
              style: const TextStyle(fontSize: 11, color: Colors.black45)),
        ),
        Expanded(
          child: Text(value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 80,
          child: Text(unit,
              style: const TextStyle(fontSize: 11, color: Colors.black45)),
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
