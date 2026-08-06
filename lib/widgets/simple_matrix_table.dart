import 'package:flutter/material.dart';

import '../models/simple_matrix.dart';

/// 利尿薬 / 便秘薬 / 整腸剤のマトリクス表.
///
/// 抗菌薬表 (abx_matrix_screen.dart の _MatrixTable)と同じ見た目・操作感に揃えてある.
/// - 左は固定列 (上位分類の縦帯 + 薬剤名), 右は判定列で横スクロール
/// - 左右の縦スクロールは同期する
/// - 縦帯は区間の高さに収まるまでフォントを自動で縮め, 省略記号を出さない
class SimpleMatrixTable extends StatefulWidget {
  final List<SimpleMatrixRow> rows;
  final List<String> cols;

  /// 列ごとの基準色. 同じ "○" でも何に効くのかが色で分かるようにする.
  final Map<String, Color> colColors;
  final Color accent;
  final void Function(SimpleMatrixRow) onTap;

  const SimpleMatrixTable({
    super.key,
    required this.rows,
    required this.cols,
    required this.colColors,
    required this.accent,
    required this.onTap,
  });

  @override
  State<SimpleMatrixTable> createState() => _SimpleMatrixTableState();
}

class _GroupSpan {
  final String label;
  final int start;
  int count;
  _GroupSpan(this.label, this.start) : count = 1;
}

class _SimpleMatrixTableState extends State<SimpleMatrixTable> {
  final _vLeft = ScrollController();
  final _vRight = ScrollController();
  bool _syncing = false;

  static const _rowH = 26.0;
  static const _headH = 26.0;
  static const _nameW = 150.0; // 上位分類の帯を含む固定列の幅
  static const _groupW = 22.0; // 左端の上位分類 (90度回転)の帯
  static const _fsBand = 7.5;
  static const _fsBandMin = 4.5;

  static const _fsName = 9.5;
  static const _fsBrand = 7.5;
  static const _fsHead = 7.5;
  static const _fsMark = 13.0;

  /// 列見出しのスタイル. 実測 (_cellWidth)と描画で必ず同じものを使う.
  /// letterSpacing を明示しないと Material の bodyMedium (0.25)が乗り,
  /// 実測が文字数×0.25px だけ過小になって最長列が省略される.
  static const _headStyle = TextStyle(
    fontSize: _fsHead,
    height: 1.1,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
  );

  /// 判定列の幅. 列見出しを1行で描いたときの最大幅に揃える.
  double _cellWidth() {
    var w = 24.0;
    for (final c in widget.cols) {
      final tp = TextPainter(
        text: TextSpan(text: c, style: _headStyle),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();
      if (tp.width > w) w = tp.width;
    }
    return w + 7;
  }

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

  /// 縦帯に出す分類名. 括弧付きは短い方 (英字略号か括弧前)に畳む.
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

  Color _baseColorFor(String col) => widget.colColors[col] ?? widget.accent;

  Color _cellColor(String v, String col) {
    if (v.isEmpty) return Colors.transparent;
    final base = _baseColorFor(col);
    if (v.startsWith('○')) return base.withValues(alpha: 0.30);
    if (v.startsWith('△') || v.startsWith('▲')) {
      return base.withValues(alpha: 0.13);
    }
    return base.withValues(alpha: 0.10);
  }

  @override
  Widget build(BuildContext context) {
    final rows = widget.rows;
    final spans = _spans();
    final cellW = _cellWidth();
    return Row(
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
              width: cellW * widget.cols.length,
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
                        for (final c in widget.cols)
                          Container(
                            width: cellW,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              color: _baseColorFor(c).withValues(alpha: 0.16),
                              border: const Border(
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
                                for (final c in widget.cols) _cell(r, c, cellW),
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

  Widget _groupBand(_GroupSpan s, int si) {
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

  /// 薬剤名の1行. 一般名と商品名を同じ行に収める.
  /// 商品名側も Flexible にしないと, 長い商品名が先に幅を取って一般名が潰れる.
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
            if (r.brand.isNotEmpty)
              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: Text(
                    r.brand,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: _fsBrand,
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

  Widget _cell(SimpleMatrixRow r, String col, double cellW) {
    final v = r.marks[col] ?? '';
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
          fontSize: _fsMark,
          height: 1.0,
          fontWeight: FontWeight.bold,
          color: _baseColorFor(col),
        ),
      ),
    );
  }
}
