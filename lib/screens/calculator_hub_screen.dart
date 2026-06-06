import 'package:flutter/material.dart';

import 'adult_induction_screen.dart';
import 'gamma_calculator_screen.dart';
import 'pca_screen.dart';
import 'drip_screen.dart';
import 'pediatric_screen.dart';

/// 計算機タブのハブ画面 — 5つの計算機へのナビゲーション
class CalculatorHubScreen extends StatelessWidget {
  const CalculatorHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final items = [
      _CalcItem(
        icon: Icons.person,
        title: '成人 導入dose',
        subtitle: '導入薬用量 + 呼吸器初期設定',
        color: Colors.indigo,
        page: const AdultInductionScreen(),
      ),
      _CalcItem(
        icon: Icons.speed,
        title: 'γ 計算機',
        subtitle: '流量 ⇄ γ (mcg/kg/min)',
        color: const Color(0xFF00796B),
        page: const GammaCalculatorScreen(),
      ),
      _CalcItem(
        icon: Icons.healing,
        title: 'PCA 計算機',
        subtitle: 'フェンタニル / モルヒネ / ヒドロモルフォン',
        color: Colors.deepOrange,
        page: const PcaScreen(),
      ),
      _CalcItem(
        icon: Icons.water_drop,
        title: '点滴 メトロノーム',
        subtitle: '流量 → 滴下速度 + 点滅ガイド',
        color: Colors.teal,
        page: const DripScreen(),
      ),
      _CalcItem(
        icon: Icons.child_care,
        title: '小児麻酔 計算機',
        subtitle: '導入dose / チューブサイズ / 固定長',
        color: Colors.pink.shade400,
        page: const PediatricScreen(),
      ),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('計算機',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) => _HubCard(item: items[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalcItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Widget page;
  const _CalcItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.page,
  });
}

class _HubCard extends StatelessWidget {
  final _CalcItem item;
  const _HubCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => item.page),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: item.color, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(item.subtitle,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black26),
            ],
          ),
        ),
      ),
    );
  }
}
