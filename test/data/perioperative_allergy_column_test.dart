import 'package:flutter_test/flutter_test.dart';
import 'package:masui_ref/data/columns.dart';

void main() {
  group('周術期アレルギー後の次回手術記事', () {
    final article = kColumns.singleWhere(
      (item) => item.title == '周術期アレルギー後の次回手術',
    );

    test('術前評価に収載し主要薬剤で検索できる', () {
      expect(article.category, '術前評価');
      expect(article.searchText, contains('ロクロニウム'));
      expect(article.searchText, contains('スガマデクス'));
      expect(article.searchText, contains('抗菌薬'));
      expect(article.searchText, contains('アナフィラキシー'));
    });

    test('原因を推測で決めず記録と専門評価につなぐ', () {
      expect(article.body, contains('推測で1剤だけ入れ替えない'));
      expect(article.body, contains('分単位のタイムライン'));
      expect(article.body, contains('トリプターゼ'));
      expect(article.body, contains('アレルギー専門医'));
      expect(article.body, contains('陰性試験でも反応をゼロにはできない'));
    });

    test('ROC交差反応とSGXの限界を明記する', () {
      expect(article.body, contains('ベクロニウムやスキサメトニウムへ自動変更しない'));
      expect(article.body, contains('筋弛緩薬を使わない'));
      expect(article.body, contains('検査で陰性となった別の筋弛緩薬'));
      expect(article.body, contains('標準治療でも予防薬でもない'));
      expect(article.body, contains('ROC-SGX複合体'));
    });

    test('SGX回避時も定量TOFと回復深度を要求する', () {
      expect(article.body, contains('ネオスチグミン＋抗コリン薬'));
      expect(article.body, contains('深い筋弛緩を即時回復させる代替ではない'));
      expect(article.body, contains('定量TOF'));
    });

    test('抗菌薬変更を側鎖・術式・専門評価に基づかせる', () {
      expect(article.body, contains('セファゾリンを一律除外しない'));
      expect(article.body, contains('R1側鎖'));
      expect(article.body, contains('重症遅延型反応'));
      expect(article.body, contains('SSIや有害事象を増やし得る'));
    });

    test('精査前の緊急手術に再発対応計画を示す', () {
      expect(article.body, contains('使用薬を必要最小限'));
      expect(article.body, contains('アドレナリンを直ちに使える状態'));
      expect(article.body, contains('前投薬で再発を防げるとは考えない'));
      expect(article.table, isNotNull);
      expect(article.table!.rows, hasLength(5));
    });

    test('術前診察テンプレートから関連記事として開ける', () {
      final preop = kColumns.singleWhere(
        (item) => item.title == '術前診察テンプレート: 麻酔薬との相性チェック',
      );
      expect(preop.relatedArticleTitles, contains(article.title));
    });
  });
}
