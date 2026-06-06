import 'package:flutter/material.dart';

import '../data/columns.dart';

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
    super.dispose();
  }

  void _snapTo(double target) {
    _snapFrom = _panelHeight;
    _snapToTarget = target;
    _snapCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _selected == _allLabel
        ? kColumns
        : kColumns.where((c) => c.category == _selected).toList();
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
                      onTap: () => setState(() => _selected = e.key),
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
                                  for (final c in filtered) _Section(article: c),
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

class _Section extends StatelessWidget {
  final ColumnArticle article;
  const _Section({required this.article});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
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
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                  color:
                      Theme.of(context).colorScheme.outline.withValues(alpha: 0.4),
                  width: 0.8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(article.body,
                  style: const TextStyle(height: 1.7, fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}
