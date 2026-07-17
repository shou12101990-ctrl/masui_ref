import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/perioperative_medication.dart';
import '../widgets/perioperative_medication_visuals.dart';

class PerioperativeMedicationDetailScreen extends StatelessWidget {
  final PerioperativeMedication medication;
  const PerioperativeMedicationDetailScreen({
    super.key,
    required this.medication,
  });

  @override
  Widget build(BuildContext context) {
    final action = medication.defaultAction;
    final categoryColor = medication.category.color;
    return Scaffold(
      appBar: AppBar(title: const Text('継続・中止薬マスタ')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 6, height: 52, color: categoryColor),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medication.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      medication.brands,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              _TopActionBadge(action: action),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4E6),
              border: Border.all(color: const Color(0xFFF59F00)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              '上のラベルは典型例の初期値. 適応・用量・最終投与時刻・Cockcroft-Gault CCr・手術出血リスク・区域麻酔手技が揃わなければ患者別の継続/中止は判定できない.',
              style: TextStyle(fontSize: 11.5, height: 1.45),
            ),
          ),
          _Section(
            title: '手術当日の基本方針',
            icon: action.icon,
            color: action.color,
            body: medication.dayOfSurgery,
          ),
          if (medication.administrationPlan.isNotEmpty)
            _Section(
              title: '術中投与・代替経路',
              icon: Icons.medication_outlined,
              color: const Color(0xFF0B7285),
              body: medication.administrationPlan,
            ),
          if (medication.holdTiming.isNotEmpty)
            _Section(
              title: '術前休止期間',
              icon: Icons.schedule,
              color: const Color(0xFFC92A2A),
              body: medication.holdTiming,
            ),
          if (medication.scenarios.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              '条件別の判断',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            for (final scenario in medication.scenarios)
              _ScenarioCard(scenario: scenario),
          ],
          _Section(
            title: '区域麻酔・深部ブロック',
            icon: Icons.account_tree_outlined,
            color: const Color(0xFF5F3DC4),
            body: medication.neuraxial,
          ),
          _Section(
            title: '再開',
            icon: Icons.restart_alt,
            color: const Color(0xFF087F5B),
            body: medication.restart,
          ),
          _Section(
            title: '根拠',
            icon: Icons.fact_check_outlined,
            color: const Color(0xFF276FBF),
            body: medication.rationale,
          ),
          _Section(
            title: '処方意図を読むTip',
            icon: Icons.lightbulb_outline,
            color: const Color(0xFFB26A00),
            body: medication.prescriptionTip,
          ),
          _Section(
            title: '例外・確認事項',
            icon: Icons.report_problem_outlined,
            color: const Color(0xFFC92A2A),
            body: medication.exceptions,
          ),
          const SizedBox(height: 12),
          const Text(
            '一次資料',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          for (final source in medication.sources) _SourceCard(source: source),
          const SizedBox(height: 10),
          Text(
            '最終確認: ${medication.lastReviewed}\n本マスタは研修用の判断支援. 緊急手術・院内規定・処方医の指示を優先し, 最終判断は担当チームで行う.',
            style: const TextStyle(fontSize: 10.5, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _TopActionBadge extends StatelessWidget {
  final PerioperativeAction action;
  const _TopActionBadge({required this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: action.color.withValues(alpha: 0.10),
        border: Border.all(color: action.color),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        action.label,
        style: TextStyle(
          color: action.color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String body;
  const _Section({
    required this.title,
    required this.icon,
    required this.color,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: color, width: 4)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 17, color: color),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          SelectableText(
            body,
            style: const TextStyle(fontSize: 13, height: 1.55),
          ),
        ],
      ),
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  final PerioperativeScenario scenario;
  const _ScenarioCard({required this.scenario});

  @override
  Widget build(BuildContext context) {
    final color = scenario.action.color;
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        border: Border.all(color: color.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  scenario.label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                scenario.action.label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            scenario.timing,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            scenario.rationale,
            style: const TextStyle(fontSize: 12, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _SourceCard extends StatelessWidget {
  final EvidenceSource source;
  const _SourceCard({required this.source});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.description_outlined,
            size: 18,
            color: Colors.black54,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  source.title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${source.organization} · ${source.year} · ${source.locator}',
                  style: const TextStyle(fontSize: 10.5, color: Colors.black54),
                ),
                const SizedBox(height: 3),
                SelectableText(
                  source.url,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF1565C0),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'URLをコピー',
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.copy, size: 17),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: source.url));
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('URLをコピーしました')));
            },
          ),
        ],
      ),
    );
  }
}
