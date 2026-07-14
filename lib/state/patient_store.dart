import 'package:flutter/foundation.dart';

/// 性別.
enum Sex {
  male('男性'),
  female('女性');

  final String label;
  const Sex(this.label);
}

/// アプリ全体で共有する患者情報 (年齢・身長・体重・性別).
/// 計算機タブのTOPで一度入力すると, 各計算機がこれを自動参照する.
/// 値が未入力 (null)のときは各 *Or getter がデフォルト値を返す.
class PatientStore extends ChangeNotifier {
  PatientStore._();
  static final PatientStore instance = PatientStore._();

  int? age; // 歳
  int? heightCm; // cm
  double? weightKg; // kg
  Sex? sex;

  // 未入力時に計算機が用いるデフォルト
  static const int defaultAge = 60;
  static const int defaultHeightCm = 160;
  static const double defaultWeightKg = 50.0;
  static const Sex defaultSex = Sex.male;

  int get ageOr => age ?? defaultAge;
  int get heightOr => heightCm ?? defaultHeightCm;
  double get weightOr => weightKg ?? defaultWeightKg;
  Sex get sexOr => sex ?? defaultSex;

  bool get hasAny =>
      age != null || heightCm != null || weightKg != null || sex != null;
  bool get isComplete =>
      age != null && heightCm != null && weightKg != null && sex != null;

  void setAge(int? v) {
    age = v;
    notifyListeners();
  }

  void setHeight(int? v) {
    heightCm = v;
    notifyListeners();
  }

  void setWeight(double? v) {
    weightKg = v;
    notifyListeners();
  }

  void setSex(Sex? v) {
    sex = v;
    notifyListeners();
  }

  void clear() {
    age = null;
    heightCm = null;
    weightKg = null;
    sex = null;
    notifyListeners();
  }
}
