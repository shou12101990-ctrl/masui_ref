import 'package:flutter/material.dart';

import '../data/drugs.dart';
import '../models/drug.dart';
import '../widgets/category_mark.dart';
import 'drug_detail_screen.dart';

class DrugListScreen extends StatefulWidget {
  const DrugListScreen({super.key});

  @override
  State<DrugListScreen> createState() => _DrugListScreenState();
}

class _DrugListScreenState extends State<DrugListScreen> {
  String _query = '';
  DrugCategory? _category;

  List<Drug> get _filtered {
    final q = _query.trim().toLowerCase();
    return kDrugs.where((d) {
      // クラスは統合せず、各カテゴリ単独で絞り込む
      final matchesCategory = _category == null || d.category == _category;
      final matchesQuery = q.isEmpty || d.searchText.contains(q);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final list = _filtered;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: [
                  Text('やさしい麻酔科ローテ',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text('${list.length}剤',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.black54)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: '薬剤名・商品名・作用で検索',
                  prefixIcon: const Icon(Icons.search),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            // クラスは重ねず全カテゴリを単独表示・ラベル全文表示（横スクロール）
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(12, 2, 12, 4),
              child: Row(
                children: [
                  _CategoryChip(
                    label: 'すべて',
                    selected: _category == null,
                    onTap: () => setState(() => _category = null),
                  ),
                  for (final c in DrugCategory.values)
                    _CategoryChip(
                      label: c.label,
                      selected: _category == c,
                      onTap: () => setState(() => _category = c),
                    ),
                ],
              ),
            ),
            Expanded(
              child: list.isEmpty
                  ? const Center(
                      child: Text('該当する薬剤がありません',
                          style: TextStyle(color: Colors.black45)))
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) => _DrugCard(drug: list[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _CategoryChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? scheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selected
                ? scheme.primary
                : scheme.primary.withValues(alpha: 0.4),
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          softWrap: false,
          overflow: TextOverflow.visible,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontSize: 12.5,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _DrugCard extends StatelessWidget {
  final Drug drug;
  const _DrugCard({required this.drug});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final catColor = drug.category.color;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => DrugDetailScreen(drug: drug)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CategoryMark(
                      color: catColor, diagonal: drug.isDiagonal, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(drug.name,
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text(drug.brand,
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: Colors.black54)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.bolt, size: 14, color: Colors.black38),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      drug.mechanism,
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
