import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masui_ref/screens/drug_matrix_hub_screen.dart';

/// 薬剤マトリクスのサブアプリが4タブとも描画でき, 切替できることを確認する.
void main() {
  Future<void> pumpHub(WidgetTester tester) async {
    tester.view.physicalSize = const Size(430 * 3, 932 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      const MaterialApp(home: DrugMatrixHubScreen()),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('4タブが下部ナビに出る', (tester) async {
    await pumpHub(tester);
    for (final label in ['抗菌薬', '向精神薬', '利尿薬', '便秘薬']) {
      expect(find.text(label), findsWidgets, reason: '$label タブが無い');
    }
  });

  testWidgets('タブを切り替えるとAppBarの表題が変わる', (tester) async {
    await pumpHub(tester);
    expect(find.text('抗微生物薬 一覧表'), findsOneWidget);

    await tester.tap(find.text('利尿薬').last);
    await tester.pumpAndSettle();
    expect(find.text('利尿薬 一覧表'), findsOneWidget);

    await tester.tap(find.text('便秘薬').last);
    await tester.pumpAndSettle();
    expect(find.text('便秘薬・整腸剤 一覧表'), findsOneWidget);

    await tester.tap(find.text('向精神薬').last);
    await tester.pumpAndSettle();
    expect(find.text('向精神薬 分類・対応表'), findsOneWidget);
  });

  testWidgets('埋め込み時に各表の小分類切替が本文の先頭に出る', (tester) async {
    await pumpHub(tester);
    // 抗菌薬タブ: 抗菌薬 / 抗真菌薬 / 抗ウイルス薬
    expect(find.textContaining('抗真菌薬 ('), findsOneWidget);
    expect(find.textContaining('抗ウイルス薬 ('), findsOneWidget);

    await tester.tap(find.text('向精神薬').last);
    await tester.pumpAndSettle();
    expect(find.textContaining('分類 ('), findsOneWidget);
    expect(find.textContaining('疾患・症状 ('), findsOneWidget);
  });

  testWidgets('表示テキストに全角の記号が混ざっていない', (tester) async {
    await pumpHub(tester);
    final bad = RegExp('[、。（）：]');
    for (final w in tester.widgetList<Text>(find.byType(Text))) {
      final s = w.data;
      if (s == null) continue;
      expect(bad.hasMatch(s), isFalse, reason: '全角記号: $s');
    }
  });
}
