import 'dart:math' as math;

/// 体重換算上限と製剤上限の低い方を返す.
double? computeCappedLocalAnestheticDose({
  required double weightKg,
  required double mgPerKg,
  required double absoluteMaxMg,
}) {
  if (weightKg <= 0 || mgPerKg <= 0 || absoluteMaxMg <= 0) return null;
  return math.min(weightKg * mgPerKg, absoluteMaxMg);
}
