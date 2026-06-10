/// 酸素較差の計算ロジック (UIに依存しない純粋ロジック).
///
/// Hb (g/dL), SaO2 (%), SvO2 (%) から
/// 動脈血/混合静脈血酸素含量, 動静脈較差 (CaO2 - CvO2), O2ER を算出する.
/// 溶存酸素 (0.0031 x PaO2)は無視している.
library;

class OxygenGapResult {
  final double caO2; // 動脈血酸素含量 (mL/dL)
  final double cvO2; // 混合静脈血酸素含量 (mL/dL)
  final double gap; // 動静脈酸素含量較差 CaO2 - CvO2 (mL/dL)
  final double o2er; // 酸素摂取率 (%)
  const OxygenGapResult({
    required this.caO2,
    required this.cvO2,
    required this.gap,
    required this.o2er,
  });
}

/// Hb・SaO2・SvO2 から酸素較差を計算する.
/// いずれかが null または 0以下なら null を返す (入力未完/無効).
OxygenGapResult? computeOxygenGap({
  double? hb,
  double? sao2,
  double? svo2,
}) {
  if (hb == null || hb <= 0) return null;
  if (sao2 == null || sao2 <= 0) return null;
  if (svo2 == null || svo2 <= 0) return null;

  final caO2 = 1.34 * hb * (sao2 / 100.0);
  final cvO2 = 1.34 * hb * (svo2 / 100.0);
  final gap = caO2 - cvO2;
  final o2er = caO2 > 0 ? gap / caO2 * 100.0 : 0.0;

  return OxygenGapResult(caO2: caO2, cvO2: cvO2, gap: gap, o2er: o2er);
}
