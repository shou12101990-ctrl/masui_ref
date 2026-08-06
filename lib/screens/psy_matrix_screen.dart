import 'package:flutter/material.dart';

import '../data/psy_matrix.dart';
import '../models/psy_matrix.dart';

/// 向精神薬を上位分類 (定型/非定型, 受容体プロファイル)で俯瞰する画面.
/// 「分類」タブと,「疾患・症状との対応表」タブの2構成.
class PsyMatrixScreen extends StatefulWidget {
  /// 薬剤マトリクスのタブとして埋め込むとき true.
  /// AppBarはハブ側が出すので, 分類/疾患・症状の切替を本文の先頭に出す.
  final bool embedded;
  const PsyMatrixScreen({super.key, this.embedded = false});

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
      appBar: widget.embedded
          ? null
          : AppBar(
              title: const Text('向精神薬 分類・対応表'),
              backgroundColor: _accent,
              foregroundColor: Colors.white,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(42),
                child: Container(
                  color: _accent,
                  padding: const EdgeInsets.only(bottom: 6),
                  child: _tabRow(),
                ),
              ),
            ),
      body: Column(
        children: [
          // 埋め込み時はハブのAppBar直下に切替を出す
          if (widget.embedded)
            Container(
              color: _accent,
              padding: const EdgeInsets.fromLTRB(0, 2, 0, 8),
              child: _tabRow(),
            ),
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

  /// 分類 / 疾患・症状 の切替. AppBar下・本文先頭のどちらにも置ける.
  Widget _tabRow() => Row(
    children: [
      _tabBtn('分類 (${kPsyClassMatrix.length})', _Tab.classes),
      _tabBtn('疾患・症状 (${kPsyIndications.length})', _Tab.indications),
    ],
  );

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

/// 上位分類が連続する区間 (帯を1回だけ描くために使う).
class _PsyGroupSpan {
  final String label;
  final int start;
  int count;
  _PsyGroupSpan(this.label, this.start) : count = 1;
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

  static const _rowH = 26.0;
  static const _headH = 28.0;
  static const _nameW = 134.0; // 上位分類の帯を含む固定列の幅
  static const _groupW = 22.0; // 左端の上位分類 (90度回転, 最大2行)の帯
  static const _fsBandMin = 4.5;

  // 表内フォント (従来より2pt小さい)
  static const _fsName = 9.5;
  static const _fsBand = 7.5;
  static const _fsHead = 7.5;
  static const _fsMark = 13.0;

  /// 列見出しのスタイル. 実測 (_cellWidth)と描画で必ず同じものを使う.
  /// letterSpacing を明示しないと Material の bodyMedium (0.25)が乗り, 実測が過小になる.
  static const _headStyle = TextStyle(
    fontSize: _fsHead,
    height: 1.1,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
  );

  /// 判定列の幅. 列見出しを1行で描いたときの最大幅に合わせて全列で統一する.
  double _cellWidth(List<String> cols) {
    var w = 24.0;
    for (final c in cols) {
      final tp = TextPainter(
        text: TextSpan(text: c, style: _headStyle),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();
      if (tp.width > w) w = tp.width;
    }
    // セル内寸で padding 左右2px + 右罫線1px を使う分と丸め誤差の余裕
    return w + 7;
  }

  /// 帯に収まるフォントサイズ. 区間の高さ (回転後の走査長)に対して
  /// 2行まで使って収まる最大サイズを探し, 省略記号を出さずに収める.
  static final _bandFontCache = <String, double>{};

  static TextStyle _bandStyle(double fs) => TextStyle(
    fontSize: fs,
    height: 1.05,
    letterSpacing: 0,
    fontWeight: FontWeight.bold,
  );

  static double _bandFontSize(String label, double avail, double bandInner) {
    final key = '$label|${avail.toStringAsFixed(1)}';
    final cached = _bandFontCache[key];
    if (cached != null) return cached;
    var result = _fsBandMin;
    for (var fs = _fsBand; fs >= _fsBandMin; fs -= 0.25) {
      final tp = TextPainter(
        text: TextSpan(text: label, style: _bandStyle(fs)),
        maxLines: 3,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: avail);
      if (!tp.didExceedMaxLines && tp.height <= bandInner) {
        result = fs;
        break;
      }
    }
    _bandFontCache[key] = result;
    return result;
  }

  /// 縦帯に出す分類名. 帯は区間の高さぶんしか長さが無いので,
  /// 括弧付きのラベルは短い方 (英字略号か括弧前)に畳む.
  static String _bandLabel(String s) {
    final m = RegExp(r'^(.*?)\s*\(([^)]*)\)').firstMatch(s);
    if (m == null) return s;
    final head = m.group(1)!.trim();
    final inner = m.group(2)!.trim();
    if (head.isEmpty) return inner;
    final isAbbr = RegExp(r'^[A-Za-z0-9\-/. ]+$').hasMatch(inner);
    if (isAbbr && inner.length < head.length) return inner;
    return head;
  }

  /// 上位分類 (classLabel)が連続する区間.
  List<_PsyGroupSpan> _spans() {
    final res = <_PsyGroupSpan>[];
    for (var i = 0; i < widget.rows.length; i++) {
      final g = widget.rows[i].classLabel;
      if (res.isNotEmpty && res.last.label == g) {
        res.last.count++;
      } else {
        res.add(_PsyGroupSpan(g, i));
      }
    }
    return res;
  }

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
    if (v.startsWith('◎')) return const Color(0xFFC8E6C9);
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
    final spans = _spans();
    final cellW = _cellWidth(cols);
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
                      padding: const EdgeInsets.only(left: 6),
                      decoration: BoxDecoration(
                        color: widget.accent.withValues(alpha: 0.12),
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                          right: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Text(
                        '分類 / 薬剤',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: widget.accent,
                        ),
                      ),
                    ),
                    Expanded(
                      // 分類が続く区間ごとに帯を1回だけ描く
                      child: ListView.builder(
                        controller: _vLeft,
                        itemCount: spans.length,
                        itemBuilder: (_, si) {
                          final s = spans[si];
                          return SizedBox(
                            height: _rowH * s.count,
                            child: Row(
                              children: [
                                _groupBand(s, si),
                                Expanded(
                                  child: Column(
                                    children: [
                                      for (var k = 0; k < s.count; k++)
                                        _nameRow(s.start + k),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: cellW * cols.length,
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
                                  width: cellW,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 1,
                                      ),
                                      child: Text(
                                        c,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: _headStyle.copyWith(
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
                                        width: cellW,
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
                                            fontSize: _fsMark,
                                            height: 1.0,
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

  /// 左端の上位分類. 横書きを90度回転 (左が文字の上側)して縦帯にする.
  /// 区間の高さに収まるまで字を small にして, 省略記号を出さずに納める.
  Widget _groupBand(_PsyGroupSpan s, int si) {
    final label = _bandLabel(s.label);
    // 回転後の走査長 = 区間の高さ − 下罫線1px − 左右padding 4px
    final avail = _rowH * s.count - 5;
    final fs = _bandFontSize(label, avail, _groupW - 1);
    return Container(
      width: _groupW,
      decoration: BoxDecoration(
        color: widget.accent.withValues(alpha: si.isEven ? 0.13 : 0.06),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
          right: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: RotatedBox(
        quarterTurns: 3,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              label,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: _bandStyle(fs).copyWith(color: widget.accent),
            ),
          ),
        ),
      ),
    );
  }

  /// 薬剤名の1行. 1剤しかない分類では帯に数文字しか入らないため,
  /// 分類 (短縮形)を行内にも併記して表から読み取れるようにする.
  Widget _nameRow(int i) {
    final r = widget.rows[i];
    final band = _bandLabel(r.classLabel);
    return InkWell(
      onTap: () => _detail(r),
      child: Container(
        height: _rowH,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: i.isEven ? Colors.white : const Color(0xFFFAFAFA),
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
            right: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Row(
          children: [
            Flexible(
              flex: 5,
              child: Text(
                r.generic,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: _fsName,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (band.isNotEmpty)
              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: Text(
                    band,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: _fsBand,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
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
