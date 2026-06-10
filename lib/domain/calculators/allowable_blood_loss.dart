/// 許容出血量 (ABL)の計算ロジック (UIに依存しない純粋ロジック).
///
/// 循環血液量 EBV = 体重 x 係数(mL/kg).
/// 許容出血量 = EBV x (Hb初期 - Hb許容) / Hb平均   (Gross の式).
library;

class AllowableBloodLossResult {
  final double ebv; // 循環血液量 (mL)
  final double abl; // 許容出血量 (mL)
  const AllowableBloodLossResult({required this.ebv, required this.abl});
}

/// 体重・現在Hb・許容Hb・循環血液量係数(mL/kg)から ABL を計算する.
/// いずれかの数値が null/0以下なら null.
/// Hb初期 <= Hb許容 のときは ABL = 0.
AllowableBloodLossResult? computeAllowableBloodLoss({
  double? weightKg,
  double? hb0,
  double? hbTarget,
  required int mlPerKg,
}) {
  if (weightKg == null || weightKg <= 0) return null;
  if (hb0 == null || hb0 <= 0) return null;
  if (hbTarget == null || hbTarget <= 0) return null;

  final ebv = weightKg * mlPerKg;
  final abl = hb0 <= hbTarget
      ? 0.0
      : ebv * (hb0 - hbTarget) / ((hb0 + hbTarget) / 2.0);
  return AllowableBloodLossResult(ebv: ebv, abl: abl);
}
