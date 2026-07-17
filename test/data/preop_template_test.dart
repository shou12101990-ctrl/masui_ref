import 'package:flutter_test/flutter_test.dart';
import 'package:masui_ref/data/columns.dart';

void main() {
  const title = '術前診察テンプレート: 麻酔薬との相性チェック';

  test('術前診察テンプレートは主要病態と薬剤リスクを横断する', () {
    final article = kColumns.singleWhere((item) => item.title == title);
    expect(article.category, '術前評価');

    final text = article.body;
    for (final keyword in const [
      '困難気道',
      '悪性高熱',
      '喘息',
      'AERD',
      'QT延長',
      'Parkinsonism',
      '抗てんかん薬',
      '重症筋無力症',
      '眼内ガス',
      'ステロイドカバー',
      '抗血小板薬/抗凝固薬',
      'フルマゼニル',
      '急性離脱・痙攣',
    ]) {
      expect(text, contains(keyword), reason: '$keyword が術前診察にない');
    }
  });

  test('関連記事ボタンの遷移先はすべて一意に存在する', () {
    final article = kColumns.singleWhere((item) => item.title == title);
    expect(article.relatedArticleTitles, hasLength(11));
    expect(article.relatedArticleTitles.toSet(), hasLength(11));
    expect(article.relatedArticleTitles, isNot(contains(title)));

    for (final target in article.relatedArticleTitles) {
      expect(
        kColumns.where((item) => item.title == target),
        hasLength(1),
        reason: '関連記事 $target の遷移先が一意でない',
      );
    }
  });

  test('関連記事タイトルも検索対象に含まれる', () {
    final article = kColumns.singleWhere((item) => item.title == title);
    expect(article.searchText, contains('parkinsonismと周術期薬'.toLowerCase()));
    expect(article.searchText, contains('区域麻酔・神経ブロックと抗血栓療法gl'.toLowerCase()));
  });
}
