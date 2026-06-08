import 'package:flutter/material.dart';

enum _Sex {
  male('男性'),
  female('女性');

  final String label;
  const _Sex(this.label);
}

const _heightOpts = [
  140, 145, 150, 155, 160, 165, 170, 175, 180, 185, 190
];

class DltScreen extends StatefulWidget {
  const DltScreen({super.key});

  @override
  State<DltScreen> createState() => _DltScreenState();
}

class _DltScreenState extends State<DltScreen> {
  _Sex _sex    = _Sex.male;
  int _height  = 165;

  // 身長・性別によるサイズ推奨（Brodsky 法準拠）
  int get _fr {
    if (_sex == _Sex.male) {
      if (_height >= 170) return 41;
      if (_height >= 160) return 39;
      return 37;
    } else {
      if (_height >= 160) return 37;
      return 35;
    }
  }

  // 挿入深さ目安（切歯から cm）
  double get _depth => _height / 10.0 + 12.0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('DLT サイズ選択'),
        backgroundColor: scheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [

          // ── 入力 ──────────────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('性別',
                            style: TextStyle(
                                color: scheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                        const SizedBox(height: 6),
                        SegmentedButton<_Sex>(
                          segments: _Sex.values
                              .map((s) => ButtonSegment(
                                    value: s,
                                    label: Text(s.label),
                                  ))
                              .toList(),
                          selected: {_sex},
                          onSelectionChanged: (s) =>
                              setState(() => _sex = s.first),
                          style: ButtonStyle(
                            visualDensity: VisualDensity.compact,
                            textStyle: WidgetStateProperty.all(
                                const TextStyle(fontSize: 13)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _dd<int>(
                      label: '身長',
                      suffix: 'cm',
                      value: _height,
                      items: _heightOpts,
                      onChanged: (v) => setState(() => _height = v),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ── 推奨サイズ ──────────────────────────────────────────────
          Card(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border:
                    Border(left: BorderSide(color: scheme.primary, width: 4)),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('推奨サイズ（左 DLT）',
                      style: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('$_fr',
                          style: const TextStyle(
                              fontSize: 52, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      const Text('Fr',
                          style: TextStyle(
                              fontSize: 22, color: Colors.black54)),
                    ],
                  ),
                  Text(
                    '${_sex.label} · ${_height}cm → $_fr Fr',
                    style: const TextStyle(fontSize: 11, color: Colors.black45),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  _vRow('挿入深さ目安',
                      '${_depth.toStringAsFixed(1)} cm',
                      '切歯から（身長÷10 + 12）'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ── サイズ基準表 ────────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('サイズ基準表',
                      style: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                  const SizedBox(height: 10),
                  _sizeTable(scheme),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ── FOB確認ポイント ─────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('FOB 確認ポイント',
                      style: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                  const SizedBox(height: 8),
                  _note('左 DLT 挿管後：気管腔から左上葉支の分岐（↖）が確認できること.'),
                  _note('左上葉支が見えないほど深い → 少し引き抜く.'),
                  _note('右 DLT は右上葉支が近接するため左 DLT を標準とする施設が多い.'),
                  _note('体位変換後（側臥位）に必ず再確認. ブランコ孔がずれやすい.'),
                  _note('自発呼吸のある患者はチューブ固定後も確認を怠らない.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sizeTable(ColorScheme scheme) {
    const headerStyle = TextStyle(fontSize: 11, fontWeight: FontWeight.bold);
    const bodyStyle   = TextStyle(fontSize: 12);

    TableRow header(String a, String b, String c) => TableRow(
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(4),
          ),
          children: [
            _cell(a, headerStyle, scheme.primary),
            _cell(b, headerStyle, scheme.primary),
            _cell(c, headerStyle, scheme.primary),
          ],
        );

    TableRow row(String a, String b, String c, {bool highlight = false}) =>
        TableRow(
          decoration: highlight
              ? BoxDecoration(color: scheme.primary.withValues(alpha: 0.05))
              : null,
          children: [
            _cell(a, bodyStyle, highlight ? scheme.primary : Colors.black87),
            _cell(b, bodyStyle, Colors.black87),
            _cell(c, bodyStyle,
                highlight ? scheme.primary : Colors.black87,
                bold: highlight),
          ],
        );

    final isMale = _sex == _Sex.male;

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2.5),
        2: FlexColumnWidth(1.5),
      },
      children: [
        header('性別', '身長', 'サイズ'),
        row('男性', '≥ 170 cm', '41 Fr',
            highlight: isMale && _height >= 170),
        row('', '160–169 cm', '39 Fr',
            highlight: isMale && _height >= 160 && _height < 170),
        row('', '< 160 cm', '37 Fr',
            highlight: isMale && _height < 160),
        row('女性', '≥ 160 cm', '37 Fr',
            highlight: !isMale && _height >= 160),
        row('', '< 160 cm', '35 Fr',
            highlight: !isMale && _height < 160),
      ],
    );
  }

  Widget _cell(String text, TextStyle style, Color color,
      {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
      child: Text(text,
          style: style.copyWith(
              color: color,
              fontWeight: bold ? FontWeight.bold : style.fontWeight)),
    );
  }

  Widget _vRow(String label, String value, String note) {
    return Row(
      children: [
        SizedBox(
          width: 82,
          child: Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ),
        Text(value,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(note,
              style:
                  const TextStyle(fontSize: 10, color: Colors.black38)),
        ),
      ],
    );
  }

  Widget _note(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('・',
              style: TextStyle(fontSize: 12, color: Colors.black45)),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 12, color: Colors.black54, height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _dd<T>({
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
