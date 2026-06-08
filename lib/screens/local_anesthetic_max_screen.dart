import 'package:flutter/material.dart';

// ─── モデル ──────────────────────────────────────────────────────

enum _LADrug {
  lidocaine(
    label: 'リドカイン',
    brand: 'キシロカイン',
    maxNoEpi: 4.0,
    maxEpi: 7.0,
    concList: [0.5, 1.0, 2.0],
  ),
  mepivacaine(
    label: 'メピバカイン',
    brand: 'カルボカイン',
    maxNoEpi: 7.0,
    maxEpi: 7.0,
    concList: [0.5, 1.0, 1.5, 2.0],
  ),
  ropivacaine(
    label: 'ロピバカイン',
    brand: 'アナペイン',
    maxNoEpi: 3.0,
    maxEpi: 3.0,
    concList: [0.2, 0.75, 1.0],
  ),
  levobupivacaine(
    label: 'レボブピバカイン',
    brand: 'ポプスカイン',
    maxNoEpi: 3.0,
    maxEpi: 3.0,
    concList: [0.25, 0.5, 0.75],
  ),
  bupivacaine(
    label: 'ブピバカイン',
    brand: 'マーカイン',
    maxNoEpi: 2.0,
    maxEpi: 2.0,
    concList: [0.25, 0.5],
  );

  final String label;
  final String brand;
  final double maxNoEpi;
  final double maxEpi;
  final List<double> concList;

  const _LADrug({
    required this.label,
    required this.brand,
    required this.maxNoEpi,
    required this.maxEpi,
    required this.concList,
  });

  /// エピネフリンで上限が変わるか（リドカインのみ変わる）
  bool get epiChangesMax => maxEpi != maxNoEpi;
  double effectiveMax(bool epi) => epi ? maxEpi : maxNoEpi;
}

// ─── 表示フォーマット ─────────────────────────────────────────

String _fmtVal(double v) {
  if (v >= 100) return v.toStringAsFixed(0);
  if (v >= 10) return v.toStringAsFixed(1);
  return v.toStringAsFixed(1);
}

String _fmtPct(double c) =>
    c.toStringAsFixed(2).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');

String _mgkg(double v) =>
    v % 1 == 0 ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

Widget _colTitle(String t) => Text(t,
    textAlign: TextAlign.center,
    style: const TextStyle(
        fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF6B7280)));

Widget _times() => const Padding(
      padding: EdgeInsets.only(top: 26, left: 3, right: 3),
      child: Text('×',
          style: TextStyle(
              fontSize: 18, color: Colors.black38, fontWeight: FontWeight.bold)),
    );

// ─── 画面 ─────────────────────────────────────────────────────

class LocalAnestheticMaxScreen extends StatefulWidget {
  const LocalAnestheticMaxScreen({super.key});

  @override
  State<LocalAnestheticMaxScreen> createState() =>
      _LocalAnestheticMaxScreenState();
}

class _LocalAnestheticMaxScreenState extends State<LocalAnestheticMaxScreen> {
  static const _accent = Color(0xFF6B7280);

  static const _concs = [0.125, 0.25, 0.375, 0.5, 0.75, 1.0];

  int _wt = 60;
  _LADrug _drug = _LADrug.lidocaine;
  bool _epi = false;
  double _conc = 0.25;

  double get _maxMg => _wt * _drug.effectiveMax(_epi);
  double get _mgPerMl => _conc * 10.0;
  double get _maxMl => _maxMg / _mgPerMl;

  void _selectDrug(_LADrug d) => setState(() => _drug = d);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('局所麻酔薬 極量計算'),
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── 体重 ──
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    const Text('体重',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    _RoundBtn(
                      icon: Icons.remove,
                      onTap: () => setState(
                          () => _wt = (_wt - 5).clamp(10, 150)),
                    ),
                    SizedBox(
                      width: 84,
                      child: Text('$_wt kg',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    _RoundBtn(
                      icon: Icons.add,
                      onTap: () => setState(
                          () => _wt = (_wt + 5).clamp(10, 150)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── 製剤 × 濃度 × エピ ──
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // A: 製剤
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _colTitle('製剤'),
                          const SizedBox(height: 8),
                          for (final d in _LADrug.values) ...[
                            _ChoiceBtn(
                              label: d.label,
                              sub: '${_mgkg(d.maxNoEpi)} mg/kg',
                              selected: _drug == d,
                              color: _accent,
                              onTap: () => _selectDrug(d),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ],
                      ),
                    ),
                    _times(),
                    // B: 濃度
                    SizedBox(
                      width: 76,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _colTitle('濃度'),
                          const SizedBox(height: 8),
                          for (final c in _concs) ...[
                            _ChoiceBtn(
                              label: '${_fmtPct(c)}%',
                              selected: _conc == c,
                              color: _accent,
                              onTap: () => setState(() => _conc = c),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ],
                      ),
                    ),
                    _times(),
                    // C: エピ添加
                    SizedBox(
                      width: 54,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _colTitle('エピ'),
                          const SizedBox(height: 8),
                          _ChoiceBtn(
                            label: 'なし',
                            selected: !_epi,
                            color: _accent,
                            onTap: () => setState(() => _epi = false),
                          ),
                          const SizedBox(height: 8),
                          _ChoiceBtn(
                            label: 'あり',
                            selected: _epi,
                            color: _accent,
                            onTap: () => setState(() => _epi = true),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── 出力 (mL) ──
            Card(
              color: _accent.withValues(alpha: 0.07),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    const Text('最大投与量',
                        style:
                            TextStyle(fontSize: 13, color: Colors.black54)),
                    const SizedBox(height: 4),
                    Text(
                      '${_fmtVal(_maxMl)} mL',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: _accent,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${_drug.label} ${_fmtPct(_conc)}%  ·  極量 ${_fmtVal(_maxMg)} mg',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${_drug.effectiveMax(_epi).toStringAsFixed(_drug.effectiveMax(_epi) % 1 == 0 ? 0 : 1)} mg/kg × $_wt kg${_epi ? "（エピあり）" : ""}',
                      style: const TextStyle(
                          fontSize: 11, color: Colors.black45),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── 極量 (mg/kg) 一覧 ──
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ガイドライン上の極量 (mg/kg)',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Table(
                      border: TableBorder.symmetric(
                        inside: BorderSide(
                            color: Colors.grey.shade200, width: 0.8),
                      ),
                      columnWidths: const {
                        0: FlexColumnWidth(1.7),
                        1: FlexColumnWidth(1.0),
                        2: FlexColumnWidth(1.0),
                      },
                      children: [
                        TableRow(
                          decoration:
                              BoxDecoration(color: Colors.grey.shade100),
                          children: const [
                            _Cell('薬剤', header: true),
                            _Cell('エピなし', header: true),
                            _Cell('エピあり', header: true),
                          ],
                        ),
                        for (final d in _LADrug.values)
                          TableRow(
                            decoration: BoxDecoration(
                                color: d == _drug
                                    ? _accent.withValues(alpha: 0.10)
                                    : null),
                            children: [
                              _Cell(d.label, bold: d == _drug),
                              _Cell(_mgkg(d.maxNoEpi), bold: d == _drug),
                              _Cell(_mgkg(d.maxEpi), bold: d == _drug),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '単位 mg/kg。エピネフリン添加で上限が上がるのは主にリドカイン。'
                      '高齢者・低体重では減量を。',
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── 注意 ──
            Card(
              color: Colors.amber.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.info_outline,
                          color: Colors.amber.shade800, size: 18),
                      const SizedBox(width: 6),
                      Text('注意事項',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.amber.shade900,
                              fontSize: 13)),
                    ]),
                    const SizedBox(height: 6),
                    const Text(
                      '・極量は成人の参考値。高齢者・低体重・肝機能低下では減量。\n'
                      '・エピネフリン添加で吸収が遅くなり上限が緩和されるのは主にリドカイン（ブピバカイン等は変化なし）。\n'
                      '・血管内誤注入では極量以下でも中毒(LAST)が起こりうる。\n'
                      '・必ず最新の添付文書を確認すること。',
                      style: TextStyle(fontSize: 12, height: 1.6),
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

class _Cell extends StatelessWidget {
  final String text;
  final bool header;
  final bool bold;
  const _Cell(this.text, {this.header = false, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      child: Text(text,
          style: TextStyle(
              fontSize: header ? 12 : 13,
              fontWeight:
                  (header || bold) ? FontWeight.bold : FontWeight.normal)),
    );
  }
}

class _RoundBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: scheme.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: scheme.primary),
      ),
    );
  }
}

class _ChoiceBtn extends StatelessWidget {
  final String label;
  final String sub;
  final bool selected;
  final Color color;
  final VoidCallback onTap;
  const _ChoiceBtn({
    required this.label,
    this.sub = '',
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.14) : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected ? color : Colors.transparent, width: 1.6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                    color: selected ? Colors.black87 : Colors.black54)),
            if (sub.isNotEmpty) ...[
              const SizedBox(height: 1),
              Text(sub,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10,
                      color: selected ? color : Colors.black38)),
            ],
          ],
        ),
      ),
    );
  }
}
