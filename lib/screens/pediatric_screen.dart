import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/drug.dart';
import '../widgets/category_mark.dart';

// ── 選択肢 ────────────────────────────────────────────────────────────────
final _heightOpts = List.generate(23, (i) => 30 + i * 5); // 30–140cm
final _weightOpts = List.generate(60, (i) => i + 1);       // 1–60kg

// ── 薬剤 enum ─────────────────────────────────────────────────────────────
enum _SedDrug {
  thiamylal('チアラミール'),
  thiopental('チオペンタール'),
  propofol('プロポフォール');
  final String label;
  const _SedDrug(this.label);
}

enum _RocConc {
  original('原液  (10 mg/mL)', 10.0),
  half('2倍希釈  (5 mg/mL)', 5.0);
  final String label;
  final double mgPerMl;
  const _RocConc(this.label, this.mgPerMl);
  String get shortLabel => switch (this) {
    _RocConc.original => '原液 10mg/mL',
    _RocConc.half     => '2倍希釈 5mg/mL',
  };
  String get concLabel => switch (this) {
    _RocConc.original => '原液 (10mg/mL)',
    _RocConc.half     => '2倍希釈 (5mg/mL)',
  };
}

enum _FentConc {
  original('原液  (50 μg/mL)', 50.0),
  diluted('希釈  (10 μg/mL)', 10.0);
  final String label;
  final double mcgPerMl;
  const _FentConc(this.label, this.mcgPerMl);
  String get shortLabel => switch (this) {
    _FentConc.original => '原液 50μg/mL',
    _FentConc.diluted  => '希釈 10μg/mL',
  };
  String get concLabel => switch (this) {
    _FentConc.original => '原液 (50μg/mL)',
    _FentConc.diluted  => '希釈 (10μg/mL)',
  };
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

  // 年齢テキスト入力 (yy/mm 形式)
  final _ageCtrl = TextEditingController(text: '6');

  // 薬剤設定
  _SedDrug  _sed      = _SedDrug.thiamylal;
  _RocConc  _rocConc  = _RocConc.original;
  _FentConc _fentConc = _FentConc.original;

  // 呼吸器設定
  int _rr = 20; // 呼吸回数 (20/25/30, 5回刻み)

  @override
  void initState() {
    super.initState();
    _ageCtrl.addListener(_parseAge);
  }

  @override
  void dispose() {
    _ageCtrl.dispose();
    super.dispose();
  }

  /// "yy/mm" または "yy" の入力を解析して _ageYears / _ageMonths を更新
  void _parseAge() {
    final parts = _ageCtrl.text.split('/');
    final years  = (int.tryParse(parts[0].trim()) ?? 0).clamp(0, 12);
    final months = parts.length >= 2
        ? (int.tryParse(parts[1].trim()) ?? 0).clamp(0, 11)
        : 0;
    if (_ageYears != years || _ageMonths != months) {
      setState(() {
        _ageYears  = years;
        _ageMonths = months;
      });
    }
  }

  // ── Computed ────────────────────────────────────────────────────────────
  double get _ageYrs => _ageYears + _ageMonths / 12.0;
  double get _wt     => _weight.toDouble();

  // 気管チューブ
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
  // 固定長: 身長/11 + 5.5 cm, 0.5cm単位に丸め
  double get _fixLen =>
      ((_height / 11.0 + 5.5) * 2).round() / 2.0;

  // 鎮静薬 (バルビツール固定2.5% = 25mg/mL, プロポ固定10mg/mL)
  double get _sedConcMgMl => _sed == _SedDrug.propofol ? 10.0 : 25.0;
  double get _sedMinPKg   => _sed == _SedDrug.propofol ? 2.0 : 3.0;
  double get _sedMaxPKg   => _sed == _SedDrug.propofol ? 2.0 : 5.0;
  double get _sedMinMg    => _wt * _sedMinPKg;
  double get _sedMaxMg    => _wt * _sedMaxPKg;
  double get _sedMinMl    => _sedMinMg / _sedConcMgMl;
  double get _sedMaxMl    => _sedMaxMg / _sedConcMgMl;

  /// 投与幅内で整数 mL になる候補
  List<int> get _sedIntMls {
    final lo = _sedMinMl.ceil();
    final hi = _sedMaxMl.floor();
    if (lo > hi) return [];
    return List.generate(hi - lo + 1, (i) => lo + i);
  }

  /// サマリー用: 投与幅の中央に最も近い整数 mL
  int get _sedSummaryMl {
    final intMls = _sedIntMls;
    if (intMls.isNotEmpty) {
      final mid = (_sedMinMl + _sedMaxMl) / 2;
      return intMls.reduce((a, b) =>
          (a - mid).abs() < (b - mid).abs() ? a : b);
    }
    return ((_sedMinMl + _sedMaxMl) / 2).round().clamp(1, 50);
  }
  double get _sedSummaryMg => _sedSummaryMl * _sedConcMgMl;

  // ロクロニウム (1 mg/kg 固定)
  double get _rocMg => _wt * 1.0;
  double get _rocMl => _rocMg / _rocConc.mgPerMl;

  // フェンタニル (1–2 μg/kg 範囲)
  double get _fentMinMcg => _wt * 1.0;
  double get _fentMaxMcg => _wt * 2.0;
  double get _fentMinMl  => _fentMinMcg / _fentConc.mcgPerMl;
  double get _fentMaxMl  => _fentMaxMcg / _fentConc.mcgPerMl;
  double get _fentStep   => _fentConc == _FentConc.diluted ? 0.5 : 0.1;

  /// 投与幅内の最初のステップ mL
  double? get _fentSuggestMl {
    final step = _fentStep;
    final n = ((_fentMinMl / step) + 1e-9).ceil();
    final first = double.parse((n * step).toStringAsFixed(2));
    if (first > _fentMaxMl + 1e-9) return null;
    return first;
  }
  double get _fentSummaryMl  => _fentSuggestMl ?? _fentMinMl;
  double get _fentSummaryMcg => _fentSummaryMl * _fentConc.mcgPerMl;

  // アトロピン (≤10kg のみ, 固定: 10倍希釈 0.05mg/mL)
  bool   get _showAtrop  => _weight <= 10;
  double get _atropMg    => _wt * 0.01;
  double get _atropMl    => _atropMg / 0.05; // 10倍希釈固定

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
          _ventCard(scheme),
          const SizedBox(height: 12),
          _sedCard(scheme),
          const SizedBox(height: 12),
          _rocCard(scheme),
          const SizedBox(height: 12),
          _fentCard(scheme),
          const SizedBox(height: 16),
          _summaryZone(scheme),
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
          _ageField(),
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

  // ── 年齢テキスト入力フィールド ────────────────────────────────────────────
  Widget _ageField() {
    final String parsed;
    if (_ageYears == 0 && _ageMonths > 0) {
      parsed = '$_ageMonths ヶ月';
    } else if (_ageMonths == 0) {
      parsed = '$_ageYears 歳';
    } else {
      parsed = '$_ageYears 歳  $_ageMonths ヶ月';
    }
    return TextField(
      controller: _ageCtrl,
      keyboardType: TextInputType.text,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
        LengthLimitingTextInputFormatter(5),
      ],
      decoration: InputDecoration(
        labelText: '年齢  (yy/mm)',
        hintText: '例: 6/3',
        helperText: parsed,
        helperStyle: const TextStyle(fontSize: 11, color: Colors.black54),
        suffixText: 'y / m',
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
    );
  }

  // ── 気管チューブ (コンパクト表示) ─────────────────────────────────────────
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
            Text('気管チューブ', style: TextStyle(
                color: scheme.primary, fontWeight: FontWeight.bold, fontSize: 15)),
          ]),
          if (_ageYrs < 1.0) ...[
            const SizedBox(height: 6),
            _warnBadge('1歳未満: 年齢式の精度低下あり. 実測体格で確認を.'),
          ],
          const SizedBox(height: 12),
          // チューブ径
          _tubeCompactRow(
            rowLabel: 'チューブ径',
            leftLabel: 'カフあり',
            leftVal: _tubeCuffed,
            rightLabel: 'なし',
            rightVal: _tubeCuffless,
            unit: 'mm',
          ),
          const Divider(height: 14),
          // 固定長
          _tubeCompactRow(
            rowLabel: '固定長',
            leftLabel: '口角',
            leftVal: _fixLen,
            rightLabel: '鼻腔',
            rightVal: _fixLen + 2.5,
            unit: 'cm',
          ),
          const SizedBox(height: 4),
          Text('身長/11 + 5.5  (0.5cm単位)',
              style: const TextStyle(fontSize: 10, color: Colors.black38)),
        ],
      ),
    ),
  );

  Widget _tubeCompactRow({
    required String rowLabel,
    required String leftLabel,
    required double leftVal,
    required String rightLabel,
    required double rightVal,
    required String unit,
  }) {
    final bigStyle   = const TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
    final smallStyle = const TextStyle(fontSize: 12, color: Colors.black54);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        SizedBox(width: 58,
            child: Text(rowLabel, style: smallStyle)),
        Text(leftLabel, style: smallStyle),
        const SizedBox(width: 4),
        Text(leftVal.toStringAsFixed(1), style: bigStyle),
        Text(' $unit', style: smallStyle),
        Text('  /  $rightLabel ', style: smallStyle),
        Text(rightVal.toStringAsFixed(1), style: bigStyle),
        Text(' $unit', style: smallStyle),
      ],
    );
  }

  // ── 呼吸器設定 (PCV) ──────────────────────────────────────────────────────
  Widget _ventCard(ColorScheme scheme) => Card(
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
            Icon(Icons.air, size: 18, color: scheme.primary),
            const SizedBox(width: 6),
            Text('呼吸器設定', style: TextStyle(
                color: scheme.primary, fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text('PCV', style: TextStyle(
                  fontSize: 10, color: scheme.primary, fontWeight: FontWeight.bold)),
            ),
          ]),
          const SizedBox(height: 12),
          _ventRow('PEEP', '5', 'cmH₂O', null),
          const Divider(height: 16),
          _ventRow('ΔP (駆動圧)', '10', 'cmH₂O', 'Pmax 15'),
          const Divider(height: 16),
          // 呼吸回数 (ドロップダウン)
          Row(children: [
            const SizedBox(width: 96,
                child: Text('呼吸回数',
                    style: TextStyle(fontSize: 13, color: Colors.black54))),
            _inlineDd<int>(
              value: _rr, items: const [20, 25, 30],
              itemLabel: (v) => '$v',
              onChanged: (v) => setState(() => _rr = v),
            ),
            const SizedBox(width: 8),
            const Text('回/min',
                style: TextStyle(fontSize: 13, color: Colors.black54)),
          ]),
        ],
      ),
    ),
  );

  Widget _ventRow(String label, String value, String unit, String? sub) => Row(
    crossAxisAlignment: CrossAxisAlignment.baseline,
    textBaseline: TextBaseline.alphabetic,
    children: [
      SizedBox(width: 96,
          child: Text(label,
              style: const TextStyle(fontSize: 13, color: Colors.black54))),
      Text(value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(width: 4),
      Text(unit, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      if (sub != null) ...[
        const Spacer(),
        Text(sub,
            style: const TextStyle(
                fontSize: 12,
                color: Colors.black45,
                fontWeight: FontWeight.w600)),
      ],
    ],
  );

  // ── 鎮静薬 (選択のみ) ─────────────────────────────────────────────────────
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
              const Text('鎮静薬',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ]),
            const SizedBox(height: 10),
            _chips<_SedDrug>(
              values: _SedDrug.values, selected: _sed, color: color,
              label: (d) => d.label,
              onTap: (d) => setState(() => _sed = d),
            ),
            const SizedBox(height: 8),
            if (_sed != _SedDrug.propofol)
              _barbAlert()
            else
              _propoWarning(),
          ],
        ),
      ),
    );
  }

  Widget _barbAlert() => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.red.withValues(alpha: 0.07),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.red.shade200),
    ),
    child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(Icons.water_drop, size: 14, color: Colors.red),
      SizedBox(width: 6),
      Expanded(child: Text(
        '投与後は必ず押水（生食フラッシュ）を行うこと.\nルート内残留・血管外漏出に注意.',
        style: TextStyle(fontSize: 11, color: Colors.red, height: 1.4),
      )),
    ]),
  );

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

  // ── ロクロニウム (選択のみ) ───────────────────────────────────────────────
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
              const Expanded(
                child: Text('筋弛緩薬  (ロクロニウム)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              _inlineDd<_RocConc>(
                value: _rocConc, items: _RocConc.values,
                itemLabel: (c) => c.shortLabel,
                onChanged: (v) => setState(() => _rocConc = v),
              ),
            ]),
            const SizedBox(height: 8),
            _noteBadge('拮抗: スガマデクス 2 mg/kg (通常) / 16 mg/kg (即時)',
                color),
          ],
        ),
      ),
    );
  }

  // ── フェンタニル (選択のみ) ───────────────────────────────────────────────
  Widget _fentCard(ColorScheme scheme) {
    final color = DrugCategory.analgesic.color;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CategoryMark(color: color, size: 14),
            const SizedBox(width: 7),
            const Expanded(
              child: Text('鎮痛薬  (フェンタニル)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
            _inlineDd<_FentConc>(
              value: _fentConc, items: _FentConc.values,
              itemLabel: (c) => c.shortLabel,
              onChanged: (v) => setState(() => _fentConc = v),
            ),
          ],
        ),
      ),
    );
  }

  // ── サマリーゾーン ────────────────────────────────────────────────────────
  Widget _summaryZone(ColorScheme scheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dosageCard(scheme),
        const SizedBox(height: 10),
        _recordCard(scheme),
      ],
    );
  }

  /// 投与カード: 薬剤名 + 濃度 + mL
  Widget _dosageCard(ColorScheme scheme) {
    final sedLabel = _sed == _SedDrug.propofol
        ? 'プロポフォール  10mg/mL'
        : '${_sed.label}  2.5% (25mg/mL)';

    final rows = <(String, String)>[
      (sedLabel,                              '${_sedSummaryMl} mL'),
      ('ロクロニウム  ${_rocConc.concLabel}', '${_fmtMl(_rocMl)} mL'),
      ('フェンタニル  ${_fentConc.concLabel}','${_fmtMl(_fentSummaryMl)} mL'),
      if (_showAtrop) ('アトロピン  10倍希釈 (0.05mg/mL)', '${_fmtMl(_atropMl)} mL'),
    ];

    return Card(
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
              Icon(Icons.colorize, size: 16, color: scheme.primary),
              const SizedBox(width: 6),
              Text('投与量',
                  style: TextStyle(color: scheme.primary,
                      fontWeight: FontWeight.bold, fontSize: 15)),
            ]),
            const SizedBox(height: 12),
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0) const Divider(height: 16),
              _summaryRow(rows[i].$1, rows[i].$2),
            ],
          ],
        ),
      ),
    );
  }

  /// 記載カード: 薬剤名 + mg/μg
  Widget _recordCard(ColorScheme scheme) {
    const recordColor = Color(0xFF607D8B); // blue-grey

    final rows = <(String, String)>[
      (_sed.label,    '${_fmtMg(_sedSummaryMg)} mg'),
      ('ロクロニウム', '${_fmtMg(_rocMg)} mg'),
      ('フェンタニル', '${_fmtMg(_fentSummaryMcg)} μg'),
      if (_showAtrop) ('アトロピン', '${_fmtMg(_atropMg)} mg'),
    ];

    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: const Border(left: BorderSide(color: recordColor, width: 4)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(children: [
              Icon(Icons.edit_note, size: 16, color: recordColor),
              SizedBox(width: 6),
              Text('麻酔記録  記載用',
                  style: TextStyle(color: recordColor,
                      fontWeight: FontWeight.bold, fontSize: 15)),
            ]),
            const SizedBox(height: 12),
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0) const Divider(height: 16),
              _summaryRow(rows[i].$1, rows[i].$2),
            ],
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) => Row(
    crossAxisAlignment: CrossAxisAlignment.baseline,
    textBaseline: TextBaseline.alphabetic,
    children: [
      Expanded(
        child: Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ),
      Text(value,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold)),
    ],
  );

  // ── 共通 Widgets ──────────────────────────────────────────────────────────

  /// カードタイトル横に置くコンパクトなインラインドロップダウン
  Widget _inlineDd<T>({
    required T value,
    required List<T> items,
    required String Function(T) itemLabel,
    required ValueChanged<T> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<T>(
        value: value,
        isDense: true,
        underline: const SizedBox.shrink(),
        style: const TextStyle(fontSize: 11, color: Colors.black54),
        iconSize: 16,
        icon: const Icon(Icons.expand_more, size: 16, color: Colors.black45),
        items: items
            .map((v) => DropdownMenuItem<T>(
                  value: v,
                  child: Text(itemLabel(v),
                      style: const TextStyle(
                          fontSize: 13, color: Colors.black87)),
                ))
            .toList(),
        onChanged: (v) { if (v != null) onChanged(v); },
      ),
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
      spacing: 8, runSpacing: 6,
      children: values.map((v) {
        final sel = v == selected;
        return GestureDetector(
          onTap: () => onTap(v),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: sel ? color.withValues(alpha: 0.15) : const Color(0xFFF0F0F0),
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
  if (v == 0) return '0';
  if (v < 0.1) return v.toStringAsFixed(2);
  if (v < 10)  return v.toStringAsFixed(1);
  return v.toStringAsFixed(0);
}

String _fmtMg(double v) {
  if (v < 0.005) return v.toStringAsFixed(3);
  if (v < 0.1)   return v.toStringAsFixed(2);
  if (v < 1)     return v.toStringAsFixed(2);
  if (v < 10)    return v.toStringAsFixed(1);
  return v.toStringAsFixed(0);
}
