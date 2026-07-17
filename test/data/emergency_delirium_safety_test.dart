import 'package:flutter_test/flutter_test.dart';
import 'package:masui_ref/data/emergency_delirium.dart';

void main() {
  group('覚醒時興奮・術後せん妄記事の安全性境界', () {
    test('せん妄と決めつけずABCと可逆的原因を検索する', () {
      expect(emergenceDeliriumAssessment, contains('決めつけない'));
      expect(emergenceDeliriumAssessment, contains('低酸素'));
      expect(emergenceDeliriumAssessment, contains('高CO2'));
      expect(emergenceDeliriumAssessment, contains('TOF'));
      expect(emergenceDeliriumAssessment, contains('低血糖'));
      expect(emergenceDeliriumAssessment, contains('脳卒中・痙攣'));
    });

    test('疼痛の過少治療とオピオイド過量を両方扱う', () {
      expect(emergenceDeliriumPain, contains('未治療の疼痛'));
      expect(emergenceDeliriumPain, contains('オピオイド過量'));
      expect(emergenceDeliriumPain, contains('NRS'));
      expect(emergenceDeliriumPain, contains('CPOT/BPS'));
      expect(emergenceDeliriumPain, contains('10-25mcg'));
      expect(emergenceDeliriumPain, contains('鎮痛後に認知状態を再評価'));
    });

    test('DEXをルーチン薬にせず循環副作用を明示する', () {
      expect(emergenceDeliriumDex, contains('根拠は限定的'));
      expect(emergenceDeliriumDex, contains('心臓手術後'));
      expect(emergenceDeliriumDex, contains('0.2mcg/kg/h'));
      expect(emergenceDeliriumDex, contains('急速bolusを避け'));
      expect(emergenceDeliriumDex, contains('徐脈'));
      expect(emergenceDeliriumDex, contains('低血圧'));
      expect(emergenceDeliriumDex, contains('ルーチン投与しない'));
    });

    test('ハロペリドールは危険な過活動型へ低用量短期間に限定する', () {
      expect(emergenceDeliriumHaloperidol, contains('過活動型に限る'));
      expect(emergenceDeliriumHaloperidol, contains('低活動型'));
      expect(emergenceDeliriumHaloperidol, contains('0.125-0.25mg'));
      expect(emergenceDeliriumHaloperidol, contains('1日総量3mg未満'));
      expect(emergenceDeliriumHaloperidol, contains('QTc'));
      expect(emergenceDeliriumHaloperidol, contains('Parkinson病'));
      expect(emergenceDeliriumHaloperidol, contains('Lewy小体型認知症'));
      expect(emergenceDeliriumHaloperidol, contains('静かになった = せん妄が治った'));
    });

    test('ベンゾジアゼピンの例外と非薬物介入を明記する', () {
      expect(emergenceDeliriumNonDrug, contains('眼鏡'));
      expect(emergenceDeliriumNonDrug, contains('補聴器'));
      expect(emergenceDeliriumNonDrug, contains('身体拘束'));
      expect(emergenceDeliriumNonDrug, contains('通常のPOD治療に使わない'));
      expect(emergenceDeliriumNonDrug, contains('離脱または痙攣は例外'));
    });

    test('根拠と更新日を保持する', () {
      expect(emergenceDeliriumLastReviewed, '2026-07-18');
      expect(emergenceDeliriumEvidence, contains('ESAIC 2024'));
      expect(emergenceDeliriumEvidence, contains('SCCM 2025'));
      expect(
        emergenceDeliriumEvidence,
        contains('American Geriatrics Society'),
      );
    });
  });
}
