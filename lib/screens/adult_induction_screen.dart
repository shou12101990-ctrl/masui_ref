import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 成人麻酔導入dose + 人工呼吸器初期設定 計算機
class AdultInductionScreen extends StatefulWidget {
  const AdultInductionScreen({super.key});

  @override
  State<AdultInductionScreen> createState() => _AdultInductionScreenState();
}

class _AdultInductionScreenState extends State<AdultInductionScreen> {
  final _wtCtl = TextEditingController(text: '60');
  final _htCtl = TextEditingController(text: '165');

  @override
  void initState() {
    super.initState();
    _wtCtl.addListener(() => setState(() {}));
    _htCtl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _wtCtl.dispose();
    _htCtl.dispose();
    super.dispose();
  }

  double? get _wt => double.tryParse(_wtCtl.text);
  double? get _ht => double.tryParse(_htCtl.text);

  /// 標準体重 (IBW) — Devine式
  double? get _ibw {
    final h = _ht;
    if (h == null) return null;
    return 50 + 0.91 * (h - 152.4);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final wt = _wt;
    final ibw = _ibw;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('成人導入 / 呼吸器設定'),
        backgroundColor: scheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          // 入力
          _card(scheme, '患者体格', [
            Row(children: [
              Expanded(child: _numField(_wtCtl, '実体重', 'kg')),
              const SizedBox(width: 12),
              Expanded(child: _numField(_htCtl, '身長', 'cm')),
            ]),
            if (ibw != null) ...[
              const SizedBox(height: 10),
              _infoBox(scheme,
                  'IBW (Devine式): ${ibw.toStringAsFixed(1)} kg'),
            ],
          ]),
          const SizedBox(height: 12),

          // 導入薬
          _card(scheme, '導入薬用量', [
            _drugTable(scheme, wt, [
              _DrugRow('プロポフォール', 1.5, 2.5, 'mg/kg', 'IV緩徐'),
              _DrugRow('チオペンタール', 3.0, 5.0, 'mg/kg', 'IV'),
              _DrugRow('ケタミン', 1.0, 2.0, 'mg/kg', 'IV / ×2〜3 IM'),
              _DrugRow('ミダゾラム', 0.05, 0.1, 'mg/kg', 'IV'),
              _DrugRow('フェンタニル', 0.002, 0.003, 'mg/kg', 'IV（2〜3 mcg/kg）'),
              _DrugRow('ロクロニウム', 0.6, 1.2, 'mg/kg', 'RSI: 1.2'),
              _DrugRow('スキサメトニウム', 1.0, 1.5, 'mg/kg', 'RSI用'),
            ]),
          ]),
          const SizedBox(height: 12),

          // 呼吸器設定
          _card(scheme, '人工呼吸器 初期設定', [
            if (ibw != null) ...[
              _ventRow('一回換気量 (TV)', '${(ibw * 6).toStringAsFixed(0)}–${(ibw * 8).toStringAsFixed(0)} mL', 'IBW × 6–8 mL/kg'),
            ] else ...[
              _ventRow('一回換気量 (TV)', '6–8 mL/kg IBW', '身長を入力すると算出'),
            ],
            _ventRow('呼吸回数 (RR)', '10–14 /min', ''),
            _ventRow('PEEP', '5 cmH₂O', ''),
            _ventRow('FiO₂', '0.4–0.5', '開始時 1.0 でもよい'),
            _ventRow('I:E比', '1:2', '閉塞性疾患では 1:2.5〜3'),
            _ventRow('吸気流速 (IPPV)', '40–60 L/min', ''),
          ]),
        ],
      ),
    );
  }

  Widget _card(ColorScheme scheme, String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    color: scheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _infoBox(ColorScheme scheme, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text,
          style: TextStyle(
              color: scheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 13)),
    );
  }

  Widget _drugTable(
      ColorScheme scheme, double? wt, List<_DrugRow> rows) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2.2),
        1: FlexColumnWidth(2.5),
        2: FlexColumnWidth(2.5),
        3: FlexColumnWidth(3),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(6),
          ),
          children: [
            _th('薬剤'),
            _th('最小'),
            _th('最大'),
            _th('備考'),
          ],
        ),
        for (final r in rows)
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(r.name,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
              ),
              _doseCell(wt, r.minPerKg, r.unit),
              _doseCell(wt, r.maxPerKg, r.unit),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                child: Text(r.note,
                    style:
                        const TextStyle(fontSize: 11, color: Colors.black54)),
              ),
            ],
          ),
      ],
    );
  }

  Widget _th(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        child: Text(text,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.black54)),
      );

  Widget _doseCell(double? wt, double perKg, String unit) {
    final unitShort = unit.replaceAll('/kg', '');
    if (wt == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        child: Text('— $unit',
            style: const TextStyle(fontSize: 11, color: Colors.black38)),
      );
    }
    final val = wt * perKg;
    final valStr = val < 1
        ? val.toStringAsFixed(2)
        : val < 10
            ? val.toStringAsFixed(1)
            : val.toStringAsFixed(0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
                text: valStr,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold)),
            TextSpan(
                text: ' $unitShort',
                style:
                    const TextStyle(fontSize: 11, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _ventRow(String label, String value, String note) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(
              width: 140,
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600))),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          if (note.isNotEmpty)
            Text(note,
                style:
                    const TextStyle(fontSize: 11, color: Colors.black45)),
        ],
      ),
    );
  }

  Widget _numField(TextEditingController c, String label, String suffix) {
    return TextField(
      controller: c,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],
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
      ),
    );
  }
}

class _DrugRow {
  final String name;
  final double minPerKg;
  final double maxPerKg;
  final String unit;
  final String note;
  const _DrugRow(this.name, this.minPerKg, this.maxPerKg, this.unit, this.note);
}
