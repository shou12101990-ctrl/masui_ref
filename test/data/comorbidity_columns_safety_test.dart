import 'package:flutter_test/flutter_test.dart';
import 'package:masui_ref/data/columns.dart';

void main() {
  const category = '併存疾患・内服';

  ColumnArticle article(String title) => kColumns.singleWhere(
    (item) => item.category == category && item.title == title,
  );

  String allText(ColumnArticle item) =>
      '${item.body} ${item.table?.searchText}';

  group('併存疾患・内服ノートの安全性境界', () {
    test('カテゴリと9本の記事を収載する', () {
      expect(kColumnCategoryColors, contains(category));
      expect(kColumns.where((item) => item.category == category), hasLength(9));
      expect(
        kColumns.where((item) => item.category == category),
        everyElement(predicate<ColumnArticle>((item) => item.table != null)),
      );
    });

    test('緑内障は病型を分け眼内ガスへの笑気を禁止する', () {
      final text = allText(article('緑内障・眼内ガスと麻酔薬'));
      expect(text, contains('閉塞隅角'));
      expect(text, contains('開放隅角'));
      expect(text, contains('一律禁忌ではない'));
      expect(text, contains('眼内ガス'));
      expect(text, contains('完全吸収を眼科が確認するまで使用しない'));
    });

    test('喘息は現在のコントロールとAERDを分ける', () {
      final text = allText(article('喘息・AERDと麻酔薬'));
      expect(text, contains('ICS'));
      expect(text, contains('AERD/NERD'));
      expect(text, contains('一律に禁忌とする必要はない'));
      expect(text, contains('デスフルラン'));
      expect(text, contains('セボフルラン'));
    });

    test('Parkinsonismでは定時薬を継続しドパミン遮断薬を避ける', () {
      final text = allText(article('Parkinsonismと周術期薬'));
      expect(text, contains('通常時刻に継続'));
      expect(text, contains('自己判断で一括休薬しない'));
      expect(text, contains('ドロペリドール'));
      expect(text, contains('ハロペリドール'));
      expect(text, contains('メトクロプラミド'));
      expect(text, contains('MAO-B阻害薬'));
    });

    test('向精神薬は突然中止とセロトニン毒性の両方を扱う', () {
      final text = allText(article('向精神薬内服と麻酔薬'));
      expect(text, contains('急に止めない'));
      expect(text, contains('セロトニン毒性'));
      expect(text, contains('clonus'));
      expect(text, contains('大手術では24時間前中止'));
      expect(text, contains('慢性内服は継続'));
    });

    test('抗てんかん薬を継続し薬剤別の相互作用を示す', () {
      final text = allText(article('てんかん・抗てんかん薬と麻酔'));
      expect(text, contains('手術当日も継続'));
      expect(text, contains('カルバマゼピンには静注製剤がない'));
      expect(text, contains('バルプロ酸'));
      expect(text, contains('トラマドール'));
      expect(text, contains('高濃度セボ'));
    });

    test('神経筋疾患では筋弛緩反応とスキサメトニウム高Kを区別する', () {
      final text = allText(article('神経筋疾患・熱傷・長期臥床と筋弛緩薬'));
      expect(text, contains('定量的TOF'));
      expect(text, contains('重症筋無力症'));
      expect(text, contains('致死的高K血症'));
      expect(text, contains('偽性コリンエステラーゼ欠損'));
      expect(text, contains('早期抜管しない'));
    });

    test('悪性高熱と急性ポルフィリン症のtriggerを混同しない', () {
      final text = allText(article('悪性高熱・急性ポルフィリン症'));
      expect(text, contains('全揮発性麻酔薬'));
      expect(text, contains('スキサメトニウム'));
      expect(text, contains('局所麻酔薬'));
      expect(text, contains('バルビツレート'));
      expect(text, contains('最新DBで全薬照合'));
    });

    test('QT/Brugadaでは薬剤だけでなく誘因と監視を示す', () {
      final text = allText(article('QT延長・Brugada症候群と周術期薬'));
      expect(text, contains('K/Mg/Ca'));
      expect(text, contains('CredibleMeds'));
      expect(text, contains('高用量長時間propofol'));
      expect(text, contains('除細動'));
    });

    test('OSAでは深鎮静とPCA持続投与を注意し慢性ベンゾは継続する', () {
      final text = allText(article('OSA・高齢/フレイルと鎮静・鎮痛'));
      expect(text, contains('気道未確保の深い鎮静'));
      expect(text, contains('capnography'));
      expect(text, contains('background infusion'));
      expect(text, contains('慢性ベンゾジアゼピンを突然中止'));
    });
  });
}
