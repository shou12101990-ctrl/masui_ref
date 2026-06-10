import 'package:flutter_test/flutter_test.dart';
import 'package:masui_ref/domain/calculators/gamma.dart';

void main() {
  group('concentrationMgPerMl', () {
    test('150mg/50mL = 3 mg/mL', () {
      expect(concentrationMgPerMl(150, 50), closeTo(3.0, 1e-9));
    });
    test('ml<=0 / null は null', () {
      expect(concentrationMgPerMl(150, 0), isNull);
      expect(concentrationMgPerMl(null, 50), isNull);
    });
  });

  group('normalizeToMgPerH', () {
    const w = 60.0;
    test('gamma 3 → mg/h (3*60*60/1000=10.8)', () {
      expect(
          normalizeToMgPerH(
              value: 3, unit: InfusionUnit.gamma, weightKg: w),
          closeTo(10.8, 1e-9));
    });
    test('ml/h は濃度を掛ける (2ml/h × 3mg/mL = 6mg/h)', () {
      expect(
          normalizeToMgPerH(
              value: 2,
              unit: InfusionUnit.mlPerH,
              concMgPerMl: 3,
              weightKg: w),
          closeTo(6.0, 1e-9));
    });
    test('ml/h で濃度不明なら null', () {
      expect(
          normalizeToMgPerH(value: 2, unit: InfusionUnit.mlPerH, weightKg: w),
          isNull);
    });
    test('mg/h はそのまま, mg/kg/h は×体重, μg/kg/h は×体重/1000', () {
      expect(normalizeToMgPerH(value: 5, unit: InfusionUnit.mgPerH, weightKg: w),
          5);
      expect(
          normalizeToMgPerH(value: 0.1, unit: InfusionUnit.mgPerKgPerH, weightKg: w),
          closeTo(6.0, 1e-9));
      expect(
          normalizeToMgPerH(value: 100, unit: InfusionUnit.mcgPerKgPerH, weightKg: w),
          closeTo(6.0, 1e-9));
    });
    test('value null は null', () {
      expect(
          normalizeToMgPerH(value: null, unit: InfusionUnit.gamma, weightKg: w),
          isNull);
    });
  });

  group('gammaFlowMlPerH', () {
    test('ノルアド0.05γ・60kg・100μg/mL → 1.8 mL/h', () {
      expect(gammaFlowMlPerH(0.05, 60, 100), closeTo(1.8, 1e-9));
    });
    test('ランジオロール5γ・60kg・3000μg/mL → 6.0 mL/h', () {
      expect(gammaFlowMlPerH(5, 60, 3000), closeTo(6.0, 1e-9));
    });
  });
}
