import 'package:flutter/material.dart';

import 'adult_induction_screen.dart';
import 'gamma_calculator_screen.dart';
import 'pca_screen.dart';
import 'drip_screen.dart';
import 'pediatric_screen.dart';
import 'local_anesthetic_max_screen.dart';
import 'dlt_screen.dart';
import 'oxygen_gap_screen.dart';
import 'opioid_conversion_screen.dart';
import 'allowable_blood_loss_screen.dart';
import 'be_correction_screen.dart';

/// 計算機タブのハブ画面 — 8つの計算機へのナビゲーション
class CalculatorHubScreen extends StatelessWidget {
  const CalculatorHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final items = [
      _CalcItem(
        icon: Icons.person,
        title: '成人 麻酔導入時',
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
        title: 'ivPCA',
        subtitle: '術後鎮痛のデザイン',
        color: Colors.deepOrange,
        page: const PcaScreen(),
      ),
      _CalcItem(
        icon: Icons.water_drop,
        title: '点滴 メトロノーム',
        subtitle: '輸液用ポンプ不要の時代へ─.',
        color: Colors.teal,
        page: const DripScreen(),
      ),
      _CalcItem(
        icon: Icons.child_care,
        title: '小児 麻酔設計',
        subtitle: '導入dose / チューブサイズ / 固定長',
        color: Colors.pink.shade400,
        page: const PediatricScreen(),
      ),
      _CalcItem(
        icon: Icons.vaccines,
        title: '局所麻酔薬 極量計算',
        subtitle: '濃度に応じた最大容量計算.',
        color: const Color(0xFF6B7280),
        page: const LocalAnestheticMaxScreen(),
      ),
      _CalcItem(
        icon: Icons.straighten,
        title: 'DLT サイズ選択',
        subtitle: 'CT実測 / Brodsky',
        color: const Color(0xFF0E7490),
        page: const DltScreen(),
      ),
      _CalcItem(
        icon: Icons.monitor_heart,
        title: '酸素較差計算機',
        subtitle: '輸血カットオフの算出.',
        color: const Color(0xFF1976D2),
        page: const OxygenGapScreen(),
      ),
      _CalcItem(
        icon: Icons.bloodtype,
        title: '許容出血量',
        subtitle: 'A lineなしでHb低下を予想する.',
        color: const Color(0xFFC2185B),
        page: const AllowableBloodLossScreen(),
      ),
      _CalcItem(
        icon: Icons.science,
        title: 'メイロン BE補正',
        subtitle: 'BE·体重 → HCO₃⁻不足分 / メイロン量',
        color: const Color(0xFF5E35B1),
        page: const BeCorrectionScreen(),
      ),
      _CalcItem(
        icon: Icons.swap_horiz,
        title: 'オピオイド換算',
        subtitle: '内服量 → フェンタニル換算 (μg/h)',
        color: const Color(0xFF1565C0),
        page: const OpioidConversionScreen(),
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
              child: Text('機能',
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(item.title,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 3),
                    Text(item.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
