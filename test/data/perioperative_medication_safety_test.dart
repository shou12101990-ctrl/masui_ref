import 'package:flutter_test/flutter_test.dart';
import 'package:masui_ref/data/perioperative_medications.dart';
import 'package:masui_ref/models/perioperative_medication.dart';

void main() {
  PerioperativeMedication byId(String id) =>
      kPerioperativeMedications.singleWhere((m) => m.id == id);

  group('継続・中止薬マスタの完全性', () {
    test('IDが一意で主要薬効群を網羅する', () {
      final ids = kPerioperativeMedications.map((m) => m.id).toList();
      expect(ids.toSet().length, ids.length);
      expect(kPerioperativeMedications.length, greaterThanOrEqualTo(65));

      final represented = kPerioperativeMedications
          .map((m) => m.category)
          .toSet();
      for (final category in PerioperativeMedicationCategory.values) {
        if (category == PerioperativeMedicationCategory.other) continue;
        expect(represented, contains(category), reason: category.label);
      }
    });

    test('全項目に判断材料と一次資料URLがある', () {
      for (final medication in kPerioperativeMedications) {
        expect(medication.dayOfSurgery, isNotEmpty, reason: medication.id);
        expect(medication.holdTiming, isNotEmpty, reason: medication.id);
        expect(medication.restart, isNotEmpty, reason: medication.id);
        expect(medication.rationale, isNotEmpty, reason: medication.id);
        expect(medication.prescriptionTip, isNotEmpty, reason: medication.id);
        expect(medication.exceptions, isNotEmpty, reason: medication.id);
        expect(medication.neuraxial, isNotEmpty, reason: medication.id);
        expect(medication.sources, isNotEmpty, reason: medication.id);
        expect(medication.lastReviewed, '2026-07-17');
        for (final source in medication.sources) {
          expect(source.url, startsWith('https://'), reason: medication.id);
          expect(source.locator, isNotEmpty, reason: medication.id);
        }
      }
    });

    test('バイアスピリンは処方目的とPCI情報で検索できる', () {
      final aspirin = byId('aspirin');
      expect(aspirin.searchText, contains('バイアスピリン'));
      expect(aspirin.searchText, contains('一次予防'));
      expect(aspirin.searchText, contains('pci'));
      expect(aspirin.searchText, contains('ステント'));
    });

    test('コイル塞栓術のアスピリン胃管投与を施設プロトコルとして扱う', () {
      final aspirin = byId('aspirin');
      expect(aspirin.administrationPlan, contains('ステント併用コイル塞栓術'));
      expect(aspirin.administrationPlan, contains('術中負荷'));
      expect(aspirin.administrationPlan, contains('施設プロトコル'));
      expect(aspirin.administrationPlan, contains('腸溶錠'));
      expect(aspirin.administrationPlan, contains('放出制御が失われる'));
      expect(aspirin.administrationPlan, contains('一律用量は表示しない'));
      expect(aspirin.administrationPlan, contains('薬剤部'));
      expect(aspirin.searchText, contains('経管投与'));
    });
  });

  group('区域麻酔の抗血栓薬境界', () {
    test('アスピリンは200mg未満と200mg以上を分ける', () {
      final aspirin = byId('aspirin');
      expect(aspirin.neuraxial, contains('<200 mg/日'));
      expect(aspirin.neuraxial, contains('高用量は3-7日'));
      expect(aspirin.restart, contains('6時間後'));
    });

    test('P2Y12阻害薬の休薬・再開時間を保持する', () {
      expect(byId('clopidogrel').neuraxial, contains('7日休薬'));
      expect(byId('clopidogrel').restart, contains('0時間'));
      expect(byId('prasugrel').restart, contains('24時間後'));
      expect(byId('ticagrelor').neuraxial, contains('5日休薬'));
      expect(byId('ticagrelor').restart, contains('24時間後'));
    });

    test('ワルファリンは5日・INR1.2・抜去後0時間', () {
      final warfarin = byId('warfarin');
      expect(warfarin.holdTiming, contains('5日'));
      expect(warfarin.holdTiming, contains('1.2以下'));
      expect(warfarin.restart, contains('0時間'));
    });

    test('DOACは低用量と標準・高用量を混同しない', () {
      final xa = byId('factor-xa-doac');
      expect(xa.holdTiming, contains('低用量24時間'));
      expect(xa.holdTiming, contains('標準/高用量72時間'));
      expect(xa.restart, contains('低用量で抜去6時間後'));
      expect(xa.restart, contains('標準/高用量で24時間後'));

      final dabigatran = byId('dabigatran');
      expect(dabigatran.holdTiming, contains('48時間'));
      expect(dabigatran.holdTiming, contains('72時間'));
    });

    test('ヘパリン系とフォンダパリヌクスの時間を保持する', () {
      final heparins = byId('heparins');
      expect(heparins.holdTiming, contains('静注UFH 4時間'));
      expect(heparins.holdTiming, contains('皮下注UFH 8-10時間'));
      expect(heparins.holdTiming, contains('エノキサパリン12時間'));
      expect(heparins.restart, contains('UFH 2時間'));
      expect(heparins.restart, contains('エノキサパリン4時間'));

      final fondaparinux = byId('fondaparinux');
      expect(fondaparinux.holdTiming, contains('36時間'));
      expect(fondaparinux.holdTiming, contains('CCr<50では72時間'));
    });
  });

  group('処方目的で結論が変わる薬剤', () {
    test('ACE阻害薬・ARBは高血圧とHFrEFを分ける', () {
      final raas = byId('raas-inhibitors');
      expect(raas.scenarios.map((s) => s.label), contains('高血圧単独 + 高リスク手術'));
      expect(raas.scenarios.map((s) => s.label), contains('HFrEF'));
      expect(
        raas.scenarios.singleWhere((s) => s.label == 'HFrEF').action,
        PerioperativeAction.continueMedication,
      );
    });

    test('SGLT2は通常薬とエルツグリフロジンの最終投与日を分ける', () {
      final sglt2 = byId('sglt2-inhibitors');
      expect(sglt2.holdTiming, contains('最終D-4'));
      expect(sglt2.holdTiming, contains('最終D-5'));
    });

    test('エストロゲン配合剤は大手術と小手術を分ける', () {
      final chc = byId('combined-hormonal-contraceptives');
      expect(chc.holdTiming, contains('28日前'));
      expect(chc.scenarios.length, 2);
      expect(chc.searchText, contains('月経困難症'));
      expect(chc.searchText, contains('代替避妊'));
    });

    test('デノスマブは計画なく遅延・中止しない', () {
      final denosumab = byId('denosumab');
      expect(denosumab.defaultAction, PerioperativeAction.continueMedication);
      expect(denosumab.rationale, contains('反跳'));
      expect(denosumab.restart, contains('後続の骨吸収抑制薬'));
    });
  });
}
