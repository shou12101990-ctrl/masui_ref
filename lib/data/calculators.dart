import 'package:flutter/material.dart';

import '../screens/drug_matrix_hub_screen.dart';
import '../screens/adult_induction_screen.dart';
import '../screens/delirium_ladder_screen.dart';
import '../screens/allowable_blood_loss_screen.dart';
import '../screens/be_correction_screen.dart';
import '../screens/discharge_score_screen.dart';
import '../screens/dlt_screen.dart';
import '../screens/drip_screen.dart';
import '../screens/gamma_calculator_screen.dart';
import '../screens/local_anesthetic_max_screen.dart';
import '../screens/opioid_conversion_screen.dart';
import '../screens/oxygen_gap_screen.dart';
import '../screens/pca_screen.dart';
import '../screens/pediatric_screen.dart';
import '../screens/pre_entry_screen.dart';

/// 計算機タブに並ぶ機能のレジストリ.
/// 新しい計算機は kCalculators に1エントリ追加するだけでハブ画面に並ぶ.
class CalculatorEntry {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Widget Function() build;
  const CalculatorEntry({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.build,
  });
}

final List<CalculatorEntry> kCalculators = [
  CalculatorEntry(
    icon: Icons.checklist_rtl,
    title: '入室前準備',
    subtitle: '準備タイマー + チェックリスト',
    color: const Color(0xFF00695C),
    build: () => const PreEntryScreen(),
  ),
  CalculatorEntry(
    icon: Icons.person,
    title: '成人 麻酔導入時',
    subtitle: '導入 / 維持のdoseの計算',
    color: Colors.indigo,
    build: () => const AdultInductionScreen(),
  ),
  CalculatorEntry(
    icon: Icons.speed,
    title: 'γ 計算機',
    subtitle: '流量を変換する.',
    color: const Color(0xFF00796B),
    build: () => const GammaCalculatorScreen(),
  ),
  CalculatorEntry(
    icon: Icons.healing,
    title: 'ivPCA',
    subtitle: '術後疼痛の考え方',
    color: Colors.deepOrange,
    build: () => const PcaScreen(),
  ),
  CalculatorEntry(
    icon: Icons.water_drop,
    title: '点滴 メトロノーム',
    subtitle: '輸液用ポンプがなくても大丈夫',
    color: Colors.teal,
    build: () => const DripScreen(),
  ),
  CalculatorEntry(
    icon: Icons.child_care,
    title: '小児 麻酔設計',
    subtitle: '導入のdose, チューブサイズ, 固定長.',
    color: Colors.pink.shade400,
    build: () => const PediatricScreen(),
  ),
  CalculatorEntry(
    icon: Icons.vaccines,
    title: '局所麻酔薬 極量計算',
    subtitle: '濃度に応じた最大容量計算.',
    color: const Color(0xFF6B7280),
    build: () => const LocalAnestheticMaxScreen(),
  ),
  CalculatorEntry(
    icon: Icons.straighten,
    title: 'DLT サイズ選択',
    subtitle: 'CT実測 / Brodsky',
    color: const Color(0xFF0E7490),
    build: () => const DltScreen(),
  ),
  CalculatorEntry(
    icon: Icons.monitor_heart,
    title: '酸素較差計算機',
    subtitle: '動静脈酸素較差・O₂ERの概算.',
    color: const Color(0xFF1976D2),
    build: () => const OxygenGapScreen(),
  ),
  CalculatorEntry(
    icon: Icons.bloodtype,
    title: '許容出血量',
    subtitle: '等容量性希釈を仮定した許容出血量の概算.',
    color: const Color(0xFFC2185B),
    build: () => const AllowableBloodLossScreen(),
  ),
  CalculatorEntry(
    icon: Icons.science,
    title: 'メイロン BE補正',
    subtitle: 'BE·体重 → HCO₃⁻不足分 / メイロン量',
    color: const Color(0xFF5E35B1),
    build: () => const BeCorrectionScreen(),
  ),
  CalculatorEntry(
    icon: Icons.swap_horiz,
    title: 'オピオイド換算',
    subtitle: '内服量 → フェンタニル換算 (μg/h)',
    color: const Color(0xFF1565C0),
    build: () => const OpioidConversionScreen(),
  ),
  CalculatorEntry(
    icon: Icons.fact_check,
    title: '退室基準スコア',
    subtitle: 'Aldrete / White-Song / MPADSS',
    color: const Color(0xFF2E7D32),
    build: () => const DischargeScoreScreen(),
  ),
  CalculatorEntry(
    icon: Icons.grid_on,
    title: '薬剤マトリクス',
    subtitle: '抗菌薬 / 向精神薬 / 利尿薬 / 便秘薬を表で比較',
    color: const Color(0xFF5C8A3A),
    build: () => const DrugMatrixHubScreen(),
  ),
  CalculatorEntry(
    icon: Icons.bedtime_outlined,
    title: 'せん妄・不眠ラダー',
    subtitle: '患者背景から使える薬剤を判定',
    color: const Color(0xFF00838F),
    build: () => const DeliriumLadderScreen(),
  ),
];
