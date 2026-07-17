import 'package:flutter_test/flutter_test.dart';
import 'package:masui_ref/data/drugs.dart';
import 'package:masui_ref/models/drug.dart';

void main() {
  group('ハロペリドール薬剤マスタの安全性境界', () {
    final drug = kDrugs.singleWhere((item) => item.name == 'ハロペリドール');
    final text = drug.notes
        .map((note) => '${note.heading} ${note.body}')
        .join(' ');

    test('規格・カテゴリ・承認適応と適応外使用を分離する', () {
      expect(drug.category, DrugCategory.psychotropic);
      expect(drug.brand, 'セレネース');
      expect(drug.spec, contains('5mg/1ml'));
      expect(drug.dose, contains('承認用量'));
      expect(drug.dose, contains('周術期せん妄: 適応外'));
      expect(text, contains('低活動型せん妄'));
      expect(text, contains('ルーチン予防には使用しない'));
    });

    test('投与前の禁忌・監視と重大な有害事象を明示する', () {
      expect(text, contains('Parkinson病またはLewy小体型認知症は禁忌'));
      expect(text, contains('QTc'));
      expect(text, contains('K/Mg'));
      expect(text, contains('15-30分後'));
      expect(text, contains('Torsades de pointes'));
      expect(text, contains('悪性症候群'));
      expect(text, contains('心電図と呼吸を監視'));
    });
  });
}
