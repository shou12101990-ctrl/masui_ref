import 'package:flutter/material.dart';

import '../data/abx_matrix.dart';
import '../models/abx_matrix.dart';

/// 抗菌薬をボタン (カード)ではなく一覧表で参照するモード.
/// カバー範囲と臓器移行性を横断的に見比べるための画面.
class AbxMatrixScreen extends StatefulWidget {
  const AbxMatrixScreen({super.key});

  @override
  State<AbxMatrixScreen> createState() => _AbxMatrixScreenState();
}

enum _Panel { coverage, organ, both }

/// 表示する薬剤群. 抗菌薬・抗真菌薬・抗ウイルス薬で列の意味が異なる.
enum _Kind {
  bacteria('抗菌薬'),
  fungus('抗真菌薬'),
  virus('抗ウイルス薬');

  final String label;
  const _Kind(this.label);

  List<AbxMatrixRow> get rows => switch (this) {
    _Kind.bacteria => kAbxMatrix,
    _Kind.fungus => kAntifungalMatrix,
    _Kind.virus => kAntiviralMatrix,
  };

  List<String> get coverageCols => switch (this) {
    _Kind.bacteria => kAbxCoverageCols,
    _Kind.fungus => kAntifungalCoverageCols,
    _Kind.virus => kAntiviralCoverageCols,
  };

  List<String> get organCols => switch (this) {
    _Kind.bacteria => kAbxOrganCols,
    _Kind.fungus => kAntifungalOrganCols,
    _Kind.virus => const [],
  };

  /// カバー範囲の列見出しの説明
  String get coverageLabel => switch (this) {
    _Kind.bacteria => '菌種のカバー範囲',
    _Kind.fungus => '真菌種のカバー範囲',
    _Kind.virus => '対象ウイルス',
  };
}

class _AbxMatrixScreenState extends State<AbxMatrixScreen> {
  String _query = '';
  String? _group;
  _Panel _panel = _Panel.coverage;
  _Kind _kind = _Kind.bacteria;

  static const _accent = Color(0xFF5C8A3A); // 抗菌薬カテゴリと同系の olive

  List<String> get _groups {
    final seen = <String>[];
    for (final r in _kind.rows) {
      if (r.group.isNotEmpty && !seen.contains(r.group)) seen.add(r.group);
    }
    return seen;
  }

  List<AbxMatrixRow> get _rows {
    final q = _query.trim().toLowerCase();
    return _kind.rows.where((r) {
      final okGroup = _group == null || r.group == _group;
      final okQuery = q.isEmpty || r.searchText.contains(q);
      return okGroup && okQuery;
    }).toList();
  }

  List<String> get _cols => switch (_panel) {
    _Panel.coverage => _kind.coverageCols,
    _Panel.organ => _kind.organCols,
    _Panel.both => [..._kind.coverageCols, ..._kind.organCols],
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = _rows;
    return Scaffold(
      appBar: AppBar(
        title: const Text('抗微生物薬 一覧表'),
        backgroundColor: _accent,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(42),
          child: Container(
            color: _accent,
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                for (final k in _Kind.values)
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() {
                        _kind = k;
                        _group = null;
                        if (k == _Kind.virus) _panel = _Panel.coverage;
                      }),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        decoration: BoxDecoration(
                          color: _kind == k
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${k.label} (${k.rows.length})',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _kind == k ? _accent : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // 検索 + 表示切替
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: '一般名・商品名・略号で検索',
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
                // 抗ウイルス薬は臓器移行性の欄が原典に無いため切替を出さない
                if (_kind.organCols.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  SegmentedButton<_Panel>(
                    segments: [
                      ButtonSegment(
                        value: _Panel.coverage,
                        label: Text(
                          _kind == _Kind.fungus ? '真菌種' : 'カバー範囲',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      const ButtonSegment(
                        value: _Panel.organ,
                        label: Text('臓器移行性', style: TextStyle(fontSize: 12)),
                      ),
                      const ButtonSegment(
                        value: _Panel.both,
                        label: Text('両方', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                    selected: {_panel},
                    showSelectedIcon: false,
                    onSelectionChanged: (s) => setState(() => _panel = s.first),
                  ),
                ],
              ],
            ),
          ),
          // 系統フィルタ
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _chip('すべて', _group == null, () => setState(() => _group = null)),
                for (final g in _groups)
                  _chip(g, _group == g, () => setState(() => _group = g)),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // 表本体
          Expanded(
            child: rows.isEmpty
                ? const Center(child: Text('該当する抗菌薬がありません'))
                : _MatrixTable(
                    rows: rows,
                    cols: _cols,
                    accent: _accent,
                    onTap: (r) => _showDetail(context, r),
                  ),
          ),
          // 凡例
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    for (final e in kAbxMarkLegend.entries)
                      Text(
                        '${e.key} ${e.value}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade700,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  switch (_kind) {
                    _Kind.bacteria =>
                      '空欄は原典に記載なし. 行をタップすると用量・補足を表示. '
                          'EKPSCE/SPACE/PEK-HaM などの菌名略号は原典表記のまま. ',
                    _Kind.fungus =>
                      '列は真菌の種類で, 抗菌薬の列とは意味が異なる. '
                          '空欄は原典に記載なし. 行をタップすると用量・補足を表示. ',
                    _Kind.virus =>
                      '対象ウイルスを示す. 原典に菌種カバー表・臓器移行性の記載は無い. '
                          '行をタップすると用量・補足を表示. ',
                  },
                  style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? _accent.withValues(alpha: 0.14) : Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: selected ? _accent : Colors.grey.shade300,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: selected ? _accent : Colors.black87,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, AbxMatrixRow r) {
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
            if (r.brand.isNotEmpty || r.abbr.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  [
                    if (r.brand.isNotEmpty) r.brand,
                    if (r.abbr.isNotEmpty) r.abbr,
                  ].join('  /  '),
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ),
            const SizedBox(height: 10),
            _kv('系統', r.group),
            if (r.dose.isNotEmpty) _kv('標準的な用量', r.dose),
            if (r.effect.isNotEmpty) _kv('位置づけ', r.effect),
            if (r.coverage.isNotEmpty)
              _kv(
                'カバー範囲',
                r.coverage.entries.map((e) => '${e.key} ${e.value}').join(' / '),
              ),
            if (r.organ.isNotEmpty)
              _kv(
                '臓器移行性',
                r.organ.entries.map((e) => '${e.key} ${e.value}').join(' / '),
              ),
            if (r.note.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Text(
                '補足',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(r.note, style: const TextStyle(fontSize: 13, height: 1.6)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _kv(String k, String v) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 78,
          child: Text(
            k,
            style: TextStyle(
              fontSize: 12.5,
              color: _accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(v, style: const TextStyle(fontSize: 13, height: 1.5)),
        ),
      ],
    ),
  );
}

/// 薬剤名列を固定し, 判定列を横スクロールさせる2ペイン構成の表.
class _MatrixTable extends StatefulWidget {
  final List<AbxMatrixRow> rows;
  final List<String> cols;
  final Color accent;
  final void Function(AbxMatrixRow) onTap;
  const _MatrixTable({
    required this.rows,
    required this.cols,
    required this.accent,
    required this.onTap,
  });

  @override
  State<_MatrixTable> createState() => _MatrixTableState();
}

class _MatrixTableState extends State<_MatrixTable> {
  final _vLeft = ScrollController();
  final _vRight = ScrollController();
  bool _syncing = false;

  static const _rowH = 42.0;
  static const _headH = 34.0;
  static const _nameW = 128.0;
  static const _cellW = 62.0;

  @override
  void initState() {
    super.initState();
    // 左右の縦スクロールを同期する
    _vLeft.addListener(() => _sync(_vLeft, _vRight));
    _vRight.addListener(() => _sync(_vRight, _vLeft));
  }

  void _sync(ScrollController from, ScrollController to) {
    if (_syncing || !to.hasClients || !from.hasClients) return;
    if ((to.offset - from.offset).abs() < 0.5) return;
    _syncing = true;
    to.jumpTo(from.offset.clamp(0.0, to.position.maxScrollExtent));
    _syncing = false;
  }

  @override
  void dispose() {
    _vLeft.dispose();
    _vRight.dispose();
    super.dispose();
  }

  Color _cellColor(String v) {
    if (v.startsWith('●')) return const Color(0xFFDCEDC8); // 効く: green
    if (v.startsWith('✕') || v.startsWith('×')) {
      return const Color(0xFFFFEBEE); // 効かない: red
    }
    if (v.startsWith('▲') || v.startsWith('△')) {
      return const Color(0xFFFFF8E1); // 条件付き: amber
    }
    if (v.isNotEmpty) return const Color(0xFFE3F2FD); // 菌名などの注記: blue
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final rows = widget.rows;
    return Row(
      children: [
        // 固定列 (薬剤名)
        SizedBox(
          width: _nameW,
          child: Column(
            children: [
              Container(
                height: _headH,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: widget.accent.withValues(alpha: 0.12),
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                    right: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Text(
                  '薬剤',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: widget.accent,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _vLeft,
                  itemCount: rows.length,
                  itemExtent: _rowH,
                  itemBuilder: (_, i) {
                    final r = rows[i];
                    return InkWell(
                      onTap: () => widget.onTap(r),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: i.isEven ? Colors.white : const Color(0xFFFAFAFA),
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade200),
                            right: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r.generic,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (r.abbr.isNotEmpty)
                              Text(
                                r.abbr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 9.5,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // 判定列 (横スクロール)
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: _cellW * widget.cols.length,
              child: Column(
                children: [
                  // ヘッダ
                  Container(
                    height: _headH,
                    decoration: BoxDecoration(
                      color: widget.accent.withValues(alpha: 0.12),
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      children: [
                        for (final c in widget.cols)
                          SizedBox(
                            width: _cellW,
                            child: Center(
                              child: Text(
                                c,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  color: widget.accent,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _vRight,
                      itemCount: rows.length,
                      itemExtent: _rowH,
                      itemBuilder: (_, i) {
                        final r = rows[i];
                        return InkWell(
                          onTap: () => widget.onTap(r),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade200),
                              ),
                            ),
                            child: Row(
                              children: [
                                for (final c in widget.cols)
                                  _cell(r, c),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _cell(AbxMatrixRow r, String col) {
    final v = r.coverage[col] ?? r.organ[col] ?? '';
    // 記号1文字なら大きく, 菌名などの注記なら小さく折り返して出す
    final isMark = v.length <= 1;
    return Container(
      width: _cellW,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: _cellColor(v),
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Text(
        v,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: isMark ? 15 : 9,
          height: isMark ? 1.0 : 1.15,
          fontWeight: isMark ? FontWeight.bold : FontWeight.w600,
          color: v.startsWith('✕') || v.startsWith('×')
              ? Colors.red.shade400
              : Colors.black87,
        ),
      ),
    );
  }
}
