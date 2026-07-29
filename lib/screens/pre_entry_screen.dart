import 'dart:async';

import 'package:flutter/material.dart';

/// 入室前準備 — 準備タイマー + チェックリスト.
/// 入室 → 準備完了 で所要時間を計測 (目標15分以内). 各項目はタップでチェック.
class PreEntryScreen extends StatefulWidget {
  const PreEntryScreen({super.key});

  @override
  State<PreEntryScreen> createState() => _PreEntryScreenState();
}

class _CheckItem {
  final String label;
  final bool hasPendingBtn; // 「指示未」ボタン付き (薬剤準備用)
  final String? note; // ラベル直下に小さく出す注釈
  final String? naBtnLabel; // 「〜なし」ボタン付き (機器がなければ N/A 化)
  const _CheckItem(this.label,
      {this.hasPendingBtn = false, this.note, this.naBtnLabel});
}

const _items = <_CheckItem>[
  _CheckItem('吸引をONにした'),
  _CheckItem('サクションをすぐ使えるように準備した'),
  _CheckItem('薬剤を術前指示に過不足なく準備した', hasPendingBtn: true),
  _CheckItem('持続注射薬のプライミングを行った',
      note: 'TIVAの場合はシリンジポンプの設定'),
  _CheckItem('喉頭鏡 / McGRATHの電池を確認した'),
  _CheckItem('チューブの準備をした', note: 'チューブの種類 / 太さは確認'),
  _CheckItem('カフテストをした', note: '8ml程度入れて弾力を確認する'),
  _CheckItem('呼吸器のセッティングをした'),
  _CheckItem('余剰排気が開いているか (30cmH2O)'),
  _CheckItem('Sev・Desを補充した'),
  _CheckItem('ソーダライムをチェックした'),
  _CheckItem('TOFモニタの準備をした', naBtnLabel: 'TOFモニタなし'),
  _CheckItem('モニタ側でTOFを「自動」に設定した'),
  _CheckItem('チューブ固定テープ・目パッチを準備した'),
  _CheckItem('体温計・脳波センサーを準備した',
      note: '耳鼻科のESSでナビゲーションを使用する場合はBIS'),
  _CheckItem('胃管の準備をした (必要症例のみ)'),
  _CheckItem('ルート準備 (22G・20G・消毒綿・駆血帯)'),
  _CheckItem('聴診器を準備した'),
];

/// 個別事例 — 該当する症例のときだけ使うチェック群.
class _CaseGroup {
  final String title;
  final List<_CheckItem> items;
  const _CaseGroup(this.title, this.items);
}

const _caseGroups = <_CaseGroup>[
  _CaseGroup('神経ブロック / ルート確保', [
    _CheckItem('エコー準備, 電源ON, 調整済',
        note: 'ルート 2cm, 神経ブロック 3cm前後'),
  ]),
  _CaseGroup('喘息患者', [
    _CheckItem('DAMカートの喘息患者セットを準備した'),
  ]),
  _CaseGroup('冠動脈疾患患者', [
    _CheckItem('硝酸薬やベラパミルを準備した', note: '上級医に確認してください'),
  ]),
  _CaseGroup('経鼻挿管', [
    _CheckItem('経鼻挿管セットの準備をNSに依頼した'),
    _CheckItem('経鼻用チューブ, マギール鉗子を準備した'),
  ]),
  _CaseGroup('腹臥位 / 歯科口腔外科', [
    _CheckItem('延長チューブを準備した'),
  ]),
];

/// 個別事例の項目をフラット化 (チェック状態は _items の後ろに続く連番で持つ).
final _caseItems = <_CheckItem>[for (final g in _caseGroups) ...g.items];
final _allItems = <_CheckItem>[..._items, ..._caseItems];

class _PreEntryScreenState extends State<PreEntryScreen> {
  static const _accent = Color(0xFF00695C);
  static const _caseBlue = Color(0xFF1565C0); // 個別事例の見出し色
  static const _targetSec = 15 * 60; // 目標15分

  final _sw = Stopwatch();
  Timer? _ticker;
  Duration _shown = Duration.zero;
  bool _finished = false;

  late final List<bool> _checked = List<bool>.filled(_allItems.length, false);
  late final List<bool> _naActive = List<bool>.filled(_allItems.length, false);
  bool _ordersPending = false;

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  // ── タイマー ──────────────────────────────────────────
  void _start() {
    _sw
      ..reset()
      ..start();
    _finished = false;
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (mounted) setState(() => _shown = _sw.elapsed);
    });
    setState(() => _shown = Duration.zero);
  }

  void _finish() {
    _sw.stop();
    _ticker?.cancel();
    setState(() {
      _shown = _sw.elapsed;
      _finished = true;
    });
  }

  void _reset() {
    _sw
      ..stop()
      ..reset();
    _ticker?.cancel();
    setState(() {
      _shown = Duration.zero;
      _finished = false;
    });
  }

  String _fmt(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final running = _sw.isRunning;
    final over = _shown.inSeconds > _targetSec;
    final timeColor = over ? Colors.red.shade700 : _accent;
    var doneCount = 0; // 進捗表示は基本項目のみ (個別事例は該当症例だけなので除外)
    for (var i = 0; i < _items.length; i++) {
      if (_checked[i] || _naActive[i]) doneCount++;
    }
    final anyOn = _checked.contains(true) || _naActive.contains(true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('入室前準備'),
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── 準備タイマー ──
            Card(
              color: over ? Colors.red.shade50 : _accent.withValues(alpha: 0.05),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  children: [
                    const Text('準備にかかった時間',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text(_fmt(_shown),
                        style: TextStyle(
                            fontSize: 49,
                            fontWeight: FontWeight.bold,
                            color: timeColor,
                            height: 1.0)),
                    const SizedBox(height: 2),
                    Text(
                      _finished
                          ? (over ? '準備完了 — 目標超過' : '準備完了 — 目標内！')
                          : '目標 15分以内！',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: over
                              ? Colors.red.shade700
                              : (_finished ? Colors.green.shade700 : Colors.black54)),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: running ? null : _start,
                            icon: const Icon(Icons.login, size: 18),
                            label: const Text('入室'),
                            style: FilledButton.styleFrom(
                                backgroundColor: _accent),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: running ? _finish : null,
                            icon: const Icon(Icons.check, size: 18),
                            label: const Text('準備完了'),
                            style: FilledButton.styleFrom(
                                backgroundColor: Colors.green.shade700),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: _reset,
                          child: const Icon(Icons.refresh, size: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── チェックリスト ──
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text('入室前チェックリスト',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Text('$doneCount / ${_items.length}',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: doneCount == _items.length
                                    ? Colors.green.shade700
                                    : Colors.black54)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text('すぐ使える状態 / 頭もとから1歩以内で完結するように！',
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade600)),
                    const SizedBox(height: 8),
                    for (int i = 0; i < _items.length; i++) _checkRow(i),
                    ..._caseSection(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed:
                            (anyOn || _ordersPending) ? _clearAll : null,
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('全てクリア',
                            style: TextStyle(fontSize: 12)),
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearAll() {
    setState(() {
      for (var i = 0; i < _checked.length; i++) {
        _checked[i] = false;
        _naActive[i] = false;
      }
      _ordersPending = false;
    });
  }

  /// 個別事例ゾーン — 「— 個別事例 —」の区切り + 事例ごとの見出しとチェック項目.
  List<Widget> _caseSection() {
    final w = <Widget>[_caseDivider()];
    var idx = _items.length; // チェック状態は _items の後ろに続く連番
    for (final g in _caseGroups) {
      w.add(Padding(
        padding: const EdgeInsets.only(left: 2, top: 10, bottom: 1),
        child: Text(g.title,
            style: const TextStyle(
                fontSize: 13.5, height: 1.3, color: _caseBlue)),
      ));
      for (var k = 0; k < g.items.length; k++) {
        w.add(_checkRow(idx++));
      }
    }
    return w;
  }

  /// 見出しを中央に置き, 横棒をカードの端-10ptまで伸ばす区切り.
  Widget _caseDivider() {
    // カード内padding 14 のうち 4 をはみ出させると カードの端-10pt に届く.
    const bleed = 4.0;
    return LayoutBuilder(
      builder: (context, c) => SizedBox(
        height: 34,
        child: OverflowBox(
          maxWidth: c.maxWidth + bleed * 2,
          child: Row(
            children: [
              const Expanded(child: Divider(color: _caseBlue, thickness: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('個別事例',
                    style: const TextStyle(
                        fontSize: 13.5, height: 1.3, color: _caseBlue)),
              ),
              const Expanded(child: Divider(color: _caseBlue, thickness: 1)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _checkRow(int i) {
    final item = _allItems[i];
    final checked = _checked[i];
    final na = _naActive[i];
    final resolved = checked || na; // チェック済み or「〜なし」で解決扱い
    final pending = item.hasPendingBtn && _ordersPending;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => setState(() => _checked[i] = !_checked[i]),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.5, horizontal: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  resolved ? Icons.check_box : Icons.check_box_outline_blank,
                  size: 22,
                  color: resolved ? Colors.grey.shade500 : Colors.black45,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 13.5,
                      height: 1.3,
                      fontWeight:
                          pending ? FontWeight.bold : FontWeight.normal,
                      color: pending
                          ? Colors.red.shade700
                          : (resolved ? Colors.grey.shade500 : Colors.black87),
                    ),
                  ),
                ),
                // 指示未ボタンは薬剤の項目のみ, 同じ行の右端に配置
                if (item.hasPendingBtn) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () =>
                        setState(() => _ordersPending = !_ordersPending),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color:
                            _ordersPending ? Colors.red.shade600 : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: Colors.red.shade400, width: 1.4),
                      ),
                      child: Text('指示未',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _ordersPending
                                  ? Colors.white
                                  : Colors.red.shade600)),
                    ),
                  ),
                ],
                // 「〜なし」ボタンも同じ行の右端に配置
                if (item.naBtnLabel != null) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() => _naActive[i] = !_naActive[i]),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: na ? Colors.red.shade600 : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: Colors.red.shade400, width: 1.4),
                      ),
                      child: Text(item.naBtnLabel!,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color:
                                  na ? Colors.white : Colors.red.shade600)),
                    ),
                  ),
                ],
              ],
            ),
            // 注釈は項目名の直下に小さく配置
            if (item.note != null)
              Padding(
                padding: const EdgeInsets.only(left: 32, top: 3),
                child: Text(item.note!,
                    style: TextStyle(
                        fontSize: 11,
                        height: 1.3,
                        color: resolved
                            ? Colors.grey.shade400
                            : Colors.grey.shade600)),
              ),
            // 指示未のときの注意文言はラベル下に表示
            if (pending)
              Padding(
                padding: const EdgeInsets.only(left: 32, top: 5),
                child: Text('→ 近くの上級医に確認',
                    style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700)),
              ),
          ],
        ),
      ),
    );
  }
}
