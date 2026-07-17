import 'package:flutter/material.dart';

import '../data/perioperative_medications.dart';
import '../models/perioperative_medication.dart';
import '../widgets/perioperative_medication_visuals.dart';
import 'perioperative_medication_detail_screen.dart';

class PerioperativeMedicationScreen extends StatefulWidget {
  final bool embedded;
  const PerioperativeMedicationScreen({super.key, this.embedded = false});

  @override
  State<PerioperativeMedicationScreen> createState() =>
      _PerioperativeMedicationScreenState();
}

class _PerioperativeMedicationScreenState
    extends State<PerioperativeMedicationScreen> {
  String _query = '';
  PerioperativeMedicationCategory? _category;
  PerioperativeAction? _action;

  List<PerioperativeMedication> get _filtered {
    final q = _query.trim().toLowerCase();
    return kPerioperativeMedications.where((m) {
      final categoryMatch = _category == null || m.category == _category;
      final actionMatch = _action == null || m.defaultAction == _action;
      return categoryMatch &&
          actionMatch &&
          (q.isEmpty || m.searchText.contains(q));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        if (!widget.embedded)
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '継続・中止薬マスタ',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        _SafetyBanner(count: _filtered.length),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
          child: TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: InputDecoration(
              hintText: '一般名・商品名・薬効群・処方目的で検索',
              prefixIcon: const Icon(Icons.search),
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        _ActionFilters(
          selected: _action,
          onChanged: (v) => setState(() => _action = v),
        ),
        _CategoryFilters(
          selected: _category,
          onChanged: (v) => setState(() => _category = v),
        ),
        Expanded(
          child: _filtered.isEmpty
              ? const Center(
                  child: Text(
                    '該当する薬剤がありません',
                    style: TextStyle(color: Colors.black45),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: _filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) =>
                      _MedicationCard(medication: _filtered[index]),
                ),
        ),
      ],
    );

    if (widget.embedded) return content;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(child: content),
    );
  }
}

class _SafetyBanner extends StatelessWidget {
  final int count;
  const _SafetyBanner({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 2),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E6),
        border: Border.all(color: const Color(0xFFF59F00)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            size: 18,
            color: Color(0xFFE67700),
          ),
          const SizedBox(width: 7),
          const Expanded(
            child: Text(
              '自己判断で休薬しない. 表示は典型例の初期値であり, 適応・用量・最終投与・CCr・手術/区域麻酔手技が不明なら「判定不能」. 処方医/外科/麻酔科で決定.',
              style: TextStyle(fontSize: 11.5, height: 1.35),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$count項目',
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _ActionFilters extends StatelessWidget {
  final PerioperativeAction? selected;
  final ValueChanged<PerioperativeAction?> onChanged;
  const _ActionFilters({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(12, 2, 12, 4),
      child: Row(
        children: [
          _FilterBox(
            label: 'すべて',
            selected: selected == null,
            color: Theme.of(context).colorScheme.primary,
            onTap: () => onChanged(null),
          ),
          for (final action in PerioperativeAction.values)
            _FilterBox(
              label: action.label,
              selected: selected == action,
              color: action.color,
              onTap: () => onChanged(action),
            ),
        ],
      ),
    );
  }
}

class _CategoryFilters extends StatelessWidget {
  final PerioperativeMedicationCategory? selected;
  final ValueChanged<PerioperativeMedicationCategory?> onChanged;
  const _CategoryFilters({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
      child: Row(
        children: [
          for (final category in PerioperativeMedicationCategory.values)
            _FilterBox(
              label: category.label,
              selected: selected == category,
              color: category.color,
              onTap: () => onChanged(selected == category ? null : category),
            ),
        ],
      ),
    );
  }
}

class _FilterBox extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;
  const _FilterBox({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 7),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? color : Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: color.withValues(alpha: 0.65)),
          ),
          child: Text(
            label,
            softWrap: false,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontSize: 11.5,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _MedicationCard extends StatelessWidget {
  final PerioperativeMedication medication;
  const _MedicationCard({required this.medication});

  @override
  Widget build(BuildContext context) {
    final action = medication.defaultAction;
    final categoryColor = medication.category.color;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                PerioperativeMedicationDetailScreen(medication: medication),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 4, height: 62, color: categoryColor),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            medication.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _ActionBadge(action: action),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      medication.brands,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      medication.dayOfSurgery,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12.5, height: 1.35),
                    ),
                    if (medication.holdTiming.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        '目安: ${medication.holdTiming}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: action.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionBadge extends StatelessWidget {
  final PerioperativeAction action;
  const _ActionBadge({required this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: action.color.withValues(alpha: 0.10),
        border: Border.all(color: action.color.withValues(alpha: 0.55)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(action.icon, size: 13, color: action.color),
          const SizedBox(width: 3),
          Text(
            action.label,
            style: TextStyle(
              fontSize: 10.5,
              color: action.color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
