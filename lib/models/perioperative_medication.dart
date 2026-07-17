/// 周術期における内服・注射薬の継続／休薬情報。
///
/// 同一薬でも処方目的、手術の出血リスク、腎機能、区域麻酔の有無で
/// 推奨が変わるため、単一の休薬日数ではなく [scenarios] で条件を表す。
class PerioperativeMedication {
  final String id;
  final String name;
  final String brands;
  final List<String> aliases;
  final PerioperativeMedicationCategory category;
  final PerioperativeAction defaultAction;
  final String dayOfSurgery;
  final String holdTiming;
  final String restart;
  final String rationale;
  final String prescriptionTip;
  final String exceptions;
  final String neuraxial;
  final List<PerioperativeScenario> scenarios;
  final List<EvidenceSource> sources;
  final String lastReviewed;

  const PerioperativeMedication({
    required this.id,
    required this.name,
    required this.brands,
    this.aliases = const [],
    required this.category,
    required this.defaultAction,
    required this.dayOfSurgery,
    required this.holdTiming,
    required this.restart,
    required this.rationale,
    required this.prescriptionTip,
    required this.exceptions,
    required this.neuraxial,
    this.scenarios = const [],
    required this.sources,
    this.lastReviewed = '2026-07-17',
  });

  String get searchText => [
    name,
    brands,
    ...aliases,
    category.label,
    dayOfSurgery,
    holdTiming,
    rationale,
    prescriptionTip,
    exceptions,
    neuraxial,
    ...scenarios.expand((s) => [s.label, s.timing, s.rationale]),
  ].join(' ').toLowerCase();
}

class PerioperativeScenario {
  final String label;
  final PerioperativeAction action;
  final String timing;
  final String rationale;

  const PerioperativeScenario({
    required this.label,
    required this.action,
    required this.timing,
    required this.rationale,
  });
}

class EvidenceSource {
  final String title;
  final String organization;
  final String year;
  final String url;
  final String locator;

  const EvidenceSource({
    required this.title,
    required this.organization,
    required this.year,
    required this.url,
    required this.locator,
  });
}

enum PerioperativeAction {
  continueMedication('継続'),
  hold('中止'),
  adjust('調整'),
  individualize('個別判断');

  final String label;
  const PerioperativeAction(this.label);
}

enum PerioperativeMedicationCategory {
  antiplatelet('抗血小板薬'),
  anticoagulant('抗凝固薬'),
  cardiovascular('循環器薬'),
  diabetes('糖尿病薬'),
  endocrine('内分泌薬'),
  psychiatricNeurologic('精神・神経薬'),
  immunosuppressant('免疫・抗リウマチ薬'),
  respiratory('呼吸器薬'),
  analgesic('鎮痛薬'),
  gi('消化器薬'),
  hormone('ホルモン・骨代謝薬'),
  supplement('サプリ・漢方'),
  other('その他');

  final String label;
  const PerioperativeMedicationCategory(this.label);
}
