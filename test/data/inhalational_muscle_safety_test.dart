import 'package:flutter_test/flutter_test.dart';
import 'package:masui_ref/data/drugs/inhalational.dart';
import 'package:masui_ref/data/drugs/muscle_relaxant.dart';
import 'package:masui_ref/models/drug.dart';

void main() {
  group('吸入麻酔薬・筋弛緩関連マスタの安全性回帰', () {
    test('6剤すべて電子添文の版とPMDA URLを保持する', () {
      final drugs = [...kInhalationalDrugs, ...kMuscleRelaxantDrugs];
      expect(drugs, hasLength(6));

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

    test('セボフルランは承認濃度と年齢補正を分離する', () {
      final drug = kInhalationalDrugs.singleWhere((d) => d.name == 'セボフルラン');
      expect(drug.dose, contains('0.5-5.0%'));
      expect(drug.dose, contains('4.0%以下'));
      expect(drug.dose, isNot(contains('年齢')));
      expect(
        drug.notes.any(
          (note) =>
              note.type == DrugNoteType.facilityPractice &&
              note.body.contains('etSev'),
        ),
        isTrue,
      );
      expect(drug.searchText, isNot(contains('脳保護作用あり')));
    });

    test('デスフルランは維持のみで3.0%開始・7.6%以下', () {
      final drug = kInhalationalDrugs.singleWhere((d) => d.name == 'デスフルラン');
      expect(drug.dose, contains('維持のみ'));
      expect(drug.dose, contains('3.0%'));
      expect(drug.dose, contains('7.6%'));
      expect(drug.searchText, contains('導入には使用しない'));
      expect(drug.searchText, isNot(contains('15歳未満には用いない')));
    });

    test('笑気は酸素20%以上と眼内ガス回避を示す', () {
      final drug = kInhalationalDrugs.singleWhere((d) => d.name.contains('笑気'));
      expect(drug.dose, contains('20%以上'));
      expect(drug.contraindications, isEmpty);
      expect(drug.searchText, contains('眼内ガス'));
      expect(drug.searchText, contains('失明'));
      expect(drug.searchText, contains('使用しない'));
    });

    test('ダントロレンは本邦承認用量と国際手順を分離する', () {
      final drug = kInhalationalDrugs.singleWhere((d) => d.name == 'ダントロレン');
      expect(drug.dose, contains('初回1mg/kg'));
      expect(drug.dose, contains('総量7mg/kg'));
      expect(drug.dilution, contains('注射用水60mL'));
      expect(drug.dose, isNot(contains('2.5mg/kg')));
      expect(
        drug.notes.any(
          (note) =>
              note.type == DrugNoteType.literature &&
              note.body.contains('2.5mg/kg'),
        ),
        isTrue,
      );
    });

    test('ロクロニウムは電子添文用量とTOF条件を保持する', () {
      final drug = kMuscleRelaxantDrugs.singleWhere(
        (d) => d.name.contains('ロクロニウム'),
      );
      final text = [
        drug.dose ?? '',
        ...drug.notes.map((note) => note.body),
      ].join(' ');
      expect(drug.spec, contains('25mg/2.5mL'));
      expect(drug.spec, contains('50mg/5.0mL'));
      expect(drug.dose, contains('0.6mg/kg'));
      expect(drug.dose, contains('0.1-0.2mg/kg'));
      expect(drug.dose, contains('7mcg/kg/min'));
      expect(drug.dose, contains('0.9mg/kg'));
      expect(drug.searchText, contains('tofモニタリングがない状況で持続投与しない'));
      expect(drug.searchText, contains('5mcg/kg/min'));
      expect(text, isNot(contains('導入 0.6-1.2mg/kg')));
      expect(text, isNot(contains('1.0-1.2mg/kg')));
      expect(text, isNot(contains('ROC 1.0-1.8mg/kg')));
    });

    test('スガマデクスはT2・PTCと緊急用量を正確に示す', () {
      final drug = kMuscleRelaxantDrugs.singleWhere(
        (d) => d.name.contains('スガマデクス'),
      );
      final text = [
        drug.dose ?? '',
        ...drug.notes.map((note) => note.body),
      ].join(' ');
      expect(drug.spec, contains('200mg/2mL'));
      expect(drug.spec, contains('500mg/5mL'));
      expect(drug.dose, contains('T2再出現後'));
      expect(drug.dose, contains('1-2 PTC'));
      expect(drug.dose, contains('16mg/kg'));
      expect(text, isNot(contains('TOF 1以上で2mg/kg')));
      expect(text, isNot(contains('ROCアレルギーには等量SUG')));
      expect(drug.searchText, contains('標準治療ではない'));
    });
  });
}
