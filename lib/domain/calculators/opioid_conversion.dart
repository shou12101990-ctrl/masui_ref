/// オピオイド換算の計算ロジック (UI非依存).
///
/// 内服オピオイド量(mg/日) x 経口モルヒネ換算係数 = 経口モルヒネ換算(mg/日).
/// 経口モルヒネ 60mg/日 ≒ フェンタニル 0.6mg/日(600μg) より, フェンタμg/日 = 経口モルヒネmg/日 x 10.
library;

class OpioidConversionResult {
  final double oralMorphineEqMgPerDay; // 経口モルヒネ換算 (mg/日)
  final double fentanylMcgPerDay; // フェンタニル (μg/日)
  final double fentanylMcgPerHour; // フェンタニル持続 (μg/h)
  const OpioidConversionResult({
    required this.oralMorphineEqMgPerDay,
    required this.fentanylMcgPerDay,
    required this.fentanylMcgPerHour,
  });
}

/// 内服量(mg/日)と経口モルヒネ換算係数からフェンタニル換算を計算する.
/// 量が null/0以下なら null.
OpioidConversionResult? computeOpioidConversion({
  double? doseMgPerDay,
  required double toMorphineFactor,
}) {
  if (doseMgPerDay == null || doseMgPerDay <= 0) return null;
  final omeq = doseMgPerDay * toMorphineFactor;
  final fentaDay = omeq * 10.0;
  return OpioidConversionResult(
    oralMorphineEqMgPerDay: omeq,
    fentanylMcgPerDay: fentaDay,
    fentanylMcgPerHour: fentaDay / 24.0,
  );
}
