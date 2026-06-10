/// γ計算 (流量・投与量の相互変換, 一括流量)の純粋ロジック (UI非依存).
library;

/// 入力単位 (画面の _Unit に1:1対応).
enum InfusionUnit { gamma, mlPerH, mgPerH, mgPerKgPerH, mcgPerKgPerH }

/// 薬剤希釈から濃度 (mg/mL)を求める. mlが0以下/未入力なら null.
double? concentrationMgPerMl(double? drugMg, double? totalMl) {
  if (drugMg == null || totalMl == null || totalMl <= 0) return null;
  return drugMg / totalMl;
}

/// 入力値を mg/h に正規化する. 計算不能なら null.
/// - gamma(μg/kg/min): x 体重 x 60 / 1000
/// - ml/h: x 濃度(mg/mL) (濃度不明なら null)
/// - mg/h: そのまま
/// - mg/kg/h: x 体重
/// - μg/kg/h: x 体重 / 1000
double? normalizeToMgPerH({
  required double? value,
  required InfusionUnit unit,
  double? concMgPerMl,
  required double weightKg,
}) {
  if (value == null) return null;
  switch (unit) {
    case InfusionUnit.mlPerH:
      if (concMgPerMl == null || concMgPerMl <= 0) return null;
      return value * concMgPerMl;
    case InfusionUnit.gamma:
      return value * weightKg * 60 / 1000;
    case InfusionUnit.mgPerH:
      return value;
    case InfusionUnit.mgPerKgPerH:
      return value * weightKg;
    case InfusionUnit.mcgPerKgPerH:
      return value * weightKg / 1000;
  }
}

/// 一括流量 mL/h = γ x 体重 x 60 / 濃度(μg/mL).
double gammaFlowMlPerH(double gamma, double weightKg, double concMcgPerMl) =>
    gamma * weightKg * 60 / concMcgPerMl;
