import 'package:flutter/material.dart';

import '../models/perioperative_medication.dart';

extension PerioperativeActionVisuals on PerioperativeAction {
  Color get color => switch (this) {
    PerioperativeAction.continueMedication => const Color(0xFF087F5B),
    PerioperativeAction.hold => const Color(0xFFC92A2A),
    PerioperativeAction.adjust => const Color(0xFFB26A00),
    PerioperativeAction.individualize => const Color(0xFF5F3DC4),
  };

  IconData get icon => switch (this) {
    PerioperativeAction.continueMedication => Icons.play_circle_outline,
    PerioperativeAction.hold => Icons.pause_circle_outline,
    PerioperativeAction.adjust => Icons.tune,
    PerioperativeAction.individualize => Icons.alt_route,
  };
}

extension PerioperativeCategoryVisuals on PerioperativeMedicationCategory {
  Color get color => switch (this) {
    PerioperativeMedicationCategory.antiplatelet => const Color(0xFFB42318),
    PerioperativeMedicationCategory.anticoagulant => const Color(0xFF8B1E3F),
    PerioperativeMedicationCategory.cardiovascular => const Color(0xFF276FBF),
    PerioperativeMedicationCategory.diabetes => const Color(0xFF00796B),
    PerioperativeMedicationCategory.endocrine => const Color(0xFF6D4C41),
    PerioperativeMedicationCategory.psychiatricNeurologic => const Color(
      0xFF6750A4,
    ),
    PerioperativeMedicationCategory.immunosuppressant => const Color(
      0xFF9C5A00,
    ),
    PerioperativeMedicationCategory.respiratory => const Color(0xFF0B7285),
    PerioperativeMedicationCategory.analgesic => const Color(0xFF4C6EF5),
    PerioperativeMedicationCategory.gi => const Color(0xFF2B8A3E),
    PerioperativeMedicationCategory.hormone => const Color(0xFFB83280),
    PerioperativeMedicationCategory.supplement => const Color(0xFF5C7C3A),
    PerioperativeMedicationCategory.other => const Color(0xFF6C757D),
  };
}
