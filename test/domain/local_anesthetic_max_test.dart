import 'package:flutter_test/flutter_test.dart';
import 'package:masui_ref/domain/calculators/local_anesthetic_max.dart';

void main() {
  group('computeCappedLocalAnestheticDose', () {
    test('体重換算値が製剤上限より低ければ体重換算値を返す', () {
      expect(
        computeCappedLocalAnestheticDose(
          weightKg: 50,
          mgPerKg: 4,
          absoluteMaxMg: 300,
        ),
        200,
      );
    });

    test('製剤上限を超えて体重比例しない', () {
      expect(
        computeCappedLocalAnestheticDose(
          weightKg: 100,
          mgPerKg: 7,
          absoluteMaxMg: 500,
        ),
        500,
      );
    });

    test('0以下の入力は無効', () {
      expect(
        computeCappedLocalAnestheticDose(
          weightKg: 0,
          mgPerKg: 4,
          absoluteMaxMg: 200,
        ),
        isNull,
      );
    });
  });
}
