import 'package:flutter/material.dart';

import '../models/drug.dart';
import '../state/patient_store.dart';
import '../widgets/calc_parts.dart';
import '../widgets/category_mark.dart';
import '../widgets/drug_visuals.dart';

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
  fentaRemi('フェンタ＋レミ');

  final String label;
  const _AnalDrug(this.label);
}

enum _Volatile {
  sevoflurane('セボフルラン', 2.0),
  desflurane('デスフルラン', 5.0);

  final String label;
  final double initPct; // 導入後の初期ダイアル設定 (%)
  const _Volatile(this.label, this.initPct);
}

// ── 用量モデル ────────────────────────────────────────────────────────────
class _DoseLine {
  final String rowLabel;
  final double value;
  final String unit;
  final String basis;
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
  final _patient = PatientStore.instance;
  int get _age => _patient.ageOr;        // 年齢・身長・体重・性別は患者情報から自動連携
  int get _height => _patient.heightOr;
  bool get _isMale => _patient.sexOr == Sex.male;

  _SedDrug  _sed  = _SedDrug.propofol;
  _AnalDrug _anal = _AnalDrug.fentanyl;
  _Volatile _volatile = _Volatile.sevoflurane;

  void _onPatient() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _patient.addListener(_onPatient);
  }

  @override
  void dispose() {
    _patient.removeListener(_onPatient);
    super.dispose();
  }

  bool   get _elderly => _age >= 65;
  double get _wt      => _patient.weightOr;
  // Devine式 (性別補正) — IBW: 薬剤投与量基準 / PBW: 換気量設定基準 (同値)
  double get _ibw     => (_isMale ? 50.0 : 45.5) + 0.91 * (_height - 152.4);
  double get _pbw     => _ibw;

  // 吸入麻酔薬 飽和後の目標 et濃度 (年齢補正)
  // A = 1.7 − 0.01×年齢 (etSev), B = 6.0 − 0.04×年齢 (etDes)
  double get _etTarget => _volatile == _Volatile.sevoflurane
      ? 1.7 - 0.01 * _age
      : 6.0 - 0.04 * _age;
  String get _etLabel =>
      _volatile == _Volatile.sevoflurane ? 'etSev' : 'etDes';

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
          _DoseLine('低用量', wt * 1.0, 'mg',   '1 mg/kg'),
          _DoseLine('高用量', wt * 2.0, 'mg',   '2 mg/kg'),
          _DoseLine('維持',   wt * 1.0, 'mg/h', '1 mg/kg/h'),
        ], 'ボーラス 1–2 mg/kg 緩徐静注. 意識消失後 1 mg/kg/h で開始. 拮抗薬: フルマゼニル.');
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

  // ── ml 換算ゲッター (投与量カード用) ─────────────────────────────────────
  // 鎮静薬
  String get _sedMlStr {
    final wt = _wt;
    switch (_sed) {
      case _SedDrug.propofol:
        final lo = wt * 1.0 / 10.0;
        final hi = (_elderly ? wt * 1.5 : wt * 2.0) / 10.0;
        return '${_fmtMl(lo)} 〜 ${_fmtMl(hi)} ml';
      case _SedDrug.remimazolam:
        return '${_fmtMl(wt * 1.0)} 〜 ${_fmtMl(wt * 2.0)} mg (bolus)';
      case _SedDrug.midazolam:
        final lo = (_elderly ? wt * 0.025 : wt * 0.05) / 5.0;
        final hi = (_elderly ? wt * 0.05  : wt * 0.10) / 5.0;
        return '${_fmtMl(lo)} 〜 ${_fmtMl(hi)} ml';
    }
  }

  /// remimazolam の維持速度行 (他の薬剤は null)
  String? get _sedMlLine2 {
    if (_sed != _SedDrug.remimazolam) return null;
    return '${_fmtMl(_wt * 1.0)} mg/h (維持)';
  }

  String get _sedConcNote => switch (_sed) {
    _SedDrug.propofol    => '10 mg/ml',
    _SedDrug.remimazolam => 'アネレム (50 mg/vial, 調製濃度で換算)',
    _SedDrug.midazolam   => '5 mg/ml',
  };

  // 鎮痛薬 (行1) — ml は 0.5ml 刻み
  String get _analMlLine1 {
    final wt = _wt;
    switch (_anal) {
      case _AnalDrug.fentanyl:
        return '${_fmtMl(_r05(wt * 1.0 / 50.0))} 〜 ${_fmtMl(_r05(wt * 3.0 / 50.0))} ml';
      case _AnalDrug.remifentanil:
        final lo = _r05(wt * 0.25 * 60.0 / 100.0);
        final hi = _r05(wt * 0.5  * 60.0 / 100.0);
        return '${_fmtMl(lo)} 〜 ${_fmtMl(hi)} ml/h';
      case _AnalDrug.fentaRemi:
        return 'F  ${_fmtMl(_r05(wt * 1.0 / 50.0))} 〜 ${_fmtMl(_r05(wt * 2.0 / 50.0))} ml (bolus)';
    }
  }

  // 鎮痛薬 (行2: フェンタ+レミのみ) — ml は 0.5ml 刻み
  String? get _analMlLine2 {
    if (_anal != _AnalDrug.fentaRemi) return null;
    final wt = _wt;
    final lo = _r05(wt * 0.1  * 60.0 / 100.0);
    final hi = _r05(wt * 0.25 * 60.0 / 100.0);
    return 'R  ${_fmtMl(lo)} 〜 ${_fmtMl(hi)} ml/h';
  }

  String get _analConcNote => switch (_anal) {
    _AnalDrug.fentanyl     => '50 μg/ml',
    _AnalDrug.remifentanil => '100 μg/ml (アルチバ 2mg/20mL)',
    _AnalDrug.fentaRemi    => 'F 50 μg/ml　R 100 μg/ml',
  };

  // 筋弛緩薬 — ml は 0.5ml 刻み
  String get _relaxMlStr {
    final wt = _wt;
    return '${_fmtMl(_r05(wt * 0.6 / 10.0))} 〜 ${_fmtMl(_r05(wt * 1.2 / 10.0))} ml';
  }

  String _fmtMl(double v) =>
      (v == v.truncateToDouble()) ? v.toInt().toString() : v.toStringAsFixed(1);

  /// 0.5 ml 刻みに丸める
  double _r05(double v) => (v * 2).round() / 2;

  // ── build ───────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('成人 麻酔導入時'),
        backgroundColor: scheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [

          // ── 患者情報 + 薬剤選択 (2カラム) ────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _secTitle('患者情報', scheme),
                  const SizedBox(height: 4),
                  Text('年齢・身長・体重・性別は「機能」TOPの患者情報から自動連携',
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade600)),
                  const SizedBox(height: 8),
                  PatientLinkedChip(
                    '$_age歳 · $_height cm · ${_wt % 1 == 0 ? _wt.toStringAsFixed(0) : _wt} kg · ${_patient.sexOr.label}',
                    usingDefault: _patient.age == null ||
                        _patient.heightCm == null ||
                        _patient.weightKg == null ||
                        _patient.sex == null,
                    accent: scheme.primary,
                  ),
                  const SizedBox(height: 14),
                  _secTitle('薬剤', scheme),
                  const SizedBox(height: 8),
                  _ddField<_SedDrug>(
                    label: '鎮静薬', suffix: '',
                    value: _sed, items: _SedDrug.values,
                    itemLabel: (d) => d.label,
                    onChanged: (v) => setState(() => _sed = v),
                  ),
                  const SizedBox(height: 8),
                  _ddField<_AnalDrug>(
                    label: '鎮痛薬', suffix: '',
                    value: _anal, items: _AnalDrug.values,
                    itemLabel: (d) => d.label,
                    onChanged: (v) => setState(() => _anal = v),
                  ),
                  const SizedBox(height: 8),
                  _ddField<_Volatile>(
                    label: '吸入麻酔薬', suffix: '',
                    value: _volatile, items: _Volatile.values,
                    itemLabel: (d) => d.label,
                    onChanged: (v) => setState(() => _volatile = v),
                  ),
                  const SizedBox(height: 10),
                  // IBW / PBW バッジ
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'IBW / PBW: ${_ibw.toStringAsFixed(1)} kg（Devine式）',
                          style: TextStyle(
                              color: scheme.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        ),
                        if (_elderly) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade600,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('高齢者用量',
                                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
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

          // ── 投与量カード ──────────────────────────────────────────
          _buildDoseCard(scheme),
          const SizedBox(height: 12),
          // ── 人工呼吸器初期設定カード ─────────────────────────────
          _VentCard(pbw: _pbw, scheme: scheme),
        ],
      ),
    );
  }

  // ── 投与量カード ─────────────────────────────────────────────────────────
  Widget _buildDoseCard(ColorScheme scheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _secTitle('投与量', scheme),
            const SizedBox(height: 12),
            _mlRow(
              label: '鎮静薬',
              color: DrugCategory.sedative.color,
              line1: _sedMlStr,
              line2: _sedMlLine2,
              note:  _sedConcNote,
            ),
            const Divider(height: 16),
            _mlRow(
              label: '吸入麻酔',
              color: DrugCategory.inhalational.color,
              line1: '${_volatile.label}  導入 ${_volatile.initPct.toStringAsFixed(0)}%',
              line2: '維持 ${_etTarget.toStringAsFixed(1)}% ($_etLabel を目標)',
              note:  '飽和後に目標etまで漸増して維持',
            ),
            const Divider(height: 16),
            _mlRow(
              label: '鎮痛薬',
              color: DrugCategory.analgesic.color,
              line1: _analMlLine1,
              line2: _analMlLine2,
              note:  _analConcNote,
            ),
            const Divider(height: 16),
            _mlRow(
              label: '筋弛緩薬',
              color: DrugCategory.muscleRelaxant.color,
              line1: _relaxMlStr,
              note:  'ロクロニウム 10 mg/ml',
            ),
          ],
        ),
      ),
    );
  }

  Widget _mlRow({
    required String label,
    required Color color,
    required String line1,
    String? line2,
    required String note,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CategoryMark(color: color, size: 11),
        const SizedBox(width: 6),
        SizedBox(
          width: 52,
          child: Text(label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(line1,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              if (line2 != null) ...[
                const SizedBox(height: 2),
                Text(line2,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
              const SizedBox(height: 2),
              Text(note,
                  style: const TextStyle(fontSize: 10, color: Colors.black45)),
            ],
          ),
        ),
      ],
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
    String Function(T)? itemLabel,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix.isEmpty ? null : suffix,
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
                child: Text(
                  itemLabel != null ? itemLabel(v) : '$v',
                  style: const TextStyle(fontSize: 13),
                ),
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
  final String subtitle;
  final Color color;
  final _DoseInfo doseInfo;

  const _DrugClassCard({
    required this.classLabel,
    required this.subtitle,
    required this.color,
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
            Row(
              children: [
                CategoryMark(color: color, size: 14),
                const SizedBox(width: 7),
                Text(classLabel,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(width: 8),
                Text(subtitle,
                    style: const TextStyle(fontSize: 13, color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            for (var i = 0; i < doseInfo.lines.length; i++) ...[
              if (i > 0) const SizedBox(height: 8),
              _DoseRow(line: doseInfo.lines[i]),
            ],
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(doseInfo.note,
                  style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.4)),
            ),
          ],
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
              style: const TextStyle(fontSize: 12, color: Colors.black45)),
        ),
        Expanded(
          child: Text(
            _fmtDose(line.value),
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 66,
          child: Text(line.unit,
              style: const TextStyle(fontSize: 13, color: Colors.black54)),
        ),
        SizedBox(
          width: 82,
          child: Text(line.basis,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 11, color: Colors.black38)),
        ),
      ],
    );
  }
}

// ── 人工呼吸器初期設定カード (VCV / PCV) ──────────────────────────────────
enum _VentMode { vcv, pcv }

class _VentCard extends StatefulWidget {
  final double pbw;
  final ColorScheme scheme;
  const _VentCard({required this.pbw, required this.scheme});

  @override
  State<_VentCard> createState() => _VentCardState();
}

class _VentCardState extends State<_VentCard> {
  _VentMode _mode = _VentMode.vcv;

  @override
  Widget build(BuildContext context) {
    final tv = widget.pbw * 7;
    final s  = widget.scheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ヘッダー
            Row(children: [
              Icon(Icons.air, size: 16, color: s.primary),
              const SizedBox(width: 6),
              Text('人工呼吸器初期設定',
                  style: TextStyle(color: s.primary, fontWeight: FontWeight.bold, fontSize: 14)),
            ]),
            const SizedBox(height: 10),

            // VCV / PCV セグメント
            SegmentedButton<_VentMode>(
              segments: const [
                ButtonSegment(value: _VentMode.vcv, label: Text('VCV')),
                ButtonSegment(value: _VentMode.pcv, label: Text('PCV')),
              ],
              selected: {_mode},
              onSelectionChanged: (s) => setState(() => _mode = s.first),
              showSelectedIcon: false,
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 12)),
              ),
            ),
            const SizedBox(height: 10),

            // VCV 絶対禁忌警告
            if (_mode == _VentMode.vcv) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded, size: 15, color: Colors.red.shade700),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text.rich(TextSpan(children: [
                        TextSpan(
                          text: '初期設定 500 mL のまま乗せない\n',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade700, fontSize: 12, height: 1.4),
                        ),
                        TextSpan(
                          text: 'VT を個別設定（PBW × 7 mL）してから呼吸器に乗せること.',
                          style: TextStyle(color: Colors.red.shade700, fontSize: 11, height: 1.4),
                        ),
                      ])),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],

            // VCV 設定値
            if (_mode == _VentMode.vcv) ...[
              _vRow('VT',   '${tv.toStringAsFixed(0)} mL', 'PBW × 7'),
              const Divider(height: 14),
              _vRow('RR',   '14 /min',    ''),
              const Divider(height: 14),
              _vRow('PEEP', '5 cmH₂O',   ''),
              const Divider(height: 14),
              _vRow('I:E',  '1 : 2',      ''),
            // PCV 設定値
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded, size: 15, color: Colors.red.shade700),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '最初の換気量をみて圧調整すること\n換気量が少なすぎる場合は片肺挿管などのチューブ位置異常を考慮',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w600,
                            height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _vRow('PEEP', '5 cmH₂O',   ''),
              const Divider(height: 14),
              _vRow('ΔP',   '10 cmH₂O',  'PC above PEEP'),
              const Divider(height: 14),
              _vRow('RR',   '14 /min',    ''),
              const Divider(height: 14),
              _vRow('I:E',  '1 : 2',      ''),
            ],
          ],
        ),
      ),
    );
  }

  Widget _vRow(String label, String value, String note) {
    return Row(
      children: [
        SizedBox(
          width: 44,
          child: Text(label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54)),
        ),
        Expanded(
          child: Text(value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        if (note.isNotEmpty)
          Text(note, style: const TextStyle(fontSize: 10, color: Colors.black38)),
      ],
    );
  }
}

// ── 数値フォーマット ──────────────────────────────────────────────────────
String _fmtDose(double v) {
  if (v == v.truncateToDouble()) return v.toInt().toString();
  if ((v * 10).truncate() == (v * 10).round()) return v.toStringAsFixed(1);
  return v.toStringAsFixed(2);
}
