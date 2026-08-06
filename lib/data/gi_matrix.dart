import '../models/simple_matrix.dart';

/// 便秘薬・消化管運動改善薬の一覧表.
/// 原典は Book4.xlsx「その他」シートの便秘薬ブロック (上 / 下 / 軟便化 / 蠕動改善).
const List<SimpleMatrixRow> kLaxativeMatrix = <SimpleMatrixRow>[];

/// 整腸剤 (プロバイオティクス)の一覧表. 列は製剤に含まれる菌種.
const List<SimpleMatrixRow> kProbioticMatrix = <SimpleMatrixRow>[];
