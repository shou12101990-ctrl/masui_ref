import 'package:flutter/material.dart';
import '../models/drug.dart';
import '../widgets/category_mark.dart';

// ── 選択肢 ────────────────────────────────────────────────────────────────
final _ageYearOpts  = List.generate(16, (i) => i);           // 0–15歳
const _ageMonthOpts = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
final _heightOpts   = List.generate(33, (i) => 30 + i * 5); // 30–190cm
final _weightOpts   = List.generate(60, (i) => i + 1);       // 1–60kg

// ── 薬剤 enum ─────────────────────────────────────────────────────────────
enum _SedDrug {
  thiamylal('チアラミール'),
  thiopental('チオペンタール'),
  propofol('プロポフォール');
  final String label;
  const _SedDrug(this.label);
}

enum _BarbConc {
  pct25('2.5%  (25 mg/mL)', 25.0),
  pct50('5%  (50 mg/mL)', 50.0);
  final String label;
  final double mgPerMl;
  const _BarbConc(this.label, this.mgPerMl);
}

enum _RocConc {
  original('原液  (10 mg/mL)', 10.0),
  half('2倍希釈  (5 mg/mL)', 5.0);
  final String label;
  final double mgPerMl;
  const _RocConc(this.label, this.mgPerMl);
}

enum _FentConc {
  original('原液  (50 μg/mL)', 50.0),
  diluted('希釈  (10 μg/mL)', 10.0);
  final String label;
  final double mcgPerMl;
  const _FentConc(this.label, this.mcgPerMl);
}

enum _AtropConc {
  tenX('10倍希釈  (0.05 mg/mL)', 0.05),
  original('原液  (0.5 mg/mL)', 0.5);
  final String label;
  final double mgPerMl;
  const _AtropConc(this.label, this.mgPerMl);
}

// ── Main ──────────────────────────────────────────────────────────────────
class PediatricScreen extends StatefulWidget {
  const PediatricScreen({super.key});
  @override
  State<PediatricScreen> createState() => _PediatricScreenState();
}

class _PediatricScreenState extends State<PediatricScreen> {
  // 患者
  int _ageYears  = 6;
  int _ageMonths = 0;
  int _height    = 115;
  int _weight    = 20;

  // 薬剤設定
  _SedDrug   _sed      = _SedDrug.thiamylal;
  _BarbConc  _barbConc = _BarbConc.pct25;
  _RocConc   _rocConc  = _RocConc.original;
  _FentConc  _fentConc = _FentConc.original;

  // ── Computed ────────────────────────────────────────────────────────────
  double get _ageYrs => _ageYears + _ageMonths / 12.0;
  double get _wt     => _weight.toDouble();

  // チューブ
  double get _tubeCuffless {
    if (_ageYrs < 0.5) return 3.0;
    if (_ageYrs < 1.0) return 3.5;
    return _ageYrs / 4 + 4.0;
  }
  double get _tubeCuffed {
    if (_ageYrs < 0.5) return 2.5;
    if (_ageYrs < 1.0) return 3.0;
    return _ageYrs / 4 + 3.5;
  }
  double get _fixLen {
    if (_ageYrs < 1.0) return 10.5 + _ageMonths * 0.125;
    return _ageYrs / 2 + 12.0;
  }

  // 鎮静薬
  double get _sedConcMgMl => _sed == _SedDrug.propofol ? 10.0 : _barbConc.mgPerMl;
  double get _sedMinPKg   => _sed == _SedDrug.propofol ? 2.5 : 3.0;
  double get _sedMaxPKg   => _sed == _SedDrug.propofol ? 3.5 : 5.0;
  double get _sedMinMg    => _wt * _sedMinPKg;
  double get _sedMaxMg    => _wt * _sedMaxPKg;
  double get _sedMinMl    => _sedMinMg / _sedConcMgMl;
  double get _sedMaxMl    => _sedMaxMg / _sedConcMgMl;

  // ロクロニウム (1 mg/kg 固定)
  double get _rocMg => _wt * 1.0;
  double get _rocMl => _rocMg / _rocConc.mgPerMl;

  // フェンタニル (1 μg/kg 固定)
  double get _fentMcg => _wt * 1.0;
  double get _fentMl  => _fentMcg / _fentConc.mcgPerMl;

  // アトロピン (≤10kg のみ, mg 表記のみ)
  bool   get _showAtrop => _weight <= 10;
  double get _atropMg   => _wt * 0.01;

  // ── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('小児麻酔 計算機'),
        backgroundColor: scheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _patientCard(scheme),
          const SizedBox(height: 12),
          _tubeCard(scheme),
          const SizedBox(height: 12),
          _sedCard(scheme),
          const SizedBox(height: 12),
          _rocCard(scheme),
          const SizedBox(height: 12),
          _fentCard(scheme),
          if (_showAtrop) ...[
            const SizedBox(height: 12),
            _atropCard(scheme),
          ],
        ],
      ),
    );
  }

  // ── 患者情報 ─────────────────────────────────────────────────────────────
  Widget _patientCard(ColorScheme scheme) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _secTitle('患者情報', scheme),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _ddField<int>(
              label: '年齢', suffix: '歳', value: _ageYears, items: _ageYearOpts,
              onChanged: (v) => setState(() => _ageYears = v),
            )),
            const SizedBox(width: 8),
            Expanded(child: _ddField<int>(
              label: '月齢', suffix: 'ヶ月', value: _ageMonths, items: _ageMonthOpts,
              onChanged: (v) => setState(() => _ageMonths = v),
            )),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: _ddField<int>(
              label: '身長', suffix: 'cm', value: _height, items: _heightOpts,
              onChanged: (v) => setState(() => _height = v),
            )),
            const SizedBox(width: 8),
            Expanded(child: _ddField<int>(
              label: '体重', suffix: 'kg', value: _weight, items: _weightOpts,
              onChanged: (v) => setState(() => _weight = v),
            )),
          ]),
        ],
      ),
    ),
  );

  // ── 挿管チューブ ──────────────────────────────────────────────────────────
  Widget _tubeCard(ColorScheme scheme) => Card(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: scheme.primary, width: 4)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.airline_seat_recline_extra, size: 18, color: scheme.primary),
            const SizedBox(width: 6),
            Text('挿管チューブ', style: TextStyle(
                color: scheme.primary, fontWeight: FontWeight.bold, fontSize: 15)),
          ]),
          if (_ageYrs < 1.0) ...[
            const SizedBox(height: 6),
            _warnBadge('1歳未満: 年齢式の精度低下あり. 実測体格で確認を.'),
          ],
          const SizedBox(height: 12),
          _tubeRow('カフなし ID', '${_tubeCuffless.toStringAsFixed(1)} mm', 'age/4 + 4.0'),
          const Divider(height: 14),
          _tubeRow('カフあり ID', '${_tubeCuffed.toStringAsFixed(1)} mm', 'age/4 + 3.5'),
          const Divider(height: 14),
          _tubeRow('固定長 (口角)', '${_fixLen.toStringAsFixed(1)} cm', 'age/2 + 12'),
          const Divider(height: 14),
          _tubeRow('固定長 (鼻腔)', '${(_fixLen + 2.5).toStringAsFixed(1)} cm', '口角 + 2.5'),
        ],
      ),
    ),
  );

  Widget _tubeRow(String label, String value, String formula) => Row(
    children: [
      SizedBox(width: 100, child: Text(label,
          style: const TextStyle(fontSize: 12, color: Colors.black54))),
      Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const Spacer(),
      Text(formula, style: const TextStyle(fontSize: 11, color: Colors.black38)),
    ],
  );

  // ── 鎮静薬 ───────────────────────────────────────────────────────────────
  Widget _sedCard(ColorScheme scheme) {
    final color = DrugCategory.sedative.color;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              CategoryMark(color: color, size: 14),
              const SizedBox(width: 7),
              const Text('鎮静薬', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ]),
            const SizedBox(height: 10),
            _chips<_SedDrug>(
              values: _SedDrug.values, selected: _sed, color: color,
              label: (d) => d.label,
              onTap: (d) => setState(() => _sed = d),
            ),
            const SizedBox(height: 10),
            if (_sed != _SedDrug.propofol) ...[
              _enumDd<_BarbConc>(
                label: '希釈濃度', value: _barbConc, items: _BarbConc.values,
                itemLabel: (c) => c.label,
                onChanged: (v) => setState(() => _barbConc = v),
              ),
              const SizedBox(height: 8),
              // 押水アラート
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.water_drop, size: 14, color: Colors.red),
                    SizedBox(width: 6),
                    Expanded(child: Text(
                      '投与後は必ず押水（生食フラッシュ）を行うこと.\nルート内残留・血管外漏出に注意.',
                      style: TextStyle(
                          fontSize: 11, color: Colors.red, height: 1.4),
                    )),
                  ],
                ),
              ),
            ] else
              _propoWarning(),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            _mlMgRow(label: '低用量',
              basis: '${_sedMinPKg.toStringAsFixed(1)} mg/kg',
              mlValue: _sedMinMl, mgValue: _sedMinMg, mgUnit: 'mg'),
            const SizedBox(height: 10),
            _mlMgRow(label: '高用量',
              basis: '${_sedMaxPKg.toStringAsFixed(1)} mg/kg',
              mlValue: _sedMaxMl, mgValue: _sedMaxMg, mgUnit: 'mg'),
          ],
        ),
      ),
    );
  }

  Widget _propoWarning() => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.orange.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.orange.shade300),
    ),
    child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(Icons.warning_amber_rounded, size: 14, color: Colors.orange),
      SizedBox(width: 6),
      Expanded(child: Text(
        'Propofol Infusion Syndrome に注意.\n長時間・高用量投与は禁忌. 固定濃度: 10 mg/mL.',
        style: TextStyle(fontSize: 11, color: Colors.deepOrange, height: 1.4),
      )),
    ]),
  );

  // ── ロクロニウム ──────────────────────────────────────────────────────────
  Widget _rocCard(ColorScheme scheme) {
    final color = DrugCategory.muscleRelaxant.color;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              CategoryMark(color: color, size: 14),
              const SizedBox(width: 7),
              const Text('筋弛緩薬  (ロクロニウム)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ]),
            const SizedBox(height: 10),
            _enumDd<_RocConc>(
              label: '希釈濃度', value: _rocConc, items: _RocConc.values,
              itemLabel: (c) => c.label,
              onChanged: (v) => setState(() => _rocConc = v),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            _mlMgRow(label: '投与量', basis: '1.0 mg/kg',
              mlValue: _rocMl, mgValue: _rocMg, mgUnit: 'mg'),
            const SizedBox(height: 8),
            _noteBadge('拮抗: スガマデクス 2 mg/kg (通常) / 16 mg/kg (即時)',
                DrugCategory.muscleRelaxant.color),
          ],
        ),
      ),
    );
  }

  // ── フェンタニル ──────────────────────────────────────────────────────────
  Widget _fentCard(ColorScheme scheme) {
    final color = DrugCategory.analgesic.color;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              CategoryMark(color: color, size: 14),
              const SizedBox(width: 7),
              const Text('鎮痛薬  (フェンタニル)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ]),
            const SizedBox(height: 10),
            _enumDd<_FentConc>(
              label: '希釈濃度', value: _fentConc, items: _FentConc.values,
              itemLabel: (c) => c.label,
              onChanged: (v) => setState(() => _fentConc = v),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            _mlMgRow(label: '投与量', basis: '1 μg/kg',
              mlValue: _fentMl, mgValue: _fentMcg, mgUnit: 'μg'),
          ],
        ),
      ),
    );
  }

  // ── アトロピン (≤10kg, mg のみ) ──────────────────────────────────────────
  Widget _atropCard(ColorScheme scheme) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.medication_outlined, size: 16, color: Colors.teal.shade600),
            const SizedBox(width: 7),
            Text('アトロピン  (迷走神経反射予防)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,
                    color: Colors.teal.shade700)),
          ]),
          const SizedBox(height: 2),
          const Text('体重 ≤ 10 kg のみ表示',
              style: TextStyle(fontSize: 11, color: Colors.black38)),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          // mg のみ表示
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const SizedBox(
                width: 78,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('投与量',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    Text('0.01 mg/kg',
                        style: TextStyle(fontSize: 11, color: Colors.black45)),
                  ],
                ),
              ),
              Expanded(
                child: RichText(
                  textAlign: TextAlign.right,
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(text: _fmtMg(_atropMg),
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold)),
                      const TextSpan(text: ' mg',
                          style: TextStyle(fontSize: 14, color: Colors.black54)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  // ── 共通 Widgets ──────────────────────────────────────────────────────────

  /// mL (大) + mg/μg (小) の2段表示行
  Widget _mlMgRow({
    required String label,
    required String basis,
    required double mlValue,
    required double mgValue,
    required String mgUnit,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 78,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              Text(basis,
                  style: const TextStyle(fontSize: 11, color: Colors.black45)),
            ],
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // mL — 投与用 (主)
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(text: _fmtMl(mlValue),
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold)),
                    const TextSpan(text: ' mL',
                        style: TextStyle(fontSize: 13, color: Colors.black54)),
                  ],
                ),
              ),
              // mg — 記録用 (副)
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(text: _fmtMg(mgValue),
                        style: const TextStyle(
                            fontSize: 15, color: Colors.black45)),
                    TextSpan(text: ' $mgUnit',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black38)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 薬剤選択チップ (汎用)
  Widget _chips<T>({
    required List<T> values,
    required T selected,
    required Color color,
    required String Function(T) label,
    required void Function(T) onTap,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: values.map((v) {
        final sel = v == selected;
        return GestureDetector(
          onTap: () => onTap(v),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: sel
                  ? color.withValues(alpha: 0.15)
                  : const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: sel ? color : Colors.transparent, width: 1.5),
            ),
            child: Text(label(v),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                    color: sel ? Colors.black87 : Colors.black54)),
          ),
        );
      }).toList(),
    );
  }

  /// enum 用ドロップダウン (希釈選択)
  Widget _enumDd<T>({
    required String label,
    required T value,
    required List<T> items,
    required String Function(T) itemLabel,
    required ValueChanged<T> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        filled: true,
        fillColor: const Color(0xFFF7F9FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      items: items
          .map((v) => DropdownMenuItem<T>(
                value: v,
                child: Text(itemLabel(v),
                    style: const TextStyle(fontSize: 13)),
              ))
          .toList(),
      onChanged: (v) { if (v != null) onChanged(v); },
    );
  }

  /// 患者情報用ドロップダウン
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
      onChanged: (v) { if (v != null) onChanged(v); },
    );
  }

  Widget _secTitle(String t, ColorScheme s) => Text(t,
      style: TextStyle(
          color: s.primary, fontWeight: FontWeight.bold, fontSize: 14));

  Widget _warnBadge(String text) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.orange.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(text,
        style: const TextStyle(fontSize: 11, color: Colors.deepOrange)),
  );

  Widget _noteBadge(String text, Color color) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.07),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(text,
        style: const TextStyle(fontSize: 11, color: Colors.black54)),
  );
}

// ── 数値フォーマット ──────────────────────────────────────────────────────
String _fmtMl(double v) {
  if (v < 0.05) return v.toStringAsFixed(2);
  if (v < 1)    return v.toStringAsFixed(2);
  if (v < 10)   return v.toStringAsFixed(1);
  return v.toStringAsFixed(0);
}

String _fmtMg(double v) {
  if (v < 0.005) return v.toStringAsFixed(3);
  if (v < 0.1)   return v.toStringAsFixed(2);
  if (v < 1)     return v.toStringAsFixed(2);
  if (v < 10)    return v.toStringAsFixed(1);
  return v.toStringAsFixed(0);
}
