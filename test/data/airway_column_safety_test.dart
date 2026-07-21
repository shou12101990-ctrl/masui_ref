import 'package:flutter_test/flutter_test.dart';
import 'package:masui_ref/data/columns.dart';

void main() {
  group('DLT挿管手順記事の安全性境界', () {
    final article = kColumns.singleWhere((item) => item.title == 'DLT挿管手順');

    test('気道管理カテゴリに収載し主要語で検索できる', () {
      expect(article.category, '気道管理');
      expect(article.searchText, contains('dlt'));
      expect(article.searchText, contains('分離肺換気'));
      expect(article.searchText, contains('気管支鏡'));
    });

    test('左用を原則とし右用の限定的適応を示す', () {
      expect(article.body, contains('原則は左用DLT'));
      expect(article.body, contains('左肺全摘'));
      expect(article.body, contains('左主気管支の手術'));
      expect(article.body, contains('右上葉換気孔'));
    });

    test('挿入操作と過膨張防止を明記する', () {
      expect(article.body, contains('90度反時計回り'));
      expect(article.body, contains('抵抗に逆らって押し込まない'));
      expect(article.body, contains('最小量・最小圧'));
      expect(article.body, contains('一律の固定量を注入せず'));
    });

    test('聴診だけで確定せず両ルーメンを気管支鏡確認する', () {
      expect(article.body, contains('聴診だけでは位置異常を除外できない'));
      expect(article.body, contains('右上葉口が開存'));
      expect(article.body, contains('青い気管支カフ上縁'));
      expect(article.body, contains('左上葉口と左下葉口'));
    });

    test('体位変換後と換気異常時に再確認する', () {
      expect(article.body, contains('側臥位への体位変換後は必ず'));
      expect(article.body, contains('FiO2 1.0'));
      expect(article.body, contains('速やかに両肺換気へ戻す'));
      expect(article.table, isNotNull);
      expect(article.table!.rows, hasLength(3));
    });

    test('根拠と気管支鏡関連記事を追える', () {
      expect(article.body, contains('PMCID: PMC10591134'));
      expect(article.body, contains('PMID 1394757'));
      expect(article.body, contains('PMID 14722168'));
      expect(article.relatedArticleTitles, contains('気管支鏡所見の見かた'));
    });
  });

  group('気管支鏡所見記事の安全性境界', () {
    final article = kColumns.singleWhere((item) => item.title == '気管支鏡所見の見かた');

    test('正常解剖を左右別に系統的に示す', () {
      expect(article.body, contains('軟骨輪'));
      expect(article.body, contains('膜様部'));
      expect(article.body, contains('気管支中間幹'));
      expect(article.body, contains('左上葉と左下葉'));
      expect(article.body, contains('上区と舌区'));
    });

    test('麻酔中に重要な異常所見を網羅する', () {
      expect(article.body, contains('分泌物'));
      expect(article.body, contains('活動性出血'));
      expect(article.body, contains('高度狭窄'));
      expect(article.body, contains('動的虚脱'));
      expect(article.table, isNotNull);
      expect(article.table!.rows, hasLength(5));
    });

    test('所見単独で確定診断させず記録項目を示す', () {
      expect(article.body, contains('記録テンプレート'));
      expect(article.body, contains('時計方向だけでなく'));
      expect(article.body, contains('気管支鏡像だけで'));
      expect(article.body, contains('CT, 手術所見, 培養・病理と統合'));
    });

    test('DLT記事へ相互に移動できる', () {
      expect(article.relatedArticleTitles, contains('DLT挿管手順'));
    });
  });
}
