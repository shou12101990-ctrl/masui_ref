import 'package:flutter/material.dart';

import '../data/psy_matrix.dart';
import '../models/psy_matrix.dart';

/// 向精神薬を上位分類 (定型/非定型, 受容体プロファイル)で俯瞰する画面.
/// 「分類」タブと,「疾患・症状との対応表」タブの2構成.
class PsyMatrixScreen extends StatefulWidget {
  const PsyMatrixScreen({super.key});

  @override
  State<PsyMatrixScreen> createState() => _PsyMatrixScreenState();
}

enum _Tab { classes, indications }

class _PsyMatrixScreenState extends State<PsyMatrixScreen> {
  static const _accent = Color(0xFFD2691E); // 向精神薬 (salmon系)より濃い橙

  _Tab _tab = _Tab.classes;
  String _query = '';
  String? _section;

  List<String> get _sections {
    final seen = <String>[];
    for (final r in kPsyClassMatrix) {
      if (r.section.isNotEmpty && !seen.contains(r.section)) seen.add(r.section);
    }
    return seen;
  }

  List<PsyClassRow> get _classRows {
    final q = _query.trim().toLowerCase();
    return kPsyClassMatrix.where((r) {
      final okSec = _section == null || r.section == _section;
      final okQ = q.isEmpty || r.searchText.contains(q);
      return okSec && okQ;
    }).toList();
  }

  List<PsyIndicationRow> get _indRows {
    final q = _query.trim().toLowerCase();
    return kPsyIndications
        .where((r) => q.isEmpty || r.searchText.contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('向精神薬 分類・対応表'),
        backgroundColor: _accent,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(42),
          child: Container(
            color: _accent,
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                _tabBtn('分類 (${kPsyClassMatrix.length})', _Tab.classes),
                _tabBtn('疾患・症状 (${kPsyIndications.length})', _Tab.indications),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: '一般名・商品名・分類で検索',
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
          if (_tab == _Tab.classes) ...[
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _chip('すべて', _section == null,
                      () => setState(() => _section = null)),
                  for (final s in _sections)
                    _chip(s, _section == s, () => setState(() => _section = s)),
                ],
              ),
            ),
            const SizedBox(height: 6),
          ],
          Expanded(
            child: _tab == _Tab.classes
                ? _ClassList(rows: _classRows, accent: _accent)
                : _IndicationTable(rows: _indRows, accent: _accent),
          ),
        ],
      ),
    );
  }

  Widget _tabBtn(String label, _Tab t) => Expanded(
    child: InkWell(
      onTap: () => setState(() {
        _tab = t;
        _section = null;
      }),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          color: _tab == t ? Colors.white : Colors.white.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: _tab == t ? _accent : Colors.white,
          ),
        ),
      ),
    ),
  );

  Widget _chip(String label, bool selected, VoidCallback onTap) => Padding(
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

/// 分類タブ. 上位分類ごとにグループ化して並べる.
class _ClassList extends StatelessWidget {
  final List<PsyClassRow> rows;
  final Color accent;
  const _ClassList({required this.rows, required this.accent});

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const Center(child: Text('該当する薬剤がありません'));
    // section > subclass > profile の順にグループ化
    final groups = <String, List<PsyClassRow>>{};
    for (final r in rows) {
      final key = [
        r.section,
        if (r.subclass.isNotEmpty) r.subclass,
        if (r.profile.isNotEmpty) r.profile,
      ].join(' / ');
      groups.putIfAbsent(key, () => []).add(r);
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
      children: [
        for (final e in groups.entries) ...[
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 6),
            child: Row(
              children: [
                Container(width: 4, height: 16, color: accent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    e.key,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: accent,
                    ),
                  ),
                ),
                Text(
                  '${e.value.length}剤',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          // 受容体プロファイルの説明 (該当があれば)
          if (_legendFor(e.key) != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _legendFor(e.key)!,
                style: const TextStyle(fontSize: 11.5, height: 1.5),
              ),
            ),
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < e.value.length; i++) ...[
                  if (i > 0) const Divider(height: 1),
                  _row(context, e.value[i]),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  String? _legendFor(String key) {
    for (final k in kPsyProfileLegend.keys) {
      if (key.endsWith(k)) return '$k: ${kPsyProfileLegend[k]}';
    }
    return null;
  }

  Widget _row(BuildContext context, PsyClassRow r) => InkWell(
    onTap: r.note.isEmpty && r.effect.isEmpty
        ? null
        : () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (_) => DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.5,
              maxChildSize: 0.9,
              builder: (_, c) => ListView(
                controller: c,
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
                children: [
                  Text(
                    r.generic,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (r.brand.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        r.brand,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  if (r.effect.isNotEmpty)
                    Text(
                      r.effect,
                      style: const TextStyle(fontSize: 13, height: 1.6),
                    ),
                  if (r.note.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      r.note,
                      style: const TextStyle(fontSize: 13, height: 1.7),
                    ),
                  ],
                ],
              ),
            ),
          ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        r.generic,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (r.abbr.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          r.abbr,
                          style: TextStyle(
                            fontSize: 10.5,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                  ],
                ),
                if (r.brand.isNotEmpty)
                  Text(
                    r.brand,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.grey.shade700,
                    ),
                  ),
                if (r.spec.isNotEmpty)
                  Text(
                    r.spec,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Colors.grey.shade500,
                    ),
                  ),
              ],
            ),
          ),
          if (r.note.isNotEmpty || r.effect.isNotEmpty)
            Icon(Icons.chevron_right, size: 18, color: Colors.grey.shade400),
        ],
      ),
    ),
  );
}

/// 疾患・症状との対応表タブ.
class _IndicationTable extends StatefulWidget {
  final List<PsyIndicationRow> rows;
  final Color accent;
  const _IndicationTable({required this.rows, required this.accent});

  @override
  State<_IndicationTable> createState() => _IndicationTableState();
}

class _IndicationTableState extends State<_IndicationTable> {
  final _vLeft = ScrollController();
  final _vRight = ScrollController();
  bool _syncing = false;

  static const _rowH = 44.0;
  static const _headH = 46.0;
  static const _nameW = 118.0;
  static const _cellW = 58.0;

  @override
  void initState() {
    super.initState();
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
    if (v.startsWith('●')) return const Color(0xFFC8E6C9);
    if (v.startsWith('○')) return const Color(0xFFE8F5E9);
    if (v.startsWith('△')) return const Color(0xFFFFF8E1);
    if (v.startsWith('✕') || v.startsWith('×')) return const Color(0xFFFFEBEE);
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final rows = widget.rows;
    if (rows.isEmpty) {
      return const Center(child: Text('対応表のデータがありません'));
    }
    final cols = kPsyIndicationCols;
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
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
                        itemBuilder: (_, i) => InkWell(
                          onTap: () => _detail(rows[i]),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: i.isEven
                                  ? Colors.white
                                  : const Color(0xFFFAFAFA),
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
                                  rows[i].generic,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (rows[i].classLabel.isNotEmpty)
                                  Text(
                                    rows[i].classLabel,
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: _cellW * cols.length,
                    child: Column(
                      children: [
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
                              for (final c in cols)
                                SizedBox(
                                  width: _cellW,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 2,
                                      ),
                                      child: Text(
                                        c,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 9.5,
                                          height: 1.2,
                                          fontWeight: FontWeight.bold,
                                          color: widget.accent,
                                        ),
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
                            itemBuilder: (_, i) => InkWell(
                              onTap: () => _detail(rows[i]),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    for (final c in cols)
                                      Container(
                                        width: _cellW,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: _cellColor(
                                            rows[i].indications[c] ?? '',
                                          ),
                                          border: Border(
                                            right: BorderSide(
                                              color: Colors.grey.shade200,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          rows[i].indications[c] ?? '',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
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
            ],
          ),
        ),
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 12,
                children: [
                  for (final e in kPsyMarkLegend.entries)
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
                '行をタップすると周術期・ICUでの注意を表示. 空欄は該当なし. ',
                style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _detail(PsyIndicationRow r) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              r.generic,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (r.brand.isNotEmpty || r.classLabel.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  [
                    if (r.brand.isNotEmpty) r.brand,
                    if (r.classLabel.isNotEmpty) r.classLabel,
                  ].join('  /  '),
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ),
            const SizedBox(height: 12),
            Text(
              r.indications.entries
                  .where((e) => e.value.isNotEmpty)
                  .map((e) => '${e.value} ${e.key}')
                  .join('   '),
              style: const TextStyle(fontSize: 13, height: 1.7),
            ),
            if (r.cautions.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                '周術期・ICUでの注意',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                r.cautions,
                style: const TextStyle(fontSize: 13, height: 1.6),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
