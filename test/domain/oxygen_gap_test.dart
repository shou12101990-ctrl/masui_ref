import 'package:flutter_test/flutter_test.dart';
import 'package:masui_ref/domain/calculators/oxygen_gap.dart';

void main() {
  group('computeOxygenGap', () {
    test('既定値 (Hb14, SaO2 98, SvO2 70)を正しく計算する', () {
      final r = computeOxygenGap(hb: 14, sao2: 98, svo2: 70)!;
      // CaO2 = 1.34 * 14 * 0.98 = 18.3848
      expect(r.caO2, closeTo(18.3848, 1e-4));
      // CvO2 = 1.34 * 14 * 0.70 = 13.132
      expect(r.cvO2, closeTo(13.132, 1e-4));
      // gap = 5.2528
      expect(r.gap, closeTo(5.2528, 1e-4));
      // O2ER = gap / caO2 * 100 = 28.57%
      expect(r.o2er, closeTo(28.572, 1e-2));
    });

    test('いずれかが null なら null', () {
      expect(computeOxygenGap(hb: null, sao2: 98, svo2: 70), isNull);
      expect(computeOxygenGap(hb: 14, sao2: null, svo2: 70), isNull);
      expect(computeOxygenGap(hb: 14, sao2: 98, svo2: null), isNull);
    });

    test('0以下は無効として null', () {
      expect(computeOxygenGap(hb: 0, sao2: 98, svo2: 70), isNull);
      expect(computeOxygenGap(hb: 14, sao2: -1, svo2: 70), isNull);
    });

    test('SaO2 = SvO2 なら較差0・O2ER0', () {
      final r = computeOxygenGap(hb: 14, sao2: 90, svo2: 90)!;
      expect(r.gap, closeTo(0, 1e-9));
      expect(r.o2er, closeTo(0, 1e-9));
    });
  });
}
