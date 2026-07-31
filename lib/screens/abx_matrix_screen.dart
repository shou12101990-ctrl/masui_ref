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

  /// 常にカバー範囲と臓器移行性の両方を並べる
  List<String> get _cols => [..._kind.coverageCols, ..._kind.organCols];

  @override
  Widget build(BuildContext context) {
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
                    organCols: _kind.organCols.toSet(),
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
                // 記号の意味
                Wrap(
                  spacing: 10,
                  runSpacing: 4,
                  children: [
                    for (final e in kAbxMarkLegend.entries)
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
                // 色の意味 (病原体の種類 / 臓器移行性)
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final e in _legendGroups) _swatch(e.$1, e.$2),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  switch (_kind) {
                    _Kind.bacteria =>
                      '色は病原体の種類, 濃さは判定の強さ (○ 濃い / ▲△ 淡い). ✕は灰色. '
                          '空欄は原典に記載なし. 行をタップで用量・補足. ',
                    _Kind.fungus =>
                      '列は真菌の種類で抗菌薬の列とは意味が異なる. '
                          '色は真菌の種類, 濃さは判定の強さ. 行をタップで用量・補足. ',
                    _Kind.virus =>
                      '対象ウイルスを示す. 原典に菌種カバー表・臓器移行性の記載は無い. '
                          '行をタップで用量・補足. ',
                  },
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 凡例に出す「色 → 何を表すか」の対応
  List<(String, Color)> get _legendGroups => switch (_kind) {
    _Kind.bacteria => const [
      ('GPC (MRSA/腸球菌/Strep/MSSA)', Color(0xFF7E57C2)),
      ('GNR (EKPSCE/緑膿菌)', Color(0xFF43A047)),
      ('嫌気性菌', Color(0xFFBF5B04)),
      ('非定型', Color(0xFF3949AB)),
      ('臓器移行性', Color(0xFF01579B)),
    ],
    _Kind.fungus => const [
      ('酵母 (カンジダ/クリプトコックス)', Color(0xFFD81B60)),
      ('糸状菌・接合菌', Color(0xFFEF6C00)),
      ('PCP・地域流行真菌', Color(0xFF00897B)),
      ('臓器移行性', Color(0xFF01579B)),
    ],
    _Kind.virus => const [('対象ウイルス', Color(0xFF5E35B1))],
  };

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
            // 表のセルに入りきらない注記付きセルは, ここで全文を出す
            if (_cellNotes(r).isNotEmpty) ...[
              const SizedBox(height: 10),
              const Text(
                'セルの注記',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              for (final n in _cellNotes(r))
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    n,
                    style: const TextStyle(fontSize: 12.5, height: 1.5),
                  ),
                ),
            ],
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

  /// 記号1文字に収まらないセル (菌名・条件などの注記)を全文で拾い出す.
  List<String> _cellNotes(AbxMatrixRow r) => [
    for (final e in r.coverage.entries)
      if (e.value.trim().length > 1) '${e.key}: ${e.value}',
    for (final e in r.organ.entries)
      if (e.value.trim().length > 1) '${e.key}: ${e.value}',
  ];

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

/// 上位分類が連続する区間 (帯を1回だけ描くために使う).
class _GroupSpan {
  final String label;
  final int start;
  int count;
  _GroupSpan(this.label, this.start) : count = 1;
}

/// 薬剤名列を固定し, 判定列を横スクロールさせる2ペイン構成の表.
class _MatrixTable extends StatefulWidget {
  final List<AbxMatrixRow> rows;
  final List<String> cols;

  /// 臓器移行性の列名. カバー範囲の列と塗り分けるために使う.
  final Set<String> organCols;
  final Color accent;
  final void Function(AbxMatrixRow) onTap;
  const _MatrixTable({
    required this.rows,
    required this.cols,
    required this.organCols,
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

  static const _rowH = 26.0;
  static const _headH = 26.0;
  static const _nameW = 134.0; // 上位分類の帯を含む固定列の幅
  static const _groupW = 16.0; // 左端の上位分類 (90度回転)の帯

  // 表内フォント (従来より2pt小さい)
  static const _fsName = 9.5;
  static const _fsAbbr = 7.5;
  static const _fsHead = 7.5;
  static const _fsMark = 13.0;
  static const _fsNote = 7.0;

  /// 列見出しのスタイル. 実測 (_cellWidth)と描画で必ず同じものを使う.
  /// letterSpacing を明示しないと Material の bodyMedium (0.25)が乗り,
  /// 実測が文字数×0.25px だけ過小になって最長列が必ず省略される.
  static const _headStyle = TextStyle(
    fontSize: _fsHead,
    height: 1.1,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
  );

  /// 判定列の幅. カバー範囲・臓器移行性で幅を揃えるため,
  /// 列見出しを1行で描いたときの最大幅に合わせる (タイトニングした統一幅).
  double _cellWidth() {
    var w = 24.0; // 記号1文字が入る最小幅
    for (final c in widget.cols) {
      final tp = TextPainter(
        text: TextSpan(text: c, style: _headStyle),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();
      if (tp.width > w) w = tp.width;
    }
    // セル内寸で padding 左右2px + 右罫線1px を使うので, その分と丸め誤差の余裕を足す
    return w + 7;
  }

  /// 縦帯に出す分類名. 帯は区間の高さぶんしか長さが無いので,
  /// 括弧付きのラベルは短い方 (英字略号か括弧前)に畳む.
  static String _bandLabel(String s) {
    final m = RegExp(r'^(.*?)\s*\(([^)]*)\)').firstMatch(s);
    if (m == null) return s;
    final head = m.group(1)!.trim();
    final inner = m.group(2)!.trim();
    if (head.isEmpty) return inner;
    // 括弧内が英数字だけの略号 (DORA 等)で, 括弧前より短いならそちらを使う
    final isAbbr = RegExp(r'^[A-Za-z0-9\-/. ]+$').hasMatch(inner);
    if (isAbbr && inner.length < head.length) return inner;
    return head;
  }

  /// 上位分類 (group)が連続する区間. 帯をまとめて1回だけ描くために使う.
  List<_GroupSpan> _spans() {
    final res = <_GroupSpan>[];
    for (var i = 0; i < widget.rows.length; i++) {
      final g = widget.rows[i].group;
      if (res.isNotEmpty && res.last.label == g) {
        res.last.count++;
      } else {
        res.add(_GroupSpan(g, i));
      }
    }
    return res;
  }

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

  /// 病原体の種類ごとの基準色. 列 (菌種/真菌種/ウイルス)によって塗り分ける.
  /// 同じ「○」でも, どの病原体をカバーしているのかが色で分かるようにする.
  static const _colColor = <String, Color>{
    // グラム陽性球菌 (GPC) : 紫系
    'MRSA': Color(0xFF7E57C2),
    '腸球菌': Color(0xFF7E57C2),
    'Strep': Color(0xFF7E57C2),
    'MSSA': Color(0xFF7E57C2),
    // グラム陰性桿菌 (GNR) : 緑系
    'EKPSCE': Color(0xFF43A047),
    '緑膿菌': Color(0xFF43A047),
    // 嫌気性菌 : 赤茶系
    '嫌気': Color(0xFFBF5B04),
    // 非定型 : 藍系
    '非定型': Color(0xFF3949AB),
    // 真菌 (酵母) : ピンク系
    'カンジダ': Color(0xFFD81B60),
    'クリプトコックス': Color(0xFFD81B60),
    // 真菌 (糸状菌・接合菌) : オレンジ系
    '接合菌': Color(0xFFEF6C00),
    'アスペルギルス': Color(0xFFEF6C00),
    'フサリウム/スケドスポリウム': Color(0xFFEF6C00),
    // PCP・地域流行真菌 : 青緑系
    'PCP': Color(0xFF00897B),
    '地域流行真菌': Color(0xFF00897B),
    // ウイルス
    '対象ウイルス': Color(0xFF5E35B1),
  };

  /// 臓器移行性の色 (暗い水色)
  static const _organColor = Color(0xFF01579B);

  Color _baseColorFor(String col) =>
      widget.organCols.contains(col) ? _organColor : (_colColor[col] ?? widget.accent);

  /// セルの背景色. 判定の強さで濃度を変え, 色相で病原体の種類を示す.
  Color _cellColor(String v, String col) {
    if (v.isEmpty) return Colors.transparent;
    final base = _baseColorFor(col);
    if (v.startsWith('✕') || v.startsWith('×')) {
      // カバーしない: 灰色で沈める (色相を持たせない)
      return const Color(0xFFF2F2F2);
    }
    if (v.startsWith('○')) return base.withValues(alpha: 0.30);
    if (v.startsWith('▲') || v.startsWith('△')) {
      return base.withValues(alpha: 0.13);
    }
    // 菌名などの注記 (PEK, SPACE など)
    return base.withValues(alpha: 0.10);
  }

  @override
  Widget build(BuildContext context) {
    final rows = widget.rows;
    final spans = _spans();
    final cellW = _cellWidth();
    return Row(
      children: [
        // 固定列 (上位分類の帯 + 薬剤名)
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
        // 判定列 (横スクロール)
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: cellW * widget.cols.length,
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
                          Container(
                            width: cellW,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              color: _baseColorFor(c).withValues(alpha: 0.16),
                              border: Border(
                                right: BorderSide(color: Colors.white, width: 1),
                              ),
                            ),
                            child: Text(
                              c,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: _headStyle.copyWith(
                                color: _baseColorFor(c),
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
                                  _cell(r, c, cellW),
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

  /// 左端の上位分類. 横書きを90度回転 (左が文字の上側)して縦帯にする.
  Widget _groupBand(_GroupSpan s, int si) => Container(
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
            _bandLabel(s.label),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: _fsAbbr,
              letterSpacing: 0,
              fontWeight: FontWeight.bold,
              color: widget.accent,
            ),
          ),
        ),
      ),
    ),
  );

  /// 薬剤名の1行. 一般名と略語を同じ行に収める.
  Widget _nameRow(int i) {
    final r = widget.rows[i];
    return InkWell(
      onTap: () => widget.onTap(r),
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
        // 略号側も Flexible にしないと, 長い略号が先に幅を取って
        // 主たる識別情報である一般名が数文字まで潰れる
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
            if (r.abbr.isNotEmpty)
              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: Text(
                    r.abbr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: _fsAbbr,
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

  Widget _cell(AbxMatrixRow r, String col, double cellW) {
    final v = r.coverage[col] ?? r.organ[col] ?? '';
    // 記号1文字なら大きく, 菌名などの注記なら小さく出す (全文は行タップの詳細に表示)
    final isMark = v.length <= 1;
    return Container(
      width: cellW,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: _cellColor(v, col),
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Text(
        v,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: isMark ? _fsMark : _fsNote,
          height: 1.0,
          fontWeight: isMark ? FontWeight.bold : FontWeight.w600,
          color: v.startsWith('✕') || v.startsWith('×')
              ? Colors.grey.shade500
              : _baseColorFor(col).withValues(alpha: 1.0),
        ),
      ),
    );
  }
}
