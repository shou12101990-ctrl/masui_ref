import 'package:flutter/material.dart';

import '../state/patient_store.dart';
import '../widgets/calc_parts.dart';

/// iv PCA 計算機
class PcaScreen extends StatefulWidget {
  const PcaScreen({super.key});

  @override
  State<PcaScreen> createState() => _PcaScreenState();
}

// ── 選択肢 ──────────────────────────────────────────────────────────────────
const _concOpts = [5, 10, 15, 20, 25]; // mcg/ml (シリンジ内目標濃度)
const _rateOpts = [0.5, 1.0, 1.5, 2.0, 2.5, 3.0]; // ml/h 持続流速
final _dayOpts  = [
  (0.5, '翌日退院'),
  (1.0, '1 日'),
  (1.5, '1.5 日'),
  (2.0, '2 日'),
  (2.5, '2.5 日'),
  (3.0, '3 日'),
];

class _PcaScreenState extends State<PcaScreen> {
  final _patient = PatientStore.instance;
  double get _wt => _patient.weightOr; // 体重は患者情報から自動連携
  int    _conc = 10;   // mcg/ml
  double _rate = 2.0;  // ml/h  ← デフォルト 2 ml/h
  double _days = 2.0;
  bool   _drop = false;

  // ── タブ2 (逆算) 入力 ──────────────────────────────────────────
  final _fen2  = TextEditingController(text: '20'); // フェンタニル mL
  final _dro2  = TextEditingController(text: '0');  // ドロレプタン mL
  final _ns2   = TextEditingController(text: '80'); // 生食 mL
  final _rate2 = TextEditingController(text: '2');  // 流速 mL/h

  List<TextEditingController> get _ctrl2 =>
      [_fen2, _dro2, _ns2, _rate2];

  void _onPatient() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    for (final c in _ctrl2) {
      c.addListener(() => setState(() {}));
    }
    _patient.addListener(_onPatient);
  }

  @override
  void dispose() {
    _patient.removeListener(_onPatient);
    for (final c in _ctrl2) {
      c.dispose();
    }
    super.dispose();
  }

  double _pv(TextEditingController c) => double.tryParse(c.text.trim()) ?? 0;
  double get _fentaMcg2 => _pv(_fen2) * 50.0; // 原液 50μg/mL
  double get _total2 => _pv(_fen2) + _pv(_dro2) + _pv(_ns2);
  double? get _conc2 => _total2 > 0 ? _fentaMcg2 / _total2 : null;
  double? get _speed2 {
    final w = _wt, r = _pv(_rate2);
    return (_conc2 != null && w > 0) ? _conc2! * r / w : null;
  }

  Widget _weightChip() => PatientLinkedChip(
        '体重 ${_wt % 1 == 0 ? _wt.toStringAsFixed(0) : _wt} kg',
        usingDefault: _patient.weightKg == null,
        accent: const Color(0xFFE64A19),
      );
  double? get _hours2 {
    final r = _pv(_rate2);
    return r > 0 ? _total2 / r : null;
  }

  // ── 計算 ──────────────────────────────────────────────────────────────────
  /// 投与速度 (mcg/kg/h)
  double get _mcgKgH => _rate * _conc / _wt;

  /// 必要総量 (50ml単位切り上げ, 50–500ml)
  double get _totalMl {
    final raw = _rate * _days * 24.0;
    return ((raw / 50.0).ceil() * 50.0).clamp(50.0, 500.0);
  }

  /// フェンタニル原液必要量 (mL) — 原液 50μg/ml から換算
  double get _fentOrigMl => _totalMl * _conc / 50.0;
  int    get _fentOrigMlInt => _fentOrigMl.round();

  /// バイアル本数 (10ml → 5ml → 2ml の順で最小化)
  int get _n10 => _fentOrigMlInt ~/ 10;
  int get _n5  => (_fentOrigMlInt % 10) ~/ 5;
  int get _n2  => (_fentOrigMlInt % 10 % 5) ~/ 2;

  /// ドロレプタン (ml)
  double get _dropMl => _drop ? 1.0 : 0.0;

  /// 生食 (ml)
  double get _nsMl => _totalMl - _fentOrigMl - _dropMl;

  /// 実予測期間 (0.5日単位切り下げ)
  double get _durDays {
    if (_rate <= 0) return 0;
    final raw = _totalMl / _rate / 24.0;
    return (raw / 0.5).floor() * 0.5;
  }

  /// バイアル内訳テキスト
  String get _vialStr {
    final parts = <String>[];
    if (_n10 > 0) parts.add('10mLA×$_n10');
    if (_n5  > 0) parts.add(' 5mLA×$_n5');
    if (_n2  > 0) parts.add(' 2mLA×$_n2');
    return parts.isEmpty ? '—' : parts.join('  ');
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ivPCA'),
          backgroundColor: scheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: '設計（流速→調製）'),
              Tab(text: '逆算（調製→速度）'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // ── タブ1: 設計 ──
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [

          _weightChip(),
          const SizedBox(height: 12),
          // ── 入力 ──────────────────────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // 左: 各ドロップダウン縦並び
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _dd<int>(
                          label: '濃度', suffix: 'μg/ml',
                          value: _conc, items: _concOpts,
                          onChanged: (v) => setState(() => _conc = v),
                        ),
                        const SizedBox(height: 8),
                        _dd<double>(
                          label: '流速', suffix: 'ml/h',
                          value: _rate, items: _rateOpts,
                          onChanged: (v) => setState(() => _rate = v),
                          itemLabel: (v) => v.toStringAsFixed(1),
                        ),
                        const SizedBox(height: 8),
                        _dd<double>(
                          label: '投与日数', suffix: '',
                          value: _days,
                          items: _dayOpts.map((e) => e.$1).toList(),
                          onChanged: (v) => setState(() => _days = v),
                          itemLabel: (v) => _dayOpts.firstWhere((e) => e.$1 == v).$2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),

                  // 右: ドロレプタン (縦並び)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'ドロレプタン',
                        style: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton<bool>(
                        direction: Axis.vertical,
                        segments: const [
                          ButtonSegment(value: true,  label: Text('あり')),
                          ButtonSegment(value: false, label: Text('なし')),
                        ],
                        selected: {_drop},
                        onSelectionChanged: (s) => setState(() => _drop = s.first),
                        style: ButtonStyle(
                          visualDensity: VisualDensity.compact,
                          textStyle: WidgetStateProperty.all(
                              const TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ── 投与速度 (左) + 調製 (右) ─────────────────────────────────
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 投与速度
                Expanded(
                  flex: 4,
                  child: _resultCard(
                    scheme: scheme,
                    title: '投与速度',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              _mcgKgH.toStringAsFixed(2),
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 5),
                            const Text('mcg/kg/h',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.black54)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text('持続 ${_fmtD(_rate)} ml/h',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black54)),
                        Text('予測期間 ${_fmtD(_durDays)} 日',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black54)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // 調製
                Expanded(
                  flex: 6,
                  child: _resultCard(
                    scheme: scheme,
                    title: '調製  (${_conc}μg/ml · ${_totalMl.toInt()}ml)',
                    child: Column(
                      children: [
                        _prepRow(
                          label: 'フェンタニル',
                          value: '${_fentOrigMlInt} ml',
                          sub: _vialStr,
                        ),
                        if (_drop)
                          _prepRow(
                              label: 'ドロレプタン',
                              value: '1 ml',
                              sub: '2.5 mg'),
                        _prepRow(
                          label: '生食',
                          value: '${_nsMl.toInt()} ml',
                          sub: '',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // ── PCA 設定 ───────────────────────────────────────────────────────
          _resultCard(
            scheme: scheme,
            title: 'PCA 設定',
            child: _settingTable([
              ('持続投与',     '${_fmtD(_rate)} ml/h'),
              ('ボーラス',     '2 ml  (${_conc * 2} μg) / 回'),
              ('ロックアウト', '15 分'),
              ('予測期間',     '${_fmtD(_durDays)} 日'),
            ]),
          ),
              ],
            ),
            // ── タブ2: 逆算 ──
            _reverseTab(scheme),
          ],
        ),
      ),
    );
  }

  // ── タブ2: 逆算（調製内容 → 速度・もち時間）─────────────────────
  Widget _reverseTab(ColorScheme scheme) {
    final hrs = _hours2;
    String dur = '—';
    if (hrs != null) {
      final d = hrs ~/ 24;
      final h = (hrs - d * 24).round();
      dur = d > 0 ? '$d 日 $h 時間' : '$h 時間';
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('調製内容を入力',
                    style: TextStyle(
                        color: scheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
                const SizedBox(height: 12),
                _weightChip(),
                const SizedBox(height: 10),
                _in2('フェンタニル', _fen2, 'mL'),
                _in2('ドロレプタン', _dro2, 'mL'),
                _in2('生食', _ns2, 'mL'),
                _in2('流速', _rate2, 'mL/h'),
                const SizedBox(height: 4),
                Text('※ フェンタニルは原液 50 μg/mL として計算',
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey.shade500)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        _resultCard(
          scheme: scheme,
          title: '計算結果  (総液量 ${_total2.toStringAsFixed(0)} mL)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _outRow('濃度', _conc2 == null ? '—' : _conc2!.toStringAsFixed(1),
                  'μg/mL'),
              const Divider(height: 18),
              _outRow('投与速度',
                  _speed2 == null ? '—' : _speed2!.toStringAsFixed(2),
                  'μg/kg/h'),
              const Divider(height: 18),
              _outRow('もつ時間', dur, ''),
            ],
          ),
        ),
      ],
    );
  }

  Widget _in2(String label, TextEditingController c, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(children: [
        SizedBox(
            width: 96,
            child: Text(label, style: const TextStyle(fontSize: 14))),
        SizedBox(
          width: 92,
          child: TextField(
            controller: c,
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
        const SizedBox(width: 8),
        Text(unit, style: const TextStyle(fontSize: 13, color: Colors.black54)),
      ]),
    );
  }

  Widget _outRow(String label, String value, String unit) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        SizedBox(
            width: 90,
            child: Text(label,
                style: const TextStyle(fontSize: 13, color: Colors.black54))),
        Text(value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(width: 5),
        Text(unit, style: const TextStyle(fontSize: 13, color: Colors.black54)),
      ],
    );
  }

  // ── 共通ウィジェット ───────────────────────────────────────────────────────
  Widget _resultCard({
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

  Widget _prepRow(
      {required String label, required String value, required String sub}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 78,
            child: Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                if (sub.isNotEmpty)
                  Text(sub,
                      style: const TextStyle(
                          fontSize: 11, color: Colors.black45)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingTable(List<(String, String)> rows) {
    return Column(
      children: rows
          .map((r) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(r.$1,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54)),
                    ),
                    Expanded(
                      child: Text(r.$2,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ))
          .toList(),
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

  String _fmtD(double v) {
    if (v == v.truncateToDouble()) return v.toInt().toString();
    final s = v.toStringAsFixed(2);
    return s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }
}
