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
  bupivacaine(
    label: 'ブピバカイン',
    brand: 'マーカイン',
    maxNoEpi: 2.0,
    maxEpi: 2.0,
    concList: [0.25, 0.5],
  ),
  levobupivacaine(
    label: 'レボブピバカイン',
    brand: 'ポプスカイン',
    maxNoEpi: 3.0,
    maxEpi: 3.0,
    concList: [0.25, 0.5, 0.75],
  ),
  ropivacaine(
    label: 'ロピバカイン',
    brand: 'アナペイン',
    maxNoEpi: 3.0,
    maxEpi: 3.0,
    concList: [0.2, 0.75, 1.0],
  ),
  mepivacaine(
    label: 'メピバカイン',
    brand: 'カルボカイン',
    maxNoEpi: 7.0,
    maxEpi: 7.0,
    concList: [0.5, 1.0, 1.5, 2.0],
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

  double effectiveMax(bool epi) => epi ? maxEpi : maxNoEpi;
}

// ─── 表示フォーマット ─────────────────────────────────────────

String _fmtVal(double v) {
  if (v >= 100) return v.toStringAsFixed(0);
  if (v >= 10) return v.toStringAsFixed(1);
  return v.toStringAsFixed(2);
}

// ─── 画面 ─────────────────────────────────────────────────────

class LocalAnestheticMaxScreen extends StatefulWidget {
  const LocalAnestheticMaxScreen({super.key});

  @override
  State<LocalAnestheticMaxScreen> createState() =>
      _LocalAnestheticMaxScreenState();
}

class _LocalAnestheticMaxScreenState extends State<LocalAnestheticMaxScreen> {
  int _wt = 60;
  _LADrug _drug = _LADrug.lidocaine;
  bool _epi = false;

  static final _wtOpts = List.generate(
      15, (i) => 30 + i * 5); // 30,35,...,100 → but let's do 30-120
  static final _weightOpts = List.generate(19, (i) => 30 + i * 5);

  double get _maxMg => _wt * _drug.effectiveMax(_epi);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('局所麻酔薬 極量'),
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
                    Text('条件設定',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    // 体重
                    Row(children: [
                      const SizedBox(width: 80, child: Text('体重')),
                      DropdownButton<int>(
                        value: _wt,
                        items: _weightOpts
                            .map((w) => DropdownMenuItem(
                                value: w, child: Text('$w kg')))
                            .toList(),
                        onChanged: (v) => setState(() => _wt = v!),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    // 薬剤
                    Row(children: [
                      const SizedBox(width: 80, child: Text('薬剤')),
                      DropdownButton<_LADrug>(
                        value: _drug,
                        items: _LADrug.values
                            .map((d) => DropdownMenuItem(
                                value: d,
                                child: Text('${d.label}（${d.brand}）')))
                            .toList(),
                        onChanged: (v) => setState(() => _drug = v!),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    // エピ
                    Row(children: [
                      const SizedBox(width: 80, child: Text('エピネフリン')),
                      SegmentedButton<bool>(
                        segments: const [
                          ButtonSegment(value: false, label: Text('なし')),
                          ButtonSegment(value: true, label: Text('あり')),
                        ],
                        selected: {_epi},
                        onSelectionChanged: (s) =>
                            setState(() => _epi = s.first),
                        style: const ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // ─ 極量表示 ─
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '極量',
                      style: theme.textTheme.labelLarge
                          ?.copyWith(color: scheme.primary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_fmtVal(_maxMg)} mg',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: scheme.primary,
                      ),
                    ),
                    Text(
                      '（${_drug.effectiveMax(_epi)} mg/kg × $_wt kg${_epi ? "　エピあり" : ""}）',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // ─ 濃度別最大量テーブル ─
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('濃度別 最大量',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Table(
                      border: TableBorder.symmetric(
                        inside: BorderSide(
                            color: Colors.grey.shade200, width: 0.8),
                      ),
                      columnWidths: const {
                        0: FlexColumnWidth(1.4),
                        1: FlexColumnWidth(1.0),
                        2: FlexColumnWidth(1.2),
                      },
                      children: [
                        TableRow(
                          decoration:
                              BoxDecoration(color: Colors.grey.shade100),
                          children: const [
                            _TH('濃度'),
                            _TH('mg/mL'),
                            _TH('最大量 (mL)'),
                          ],
                        ),
                        for (final c in _drug.concList)
                          TableRow(children: [
                            _TD('${c.toStringAsFixed(2).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '')} %'),
                            _TD('${(c * 10).toStringAsFixed(0)} mg/mL'),
                            _TD('${_fmtVal(_maxMg / (c * 10))} mL'),
                          ]),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // ─ 注意 ─
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
                      '・极量は成人の参考値。高齢者・低体重・肝機能低下では減量。\n'
                      '・エピネフリン添加により組織固定が高まり吸収が遅くなるため上限が緩和される（ただしブピバカインは変わらず）。\n'
                      '・硬膜外・脊椎麻酔での全量投与は血管内投与と同様に扱う。\n'
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

class _TH extends StatelessWidget {
  final String text;
  const _TH(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Text(text,
            style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      );
}

class _TD extends StatelessWidget {
  final String text;
  const _TD(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Text(text, style: const TextStyle(fontSize: 13)),
      );
}
