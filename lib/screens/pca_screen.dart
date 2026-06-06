import 'package:flutter/material.dart';

/// iv PCA 計算機 — ① スコア法 / ② 体重計算法
class PcaScreen extends StatefulWidget {
  const PcaScreen({super.key});

  @override
  State<PcaScreen> createState() => _PcaScreenState();
}

// ── 選択肢 ──────────────────────────────────────────────────────────────────
const _wtOpts = [30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100];
const _ageOpts = [
  20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90
];
// 目標速度 (mcg/kg/h)
const _targetOpts = [0.10, 0.15, 0.20, 0.25, 0.30];
// 期間
final _dayOpts = [
  (0.5, '翌日退院'),
  (1.0, '1 日'),
  (1.5, '1.5 日'),
  (2.0, '2 日'),
];

class _PcaScreenState extends State<PcaScreen>
    with SingleTickerProviderStateMixin {
  late final _tc = TabController(length: 2, vsync: this);

  // ─ Tab ①
  int _wt1 = 60;
  int _age = 40;
  bool _drop1 = false;

  // ─ Tab ②
  int _wt2 = 60;
  double _target = 0.20; // mcg/kg/h
  double _days = 2.0;
  bool _drop2 = false;

  @override
  void dispose() {
    _tc.dispose();
    super.dispose();
  }

  // ── ① スコア計算 ────────────────────────────────────────────────────────
  int get _wtScore => _wt1 <= 39 ? 0 : _wt1 <= 59 ? 1 : 2;
  int get _ageScore => _age <= 69 ? 2 : _age <= 79 ? 1 : 0;
  int get _score => _wtScore + _ageScore;

  // スコア→持続流速 (ml/h): 0→0.5, 1→0.5, 2→1.0, 3→1.5, 4→2.0
  double get _basal1 => [0.5, 0.5, 1.0, 1.5, 2.0][_score];

  // 調製: 固定 100 ml / 10 mcg/ml
  // フェンタニル 10 本 × 2 ml (100mcg/本) = 20 ml = 1000 mcg
  static const double _fent1Ml = 20.0;
  static const double _dropMlConst = 1.0; // ドロレプタン 2.5mg/1ml
  double get _drop1Ml => _drop1 ? _dropMlConst : 0.0;
  double get _ns1 => 100.0 - _fent1Ml - _drop1Ml;
  double get _durH1 => 100.0 / _basal1;

  // ── ② 計算 ──────────────────────────────────────────────────────────────
  // 持続流速 = 目標速度 × 体重 / 濃度(10 mcg/ml)
  double get _basal2 => _target * _wt2 / 10.0;
  // 必要総量を 50 ml 単位で切り上げ
  double get _totalMl2 {
    final raw = _basal2 * _days * 24.0;
    return ((raw / 50.0).ceil() * 50.0).clamp(50.0, 500.0);
  }
  // フェンタ量 = 総量 × 10(mcg/ml) / 50(mcg/ml 原液) = 総量 / 5
  double get _fent2Ml => _totalMl2 / 5.0;
  double get _drop2Ml => _drop2 ? _dropMlConst : 0.0;
  double get _ns2 => _totalMl2 - _fent2Ml - _drop2Ml;

  // ── build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ivPCA'),
        backgroundColor: scheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tc,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: '①  スコア法'),
            Tab(text: '②  体重計算'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tc,
        children: [_tab1(scheme), _tab2(scheme)],
      ),
    );
  }

  // ─────────────────────────────── Tab ① ───────────────────────────────────
  Widget _tab1(ColorScheme scheme) {
    final basalMcgH = _basal1 * 10.0;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        // 入力カード
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(
                    child: _ddInt('体重', 'kg', _wt1, _wtOpts,
                        (v) => setState(() => _wt1 = v)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ddInt('年齢', '歳', _age, _ageOpts,
                        (v) => setState(() => _age = v)),
                  ),
                ]),
                const SizedBox(height: 12),
                _dropRow(_drop1, (v) => setState(() => _drop1 = v)),
                const SizedBox(height: 10),
                _scoreBadge(scheme),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // 調製カード
        _leftCard(
          scheme: scheme,
          title: '調製  (10 mcg/ml / 100 ml)',
          child: Column(children: [
            _prepRow('フェンタニル', '20 ml  (10 本 / 1,000 mcg)'),
            if (_drop1) _prepRow('ドロレプタン', '1 ml  (2.5 mg)'),
            _prepRow('生食', '${_ns1.toInt()} ml'),
          ]),
        ),
        const SizedBox(height: 10),

        // PCA 設定カード
        _leftCard(
          scheme: scheme,
          title: 'PCA 設定',
          child: _settingTable([
            (
              '持続投与',
              '${_fmtD(_basal1)} ml/h'
                  '  (${_fmtD(basalMcgH)} mcg/h'
                  '  /  ${_fmtD(basalMcgH / _wt1)} mcg/kg/h)'
            ),
            ('ボーラス', '2 ml  (20 mcg) / 回'),
            ('ロックアウト', '15 分'),
            (
              '予測期間',
              '${_fmtD(_durH1)} 時間  (${_fmtD(_durH1 / 24)} 日)'
            ),
          ]),
        ),
      ],
    );
  }

  // ─────────────────────────────── Tab ② ───────────────────────────────────
  Widget _tab2(ColorScheme scheme) {
    final basalMcgH = _basal2 * 10.0;
    final amps = (_fent2Ml / 2).round(); // 本数
    final totalMcg = (_fent2Ml * 50).round(); // mcg
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        // 入力カード
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(
                    child: _ddInt('体重', 'kg', _wt2, _wtOpts,
                        (v) => setState(() => _wt2 = v)),
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
                _dropRow(_drop2, (v) => setState(() => _drop2 = v)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // 調製カード
        _leftCard(
          scheme: scheme,
          title: '調製  (10 mcg/ml / ${_totalMl2.toInt()} ml)',
          child: Column(children: [
            _prepRow(
                'フェンタニル',
                '${_fent2Ml.toInt()} ml'
                    '  ($amps 本 / $totalMcg mcg)'),
            if (_drop2) _prepRow('ドロレプタン', '1 ml  (2.5 mg)'),
            _prepRow('生食', '${_ns2.toInt()} ml'),
          ]),
        ),
        const SizedBox(height: 10),

        // PCA 設定カード
        _leftCard(
          scheme: scheme,
          title: 'PCA 設定',
          child: _settingTable([
            (
              '持続投与',
              '${_fmtD(_basal2)} ml/h  (${_fmtD(basalMcgH)} mcg/h)'
            ),
            ('ボーラス', '2 ml  (20 mcg) / 回'),
            ('ロックアウト', '15 分'),
          ]),
        ),
      ],
    );
  }

  // ── 共通ウィジェット ─────────────────────────────────────────────────────
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

  Widget _scoreBadge(ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _scoreItem('体重 ${_wt1}kg', _wtScore, scheme),
          const Text('  +  ',
              style: TextStyle(fontSize: 12, color: Colors.black38)),
          _scoreItem('年齢 ${_age}歳', _ageScore, scheme),
          const Spacer(),
          Text('合計  $_score 点',
              style: TextStyle(
                  color: scheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
        ],
      ),
    );
  }

  Widget _scoreItem(String label, int score, ColorScheme scheme) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 12, color: Colors.black54),
        children: [
          TextSpan(text: '$label = '),
          TextSpan(
            text: '$score',
            style: TextStyle(
                color: scheme.primary, fontWeight: FontWeight.bold),
          ),
          const TextSpan(text: '点'),
        ],
      ),
    );
  }

  Widget _dropRow(bool val, ValueChanged<bool> cb) {
    return Row(
      children: [
        const Text('ドロレプタン', style: TextStyle(fontSize: 13)),
        const Spacer(),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: true, label: Text('あり')),
            ButtonSegment(value: false, label: Text('なし')),
          ],
          selected: {val},
          onSelectionChanged: (s) => cb(s.first),
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
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
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
