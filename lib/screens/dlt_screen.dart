import 'package:flutter/material.dart';

// ─── モデル ──────────────────────────────────────────────────────

enum _Sex {
  male('男性'),
  female('女性');

  final String label;
  const _Sex(this.label);
}

// Brodsky (1999) サイズ基準
const _tableRows = [
  // [height, maleFr, femaleFr]
  [140, 37, 35],
  [145, 37, 35],
  [150, 37, 35],
  [155, 37, 35],
  [160, 39, 37],
  [165, 39, 37],
  [170, 41, 37],
  [175, 41, 37],
  [180, 41, 37],
  [185, 41, 37],
  [190, 41, 37],
];

// ─── 画面 ─────────────────────────────────────────────────────

class DltScreen extends StatefulWidget {
  const DltScreen({super.key});

  @override
  State<DltScreen> createState() => _DltScreenState();
}

class _DltScreenState extends State<DltScreen> {
  _Sex _sex = _Sex.male;
  int _height = 165;

  int get _fr {
    if (_sex == _Sex.male) {
      if (_height >= 170) return 41;
      if (_height >= 160) return 39;
      return 37;
    } else {
      if (_height >= 160) return 37;
      return 35;
    }
  }

  double get _depth => _height / 10.0 + 12.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('DLT サイズ選択'),
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
                    Text('患者情報',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    // 性別
                    Row(children: [
                      const SizedBox(width: 60, child: Text('性別')),
                      SegmentedButton<_Sex>(
                        segments: _Sex.values
                            .map((s) => ButtonSegment(
                                value: s, label: Text(s.label)))
                            .toList(),
                        selected: {_sex},
                        onSelectionChanged: (s) =>
                            setState(() => _sex = s.first),
                        style: const ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ]),
                    const SizedBox(height: 12),
                    // 身長
                    Row(children: [
                      const SizedBox(width: 60, child: Text('身長')),
                      DropdownButton<int>(
                        value: _height,
                        items: _tableRows
                            .map((r) => DropdownMenuItem(
                                value: r[0] as int,
                                child: Text('${r[0]} cm')))
                            .toList(),
                        onChanged: (v) => setState(() => _height = v!),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ─ 推奨結果 ─
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ResultChip(
                          label: '推奨 Fr',
                          value: '$_fr Fr',
                          color: scheme.primary,
                        ),
                        _ResultChip(
                          label: '挿入深さ',
                          value: '${_depth.toStringAsFixed(1)} cm',
                          color: scheme.secondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '（Brodsky 1999 基準 · 身長 $_height cm · ${_sex.label}）',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '挿入深さ = 身長 / 10 + 12',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.black38),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ─ サイズ表 ─
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('身長別サイズ表（Brodsky）',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Table(
                      border: TableBorder.symmetric(
                        inside: BorderSide(
                            color: Colors.grey.shade200, width: 0.8),
                      ),
                      columnWidths: const {
                        0: FlexColumnWidth(1.2),
                        1: FlexColumnWidth(1.0),
                        2: FlexColumnWidth(1.0),
                        3: FlexColumnWidth(1.2),
                      },
                      children: [
                        TableRow(
                          decoration:
                              BoxDecoration(color: Colors.grey.shade100),
                          children: const [
                            _TH('身長 (cm)'),
                            _TH('男性 (Fr)'),
                            _TH('女性 (Fr)'),
                            _TH('挿入深さ (cm)'),
                          ],
                        ),
                        for (final row in _tableRows) ...[
                          _buildRow(context, row, scheme),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ─ CT実測 気管径/気管支径 表 ─
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CT実測（気管径・気管支径）',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('術前CT・胸部Xpで径を実測できる場合はこちらがより正確',
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade600)),
                    const SizedBox(height: 10),
                    Table(
                      border: TableBorder.symmetric(
                        inside: BorderSide(
                            color: Colors.grey.shade200, width: 0.8),
                      ),
                      columnWidths: const {
                        0: FlexColumnWidth(1.1),
                        1: FlexColumnWidth(1.1),
                        2: FlexColumnWidth(1.3),
                      },
                      children: [
                        TableRow(
                          decoration:
                              BoxDecoration(color: Colors.grey.shade100),
                          children: const [
                            _TH('気管径'),
                            _TH('気管支径'),
                            _TH('DLT size'),
                          ],
                        ),
                        for (final r in const [
                          ['> 18 mm', '> 12 mm', '41 or 39 Fr'],
                          ['> 16 mm', '12 mm', '39 or 37 Fr'],
                          ['> 15 mm', '11 mm', '37 Fr'],
                          ['> 14 mm', '10 mm', '35 Fr'],
                          ['> 12.5 mm', '< 10 mm', '32 Fr'],
                        ])
                          TableRow(children: [
                            _TDStyled(r[0], const TextStyle(fontSize: 13)),
                            _TDStyled(r[1], const TextStyle(fontSize: 13)),
                            _TDStyled(
                                r[2],
                                const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                          ]),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '※ 左用DLTは左主気管支径から、右用は気管径からも選択する。'
                      '気管支径は左主気管支径を指す。',
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                          height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ─ 確認メモ ─
            Card(
              color: scheme.primaryContainer.withValues(alpha: 0.4),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.check_circle_outline,
                          color: scheme.primary, size: 18),
                      const SizedBox(width: 6),
                      Text('FOB確認のポイント',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: scheme.primary,
                              fontSize: 13)),
                    ]),
                    const SizedBox(height: 6),
                    const Text(
                      '【左用 DLT 挿入後の確認手順】\n'
                      '1. 聴診で両肺換気を確認（バルーン膨らませない状態）\n'
                      '2. 気管支側を clamp → 左肺のみ換気\n'
                      '3. 気管側を clamp → 右肺のみ換気\n'
                      '4. FOB（気管管腔）→ 輪状軟骨を通過しているか確認\n'
                      '5. FOB（気管支管腔）→ 左上肺葉の開口部が見えるか確認\n\n'
                      '【体位変換後は必ず再確認！】\n'
                      '側臥位へ体位変換するとチューブ位置がずれることが多い。\n'
                      'FOB または聴診で換気を必ず再確認する。',
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

  TableRow _buildRow(
      BuildContext context, List<dynamic> row, ColorScheme scheme) {
    final h = row[0] as int;
    final mFr = row[1] as int;
    final fFr = row[2] as int;
    final depth = h / 10.0 + 12.0;
    final isCurrent = h == _height;

    final bg = isCurrent
        ? scheme.primary.withValues(alpha: 0.12)
        : Colors.transparent;
    final style = isCurrent
        ? const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)
        : const TextStyle(fontSize: 13);

    return TableRow(
      decoration: BoxDecoration(color: bg),
      children: [
        _TDStyled('$h', style),
        _TDStyled('$mFr', style),
        _TDStyled('$fFr', style),
        _TDStyled(depth.toStringAsFixed(1), style),
      ],
    );
  }
}

class _ResultChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _ResultChip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 12, color: color, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}

class _TH extends StatelessWidget {
  final String text;
  const _TH(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Text(text,
            style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      );
}

class _TDStyled extends StatelessWidget {
  final String text;
  final TextStyle style;
  const _TDStyled(this.text, this.style);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Text(text, style: style),
      );
}
