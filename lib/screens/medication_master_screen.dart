import 'package:flutter/material.dart';

import 'drug_list_screen.dart';
import 'perioperative_medication_screen.dart';

enum _MedicationMaster { anesthesia, perioperative }

class MedicationMasterScreen extends StatefulWidget {
  const MedicationMasterScreen({super.key});

  @override
  State<MedicationMasterScreen> createState() => _MedicationMasterScreenState();
}

class _MedicationMasterScreenState extends State<MedicationMasterScreen> {
  _MedicationMaster _master = _MedicationMaster.anesthesia;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'やさしい麻酔科ローテ β',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<_MedicationMaster>(
                    showSelectedIcon: false,
                    style: const ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                    segments: const [
                      ButtonSegment(
                        value: _MedicationMaster.anesthesia,
                        label: Text('麻酔薬'),
                        icon: Icon(Icons.medication, size: 17),
                      ),
                      ButtonSegment(
                        value: _MedicationMaster.perioperative,
                        label: Text('継続・中止'),
                        icon: Icon(Icons.event_note, size: 17),
                      ),
                    ],
                    selected: {_master},
                    onSelectionChanged: (v) =>
                        setState(() => _master = v.first),
                  ),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _master.index,
                children: const [
                  DrugListScreen(embedded: true),
                  PerioperativeMedicationScreen(embedded: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
