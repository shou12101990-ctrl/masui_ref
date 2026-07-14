import 'package:flutter_test/flutter_test.dart';
import 'package:masui_ref/data/drugs/sedative.dart';

void main() {
  group('鎮静薬マスタの安全性回帰', () {
    test('レミマゾラム導入は持続注入であり1-2mg/kgボーラスではない', () {
      final drug = kSedativeDrugs.singleWhere((d) => d.name.contains('レミマゾラム'));
      expect(drug.dose, contains('12mg/kg/h'));
      expect(drug.notes.first.body, contains('ボーラス導入ではない'));
      expect(drug.notes.first.body, isNot(contains('0.2mg/kg(50kg=10mg)')));
    });

    test('デクスメデトミジン負荷は総量1mcg/kg', () {
      final drug = kSedativeDrugs.singleWhere(
        (d) => d.name.contains('デクスメデトミジン'),
      );
      expect(drug.dose, contains('6mcg/kg/hで10min'));
      expect(drug.dose, contains('計1mcg/kg'));
    });

    test('フルマゼニルの通常総投与量上限は1mg', () {
      final drug = kSedativeDrugs.singleWhere((d) => d.name.contains('フルマゼニル'));
      expect(drug.dose, contains('通常上限1mg'));
      expect(drug.dose, isNot(contains('20分毎')));
    });
  });
}
