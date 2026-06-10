import 'package:flutter_test/flutter_test.dart';
import 'package:masui_ref/domain/calculators/allowable_blood_loss.dart';

void main() {
  group('computeAllowableBloodLoss', () {
    test('成人70mL/kg・体重60・Hb 12→7 (Gross式)', () {
      final r = computeAllowableBloodLoss(
          weightKg: 60, hb0: 12, hbTarget: 7, mlPerKg: 70)!;
      expect(r.ebv, closeTo(4200, 1e-6)); // 60*70
      // mean = 9.5, abl = 4200*(5)/9.5 = 2210.5...
      expect(r.abl, closeTo(4200 * 5 / 9.5, 1e-6));
    });

    test('Hb初期 <= 許容 なら ABL=0', () {
      final r = computeAllowableBloodLoss(
          weightKg: 60, hb0: 7, hbTarget: 7, mlPerKg: 70)!;
      expect(r.ebv, closeTo(4200, 1e-6));
      expect(r.abl, 0);
      final r2 = computeAllowableBloodLoss(
          weightKg: 60, hb0: 6, hbTarget: 7, mlPerKg: 70)!;
      expect(r2.abl, 0);
    });

    test('係数を反映 (小児80mL/kg)', () {
      final r = computeAllowableBloodLoss(
          weightKg: 20, hb0: 12, hbTarget: 7, mlPerKg: 80)!;
      expect(r.ebv, closeTo(1600, 1e-6)); // 20*80
    });

    test('無効入力は null', () {
      expect(
          computeAllowableBloodLoss(
              weightKg: null, hb0: 12, hbTarget: 7, mlPerKg: 70),
          isNull);
      expect(
          computeAllowableBloodLoss(
              weightKg: 0, hb0: 12, hbTarget: 7, mlPerKg: 70),
          isNull);
      expect(
          computeAllowableBloodLoss(
              weightKg: 60, hb0: null, hbTarget: 7, mlPerKg: 70),
          isNull);
    });
  });
}
