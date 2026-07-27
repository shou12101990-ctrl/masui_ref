import 'package:flutter/material.dart';

import '../data/calculators.dart';
import '../widgets/patient_info_panel.dart';
import 'pre_entry_screen.dart';

/// 計算機タブのハブ画面 — 各計算機へのナビゲーション.
/// 項目の定義は lib/data/calculators.dart のレジストリに集約.
class CalculatorHubScreen extends StatelessWidget {
  const CalculatorHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('機能',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: _PreEntryBanner(),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: PatientInfoPanel(),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 124,
                ),
                itemCount: kCalculators.length,
                itemBuilder: (context, i) => _HubCard(item: kCalculators[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HubCard extends StatelessWidget {
  final CalculatorEntry item;
  const _HubCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => item.build()),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(item.icon, color: item.color, size: 22),
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right,
                      color: Colors.black26, size: 18),
                ],
              ),
              const SizedBox(height: 8),
              Text(item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 13.5, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Expanded(
                child: Text(item.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 10.5,
                        height: 1.3,
                        color: Colors.black54)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 機能タブ最上位の「入室前準備」バナー (準備タイマー + チェックリストへ).
class _PreEntryBanner extends StatelessWidget {
  const _PreEntryBanner();

  static const _accent = Color(0xFF00695C);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: _accent.withValues(alpha: 0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: _accent.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const PreEntryScreen()),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.checklist_rtl,
                    color: _accent, size: 26),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('入室前準備',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2),
                    Text('準備タイマー + チェックリスト (目標15分)',
                        style: TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: _accent),
            ],
          ),
        ),
      ),
    );
  }
}
