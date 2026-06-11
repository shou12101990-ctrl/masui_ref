import 'package:flutter_test/flutter_test.dart';
import 'package:masui_ref/domain/calculators/discharge_score.dart';

void main() {
  group('Modified Aldrete', () {
    test('5項目・満点10・カットオフ9', () {
      expect(aldreteScale.items.length, 5);
      expect(aldreteScale.maxTotal, 10);
      expect(aldreteScale.cutoff, 9);
      expect(aldreteScale.minPerItem, 0);
    });

    test('全項目2点 → 10点で合格', () {
      final r = aldreteScale.evaluate([2, 2, 2, 2, 2]);
      expect(r.total, 10);
      expect(r.maxTotal, 10);
      expect(r.pass, isTrue);
    });

    test('9点で合格, 8点で不合格', () {
      expect(aldreteScale.evaluate([2, 2, 2, 2, 1]).pass, isTrue);
      expect(aldreteScale.evaluate([2, 2, 2, 1, 1]).pass, isFalse);
    });

    test('0点項目があっても合計9点なら合格 (最低点条件なし)', () {
      final r = aldreteScale.evaluate([2, 2, 2, 2, 0]); // 計8 → 不合格
      expect(r.pass, isFalse);
      final r2 = aldreteScale.evaluate([2, 2, 2, 2, 1]); // 計9 → 合格
      expect(r2.hasBelowMinItem, isFalse);
      expect(r2.pass, isTrue);
    });
  });

  group('White-Song', () {
    test('7項目・満点14・カットオフ12・各項目1点以上', () {
      expect(whiteSongScale.items.length, 7);
      expect(whiteSongScale.maxTotal, 14);
      expect(whiteSongScale.cutoff, 12);
      expect(whiteSongScale.minPerItem, 1);
    });

    test('全項目2点 → 14点で合格', () {
      final r = whiteSongScale.evaluate([2, 2, 2, 2, 2, 2, 2]);
      expect(r.total, 14);
      expect(r.pass, isTrue);
    });

    test('12点 (全項目1点以上) で合格', () {
      final r = whiteSongScale.evaluate([2, 2, 2, 2, 2, 1, 1]);
      expect(r.total, 12);
      expect(r.pass, isTrue);
    });

    test('11点では不合格', () {
      final r = whiteSongScale.evaluate([2, 2, 2, 2, 1, 1, 1]);
      expect(r.total, 11);
      expect(r.pass, isFalse);
      expect(r.hasBelowMinItem, isFalse);
    });

    test('合計12点以上でも0点の項目があれば不合格', () {
      final r = whiteSongScale.evaluate([2, 2, 2, 2, 2, 2, 0]);
      expect(r.total, 12);
      expect(r.pass, isFalse);
      expect(r.hasBelowMinItem, isTrue);
    });
  });

  group('MPADSS', () {
    test('5項目・満点10・カットオフ9', () {
      expect(mpadssScale.items.length, 5);
      expect(mpadssScale.maxTotal, 10);
      expect(mpadssScale.cutoff, 9);
      expect(mpadssScale.minPerItem, 0);
    });

    test('9点で帰宅可, 8点で不可', () {
      expect(mpadssScale.evaluate([2, 2, 2, 2, 1]).pass, isTrue);
      expect(mpadssScale.evaluate([2, 2, 2, 1, 1]).pass, isFalse);
    });
  });

  group('スコア定義の整合性', () {
    test('全スケールで各項目の選択肢は 2→1→0 点の3つ', () {
      for (final scale in kDischargeScales) {
        for (final item in scale.items) {
          expect(item.options.map((o) => o.points).toList(), [2, 1, 0],
              reason: '${scale.name} / ${item.name}');
        }
      }
    });

    test('登録順は Aldrete → White-Song → MPADSS', () {
      expect(kDischargeScales.map((s) => s.name).toList(),
          ['Modified Aldrete', 'White-Song', 'MPADSS']);
    });
  });
}
