import '../models/simple_matrix.dart';

/// 利尿薬の一覧表. 原典は Book4.xlsx「その他」シートの利尿薬ブロック.
/// マトリクスの列は kDiureticCols (作用部位5列 + 利尿の型2列).
const List<SimpleMatrixRow> kDiureticMatrix = <SimpleMatrixRow>[];
