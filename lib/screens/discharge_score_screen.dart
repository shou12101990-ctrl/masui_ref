import 'package:flutter/material.dart';

import '../domain/calculators/discharge_score.dart';

/// 退室基準スコア計算機
/// Modified Aldrete (PACU退室) / White-Song (fast-track) / MPADSS (帰宅判定)
/// の3スコアをタブで切り替えて採点する.
/// スコア定義・判定ロジックは lib/domain/calculators/discharge_score.dart に分離.
class DischargeScoreScreen extends StatefulWidget {
  const DischargeScoreScreen({super.key});

  @override
  State<DischargeScoreScreen> createState() => _DischargeScoreScreenState();
}

class _DischargeScoreScreenState extends State<DischargeScoreScreen> {
  static const _accent = Color(0xFF2E7D32);

  /// スケールごとの選択点数 (初期値は全項目2点 = 満点).
  late final List<List<int>> _sel = [
    for (final s in kDischargeScales) List.filled(s.items.length, 2),
  ];

  void _reset() => setState(() {
        for (var i = 0; i < kDischargeScales.length; i++) {
          for (var j = 0; j < _sel[i].length; j++) {
            _sel[i][j] = 2;
          }
        }
      });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: kDischargeScales.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('退室基準スコア'),
          backgroundColor: theme.scaffoldBackgroundColor,
          surfaceTintColor: Colors.transparent,
          actions: [
            IconButton(
              tooltip: 'リセット (全項目2点に戻す)',
              icon: const Icon(Icons.refresh),
              onPressed: _reset,
            ),
          ],
          bottom: TabBar(
            labelColor: _accent,
            indicatorColor: _accent,
            unselectedLabelColor: Colors.black45,
            labelStyle: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.bold),
            tabs: [
              for (final s in kDischargeScales) Tab(text: s.name),
            ],
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: TabBarView(
            children: [
              for (var i = 0; i < kDischargeScales.length; i++)
                _ScaleTab(
                  scale: kDischargeScales[i],
                  selected: _sel[i],
                  accent: _accent,
                  onChanged: (item, points) =>
                      setState(() => _sel[i][item] = points),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScaleTab extends StatelessWidget {
  final DischargeScale scale;
  final List<int> selected;
  final Color accent;
  final void Function(int itemIndex, int points) onChanged;
  const _ScaleTab({
    required this.scale,
    required this.selected,
    required this.accent,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final result = scale.evaluate(selected);

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            children: [
              // ── 運用情報 ──
              Card(
                color: accent.withValues(alpha: 0.05),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      _InfoRow('目的', scale.purpose),
                      _InfoRow('タイミング', scale.timing),
                      _InfoRow('合格ライン', scale.passCriteria),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),

              // ── 評価項目 ──
              for (var i = 0; i < scale.items.length; i++) ...[
                const SizedBox(height: 8),
                _ItemCard(
                  item: scale.items[i],
                  selectedPoints: selected[i],
                  accent: accent,
                  onSelect: (p) => onChanged(i, p),
                ),
              ],
            ],
          ),
        ),

        // ── 合計・判定 ──
        _ResultBar(scale: scale, result: result, accent: accent),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 78,
            child: Text(label,
                style:
                    const TextStyle(fontSize: 11, color: Colors.black45)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final ScoreItem item;
  final int selectedPoints;
  final Color accent;
  final ValueChanged<int> onSelect;
  const _ItemCard({
    required this.item,
    required this.selectedPoints,
    required this.accent,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.name,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (final o in item.options) ...[
              _OptionTile(
                option: o,
                selected: o.points == selectedPoints,
                accent: accent,
                onTap: () => onSelect(o.points),
              ),
              if (o != item.options.last) const SizedBox(height: 6),
            ],
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final ScoreOption option;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;
  const _OptionTile({
    required this.option,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? accent.withValues(alpha: 0.12)
              : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: selected ? accent : Colors.transparent, width: 1.6),
        ),
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? accent : Colors.black12,
                shape: BoxShape.circle,
              ),
              child: Text('${option.points}',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: selected ? Colors.white : Colors.black54)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(option.text,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          selected ? FontWeight.bold : FontWeight.normal,
                      color:
                          selected ? Colors.black87 : Colors.black54)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultBar extends StatelessWidget {
  final DischargeScale scale;
  final DischargeScoreResult result;
  final Color accent;
  const _ResultBar({
    required this.scale,
    required this.result,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final pass = result.pass;
    final fg = pass ? Colors.green.shade700 : Colors.red.shade700;
    final bg = pass ? Colors.green.shade50 : Colors.red.shade50;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: BoxDecoration(
        color: bg,
        border: Border(top: BorderSide(color: fg.withValues(alpha: 0.3))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    const Text('合計',
                        style: TextStyle(
                            fontSize: 12, color: Colors.black54)),
                    const SizedBox(width: 8),
                    Text('${result.total}',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: fg)),
                    Text(' / ${result.maxTotal}',
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black54)),
                  ],
                ),
                Text('合格ライン: ${scale.passCriteria}',
                    style: const TextStyle(
                        fontSize: 10, color: Colors.black45)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: fg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(pass ? '合格' : '不合格',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              if (!pass && result.hasBelowMinItem)
                const Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Text('0点の項目があります',
                      style: TextStyle(
                          fontSize: 10, color: Colors.black54)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
