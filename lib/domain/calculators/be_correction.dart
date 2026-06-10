/// メイロン (重炭酸Na)による BE 補正の計算ロジック (UI非依存).
///
/// HCO3- 不足分 (mEq) = 0.3 x 体重(kg) x |BE|.
/// 推奨補正量は不足分の半量. メイロン 8.4% = 1 mEq/mL, 7% = 0.833 mEq/mL.
/// 入力は正の数 (塩基不足の大きさ)で, BE = -beMagnitude として扱う.
library;

const double meylonConc84 = 1.0; // 8.4% = 1 mEq/mL
const double meylonConc7 = 0.833; // 7% = 0.833 mEq/mL

class BeCorrectionResult {
  final double deficitMEq; // HCO3- 不足分 (mEq)
  final double halfMEq; // 半量補正 (mEq)
  final double meylon84mL; // メイロン 8.4% 投与量 (mL)
  final double meylon7mL; // メイロン 7% 投与量 (mL)
  const BeCorrectionResult({
    required this.deficitMEq,
    required this.halfMEq,
    required this.meylon84mL,
    required this.meylon7mL,
  });
}

/// BEの絶対値(beMagnitude)と体重から補正量を計算する.
/// beMagnitude が null, または体重が null/0以下なら null.
BeCorrectionResult? computeBeCorrection({
  double? beMagnitude,
  double? weightKg,
}) {
  if (beMagnitude == null) return null;
  if (weightKg == null || weightKg <= 0) return null;

  final mag = beMagnitude.abs();
  final deficit = 0.3 * weightKg * mag;
  final half = deficit / 2.0;
  return BeCorrectionResult(
    deficitMEq: deficit,
    halfMEq: half,
    meylon84mL: half / meylonConc84,
    meylon7mL: half / meylonConc7,
  );
}
