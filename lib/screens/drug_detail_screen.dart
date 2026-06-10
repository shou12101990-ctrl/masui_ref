import 'package:flutter/material.dart';

import '../models/drug.dart';
import '../widgets/category_mark.dart';
import '../widgets/drug_visuals.dart';

class DrugDetailScreen extends StatelessWidget {
  final Drug drug;
  const DrugDetailScreen({super.key, required this.drug});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final catColor = drug.markColor;

    final specs = <MapEntry<String, String>>[
      if (drug.spec != null) MapEntry('規格', drug.spec!),
      if (drug.dilution != null) MapEntry('希釈', drug.dilution!),
      if (drug.concentration != null) MapEntry('濃度', drug.concentration!),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(drug.name),
        backgroundColor: scheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          // ヘッダー
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CategoryMark(
                          color: catColor,
                          diagonal: drug.isDiagonal,
                          size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(drug.name,
                            style: theme.textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(drug.brand,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: Colors.black54)),
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: catColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(drug.category.label,
                        style: TextStyle(
                            fontSize: 12,
                            color: catColor,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 規格・希釈・濃度
          if (specs.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    for (var i = 0; i < specs.length; i++) ...[
                      if (i > 0) const Divider(height: 18),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 52,
                            child: Text(specs[i].key,
                                style: TextStyle(
                                    color: scheme.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13)),
                          ),
                          Expanded(
                            child: Text(specs[i].value,
                                style: theme.textTheme.bodyMedium),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // 用法・用量
          if (drug.dose != null)
            _HighlightCard(
              icon: Icons.colorize,
              title: '用法・用量',
              color: scheme.primary,
              body: drug.dose!,
            ),
          if (drug.dose != null) const SizedBox(height: 12),

          // 作用機序
          _HighlightCard(
            icon: Icons.bolt,
            title: '作用機序',
            color: const Color(0xFF8E5BB5),
            body: drug.mechanism,
          ),

          // 詳細解説
          if (drug.notes.isNotEmpty) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text('詳細解説',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ),
            for (final note in drug.notes) ...[
              _NoteCard(note: note),
              const SizedBox(height: 8),
            ],
          ],

          const SizedBox(height: 8),
          Text(
            '※ 研修用の参考情報です。実投与は最新の添付文書・成書を確認してください。',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.black45),
          ),
        ],
      ),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final String body;
  const _HighlightCard(
      {required this.icon,
      required this.title,
      required this.color,
      required this.body});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border(left: BorderSide(color: color, width: 4)),
        ),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 17, color: color),
                const SizedBox(width: 6),
                Text(title,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ],
            ),
            const SizedBox(height: 8),
            Text(body,
                style: const TextStyle(fontSize: 14, height: 1.5)),
          ],
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final DrugNote note;
  const _NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(note.heading,
                style: TextStyle(
                    color: scheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5)),
            const SizedBox(height: 6),
            Text(note.body,
                style: const TextStyle(fontSize: 13.5, height: 1.6)),
          ],
        ),
      ),
    );
  }
}
