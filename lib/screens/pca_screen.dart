import 'package:flutter/material.dart';

/// iv PCA 計算機
class PcaScreen extends StatefulWidget {
  const PcaScreen({super.key});

  @override
  State<PcaScreen> createState() => _PcaScreenState();
}

// ── 選択肢 ──────────────────────────────────────────────────────────────────
const _wtOpts   = [30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100];
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
  int    _wt   = 60;
  int    _conc = 10;   // mcg/ml
  double _rate = 1.0;  // ml/h
  double _days = 2.0;
  bool   _drop = false;

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('ivPCA'),
        backgroundColor: scheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [

          // ── 入力 ──────────────────────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 行1: 体重 / 濃度 / 流速
                  Row(children: [
                    Expanded(child: _dd<int>(
                      label: '体重', suffix: 'kg',
                      value: _wt, items: _wtOpts,
                      onChanged: (v) => setState(() => _wt = v),
                    )),
                    const SizedBox(width: 8),
                    Expanded(child: _dd<int>(
                      label: '濃度', suffix: 'μg/ml',
                      value: _conc, items: _concOpts,
                      onChanged: (v) => setState(() => _conc = v),
                    )),
                    const SizedBox(width: 8),
                    Expanded(child: _dd<double>(
                      label: '流速', suffix: 'ml/h',
                      value: _rate, items: _rateOpts,
                      onChanged: (v) => setState(() => _rate = v),
                      itemLabel: (v) => v.toStringAsFixed(1),
                    )),
                  ]),
                  const SizedBox(height: 8),
                  // 行2: 投与日数 / ドロレプタン
                  Row(children: [
                    Expanded(child: _dd<double>(
                      label: '投与日数', suffix: '',
                      value: _days,
                      items: _dayOpts.map((e) => e.$1).toList(),
                      onChanged: (v) => setState(() => _days = v),
                      itemLabel: (v) => _dayOpts.firstWhere((e) => e.$1 == v).$2,
                    )),
                    const SizedBox(width: 16),
                    const Text('ドロレプタン', style: TextStyle(fontSize: 13)),
                    const SizedBox(width: 8),
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(value: true,  label: Text('あり')),
                        ButtonSegment(value: false, label: Text('なし')),
                      ],
                      selected: {_drop},
                      onSelectionChanged: (s) => setState(() => _drop = s.first),
                      style: ButtonStyle(
                        visualDensity: VisualDensity.compact,
                        textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 12)),
                      ),
                    ),
                  ]),
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
                              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 5),
                            const Text('mcg/kg/h',
                                style: TextStyle(fontSize: 13, color: Colors.black54)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text('持続 ${_fmtD(_rate)} ml/h',
                            style: const TextStyle(fontSize: 12, color: Colors.black54)),
                        Text('予測期間 ${_fmtD(_durDays)} 日',
                            style: const TextStyle(fontSize: 12, color: Colors.black54)),
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
                          _prepRow(label: 'ドロレプタン', value: '1 ml', sub: '2.5 mg'),
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

  Widget _prepRow({required String label, required String value, required String sub}) {
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
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                if (sub.isNotEmpty)
                  Text(sub,
                      style: const TextStyle(fontSize: 11, color: Colors.black45)),
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
