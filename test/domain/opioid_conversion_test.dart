import 'package:flutter_test/flutter_test.dart';
import 'package:masui_ref/domain/calculators/opioid_conversion.dart';

void main() {
  group('computeOpioidConversion', () {
    test('経口モルヒネ60mg/日 → フェンタ600μg/日・25μg/h', () {
      final r = computeOpioidConversion(doseMgPerDay: 60, toMorphineFactor: 1.0)!;
      expect(r.oralMorphineEqMgPerDay, closeTo(60, 1e-9));
      expect(r.fentanylMcgPerDay, closeTo(600, 1e-9));
      expect(r.fentanylMcgPerHour, closeTo(25, 1e-9));
    });

    test('オキシコドン40mg/日(係数1.5) → モルヒネ60相当 → 25μg/h', () {
      final r = computeOpioidConversion(doseMgPerDay: 40, toMorphineFactor: 1.5)!;
      expect(r.oralMorphineEqMgPerDay, closeTo(60, 1e-9));
      expect(r.fentanylMcgPerHour, closeTo(25, 1e-9));
    });

    test('無効入力は null', () {
      expect(computeOpioidConversion(doseMgPerDay: null, toMorphineFactor: 1.0),
          isNull);
      expect(
          computeOpioidConversion(doseMgPerDay: 0, toMorphineFactor: 1.0), isNull);
    });
  });
}
