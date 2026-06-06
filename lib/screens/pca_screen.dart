import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// PCA（患者自己調節鎮痛）計算機
class PcaScreen extends StatefulWidget {
  const PcaScreen({super.key});

  @override
  State<PcaScreen> createState() => _PcaScreenState();
}

enum _PcaDrug { fentanyl, morphine, hydromorphone }

class _PcaScreenState extends State<PcaScreen> {
  _PcaDrug _drug = _PcaDrug.fentanyl;
  final _wtCtl = TextEditingController(text: '60');

  @override
  void initState() {
    super.initState();
    _wtCtl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _wtCtl.dispose();
    super.dispose();
  }

  double? get _wt => double.tryParse(_wtCtl.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final wt = _wt;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('PCA 計算機'),
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
                  _sectionTitle('設定', scheme),
                  const SizedBox(height: 12),
                  _numField(_wtCtl, '体重', 'kg'),
                  const SizedBox(height: 12),
                  SegmentedButton<_PcaDrug>(
                    segments: const [
                      ButtonSegment(
                          value: _PcaDrug.fentanyl,
                          label: Text('フェンタニル')),
                      ButtonSegment(
                          value: _PcaDrug.morphine,
                          label: Text('モルヒネ')),
                      ButtonSegment(
                          value: _PcaDrug.hydromorphone,
                          label: Text('ヒドロモルフォン')),
                    ],
                    selected: {_drug},
                    onSelectionChanged: (s) =>
                        setState(() => _drug = s.first),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // プロトコル
          if (wt != null) _protocolCard(scheme, wt),
          if (wt == null)
            Card(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                alignment: Alignment.center,
                child: const Text('体重を入力してください',
                    style: TextStyle(color: Colors.black45)),
              ),
            ),

          const SizedBox(height: 12),
          // 調製メモ
          if (wt != null) _prepCard(scheme, wt),
        ],
      ),
    );
  }

  Widget _protocolCard(ColorScheme scheme, double wt) {
    final p = _protocol(wt);
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
              Icon(Icons.checklist, size: 18, color: scheme.primary),
              const SizedBox(width: 6),
              Text('PCA プロトコル',
                  style: TextStyle(
                      color: scheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ]),
            const SizedBox(height: 14),
            for (final row in p.entries) ...[
              _resultRow(row.key, row.value),
              if (row.key != p.keys.last) const Divider(height: 16),
            ],
          ],
        ),
      ),
    );
  }

  Widget _prepCard(ColorScheme scheme, double wt) {
    final prep = _prepNote(wt);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('調製メモ', scheme),
            const SizedBox(height: 8),
            Text(prep,
                style: const TextStyle(fontSize: 13, height: 1.7)),
          ],
        ),
      ),
    );
  }

  Map<String, String> _protocol(double wt) {
    switch (_drug) {
      case _PcaDrug.fentanyl:
        final loading = (wt * 0.5).toStringAsFixed(0);
        final bolus = (wt * 0.3).clamp(10.0, 25.0).toStringAsFixed(0);
        return {
          '薬剤': 'フェンタニル',
          'ローディング': '$loading mcg（0.5 mcg/kg）IV ゆっくり',
          'PCA ボーラス': '$bolus mcg / 回（最大 25 mcg）',
          'ロックアウト': '5–10 分',
          '持続投与': '0–25 mcg/h（通常は0で開始）',
          '1時間上限': '${((wt * 0.3).clamp(10.0, 25.0) * 4 + 25).toStringAsFixed(0)} mcg/h',
        };
      case _PcaDrug.morphine:
        final loading = (wt * 0.05).toStringAsFixed(1);
        final bolus = (wt * 0.02).clamp(1.0, 3.0).toStringAsFixed(1);
        return {
          '薬剤': 'モルヒネ',
          'ローディング': '$loading mg（0.05 mg/kg）IV ゆっくり',
          'PCA ボーラス': '$bolus mg / 回',
          'ロックアウト': '6–10 分',
          '持続投与': '0–1 mg/h',
          '注意': '腎障害・高齢者は用量減量',
        };
      case _PcaDrug.hydromorphone:
        final loading = (wt * 0.005).toStringAsFixed(2);
        final bolus = (wt * 0.003).clamp(0.1, 0.4).toStringAsFixed(2);
        return {
          '薬剤': 'ヒドロモルフォン',
          'ローディング': '$loading mg（5 mcg/kg）IV',
          'PCA ボーラス': '$bolus mg / 回',
          'ロックアウト': '6–10 分',
          '持続投与': '0–0.2 mg/h',
          '換算': 'モルヒネ 10mg ≒ ヒドロモルフォン 1.5mg',
        };
    }
  }

  String _prepNote(double wt) {
    switch (_drug) {
      case _PcaDrug.fentanyl:
        return 'フェンタニル注 0.1mg/2mL を使用\n'
            '例) フェンタニル 500mcg + 生食 50mL → 10 mcg/mL\n'
            'ポンプ設定: ボーラス ${(((wt * 0.3).clamp(10.0, 25.0)) / 10).toStringAsFixed(1)} mL / 回\n'
            'ロックアウト 8 分、持続 0 mL/h';
      case _PcaDrug.morphine:
        return 'モルヒネ塩酸塩注 10mg/1mL を使用\n'
            '例) モルヒネ 50mg + 生食 50mL → 1 mg/mL\n'
            'ボーラス ${(wt * 0.02).clamp(1.0, 3.0).toStringAsFixed(1)} mL / 回\n'
            'ロックアウト 8 分';
      case _PcaDrug.hydromorphone:
        return 'ナルベイン注 2mg/1mL を使用\n'
            '例) ヒドロモルフォン 20mg + 生食 40mL → 0.4 mg/mL\n'
            'ボーラス ${((wt * 0.003).clamp(0.1, 0.4) / 0.4).toStringAsFixed(1)} mL / 回';
    }
  }

  Widget _resultRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(label,
              style:
                  const TextStyle(fontSize: 12, color: Colors.black54)),
        ),
        Expanded(
          child: Text(value,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

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
