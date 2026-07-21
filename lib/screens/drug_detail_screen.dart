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
    final packageNotes = drug.notes
        .where((note) => note.type == DrugNoteType.packageInsert)
        .toList();
    final facilityNotes = drug.notes
        .where((note) => note.type == DrugNoteType.facilityPractice)
        .toList();
    final offLabelNotes = drug.notes
        .where(
          (note) =>
              note.type == DrugNoteType.offLabel ||
              note.type == DrugNoteType.literature,
        )
        .toList();
    final clinicalNotes = drug.notes
        .where((note) => note.type == DrugNoteType.clinical)
        .toList();

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
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          drug.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    drug.brand,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: catColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      drug.category.label,
                      style: TextStyle(
                        fontSize: 12,
                        color: catColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (drug.packageInsertReviewed) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.verified_outlined,
                          size: 15,
                          color: Colors.teal.shade700,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '電子添文確認済み'
                          '${drug.packageInsertRevision == null ? '' : '  ${drug.packageInsertRevision}'}',
                          style: TextStyle(
                            color: Colors.teal.shade700,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
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
                            child: Text(
                              specs[i].key,
                              style: TextStyle(
                                color: scheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              specs[i].value,
                              style: theme.textTheme.bodyMedium,
                            ),
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
              title: drug.packageInsertReviewed ? '電子添文: 用法・用量' : '用法・用量',
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

          if (packageNotes.isNotEmpty)
            _NoteSection(
              title: '電子添文の補足',
              icon: Icons.description_outlined,
              color: scheme.primary,
              notes: packageNotes,
            ),
          if (drug.contraindications.isNotEmpty)
            _ContraindicationSection(items: drug.contraindications),
          if (drug.cautiousUse.isNotEmpty)
            _CautiousUseSection(items: drug.cautiousUse),
          if (facilityNotes.isNotEmpty)
            _NoteSection(
              title: '施設運用例',
              subtitle: '医局・施設の手順で異なるため、院内手順と上級医に確認',
              icon: Icons.apartment_outlined,
              color: const Color(0xFF2563EB),
              notes: facilityNotes,
            ),
          if (offLabelNotes.isNotEmpty)
            _NoteSection(
              title: '適応外・文献ベース',
              subtitle: '電子添文の承認適応・用法用量とは異なる情報',
              icon: Icons.science_outlined,
              color: const Color(0xFF7C3AED),
              notes: offLabelNotes,
            ),
          if (clinicalNotes.isNotEmpty)
            _NoteSection(
              title: '臨床解説',
              icon: Icons.menu_book_outlined,
              color: const Color(0xFF475569),
              notes: clinicalNotes,
            ),

          if (drug.packageInsertReviewed && drug.packageInsertUrl != null) ...[
            const SizedBox(height: 8),
            _SourceCard(
              url: drug.packageInsertUrl!,
              revision: drug.packageInsertRevision,
            ),
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
  const _HighlightCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.body,
  });

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
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(body, style: const TextStyle(fontSize: 14, height: 1.5)),
          ],
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final DrugNote note;
  final Color color;
  const _NoteCard({required this.note, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.heading,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              note.body,
              style: const TextStyle(fontSize: 13.5, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final List<DrugNote> notes;

  const _NoteSection({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.color,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 7),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: color,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            fontSize: 11.5,
                            height: 1.35,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          for (final note in notes) ...[
            _NoteCard(note: note, color: color),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _ContraindicationSection extends StatelessWidget {
  final List<DrugContraindication> items;
  const _ContraindicationSection({required this.items});

  @override
  Widget build(BuildContext context) {
    final red = Colors.red.shade700;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
            child: Row(
              children: [
                Icon(Icons.block, size: 18, color: red),
                const SizedBox(width: 7),
                Text(
                  '禁忌',
                  style: TextStyle(
                    color: red,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Card(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border(left: BorderSide(color: red, width: 4)),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  for (var i = 0; i < items.length; i++) ...[
                    if (i > 0) const Divider(height: 18),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        items[i].target,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '理由: ${items[i].reason}',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: red,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CautiousUseSection extends StatelessWidget {
  final List<String> items;
  const _CautiousUseSection({required this.items});

  @override
  Widget build(BuildContext context) {
    final amber = Colors.amber.shade900;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, size: 19, color: amber),
                const SizedBox(width: 7),
                Text(
                  '慎重投与・注意する患者背景',
                  style: TextStyle(
                    color: amber,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Card(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border(left: BorderSide(color: amber, width: 4)),
              ),
              padding: const EdgeInsets.all(14),
              child: Wrap(
                spacing: 7,
                runSpacing: 7,
                children: items
                    .map(
                      (item) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          border: Border.all(color: Colors.amber.shade300),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item,
                          style: const TextStyle(fontSize: 12.5),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SourceCard extends StatelessWidget {
  final String url;
  final String? revision;
  const _SourceCard({required this.url, this.revision});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD8DEE5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '根拠: PMDA電子添文${revision == null ? '' : ' ($revision)'}',
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 3),
          SelectableText(
            url,
            style: const TextStyle(fontSize: 10.5, color: Colors.black45),
          ),
        ],
      ),
    );
  }
}
