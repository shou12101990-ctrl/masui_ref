import 'package:flutter/material.dart';

import '../models/drug.dart';
import '../widgets/category_mark.dart';

// ── 選択肢リスト ──────────────────────────────────────────────────────────
final _ageOpts    = List.generate(71, (i) => i + 20);        // 20–90歳 (1歳刻み)
final _heightOpts = List.generate(13, (i) => 130 + i * 5);  // 130–190cm (5cm刻み)
final _weightOpts = List.generate(19, (i) => 30 + i * 5);   // 30–120kg  (5kg刻み)

// ── 薬剤 enum ─────────────────────────────────────────────────────────────
enum _SedDrug {
  propofol('プロポフォール'),
  remimazolam('アネレム'),
  midazolam('ミダゾラム');

  final String label;
  const _SedDrug(this.label);
}

enum _AnalDrug {
  fentanyl('フェンタニル'),
  remifentanil('レミフェンタニル'),
  fentaRemi('フェンタ＋レミフェ');

  final String label;
  const _AnalDrug(this.label);
}

// ── 用量モデル ────────────────────────────────────────────────────────────
class _DoseLine {
  final String rowLabel; // "低用量" "RSI" etc.
  final double value;
  final String unit;     // "mg" "μg" "μg/min"
  final String basis;    // "1.5 mg/kg"
  const _DoseLine(this.rowLabel, this.value, this.unit, this.basis);
}

class _DoseInfo {
  final List<_DoseLine> lines;
  final String note;
  const _DoseInfo(this.lines, this.note);
}

// ── メイン画面 ────────────────────────────────────────────────────────────
class AdultInductionScreen extends StatefulWidget {
  const AdultInductionScreen({super.key});

  @override
  State<AdultInductionScreen> createState() => _AdultInductionScreenState();
}

class _AdultInductionScreenState extends State<AdultInductionScreen> {
  int _age    = 40;
  int _height = 165;
  int _weight = 60;

  _SedDrug  _sed  = _SedDrug.propofol;
  _AnalDrug _anal = _AnalDrug.fentanyl;

  bool   get _elderly => _age >= 65;
  double get _wt      => _weight.toDouble();
  double get _ibw     => 50 + 0.91 * (_height - 152.4); // Devine式

  // ── 鎮静薬 ─────────────────────────────────────────────────────────────
  _DoseInfo get _sedInfo {
    final wt = _wt;
    switch (_sed) {
      case _SedDrug.propofol:
        return _elderly
            ? _DoseInfo([
                _DoseLine('低用量', wt * 1.0, 'mg', '1.0 mg/kg'),
                _DoseLine('高用量', wt * 1.5, 'mg', '1.5 mg/kg'),
              ], '高齢者用量. 緩徐静注. リドカイン前投与で疼痛軽減.')
            : _DoseInfo([
                _DoseLine('低用量', wt * 1.0, 'mg', '1.0 mg/kg'),
                _DoseLine('高用量', wt * 2.0, 'mg', '2.0 mg/kg'),
              ], '導入 1–2 mg/kg. 緩徐静注. リドカイン前投与で疼痛軽減.');
      case _SedDrug.remimazolam:
        return _DoseInfo([
          _DoseLine('投与速度', wt * 6.0, 'mg/h', '6 mg/kg/h'),
        ], '意識消失後 1 mg/kg/h に減量. 拮抗薬: フルマゼニル.');
      case _SedDrug.midazolam:
        return _elderly
            ? _DoseInfo([
                _DoseLine('低用量', wt * 0.025, 'mg', '0.025 mg/kg'),
                _DoseLine('高用量', wt * 0.05,  'mg', '0.05 mg/kg'),
              ], '高齢者用量. 発現 2-3 分. ゆっくり静注.')
            : _DoseInfo([
                _DoseLine('低用量', wt * 0.05, 'mg', '0.05 mg/kg'),
                _DoseLine('高用量', wt * 0.10, 'mg', '0.10 mg/kg'),
              ], '発現 2-3 分. ゆっくり静注.');
    }
  }

  // ── 鎮痛薬 ─────────────────────────────────────────────────────────────
  _DoseInfo get _analInfo {
    final wt = _wt;
    switch (_anal) {
      case _AnalDrug.fentanyl:
        return _DoseInfo([
          _DoseLine('低用量', wt * 1.0, 'μg', '1 μg/kg'),
          _DoseLine('高用量', wt * 3.0, 'μg', '3 μg/kg'),
        ], '導入 2-3 分前に静注. 呼吸抑制・筋硬直に注意.');
      case _AnalDrug.remifentanil:
        return _DoseInfo([
          _DoseLine('低用量', wt * 0.25, 'μg/min', '0.25 μg/kg/min'),
          _DoseLine('高用量', wt * 0.5,  'μg/min', '0.5 μg/kg/min'),
        ], '持続静注. 挿管後 0.05-0.2 μg/kg/min に減量.');
      case _AnalDrug.fentaRemi:
        return _DoseInfo([
          _DoseLine('F 低', wt * 1.0,  'μg',     '1 μg/kg'),
          _DoseLine('F 高', wt * 2.0,  'μg',     '2 μg/kg'),
          _DoseLine('R 低', wt * 0.1,  'μg/min', '0.1 μg/kg/min'),
          _DoseLine('R 高', wt * 0.25, 'μg/min', '0.25 μg/kg/min'),
        ], 'F=フェンタニル(導入前ボーラス) / R=レミフェンタニル(持続静注). '
           '併用時は各々を単独より減量. 挿管後Rは0.05-0.2 μg/kg/minへ.');
    }
  }

  // ── 筋弛緩薬 (ロクロニウム固定) ─────────────────────────────────────────
  _DoseInfo get _relaxInfo {
    final wt = _wt;
    return _DoseInfo([
      _DoseLine('通常', wt * 0.6, 'mg', '0.6 mg/kg'),
      _DoseLine('RSI',  wt * 1.2, 'mg', '1.2 mg/kg'),
    ], '発現: 通常 ~2 分, RSI ~60 秒. 拮抗: スガマデクス.');
  }

  // ── build ───────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('成人導入 計算機'),
        backgroundColor: scheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [

          // ── 患者情報 ──────────────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _secTitle('患者情報', scheme),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _ddField<int>(
                          label: '年齢', suffix: '歳',
                          value: _age, items: _ageOpts,
                          onChanged: (v) => setState(() => _age = v),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ddField<int>(
                          label: '身長', suffix: 'cm',
                          value: _height, items: _heightOpts,
                          onChanged: (v) => setState(() => _height = v),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ddField<int>(
                          label: '体重', suffix: 'kg',
                          value: _weight, items: _weightOpts,
                          onChanged: (v) => setState(() => _weight = v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // IBW バッジ
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'IBW: ${_ibw.toStringAsFixed(1)} kg（Devine式）',
                          style: TextStyle(
                              color: scheme.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        ),
                        if (_elderly) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade600,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('高齢者用量',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── 鎮静薬 ────────────────────────────────────────────────────
          _DrugClassCard(
            classLabel: '鎮静薬',
            color: DrugCategory.sedative.color,
            chips: _SedDrug.values
                .map((d) => (
                      label: d.label,
                      selected: _sed == d,
                      onTap: () => setState(() => _sed = d),
                    ))
                .toList(),
            doseInfo: _sedInfo,
          ),
          const SizedBox(height: 12),

          // ── 鎮痛薬 ────────────────────────────────────────────────────
          _DrugClassCard(
            classLabel: '鎮痛薬',
            color: DrugCategory.analgesic.color,
            chips: _AnalDrug.values
                .map((d) => (
                      label: d.label,
                      selected: _anal == d,
                      onTap: () => setState(() => _anal = d),
                    ))
                .toList(),
            doseInfo: _analInfo,
          ),
          const SizedBox(height: 12),

          // ── 筋弛緩薬 ──────────────────────────────────────────────────
          _DrugClassCard(
            classLabel: '筋弛緩薬',
            color: DrugCategory.muscleRelaxant.color,
            chips: [(label: 'ロクロニウム', selected: true, onTap: () {})],
            doseInfo: _relaxInfo,
          ),
          const SizedBox(height: 12),

          // ── 人工呼吸器 初期設定 ────────────────────────────────────────
          _VentCard(pbw: _ibw, scheme: scheme),
        ],
      ),
    );
  }

  // ── helpers ─────────────────────────────────────────────────────────────
  Widget _secTitle(String text, ColorScheme scheme) => Text(text,
      style: TextStyle(
          color: scheme.primary, fontWeight: FontWeight.bold, fontSize: 14));

  Widget _ddField<T>({
    required String label,
    required String suffix,
    required T value,
    required List<T> items,
    required ValueChanged<T> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        isDense: true,
        filled: true,
        fillColor: const Color(0xFFF7F9FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      ),
      items: items
          .map((v) => DropdownMenuItem<T>(
                value: v,
                child: Text('$v', style: const TextStyle(fontSize: 14)),
              ))
          .toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}

// ── 薬剤クラスカード ──────────────────────────────────────────────────────
class _DrugClassCard extends StatelessWidget {
  final String classLabel;
  final Color color;
  final List<({String label, bool selected, VoidCallback onTap})> chips;
  final _DoseInfo doseInfo;

  const _DrugClassCard({
    required this.classLabel,
    required this.color,
    required this.chips,
    required this.doseInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ヘッダー: ■ + クラス名
            Row(
              children: [
                CategoryMark(color: color, size: 14),
                const SizedBox(width: 7),
                Text(classLabel,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 10),

            // 薬剤チップ
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: chips.map((c) => _DrugChip(chip: c, color: color)).toList(),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // 用量行
            for (var i = 0; i < doseInfo.lines.length; i++) ...[
              if (i > 0) const SizedBox(height: 8),
              _DoseRow(line: doseInfo.lines[i]),
            ],
            const SizedBox(height: 10),

            // 備考バッジ
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(doseInfo.note,
                  style: const TextStyle(
                      fontSize: 12, color: Colors.black54, height: 1.4)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 薬剤選択チップ ────────────────────────────────────────────────────────
class _DrugChip extends StatelessWidget {
  final ({String label, bool selected, VoidCallback onTap}) chip;
  final Color color;
  const _DrugChip({required this.chip, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: chip.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: chip.selected
              ? color.withValues(alpha: 0.15)
              : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: chip.selected ? color : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          chip.label,
          style: TextStyle(
            fontSize: 13,
            fontWeight:
                chip.selected ? FontWeight.bold : FontWeight.normal,
            color: chip.selected ? Colors.black87 : Colors.black54,
          ),
        ),
      ),
    );
  }
}

// ── 用量行 ────────────────────────────────────────────────────────────────
class _DoseRow extends StatelessWidget {
  final _DoseLine line;
  const _DoseRow({required this.line});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        SizedBox(
          width: 58,
          child: Text(line.rowLabel,
              style:
                  const TextStyle(fontSize: 12, color: Colors.black45)),
        ),
        Expanded(
          child: Text(
            _fmtDose(line.value),
            textAlign: TextAlign.right,
            style: const TextStyle(
                fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 66,
          child: Text(line.unit,
              style:
                  const TextStyle(fontSize: 13, color: Colors.black54)),
        ),
        SizedBox(
          width: 82,
          child: Text(line.basis,
              textAlign: TextAlign.right,
              style:
                  const TextStyle(fontSize: 11, color: Colors.black38)),
        ),
      ],
    );
  }
}

// ── 人工呼吸器初期設定カード ──────────────────────────────────────────────
class _VentCard extends StatelessWidget {
  final double pbw;
  final ColorScheme scheme;
  const _VentCard({required this.pbw, required this.scheme});

  @override
  Widget build(BuildContext context) {
    final tv = pbw * 7;
    final rows = <(String, String, String)>[
      ('一回換気量', '${tv.toStringAsFixed(0)} mL', 'PBW × 7 mL/kg'),
      ('呼吸回数', '14 /min', ''),
      ('PEEP', '5 cmH₂O', ''),
      ('I:E 比', '1 : 2', ''),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.air, size: 16, color: scheme.primary),
                const SizedBox(width: 6),
                Text('人工呼吸器 初期設定',
                    style: TextStyle(
                        color: scheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ],
            ),
            const SizedBox(height: 12),

            // ⚠️ 絶対禁忌アラート
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade300, width: 1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_rounded,
                      size: 20, color: Colors.red.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: '「VC 500 mL・RR 10」の一律設定は絶対禁忌',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                              fontSize: 13,
                              height: 1.4),
                        ),
                        TextSpan(
                          text: '\n一回換気量は必ずPBW(理想体重)基準で個別に設定すること。',
                          style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 12,
                              height: 1.4),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0) const Divider(height: 14),
              Row(
                children: [
                  SizedBox(
                    width: 110,
                    child: Text(rows[i].$1,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500)),
                  ),
                  Expanded(
                    child: Text(rows[i].$2,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  if (rows[i].$3.isNotEmpty)
                    Text(rows[i].$3,
                        style: const TextStyle(
                            fontSize: 11, color: Colors.black38)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── 数値フォーマット ──────────────────────────────────────────────────────
String _fmtDose(double v) {
  if (v == v.truncateToDouble()) return v.toInt().toString();
  // .5刻みなら小数1桁
  if ((v * 10).truncate() == (v * 10).round()) {
    return v.toStringAsFixed(1);
  }
  return v.toStringAsFixed(2);
}
