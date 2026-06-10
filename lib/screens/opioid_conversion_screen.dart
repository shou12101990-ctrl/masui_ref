import 'package:flutter/material.dart';

import '../domain/calculators/opioid_conversion.dart';

/// オピオイド換算計算
/// 内服オピオイド(mg/日) → 経口モルヒネ換算 → フェンタニル換算(μg/日・μg/h)
class OpioidConversionScreen extends StatefulWidget {
  const OpioidConversionScreen({super.key});

  @override
  State<OpioidConversionScreen> createState() =>
      _OpioidConversionScreenState();
}

// 経口モルヒネ換算係数 (×dose = 経口モルヒネ mg/日)
enum _OralOpioid {
  morphine('モルヒネ', 1.0),
  oxycodone('オキシコドン', 1.5),
  hydromorphone('ヒドロモルフォン', 5.0),
  tapentadol('タペンタドール', 0.4),
  tramadol('トラマドール', 0.2),
  codeine('コデイン', 1 / 6.0);

  final String label;
  final double toMorphine;
  const _OralOpioid(this.label, this.toMorphine);
}

// 換算表（すべて 経口モルヒネ 60mg/日 相当）
const _table = [
  ['経口モルヒネ', '60 mg/日'],
  ['オキシコドン（経口）', '40 mg/日'],
  ['ヒドロモルフォン（経口）', '12 mg/日'],
  ['タペンタドール（経口）', '150 mg/日'],
  ['トラマドール（経口）', '300 mg/日'],
  ['コデイン（経口）', '360 mg/日'],
  ['モルヒネ 注射', '30 mg/日'],
  ['オキシコドン 注射', '30 mg/日'],
  ['フェンタニル 注/貼付', '0.6 mg/日 ≈ 25 μg/h'],
];

class _OpioidConversionScreenState extends State<OpioidConversionScreen> {
  static const _accent = Color(0xFF1565C0);

  _OralOpioid _drug = _OralOpioid.morphine;
  final _doseCtrl = TextEditingController(text: '30');

  @override
  void initState() {
    super.initState();
    _doseCtrl.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _doseCtrl.dispose();
    super.dispose();
  }

  // 計算ロジックは domain 層へ分離 (純粋関数)
  OpioidConversionResult? get _result => computeOpioidConversion(
        doseMgPerDay: double.tryParse(_doseCtrl.text.trim()),
        toMorphineFactor: _drug.toMorphine,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = _result;

    return Scaffold(
      appBar: AppBar(
        title: const Text('オピオイド換算'),
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── 入力(左) → 換算(右) ──
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 左: 内服薬 + dose
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('内服オピオイド',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black54)),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<_OralOpioid>(
                              value: _drug,
                              isExpanded: true,
                              decoration: _inputDeco(),
                              items: _OralOpioid.values
                                  .map((d) => DropdownMenuItem(
                                      value: d,
                                      child: Text(d.label,
                                          style: const TextStyle(
                                              fontSize: 14))))
                                  .toList(),
                              onChanged: (d) {
                                if (d != null) setState(() => _drug = d);
                              },
                            ),
                            const SizedBox(height: 10),
                            const Text('1日量',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black54)),
                            const SizedBox(height: 4),
                            TextField(
                              controller: _doseCtrl,
                              keyboardType: const TextInputType
                                  .numberWithOptions(decimal: true),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              decoration: _inputDeco(suffix: 'mg/日'),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Center(
                          child: Icon(Icons.arrow_forward,
                              color: _accent, size: 22),
                        ),
                      ),
                      // 右: フェンタニル換算
                      Expanded(
                        flex: 6,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _accent.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _out('経口モルヒネ換算',
                                  r?.oralMorphineEqMgPerDay.toStringAsFixed(0) ?? '—',
                                  'mg/日',
                                  big: false),
                              const SizedBox(height: 8),
                              _out('フェンタニル 1日量',
                                  r?.fentanylMcgPerDay.toStringAsFixed(0) ?? '—',
                                  'μg/日',
                                  big: false),
                              const Divider(height: 18),
                              _out('持続投与（目の前の量）',
                                  r?.fentanylMcgPerHour.toStringAsFixed(1) ?? '—',
                                  'μg/h',
                                  big: true),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '※ 普段の常用量に相当するフェンタニル量。周術期はこの分をベースとして継続し、手術侵襲分を上乗せする。',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600, height: 1.5),
            ),
            const SizedBox(height: 12),

            // ── 換算表（絵）──
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('オピオイド等鎮痛換算表',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('各行は同じ鎮痛効果（経口モルヒネ 60 mg/日 相当）',
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade600)),
                    const SizedBox(height: 10),
                    Table(
                      border: TableBorder.symmetric(
                        inside: BorderSide(
                            color: Colors.grey.shade200, width: 0.8),
                      ),
                      columnWidths: const {
                        0: FlexColumnWidth(1.4),
                        1: FlexColumnWidth(1.6),
                      },
                      children: [
                        TableRow(
                          decoration:
                              BoxDecoration(color: Colors.grey.shade100),
                          children: const [
                            _Cell('薬剤', header: true),
                            _Cell('等鎮痛用量', header: true),
                          ],
                        ),
                        for (final r in _table)
                          TableRow(children: [
                            _Cell(r[0]),
                            _Cell(r[1], bold: true),
                          ]),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── 注意 ──
            Card(
              color: Colors.amber.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.info_outline,
                          color: Colors.amber.shade800, size: 18),
                      const SizedBox(width: 6),
                      Text('注意',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.amber.shade900,
                              fontSize: 13)),
                    ]),
                    const SizedBox(height: 6),
                    const Text(
                      '・換算表はあくまで目安。別のオピオイドへ変更（オピオイドスイッチング）する際は、不完全交差耐性を考慮し等鎮痛換算量から 25〜50% 減量して開始する。\n'
                      '・換算比には幅があり、個人差・腎肝機能・併用薬で変動する。必ず鎮痛・呼吸を見ながら調整する。\n'
                      '・換算は フェンタニル：経口モルヒネ ≈ 1 : 100（mg比）、経口モルヒネ 60 mg/日 ≈ フェンタニル 0.6 mg/日 を採用。',
                      style: TextStyle(fontSize: 12, height: 1.7),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDeco({String? suffix}) => InputDecoration(
        suffixText: suffix,
        suffixStyle: const TextStyle(fontSize: 11, color: Colors.black45),
        isDense: true,
        filled: true,
        fillColor: const Color(0xFFF7F9FA),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      );

  Widget _out(String label, String value, String unit, {required bool big}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 11, color: Colors.black54)),
        const SizedBox(height: 1),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: big ? 28 : 18,
                    fontWeight: FontWeight.bold,
                    color: _accent)),
            const SizedBox(width: 4),
            Text(unit,
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  final String text;
  final bool header;
  final bool bold;
  const _Cell(this.text, {this.header = false, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      child: Text(text,
          style: TextStyle(
              fontSize: header ? 12 : 12.5,
              fontWeight:
                  (header || bold) ? FontWeight.bold : FontWeight.normal,
              color: header ? Colors.black54 : Colors.black87)),
    );
  }
}
