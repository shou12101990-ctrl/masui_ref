import 'package:flutter/material.dart';

import '../data/columns.dart';
import '../widgets/article_table.dart';
import '../widgets/ecg_leads_diagram.dart';

/// 解説（コラム）ページ。NutriCalcの「ノート」と同じUI：
/// カテゴリ色グリッド ＋ ドラッグで伸縮する本文パネル ＋ ■見出しセクション。
class ColumnScreen extends StatefulWidget {
  const ColumnScreen({super.key});

  @override
  State<ColumnScreen> createState() => _ColumnScreenState();
}

class _ColumnScreenState extends State<ColumnScreen>
    with SingleTickerProviderStateMixin {
  static const _allLabel = 'すべて表示';
  String _selected = _allLabel;
  String _query = '';
  final _searchCtrl = TextEditingController();

  // 本文パネル（ドラッグで上に展開。上端まで引いたら下端に戻すスナップ）
  static const double _panelMin = 220.0;
  double _panelHeight = 380.0;
  double _snapFrom = 380.0;
  double _snapToTarget = 380.0;
  late AnimationController _snapCtrl;
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _snapCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 260));
    _snapCtrl.addListener(() {
      if (!mounted) return;
      final t = Curves.easeOut.transform(_snapCtrl.value);
      setState(
          () => _panelHeight = _snapFrom + (_snapToTarget - _snapFrom) * t);
    });
  }

  @override
  void dispose() {
    _snapCtrl.dispose();
    _scroll.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _snapTo(double target) {
    _snapFrom = _panelHeight;
    _snapToTarget = target;
    _snapCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final filtered = q.isNotEmpty
        ? kColumns.where((c) => c.searchText.contains(q)).toList()
        : (_selected == _allLabel
            ? kColumns
            : kColumns.where((c) => c.category == _selected).toList());
    final media = MediaQuery.of(context);
    final pad = media.padding;
    const navBarH = 80.0;
    final maxPanel =
        (media.size.height - pad.top - kToolbarHeight - navBarH - pad.bottom)
            .clamp(_panelMin, media.size.height);
    if (_panelHeight > maxPanel) _panelHeight = maxPanel;

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text('解説（コラム）',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
          ),
          // 検索 (タイトル・本文・タグ)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'キーワード・タグで検索 (例: 生理学, 薬理学, 術前評価)',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => setState(() {
                          _query = '';
                          _searchCtrl.clear();
                        }),
                      ),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // カテゴリ色グリッド
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 3.6,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                  children: kColumnCategoryColors.entries.map((e) {
                    final selected = _selected == e.key;
                    return GestureDetector(
                      onTap: () => setState(() {
                        _selected = e.key;
                        _query = '';
                        _searchCtrl.clear();
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        decoration: BoxDecoration(
                          color: selected
                              ? e.value
                              : e.value.withValues(alpha: 0.68),
                          borderRadius: BorderRadius.circular(6),
                          border: selected
                              ? Border.all(color: Colors.white, width: 2.5)
                              : null,
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                      color: e.value.withValues(alpha: 0.4),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2))
                                ]
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(e.key,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          // 本文パネル
          SafeArea(
            top: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: SizedBox(
                height: _panelHeight,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.4),
                        width: 0.8),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onVerticalDragUpdate: (d) {
                          setState(() {
                            _panelHeight = (_panelHeight - d.delta.dy)
                                .clamp(_panelMin, maxPanel);
                          });
                        },
                        onVerticalDragEnd: (_) {
                          if (_panelHeight >= maxPanel) _snapTo(_panelMin);
                        },
                        child: Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Container(
                              height: 4,
                              width: 48,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: filtered.isEmpty
                            ? const Center(child: Text('コラムがありません'))
                            : ListView(
                                controller: _scroll,
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                children: [
                                  for (final c in filtered)
                                    _Section(
                                      key: ValueKey(
                                          '${c.title}|${_query.trim().isNotEmpty}'),
                                      article: c,
                                      expandByDefault:
                                          _query.trim().isNotEmpty,
                                      onTagTap: (t) => setState(() {
                                        _query = t;
                                        _searchCtrl.text = t;
                                      }),
                                    ),
                                ],
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
    );
  }
}

class _Section extends StatefulWidget {
  final ColumnArticle article;
  final void Function(String tag)? onTagTap;
  final bool expandByDefault;
  const _Section({
    super.key,
    required this.article,
    this.onTagTap,
    this.expandByDefault = false,
  });

  @override
  State<_Section> createState() => _SectionState();
}

class _SectionState extends State<_Section> {
  late bool _expanded = widget.expandByDefault;

  @override
  Widget build(BuildContext context) {
    final article = widget.article;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── ヘッダ (タップで開閉) ──
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: '■ ',
                          style: TextStyle(
                              color: article.color,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        TextSpan(
                          text: article.title,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.black38,
                  ),
                ],
              ),
            ),
          ),
          if (article.tags.isNotEmpty) ...[
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                for (final t in article.tags)
                  GestureDetector(
                    onTap: () => widget.onTagTap?.call(t),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: article.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: article.color.withValues(alpha: 0.4)),
                      ),
                      child: Text('# $t',
                          style: TextStyle(
                              fontSize: 10.5,
                              color: article.color,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
              ],
            ),
          ],
          // ── 本文 (展開時のみ) ──
          if (_expanded) ...[
            const SizedBox(height: 8),
            Card(
              margin: EdgeInsets.zero,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.4),
                    width: 0.8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _ArticleBody(article: article),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 記事本文の描画. 表を持つ記事は本文中の {{TABLE}} マーカー位置に
/// ArticleTableView を差し込む (マーカーがなければ末尾に表示).
class _ArticleBody extends StatelessWidget {
  final ColumnArticle article;
  const _ArticleBody({required this.article});

  static const _bodyStyle = TextStyle(height: 1.7, fontSize: 13);

  /// headerArt キーを対応する図ウィジェットへマップ (データ層はキーのみ保持).
  Widget? _headerArt() {
    switch (article.headerArt) {
      case 'ecg_leads':
        return const EcgLeadsDiagram();
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final header = _headerArt();
    final table = article.table;

    if (table == null) {
      if (header == null) return Text(article.body, style: _bodyStyle);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header,
          const SizedBox(height: 12),
          Text(article.body, style: _bodyStyle),
        ],
      );
    }

    final parts = article.body
        .split('{{TABLE}}')
        .map((p) => p.replaceAll(RegExp(r'^\n+|\n+$'), ''))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (header != null) ...[
          header,
          const SizedBox(height: 12),
        ],
        for (var i = 0; i < parts.length; i++) ...[
          if (parts[i].isNotEmpty) Text(parts[i], style: _bodyStyle),
          if (i < parts.length - 1) ...[
            const SizedBox(height: 10),
            ArticleTableView(table: table),
            const SizedBox(height: 10),
          ],
        ],
        // マーカーなしで表だけ定義された場合は末尾に表示
        if (!article.body.contains('{{TABLE}}')) ...[
          const SizedBox(height: 10),
          ArticleTableView(table: table),
        ],
      ],
    );
  }
}
