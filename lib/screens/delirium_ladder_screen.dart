import 'package:flutter/material.dart';

import '../data/delirium_ladder.dart';
import '../models/delirium_ladder.dart';

/// せん妄・不眠のラダー. 患者背景を選ぶと各薬剤の可否を判定する.
class DeliriumLadderScreen extends StatefulWidget {
  const DeliriumLadderScreen({super.key});

  @override
  State<DeliriumLadderScreen> createState() => _DeliriumLadderScreenState();
}

class _DeliriumLadderScreenState extends State<DeliriumLadderScreen> {
  static const _accent = Color(0xFF00838F); // 集中治療・せん妄と同系

  final Set<String> _selected = {};
  bool _hideBlocked = false;

  static const _verdictColor = {
    '禁忌': Color(0xFFD32F2F),
    '原則回避': Color(0xFFE65100),
    '減量': Color(0xFF00695C),
    '注意': Color(0xFF827717),
  };

  static const _verdictBg = {
    '禁忌': Color(0xFFFFEBEE),
    '原則回避': Color(0xFFFFF3E0),
    '減量': Color(0xFFE0F2F1),
    '注意': Color(0xFFF9FBE7),
  };

  @override
  Widget build(BuildContext context) {
    final drugs = kLadderDrugs.where((d) {
      if (!_hideBlocked) return true;
      final v = d.verdictFor(_selected);
      return v != '禁忌' && v != '原則回避';
    }).toList();

    final blocked = kLadderDrugs
        .where((d) => ['禁忌', '原則回避'].contains(d.verdictFor(_selected)))
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('せん妄・不眠ラダー'),
        backgroundColor: _accent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 患者背景の選択
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person_search, size: 17, color: _accent),
                    const SizedBox(width: 6),
                    Text(
                      '患者背景を選ぶ',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: _accent,
                      ),
                    ),
                    const Spacer(),
                    if (_selected.isNotEmpty)
                      TextButton(
                        onPressed: () => setState(_selected.clear),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('クリア', style: TextStyle(fontSize: 12)),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final c in kLadderConditions)
                      _condChip(c, _selected.contains(c)),
                  ],
                ),
                if (_selected.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          blocked == 0
                              ? '選択した背景で使用を避けるべき薬剤はありません'
                              : '$blocked剤が禁忌・原則回避に該当します',
                          style: TextStyle(
                            fontSize: 12,
                            color: blocked == 0
                                ? Colors.teal.shade700
                                : Colors.red.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (blocked > 0)
                        Row(
                          children: [
                            const Text('隠す', style: TextStyle(fontSize: 11.5)),
                            Switch(
                              value: _hideBlocked,
                              activeThumbColor: _accent,
                              onChanged: (v) =>
                                  setState(() => _hideBlocked = v),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 24),
              itemCount: drugs.length,
              itemBuilder: (_, i) => _card(drugs[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _condChip(String c, bool on) => InkWell(
    onTap: () => setState(() {
      if (on) {
        _selected.remove(c);
      } else {
        _selected.add(c);
      }
    }),
    borderRadius: BorderRadius.circular(16),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: on ? _accent : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: on ? _accent : Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (on)
            const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(Icons.check, size: 13, color: Colors.white),
            ),
          Text(
            kLadderConditionLabels[c] ?? c,
            style: TextStyle(
              fontSize: 11.5,
              color: on ? Colors.white : Colors.black87,
              fontWeight: on ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _card(LadderDrug d) {
    final verdict = d.verdictFor(_selected);
    final reasons = d.reasonsFor(_selected);
    final c = _verdictColor[verdict];
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: c == null
              ? null
              : Border(left: BorderSide(color: c, width: 4)),
          color: verdict == '禁忌' ? _verdictBg['禁忌'] : null,
        ),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d.generic +
                            (d.brand.isEmpty ? '' : '  <${d.brand}>'),
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (d.step.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            d.step,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (verdict.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _verdictBg[verdict],
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: c!),
                    ),
                    child: Text(
                      verdict,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: c,
                      ),
                    ),
                  ),
              ],
            ),
            if (d.dose.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                d.dose,
                style: const TextStyle(fontSize: 12.5, height: 1.5),
              ),
            ],
            // 選択した背景に対する理由
            if (reasons.isNotEmpty) ...[
              const SizedBox(height: 8),
              for (final r in reasons)
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 2, right: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: _verdictBg[r.value],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          r.value,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _verdictColor[r.value],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          kLadderConditionLabels[r.key] ?? r.key,
                          style: const TextStyle(fontSize: 11.5, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
            if (verdict == '禁忌' || verdict == '原則回避') ...[
              if (d.alternative.isNotEmpty) ...[
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.alt_route,
                        size: 14,
                        color: Colors.teal.shade700,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          d.alternative,
                          style: const TextStyle(fontSize: 11.5, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
            if (d.keyContraindications.isNotEmpty) ...[
              const SizedBox(height: 6),
              InkWell(
                onTap: () => _showCi(d),
                child: Row(
                  children: [
                    Icon(
                      Icons.block,
                      size: 13,
                      color: Colors.red.shade400,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '電子添文の禁忌 ${d.keyContraindications.length}件',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.red.shade400,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 15,
                      color: Colors.red.shade300,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showCi(LadderDrug d) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.55,
        maxChildSize: 0.9,
        builder: (_, ctrl) => ListView(
          controller: ctrl,
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
          children: [
            Text(
              d.generic,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '電子添文の禁忌',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            for (final c in d.keyContraindications)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '・${c.target}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, top: 2),
                      child: Text(
                        c.reason,
                        style: const TextStyle(fontSize: 12, height: 1.55),
                      ),
                    ),
                  ],
                ),
              ),
            if (d.alternative.isNotEmpty) ...[
              const SizedBox(height: 6),
              const Text(
                '使えないときの代替',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                d.alternative,
                style: const TextStyle(fontSize: 12.5, height: 1.6),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
