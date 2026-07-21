import 'package:flutter_test/flutter_test.dart';
import 'package:masui_ref/data/drugs/sedative.dart';
import 'package:masui_ref/models/drug.dart';

void main() {
  group('鎮静薬マスタの安全性回帰', () {
    test('レミマゾラム導入は持続注入であり1-2mg/kgボーラスではない', () {
      final drug = kSedativeDrugs.singleWhere((d) => d.name.contains('レミマゾラム'));
      final text = drug.notes.map((note) => note.body).join(' ');

      expect(drug.dose, contains('12mg/kg/h'));
      expect(text, contains('ボーラスではなく'));
      expect(text, isNot(contains('0.2mg/kg(50kg=10mg)')));
    });

    test('デクスメデトミジン負荷は総量1mcg/kg', () {
      final drug = kSedativeDrugs.singleWhere(
        (d) => d.name.contains('デクスメデトミジン'),
      );
      expect(drug.dose, contains('6mcg/kg/hで10分'));
      expect(drug.dose, contains('総量1mcg/kg'));
    });

    test('フルマゼニルの通常総投与量上限は1mg', () {
      final drug = kSedativeDrugs.singleWhere((d) => d.name.contains('フルマゼニル'));
      expect(drug.dose, contains('総量は通常1mgまで'));
      expect(drug.dose, isNot(contains('20分毎')));
    });

    test('フルマゼニルは慢性BZ使用時の離脱と痙攣を警告する', () {
      final drug = kSedativeDrugs.singleWhere((d) => d.name.contains('フルマゼニル'));
      final text = [
        ...drug.notes.map((note) => '${note.heading} ${note.body}'),
        ...drug.contraindications.map(
          (item) => '${item.target} ${item.reason}',
        ),
      ].join(' ');

      expect(text, contains('急性離脱'));
      expect(text, contains('痙攣'));
      expect(text, contains('てんかん患者'));
      expect(text, contains('三環系・四環系抗うつ薬'));
      expect(text, contains('少量ずつ緩徐投与'));
    });

    test('8剤すべて電子添文の版とPMDA URLを保持する', () {
      expect(kSedativeDrugs, hasLength(8));
      for (final drug in kSedativeDrugs) {
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

    test('電子添文と施設運用を別区分で保持する', () {
      for (final name in [
        'プロポフォール',
        'チオペンタール',
        'チアミラール',
        'ミダゾラム',
        'レミマゾラム',
        'デクスメデトミジン',
      ]) {
        final drug = kSedativeDrugs.singleWhere((d) => d.name.contains(name));
        expect(
          drug.notes.any((note) => note.type == DrugNoteType.packageInsert),
          isTrue,
          reason: name,
        );
        expect(
          drug.notes.any((note) => note.type == DrugNoteType.facilityPractice),
          isTrue,
          reason: name,
        );
      }
    });

    test('バルビツール酸系は添付注射用水で調製し危険な旧記載を除く', () {
      final thiopental = kSedativeDrugs.singleWhere((d) => d.name == 'チオペンタール');
      final thiamylal = kSedativeDrugs.singleWhere((d) => d.name == 'チアミラール');

      expect(thiopental.dilution, contains('注射用水'));
      expect(thiamylal.dilution, contains('注射用水'));
      expect(thiopental.dilution, isNot(contains('NS')));
      expect(thiamylal.dilution, isNot(contains('NS')));
      expect(thiamylal.searchText, isNot(contains('3-6γ')));
      expect(thiopental.searchText, isNot(contains('アナペイン')));
      expect(thiamylal.searchText, isNot(contains('アナペイン')));
    });

    test('プロポフォールは承認用量と小児ICU禁忌を保持する', () {
      final drug = kSedativeDrugs.singleWhere((d) => d.name == 'プロポフォール');
      expect(drug.dose, contains('2.0-2.5mg/kg'));
      expect(drug.dose, contains('4-10mg/kg/h'));
      expect(drug.dose, contains('0.3-3.0mg/kg/h'));
      expect(
        drug.contraindications.any((item) => item.target.contains('小児')),
        isTrue,
      );
      expect(drug.searchText, isNot(contains('軽い呼吸抑制')));
    });

    test('ケタミンは両規格と適応外鎮痛区分を保持する', () {
      final drug = kSedativeDrugs.singleWhere((d) => d.name == 'ケタミン');
      expect(drug.spec, contains('50mg/5mL'));
      expect(drug.spec, contains('200mg/20mL'));
      expect(
        drug.notes.any((note) => note.type == DrugNoteType.offLabel),
        isTrue,
      );
    });
  });
}
