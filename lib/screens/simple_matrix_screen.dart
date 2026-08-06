import 'package:flutter/material.dart';

import '../models/simple_matrix.dart';
import '../widgets/simple_matrix_table.dart';

/// マトリクス1面ぶんの定義. 1画面に複数面 (便秘薬 / 整腸剤 など)を持てる.
class SimpleMatrixKind {
  final String label;
  final List<SimpleMatrixRow> rows;
  final List<String> cols;
  final Map<String, Color> colColors;
  final List<(String, Color)> legendGroups;

  /// 表の下に出す読み方の説明
  final String caption;

  /// 系統フィルタ (チップ)を出すか
  final bool showGroupChips;

  const SimpleMatrixKind({
    required this.label,
    required this.rows,
    required this.cols,
    required this.colColors,
    required this.legendGroups,
    required this.caption,
    this.showGroupChips = true,
  });
}

/// 利尿薬 / 便秘薬・整腸剤 のマトリクス画面.
/// 抗菌薬・向精神薬の表と同じ操作感になるよう, 検索 + 系統チップ + 表 + 凡例の構成を揃えている.
class SimpleMatrixScreen extends StatefulWidget {
  final String title;
  final Color accent;
  final List<SimpleMatrixKind> kinds;
  final String searchHint;

  /// 薬剤マトリクスのタブとして埋め込むとき true. AppBarはハブ側が出す.
  final bool embedded;

  const SimpleMatrixScreen({
    super.key,
    required this.title,
    required this.accent,
    required this.kinds,
    this.searchHint = '一般名・商品名・分類で検索',
    this.embedded = false,
  });

  @override
  State<SimpleMatrixScreen> createState() => _SimpleMatrixScreenState();
}

class _SimpleMatrixScreenState extends State<SimpleMatrixScreen> {
  int _kindIndex = 0;
  String _query = '';
  String? _group;

  SimpleMatrixKind get _kind => widget.kinds[_kindIndex];

  List<String> get _groups {
    final seen = <String>[];
    for (final r in _kind.rows) {
      if (r.group.isNotEmpty && !seen.contains(r.group)) seen.add(r.group);
    }
    return seen;
  }

  List<SimpleMatrixRow> get _rows {
    final q = _query.trim().toLowerCase();
    return _kind.rows.where((r) {
      final okGroup = _group == null || r.group == _group;
      final okQuery = q.isEmpty || r.searchText.contains(q);
      return okGroup && okQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final rows = _rows;
    final multi = widget.kinds.length > 1;
    return Scaffold(
      appBar: widget.embedded
          ? null
          : AppBar(
              title: Text(widget.title),
              backgroundColor: widget.accent,
              foregroundColor: Colors.white,
              bottom: multi
                  ? PreferredSize(
                      preferredSize: const Size.fromHeight(42),
                      child: Container(
                        color: widget.accent,
                        padding: const EdgeInsets.only(bottom: 6),
                        child: _kindRow(),
                      ),
                    )
                  : null,
            ),
      body: Column(
        children: [
          if (widget.embedded && multi)
            Container(
              color: widget.accent,
              padding: const EdgeInsets.fromLTRB(0, 2, 0, 8),
              child: _kindRow(),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: TextField(
              decoration: InputDecoration(
                hintText: widget.searchHint,
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          if (_kind.showGroupChips)
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _chip('すべて', _group == null,
                      () => setState(() => _group = null)),
                  for (final g in _groups)
                    _chip(g, _group == g, () => setState(() => _group = g)),
                ],
              ),
            ),
          const SizedBox(height: 6),
          Expanded(
            child: rows.isEmpty
                ? const Center(child: Text('該当する薬剤がありません'))
                : SimpleMatrixTable(
                    rows: rows,
                    cols: _kind.cols,
                    colColors: _kind.colColors,
                    accent: widget.accent,
                    onTap: (r) => _showDetail(context, r),
                  ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 4,
                  children: [
                    for (final e in kSimpleMarkLegend.entries)
                      Text(
                        '${e.key} ${e.value}',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Colors.grey.shade700,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final e in _kind.legendGroups) _swatch(e.$1, e.$2),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  _kind.caption,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _kindRow() => Row(
    children: [
      for (var i = 0; i < widget.kinds.length; i++)
        Expanded(
          child: InkWell(
            onTap: () => setState(() {
              _kindIndex = i;
              _group = null;
            }),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 7),
              decoration: BoxDecoration(
                color: _kindIndex == i
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${widget.kinds[i].label} (${widget.kinds[i].rows.length})',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _kindIndex == i ? widget.accent : Colors.white,
                ),
              ),
            ),
          ),
        ),
    ],
  );

  Widget _swatch(String label, Color c) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 11,
        height: 11,
        decoration: BoxDecoration(
          color: c.withValues(alpha: 0.30),
          border: Border.all(color: c, width: 1),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 4),
      Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade800)),
    ],
  );

  Widget _chip(String label, bool selected, VoidCallback onTap) => Padding(
    padding: const EdgeInsets.only(right: 6),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? widget.accent.withValues(alpha: 0.14) : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selected ? widget.accent : Colors.grey.shade300,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: selected ? widget.accent : Colors.black87,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    ),
  );

  void _showDetail(BuildContext context, SimpleMatrixRow r) {
    // 表では記号しか見えないので, 該当した列を詳細で言葉にして出す
    final hit = [
      for (final c in _kind.cols)
        if ((r.marks[c] ?? '').isNotEmpty) '$c: ${r.marks[c]}',
    ];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.55,
        maxChildSize: 0.9,
        builder: (_, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
          children: [
            Text(
              r.generic,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (r.brand.isNotEmpty || r.spec.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  [
                    if (r.brand.isNotEmpty) r.brand,
                    if (r.spec.isNotEmpty) r.spec,
                  ].join('  /  '),
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                r.group,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: widget.accent,
                ),
              ),
            ),
            const SizedBox(height: 14),
            if (r.dose.isNotEmpty) _section('用法・用量', r.dose),
            if (r.doseLimit.isNotEmpty)
              _section('上限量・投与間隔', r.doseLimit, color: const Color(0xFFE65100)),
            if (r.mechanism.isNotEmpty) _section('作用機序', r.mechanism),
            if (r.effect.isNotEmpty) _section('位置づけ', r.effect),
            if (hit.isNotEmpty) _section('表の判定', hit.join('\n')),
            if (r.note.isNotEmpty) _section('補足', r.note),
          ],
        ),
      ),
    );
  }

  Widget _section(String heading, String body, {Color? color}) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color ?? widget.accent,
          ),
        ),
        const SizedBox(height: 3),
        Text(body, style: const TextStyle(fontSize: 13, height: 1.5)),
      ],
    ),
  );
}
