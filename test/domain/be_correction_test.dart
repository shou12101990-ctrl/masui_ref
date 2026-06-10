import 'package:flutter_test/flutter_test.dart';
import 'package:masui_ref/domain/calculators/be_correction.dart';

void main() {
  group('computeBeCorrection', () {
    test('BE10・体重60 → 不足分180・半量90・8.4%90mL・7%108mL', () {
      final r = computeBeCorrection(beMagnitude: 10, weightKg: 60)!;
      expect(r.deficitMEq, closeTo(180, 1e-6)); // 0.3*60*10
      expect(r.halfMEq, closeTo(90, 1e-6));
      expect(r.meylon84mL, closeTo(90, 1e-6)); // /1.0
      expect(r.meylon7mL, closeTo(90 / 0.833, 1e-6)); // ≒108
    });

    test('負の入力も絶対値で扱う', () {
      final r = computeBeCorrection(beMagnitude: -10, weightKg: 60)!;
      expect(r.deficitMEq, closeTo(180, 1e-6));
    });

    test('入力0なら不足分0', () {
      final r = computeBeCorrection(beMagnitude: 0, weightKg: 60)!;
      expect(r.deficitMEq, 0);
      expect(r.meylon84mL, 0);
    });

    test('無効入力は null', () {
      expect(computeBeCorrection(beMagnitude: null, weightKg: 60), isNull);
      expect(computeBeCorrection(beMagnitude: 10, weightKg: null), isNull);
      expect(computeBeCorrection(beMagnitude: 10, weightKg: 0), isNull);
    });
  });
}
