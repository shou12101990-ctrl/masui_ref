import 'package:flutter_test/flutter_test.dart';
import 'package:masui_ref/data/drugs/analgesic.dart';
import 'package:masui_ref/models/drug.dart';

void main() {
  group('オピオイド関連マスタの安全性回帰', () {
    final reviewedNames = {'フェンタニル', 'レミフェンタニル', 'モルヒネ', 'ペンタゾシン', 'ナロキソン'};

    test('5剤すべて電子添文の版とPMDA URLを保持する', () {
      final drugs = kAnalgesicDrugs
          .where((drug) => reviewedNames.contains(drug.name))
          .toList();
      expect(drugs, hasLength(5));

      for (final drug in drugs) {
        expect(drug.packageInsertReviewed, isTrue, reason: drug.name);
        expect(drug.packageInsertRevision, isNotEmpty, reason: drug.name);
        expect(
          drug.packageInsertUrl,
          startsWith('https://www.pmda.go.jp/'),
          reason: drug.name,
        );
        for (final item in drug.contraindications) {
          expect(item.target, isNotEmpty, reason: drug.name);
          expect(item.reason, isNotEmpty, reason: drug.name);
        }
      }
    });

    test('フェンタニルは承認用量と神経軸投与の遅発性呼吸抑制を示す', () {
      final drug = kAnalgesicDrugs.singleWhere((drug) => drug.name == 'フェンタニル');
      final text = _allText(drug);

      expect(drug.spec, contains('0.1mg/2mL'));
      expect(drug.spec, contains('0.25mg/5mL'));
      expect(drug.dose, contains('1.5-8mcg/kg'));
      expect(drug.dose, contains('0.5-5mcg/kg/h'));
      expect(text, contains('数時間以上経過後'));
      expect(text, isNot(contains('遅発性呼吸抑制リスク低い')));
      expect(text, isNot(contains('覚醒に影響を与えない')));
    });

    test('レミフェンタニルは承認開始量と施設運用を分離する', () {
      final drug = kAnalgesicDrugs.singleWhere(
        (drug) => drug.name == 'レミフェンタニル',
      );

      expect(drug.spec, contains('2mg/V'));
      expect(drug.spec, contains('5mg/V'));
      expect(drug.dose, contains('導入0.5mcg/kg/min'));
      expect(drug.dose, contains('維持0.25mcg/kg/min'));
      expect(drug.dose, contains('最大2.0mcg/kg/min'));
      expect(drug.searchText, contains('グリシン'));
      expect(drug.searchText, contains('硬膜外及びくも膜下へ絶対に投与しない'));
      expect(
        drug.notes.any(
          (note) =>
              note.type == DrugNoteType.facilityPractice &&
              note.body.contains('0.1-0.3mcg/kg/min'),
        ),
        isTrue,
      );
      expect(
        drug.notes.any((note) => note.type == DrugNoteType.offLabel),
        isTrue,
      );
    });

    test('モルヒネは経路別承認用量と遅発性呼吸抑制を示す', () {
      final drug = kAnalgesicDrugs.singleWhere((drug) => drug.name == 'モルヒネ');

      expect(drug.dose, contains('皮下5-10mg'));
      expect(drug.dose, contains('硬膜外2-6mg'));
      expect(drug.dose, contains('くも膜下0.1-0.5mg'));
      expect(drug.searchText, contains('数時間以上経過してから'));
      expect(
        drug.notes.any(
          (note) =>
              note.type == DrugNoteType.facilityPractice &&
              note.body.contains('100-150mcg'),
        ),
        isTrue,
      );
      expect(drug.searchText, isNot(contains('静注量の1/10')));
    });

    test('ペンタゾシンは成人承認用量を示し旧小児用量を使わせない', () {
      final drug = kAnalgesicDrugs.singleWhere((drug) => drug.name == 'ペンタゾシン');

      expect(drug.dose, contains('成人15mg IM/SC'));
      expect(drug.dose, contains('30-60mg IM/SC/IV'));
      expect(drug.searchText, contains('小児等には投与しないことが望ましい'));
      expect(drug.searchText, isNot(contains('小児0.5mg/kg')));
      expect(
        drug.notes.any((note) => note.type == DrugNoteType.facilityPractice),
        isTrue,
      );
    });

    test('ナロキソンは電子添文量と少量タイトレーションを分離する', () {
      final drug = kAnalgesicDrugs.singleWhere((drug) => drug.name == 'ナロキソン');

      expect(drug.dose, contains('成人0.2mg IV'));
      expect(drug.dose, contains('2-3分間隔'));
      expect(drug.searchText, contains('呼吸抑制が再発'));
      expect(drug.searchText, contains('無効'));
      expect(
        drug.notes.any(
          (note) =>
              note.type == DrugNoteType.facilityPractice &&
              note.body.contains('0.04mg'),
        ),
        isTrue,
      );
    });
  });
}

String _allText(Drug drug) =>
    [drug.dose ?? '', ...drug.notes.map((note) => note.body)].join(' ');
