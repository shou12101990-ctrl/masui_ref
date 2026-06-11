import 'package:flutter/material.dart';

/// 計算機画面で共用する小さな入力/表示パーツ集.
/// (各画面に重複していた _Field / _ResultRow / _ChoiceBtn / _Cell を集約.
///  画面ごとの微差はパラメータで吸収し, 見た目は従来と同一に保つ)

/// 患者情報 (PatientStore)から自動連携した値を読み取り専用で示すチップ.
/// 計算機の入力欄を廃止した代わりに「いま使っている値」を明示する.
class PatientLinkedChip extends StatelessWidget {
  final String summary; // 例: '体重 60 kg' / '40歳 · 165cm · 60kg · 男性'
  final bool usingDefault; // 参照値のいずれかが未入力 (デフォルト)のとき true
  final Color accent;
  const PatientLinkedChip(this.summary,
      {super.key, this.usingDefault = false, this.accent = const Color(0xFF00796B)});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.person_outline, size: 16, color: accent),
          const SizedBox(width: 6),
          Expanded(
            child: Text(summary,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600)),
          ),
          if (usingDefault)
            const Text('既定値 (TOPで入力)',
                style: TextStyle(fontSize: 10, color: Colors.black45))
          else
            const Text('患者情報',
                style: TextStyle(fontSize: 10, color: Colors.black38)),
        ],
      ),
    );
  }
}

/// ラベル + 単位サフィックス付きの数値入力欄.
class CalcField extends StatelessWidget {
  final String label;
  final String unit;
  final TextEditingController ctrl;
  const CalcField(this.label, this.unit, this.ctrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 4),
        TextField(
          controller: ctrl,
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            suffixText: unit,
            suffixStyle:
                const TextStyle(fontSize: 11, color: Colors.black45),
            isDense: true,
            filled: true,
            fillColor: const Color(0xFFF7F9FA),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 11),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

/// 「ラベル 値 単位」を中央揃えで並べる結果行.
class CalcResultRow extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final double valueSize;
  final double verticalPadding;
  const CalcResultRow(this.label, this.value, this.unit,
      {super.key, this.valueSize = 18, this.verticalPadding = 0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(label,
            style: const TextStyle(fontSize: 13, color: Colors.black54)),
        const SizedBox(width: 8),
        Text(value,
            style: TextStyle(
                fontSize: valueSize, fontWeight: FontWeight.bold)),
        const SizedBox(width: 4),
        Text(unit,
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ]),
    );
  }
}

/// 選択肢ボタン (ラベル + 小さなサブテキスト).
class CalcChoiceBtn extends StatelessWidget {
  final String label;
  final String sub;
  final bool selected;
  final Color color;
  final VoidCallback onTap;
  final double fontSize;
  final double hPad;
  const CalcChoiceBtn({
    super.key,
    required this.label,
    this.sub = '',
    required this.selected,
    required this.color,
    required this.onTap,
    this.fontSize = 14,
    this.hPad = 14,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 8),
        decoration: BoxDecoration(
          color:
              selected ? color.withValues(alpha: 0.14) : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected ? color : Colors.transparent, width: 1.6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                    color: selected ? Colors.black87 : Colors.black54)),
            if (sub.isNotEmpty) ...[
              const SizedBox(height: 1),
              Text(sub,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10,
                      color: selected ? color : Colors.black38)),
            ],
          ],
        ),
      ),
    );
  }
}

/// 表のセル. headerColor/bodyColor が null のときは継承色のまま.
class CalcCell extends StatelessWidget {
  final String text;
  final bool header;
  final bool bold;
  final double bodySize;
  final Color? headerColor;
  final Color? bodyColor;
  const CalcCell(this.text,
      {super.key,
      this.header = false,
      this.bold = false,
      this.bodySize = 13,
      this.headerColor,
      this.bodyColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      child: Text(text,
          style: TextStyle(
              fontSize: header ? 12 : bodySize,
              fontWeight:
                  (header || bold) ? FontWeight.bold : FontWeight.normal,
              color: header ? headerColor : bodyColor)),
    );
  }
}
