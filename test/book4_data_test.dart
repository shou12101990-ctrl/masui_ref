import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masui_ref/data/diuretic_matrix.dart';
import 'package:masui_ref/data/drugs.dart';
import 'package:masui_ref/data/gi_matrix.dart';
import 'package:masui_ref/models/simple_matrix.dart';

/// Book4 由来のデータ (利尿薬 / 便秘薬 / 整腸剤)の整合性を確認する.
void main() {
  final sets = <String, (List<SimpleMatrixRow>, List<String>)>{
    '利尿薬': (kDiureticMatrix, kDiureticCols),
    '便秘薬': (kLaxativeMatrix, kLaxativeCols),
    '整腸剤': (kProbioticMatrix, kProbioticCols),
  };

  test('マトリクスが空でない', () {
    sets.forEach((name, v) {
      expect(v.$1, isNotEmpty, reason: '$name のデータが空');
    });
  });

  test('marks のキーが定義済みの列だけを使っている', () {
    sets.forEach((name, v) {
      final (rows, cols) = v;
      for (final r in rows) {
        for (final k in r.marks.keys) {
          expect(cols, contains(k), reason: '$name / ${r.generic}: 未定義の列 $k');
        }
      }
    });
  });

  test('marks の値が凡例の記号だけを使っている', () {
    sets.forEach((name, v) {
      for (final r in v.$1) {
        for (final e in r.marks.entries) {
          expect(kSimpleMarkLegend.keys, contains(e.value),
              reason: '$name / ${r.generic}: 未定義の記号 ${e.value}');
        }
      }
    });
  });

  test('同じ上位分類の行が連続している (縦帯が分断されない)', () {
    sets.forEach((name, v) {
      final seen = <String>[];
      String? prev;
      for (final r in v.$1) {
        if (r.group != prev) {
          expect(seen, isNot(contains(r.group)),
              reason: '$name: 上位分類 ${r.group} が離れた位置に再登場している');
          seen.add(r.group);
          prev = r.group;
        }
      }
    });
  });

  test('表示テキストに全角の記号が混ざっていない', () {
    final bad = RegExp('[、。（）：]');
    sets.forEach((name, v) {
      for (final r in v.$1) {
        for (final s in [
          r.group,
          r.generic,
          r.brand,
          r.spec,
          r.dose,
          r.doseLimit,
          r.effect,
          r.mechanism,
          r.note,
        ]) {
          expect(bad.hasMatch(s), isFalse, reason: '$name / ${r.generic}: $s');
        }
      }
    });
  });

  test('薬剤マスタに一般名の重複が無い', () {
    final seen = <String>{};
    final dup = <String>[];
    for (final d in kDrugs) {
      if (!seen.add(d.name)) dup.add(d.name);
    }
    expect(dup, isEmpty, reason: '重複: $dup');
  });

  test('薬剤マスタの doseLimit に全角の記号が混ざっていない', () {
    final bad = RegExp('[、。（）：]');
    for (final d in kDrugs) {
      final s = d.doseLimit;
      if (s == null) continue;
      expect(bad.hasMatch(s), isFalse, reason: '${d.name}: $s');
    }
  });

  testWidgets('縦帯の分類名が省略されずに収まる', (tester) async {
    // 表の描画で使う値と揃えること (simple_matrix_table.dart)
    const rowH = 26.0, groupW = 22.0, fsBand = 7.5, fsBandMin = 4.0;

    String bandLabel(String s) {
      final m = RegExp(r'^(.*?)\s*\(([^)]*)\)').firstMatch(s);
      if (m == null) return s;
      final head = m.group(1)!.trim();
      final inner = m.group(2)!.trim();
      if (head.isEmpty) return inner;
      final isAbbr = RegExp(r'^[A-Za-z0-9\-/. ]+$').hasMatch(inner);
      if (isAbbr && inner.length < head.length) return inner;
      return head;
    }

    final overflow = <String>[];
    sets.forEach((name, v) {
      // 上位分類が連続する区間の長さを数える
      final spans = <(String, int)>[];
      for (final r in v.$1) {
        if (spans.isNotEmpty && spans.last.$1 == r.group) {
          spans[spans.length - 1] = (r.group, spans.last.$2 + 1);
        } else {
          spans.add((r.group, 1));
        }
      }
      for (final s in spans) {
        final label = bandLabel(s.$1);
        final avail = rowH * s.$2 - 5;
        var fits = false;
        for (var fs = fsBand; fs >= fsBandMin; fs -= 0.25) {
          final tp = TextPainter(
            text: TextSpan(
              text: label,
              style: TextStyle(
                fontSize: fs,
                height: 1.05,
                letterSpacing: 0,
                fontWeight: FontWeight.bold,
              ),
            ),
            maxLines: 3,
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: avail);
          if (!tp.didExceedMaxLines && tp.height <= groupW - 1) {
            fits = true;
            break;
          }
        }
        if (!fits) overflow.add('$name: $label (${s.$2}行)');
      }
    });
    expect(overflow, isEmpty, reason: '帯に収まらない分類: $overflow');
  });
}
