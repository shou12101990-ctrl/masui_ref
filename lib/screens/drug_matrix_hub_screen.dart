import 'package:flutter/material.dart';

import '../data/gi_matrix.dart';
import '../data/diuretic_matrix.dart';
import '../models/simple_matrix.dart';
import 'abx_matrix_screen.dart';
import 'psy_matrix_screen.dart';
import 'simple_matrix_screen.dart';

/// 薬剤マトリクスのハブ.
///
/// 「機能」タブから入ると, 独自の下部ナビを持つ別アプリのような画面に切り替わる.
/// 下段が大分類 (抗菌薬 / 向精神薬 / 利尿薬 / 便秘薬), 各画面の上段が小分類という2段構成.
class DrugMatrixHubScreen extends StatefulWidget {
  const DrugMatrixHubScreen({super.key});

  @override
  State<DrugMatrixHubScreen> createState() => _DrugMatrixHubScreenState();
}

class _MatrixTab {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String title;
  final Color accent;
  const _MatrixTab({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.title,
    required this.accent,
  });
}

const _abxAccent = Color(0xFF5C8A3A);
const _psyAccent = Color(0xFFD2691E);
const _diureticAccent = Color(0xFF1565C0);
const _giAccent = Color(0xFF6A1B9A);

class _DrugMatrixHubScreenState extends State<DrugMatrixHubScreen> {
  int _index = 0;

  static const _tabs = [
    _MatrixTab(
      icon: Icons.coronavirus_outlined,
      selectedIcon: Icons.coronavirus,
      label: '抗菌薬',
      title: '抗微生物薬 一覧表',
      accent: _abxAccent,
    ),
    _MatrixTab(
      icon: Icons.psychology_outlined,
      selectedIcon: Icons.psychology,
      label: '向精神薬',
      title: '向精神薬 分類・対応表',
      accent: _psyAccent,
    ),
    _MatrixTab(
      icon: Icons.water_drop_outlined,
      selectedIcon: Icons.water_drop,
      label: '利尿薬',
      title: '利尿薬 一覧表',
      accent: _diureticAccent,
    ),
    _MatrixTab(
      icon: Icons.dining_outlined,
      selectedIcon: Icons.dining,
      label: '便秘薬',
      title: '便秘薬・整腸剤 一覧表',
      accent: _giAccent,
    ),
  ];

  Widget _page(int i) => switch (i) {
    0 => const AbxMatrixScreen(embedded: true),
    1 => const PsyMatrixScreen(embedded: true),
    2 => SimpleMatrixScreen(
      embedded: true,
      title: '利尿薬 一覧表',
      accent: _diureticAccent,
      kinds: [
        SimpleMatrixKind(
          label: '利尿薬',
          rows: kDiureticMatrix,
          cols: kDiureticCols,
          colColors: kDiureticColColors,
          legendGroups: kDiureticLegendGroups,
          caption:
              '左の5列はネフロン上の作用部位, 右の2列は利尿の型. '
              '色は列の種類, 濃さは判定の強さ (○ 濃い / △ 淡い). 行をタップで用量・補足. ',
        ),
      ],
    ),
    _ => SimpleMatrixScreen(
      embedded: true,
      title: '便秘薬・整腸剤 一覧表',
      accent: _giAccent,
      kinds: [
        SimpleMatrixKind(
          label: '便秘薬',
          rows: kLaxativeMatrix,
          cols: kLaxativeCols,
          colColors: kLaxativeColColors,
          legendGroups: kLaxativeLegendGroups,
          caption:
              '原典の「上 / 下 / 軟便化 / 蠕動改善」に対応する. '
              '色は作用の種類, 濃さは判定の強さ (○ 濃い / △ 淡い). 行をタップで用量・補足. ',
        ),
        SimpleMatrixKind(
          label: '整腸剤',
          rows: kProbioticMatrix,
          cols: kProbioticCols,
          colColors: kProbioticColColors,
          legendGroups: kProbioticLegendGroups,
          caption:
              '列はその製剤に含まれる菌種. 抗菌薬併用時は耐性乳酸菌・酪酸菌・酵母菌が候補になる. '
              '行をタップで用量・補足. ',
        ),
      ],
    ),
  };

  @override
  Widget build(BuildContext context) {
    final tab = _tabs[_index];
    return Scaffold(
      appBar: AppBar(
        title: Text(tab.title),
        backgroundColor: tab.accent,
        foregroundColor: Colors.white,
      ),
      // IndexedStack: タブ切替時も検索条件・スクロール位置を保持する
      body: IndexedStack(
        index: _index,
        children: [for (var i = 0; i < _tabs.length; i++) _page(i)],
      ),
      bottomNavigationBar: Material(
        color: Colors.white,
        elevation: 3,
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                for (var i = 0; i < _tabs.length; i++)
                  Expanded(child: _tile(_tabs[i], i)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tile(_MatrixTab t, int i) {
    final selected = _index == i;
    // 選択中のタブだけその表のテーマ色にして, 別アプリに入った感じを出す
    final color = selected ? t.accent : Colors.black54;
    return InkWell(
      onTap: () => setState(() => _index = i),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(selected ? t.selectedIcon : t.icon, color: color, size: 22),
          const SizedBox(height: 3),
          Text(
            t.label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
