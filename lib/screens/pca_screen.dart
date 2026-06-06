import 'package:flutter/material.dart';

/// iv PCA 計算機 — 体重ベース計算
class PcaScreen extends StatefulWidget {
  const PcaScreen({super.key});

  @override
  State<PcaScreen> createState() => _PcaScreenState();
}

// ── 選択肢 ──────────────────────────────────────────────────────────────────
const _wtOpts = [30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100];
const _targetOpts = [0.10, 0.15, 0.20, 0.25, 0.30]; // mcg/kg/h
final _dayOpts = [
  (0.5, '翌日退院'),
  (1.0, '1 日'),
  (1.5, '1.5 日'),
  (2.0, '2 日'),
];

class _PcaScreenState extends State<PcaScreen> {
  int _wt = 60;
  double _target = 0.20; // mcg/kg/h
  double _days = 2.0;
  bool _drop = false;

  // ── 計算 ──────────────────────────────────────────────────────────────────
  // 持続流速 (ml/h): 目標速度 × 体重 / 濃度(10 mcg/ml)
  double get _basal => _target * _wt / 10.0;

  // 調製総量: 必要量を 50 ml 単位で切り上げ
  double get _totalMl {
    final raw = _basal * _days * 24.0;
    return ((raw / 50.0).ceil() * 50.0).clamp(50.0, 500.0);
  }

  // フェンタ量 = 総量 × 10(mcg/ml) / 50(mcg/ml 原液) = 総量 / 5
  double get _fentMl => _totalMl / 5.0;
  double get _dropMl => _drop ? 1.0 : 0.0; // ドロレプタン 2.5mg/1ml
  double get _ns => _totalMl - _fentMl - _dropMl;

  // 投与速度 mcg/kg/h (小数第1位)
  String get _basalMcgKgHStr =>
      (_basal * 10.0 / _wt).toStringAsFixed(1);

  // 予測期間: 総量 / 流速 → 0.5 日単位で切り下げ
  double get _durDays {
    if (_basal <= 0) return 0;
    final raw = _totalMl / _basal / 24.0;
    return (raw / 0.5).floor() * 0.5;
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final amps = (_fentMl / 2).round();
    final totalMcg = (_fentMl * 50).round();

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
                  Row(children: [
                    Expanded(
                      child: _ddInt('体重', 'kg', _wt, _wtOpts,
                          (v) => setState(() => _wt = v)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ddDouble(
                        '目標速度', 'mcg/kg/h', _target, _targetOpts,
                        (v) => setState(() => _target = v),
                        itemLabel: (v) => v.toStringAsFixed(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ddDouble(
                        '期間', '', _days,
                        _dayOpts.map((e) => e.$1).toList(),
                        (v) => setState(() => _days = v),
                        itemLabel: (v) =>
                            _dayOpts.firstWhere((e) => e.$1 == v).$2,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  _dropRow(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ── 調製 ──────────────────────────────────────────────────────────
          _leftCard(
            scheme: scheme,
            title: '調製  (10 mcg/ml / ${_totalMl.toInt()} ml)',
            child: Column(children: [
              _prepRow('フェンタニル',
                  '${_fentMl.toInt()} ml  ($amps 本 / $totalMcg mcg)'),
              if (_drop) _prepRow('ドロレプタン', '1 ml  (2.5 mg)'),
              _prepRow('生食', '${_ns.toInt()} ml'),
            ]),
          ),
          const SizedBox(height: 10),

          // ── PCA 設定 ───────────────────────────────────────────────────────
          _leftCard(
            scheme: scheme,
            title: 'PCA 設定',
            child: _settingTable([
              (
                '持続投与',
                '${_fmtD(_basal)} ml/h  ($_basalMcgKgHStr mcg/kg/h)'
              ),
              ('ボーラス', '2 ml  (20 mcg) / 回'),
              ('ロックアウト', '15 分'),
              ('予測期間', '${_fmtD(_durDays)} 日'),
            ]),
          ),
        ],
      ),
    );
  }

  // ── 共通ウィジェット ───────────────────────────────────────────────────────
  Widget _leftCard({
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

  Widget _dropRow() {
    return Row(
      children: [
        const Text('ドロレプタン', style: TextStyle(fontSize: 13)),
        const Spacer(),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: true, label: Text('あり')),
            ButtonSegment(value: false, label: Text('なし')),
          ],
          selected: {_drop},
          onSelectionChanged: (s) => setState(() => _drop = s.first),
          style: ButtonStyle(
            visualDensity: VisualDensity.compact,
            textStyle:
                WidgetStateProperty.all(const TextStyle(fontSize: 12)),
          ),
        ),
      ],
    );
  }

  Widget _prepRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: Text(label,
                style:
                    const TextStyle(fontSize: 12, color: Colors.black54)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600)),
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

  Widget _ddInt(
    String label,
    String suffix,
    int value,
    List<int> items,
    ValueChanged<int> onChanged,
  ) {
    return DropdownButtonFormField<int>(
      value: value,
      isExpanded: true,
      decoration: _ddDeco(label, suffix),
      items: items
          .map((v) => DropdownMenuItem(
                value: v,
                child: Text('$v', style: const TextStyle(fontSize: 13)),
              ))
          .toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }

  Widget _ddDouble(
    String label,
    String suffix,
    double value,
    List<double> items,
    ValueChanged<double> onChanged, {
    required String Function(double) itemLabel,
  }) {
    return DropdownButtonFormField<double>(
      value: value,
      isExpanded: true,
      decoration: _ddDeco(label, suffix),
      items: items
          .map((v) => DropdownMenuItem(
                value: v,
                child: Text(itemLabel(v),
                    style: const TextStyle(fontSize: 13)),
              ))
          .toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }

  InputDecoration _ddDeco(String label, String suffix) => InputDecoration(
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
      );

  String _fmtD(double v) {
    if (v == v.truncateToDouble()) return v.toInt().toString();
    final s = v.toStringAsFixed(2);
    return s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }
}
