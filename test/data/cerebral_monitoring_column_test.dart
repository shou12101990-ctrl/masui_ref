import 'package:flutter_test/flutter_test.dart';
import 'package:masui_ref/data/columns.dart';

void main() {
  group('BIS・NIRSと後方循環記事の安全性境界', () {
    final article = kColumns.singleWhere(
      (item) => item.title == 'BIS・INVOS/O3で後方循環は見えるか',
    );

    test('モニタリングカテゴリに収載し主要機器で検索できる', () {
      expect(article.category, 'モニタリング');
      expect(article.searchText, contains('bis'));
      expect(article.searchText, contains('invos'));
      expect(article.searchText, contains('o3'));
      expect(article.searchText, contains('nirs'));
    });

    test('正常値を全脳正常や後方循環除外に使わせない', () {
      expect(article.body, contains('脳全体が正常とは言えない'));
      expect(article.body, contains('NIRS正常を後方循環障害の除外には使わない'));
      expect(article.body, contains('脳灌流正常の証明ではない'));
    });

    test('前額NIRSの測定対象と限界を区別する', () {
      expect(article.body, contains('センサー直下の前頭葉皮質'));
      expect(article.body, contains('脳血流量そのものではなく'));
      expect(article.body, contains('頭蓋外組織の影響'));
      expect(article.table, isNotNull);
      expect(article.table!.rows, hasLength(3));
    });

    test('後方循環リスク時の補完手段を示す', () {
      expect(article.body, contains('経頭蓋ドプラ'));
      expect(article.body, contains('椎骨・脳底動脈'));
      expect(article.body, contains('SSEP/MEP'));
      expect(article.body, contains('BAEP'));
      expect(article.body, contains('神経診察'));
    });

    test('根拠文献を識別できる', () {
      expect(article.body, contains('PMID: 33079868'));
      expect(article.body, contains('LAB-10329A'));
      expect(article.body, contains('PMID: 22253267'));
      expect(article.body, contains('PMID: 17238867'));
    });

    test('既存BIS記事から関連記事として開ける', () {
      final bis = kColumns.singleWhere((item) => item.title == 'BISについて');
      expect(bis.relatedArticleTitles, contains(article.title));
      expect(article.relatedArticleTitles, contains(bis.title));
    });
  });
}
