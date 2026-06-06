import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 小児麻酔 計算機
/// 導入dose / 挿管チューブサイズ / 固定長
class PediatricScreen extends StatefulWidget {
  const PediatricScreen({super.key});

  @override
  State<PediatricScreen> createState() => _PediatricScreenState();
}

class _PediatricScreenState extends State<PediatricScreen> {
  final _ageCtl = TextEditingController(text: '6');
  final _wtCtl = TextEditingController(text: '20');

  @override
  void initState() {
    super.initState();
    _ageCtl.addListener(() => setState(() {}));
    _wtCtl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _ageCtl.dispose();
    _wtCtl.dispose();
    super.dispose();
  }

  double? get _age => double.tryParse(_ageCtl.text);
  double? get _wt => double.tryParse(_wtCtl.text);

  /// チューブ内径 (mm) — 年齢式
  /// 非カフ付き: age/4 + 4.0  カフ付き: age/4 + 3.5
  double? get _tubeCuffless {
    final a = _age;
    if (a == null) return null;
    return a / 4 + 4.0;
  }

  double? get _tubeCuffed {
    final a = _age;
    if (a == null) return null;
    return a / 4 + 3.5;
  }

  /// 固定長 (cm at lip) — 年齢式: age/2 + 12
  double? get _fixLength {
    final a = _age;
    if (a == null) return null;
    return a / 2 + 12;
  }

  /// 固定長 (cm at nose) ≒ 固定長(lip) + 2〜3
  double? get _fixLengthNose {
    final fl = _fixLength;
    if (fl == null) return null;
    return fl + 2.5;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final age = _age;
    final wt = _wt;
    final tubeCuffless = _tubeCuffless;
    final tubeCuffed = _tubeCuffed;
    final fixLen = _fixLength;

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
          // 入力
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('患者情報', scheme),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: _numField(_ageCtl, '年齢', '歳')),
                    const SizedBox(width: 12),
                    Expanded(child: _numField(_wtCtl, '体重', 'kg')),
                  ]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // チューブ・固定長
          if (age != null)
            Card(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border(
                      left: BorderSide(color: scheme.primary, width: 4)),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.airline_seat_recline_extra,
                          size: 18, color: scheme.primary),
                      const SizedBox(width: 6),
                      Text('挿管チューブ',
                          style: TextStyle(
                              color: scheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    ]),
                    const SizedBox(height: 14),
                    _bigRow('カフなし ID',
                        tubeCuffless != null
                            ? '${tubeCuffless.toStringAsFixed(1)} mm'
                            : '—',
                        'age/4 + 4.0'),
                    const Divider(height: 16),
                    _bigRow('カフあり ID',
                        tubeCuffed != null
                            ? '${tubeCuffed.toStringAsFixed(1)} mm'
                            : '—',
                        'age/4 + 3.5'),
                    const Divider(height: 16),
                    _bigRow('固定長 (口角)',
                        fixLen != null
                            ? '${fixLen.toStringAsFixed(1)} cm'
                            : '—',
                        'age/2 + 12'),
                    const Divider(height: 16),
                    _bigRow('固定長 (鼻腔)',
                        _fixLengthNose != null
                            ? '${_fixLengthNose!.toStringAsFixed(1)} cm'
                            : '—',
                        '口角 + 2.5'),
                  ],
                ),
              ),
            ),
          if (age == null)
            Card(
              child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: const Text('年齢を入力してください',
                      style: TextStyle(color: Colors.black45))),
            ),
          const SizedBox(height: 12),

          // 導入薬
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('導入薬用量', scheme),
                  const SizedBox(height: 12),
                  if (wt == null)
                    const Text('体重を入力してください',
                        style: TextStyle(color: Colors.black45))
                  else
                    _drugTable(scheme, wt),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 注意事項
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('参考・注意', scheme),
                  const SizedBox(height: 8),
                  _noteRow('•', '2歳未満は年齢式の精度が低下'),
                  _noteRow('•', 'チューブサイズは0.5刻みで選択（例: 4.0→実際は4.0 or 4.5）'),
                  _noteRow('•', 'カフ付きは6歳以上で主に使用'),
                  _noteRow('•', '固定長は体格差あり、挿管後 CO₂ 波形・胸郭挙上で確認'),
                  _noteRow('•',
                      '迷走神経反射: アトロピン 0.02 mg/kg（最小0.1 mg）前投薬も検討'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drugTable(ColorScheme scheme, double wt) {
    const rows = [
      _PedRow('プロポフォール', 2.5, 3.5, 'mg/kg', 'IV緩徐'),
      _PedRow('チオペンタール', 5.0, 7.0, 'mg/kg', 'IV'),
      _PedRow('ケタミン', 1.5, 2.0, 'mg/kg', 'IV / ×3 IM'),
      _PedRow('フェンタニル', 0.002, 0.003, 'mg/kg', '2〜3 mcg/kg'),
      _PedRow('スキサメトニウム', 2.0, 2.0, 'mg/kg', '小児は用量多め'),
      _PedRow('ロクロニウム', 0.6, 1.0, 'mg/kg', 'RSI: 1.2 mg/kg'),
      _PedRow('アトロピン', 0.02, 0.02, 'mg/kg', '最小 0.1 mg'),
    ];
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2.2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2.6),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: 0.07),
          ),
          children: [
            _th('薬剤'),
            _th('最小'),
            _th('最大'),
            _th('備考'),
          ],
        ),
        for (final r in rows)
          TableRow(children: [
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
                  style: const TextStyle(
                      fontSize: 11, color: Colors.black54)),
            ),
          ]),
      ],
    );
  }

  Widget _doseCell(double wt, double perKg, String unit) {
    final val = wt * perKg;
    final unitShort = unit.replaceAll('/kg', '');
    // アトロピン最小値
    final displayVal = (unit == 'mg/kg' && perKg == 0.02)
        ? val.clamp(0.1, double.infinity)
        : val;
    final valStr = displayVal < 1
        ? displayVal.toStringAsFixed(2)
        : displayVal < 10
            ? displayVal.toStringAsFixed(1)
            : displayVal.toStringAsFixed(0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
                text: valStr,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold)),
            TextSpan(
                text: ' $unitShort',
                style: const TextStyle(
                    fontSize: 10, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _bigRow(String label, String value, String formula) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(label,
              style: const TextStyle(fontSize: 13, color: Colors.black54)),
        ),
        Text(value,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold)),
        const Spacer(),
        Text(formula,
            style:
                const TextStyle(fontSize: 11, color: Colors.black38)),
      ],
    );
  }

  Widget _noteRow(String bullet, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(bullet,
              style:
                  const TextStyle(fontSize: 12, color: Colors.black45)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 12, color: Colors.black54, height: 1.5)),
          ),
        ],
      ),
    );
  }

  Widget _th(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
        child: Text(text,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.black54)),
      );

  Widget _sectionTitle(String text, ColorScheme scheme) => Text(text,
      style: TextStyle(
          color: scheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14));

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

class _PedRow {
  final String name;
  final double minPerKg;
  final double maxPerKg;
  final String unit;
  final String note;
  const _PedRow(
      this.name, this.minPerKg, this.maxPerKg, this.unit, this.note);
}
