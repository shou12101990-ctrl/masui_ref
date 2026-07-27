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
  const _CheckItem(this.label, {this.hasPendingBtn = false});
}

const _items = <_CheckItem>[
  _CheckItem('吸引をONにした'),
  _CheckItem('サクションをすぐ使えるように準備した'),
  _CheckItem('薬剤を術前指示に過不足なく準備した', hasPendingBtn: true),
  _CheckItem('持続注射薬のプライミングを行った (TIVAの場合はシリンジポンプ)'),
  _CheckItem('McGRATHのバッテリーを確認した'),
  _CheckItem('チューブの準備をした'),
  _CheckItem('カフテスト (8ml程度入れて弾力を確認)をした'),
  _CheckItem('呼吸器のセッティングをした'),
  _CheckItem('余剰排気が開いているか (30cmH2O)'),
  _CheckItem('吸入麻酔薬を補充した'),
  _CheckItem('TOFモニタの準備をした'),
  _CheckItem('モニタ側でTOFを「自動」に設定した'),
  _CheckItem('(腹臥位 / 歯科口腔外科の場合) 延長チューブを準備した'),
  _CheckItem('チューブ固定テープ・目パッチを準備した'),
  _CheckItem('体温計・脳波センサーを準備した'),
  _CheckItem('胃管の準備をした (必要症例のみ)'),
  _CheckItem('ルート準備 (22G・20G・消毒綿・駆血帯)'),
];

class _PreEntryScreenState extends State<PreEntryScreen> {
  static const _accent = Color(0xFF00695C);
  static const _targetSec = 15 * 60; // 目標15分

  final _sw = Stopwatch();
  Timer? _ticker;
  Duration _shown = Duration.zero;
  bool _finished = false;

  late final List<bool> _checked = List<bool>.filled(_items.length, false);
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
    final doneCount = _checked.where((c) => c).length;

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
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed:
                            (doneCount > 0 || _ordersPending) ? _clearAll : null,
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
      }
      _ordersPending = false;
    });
  }

  Widget _checkRow(int i) {
    final item = _items[i];
    final checked = _checked[i];
    final pending = item.hasPendingBtn && _ordersPending;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => setState(() => _checked[i] = !_checked[i]),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  checked ? Icons.check_box : Icons.check_box_outline_blank,
                  size: 22,
                  color: checked ? Colors.grey.shade500 : Colors.black45,
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
                          : (checked ? Colors.grey.shade500 : Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
            // 指示未ボタンは薬剤の項目のみ, 名前の直下に改行して配置
            if (item.hasPendingBtn)
              Padding(
                padding: const EdgeInsets.only(left: 32, top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          setState(() => _ordersPending = !_ordersPending),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: _ordersPending
                              ? Colors.red.shade600
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Colors.red.shade400, width: 1.4),
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
                    if (_ordersPending)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text('→ 近くの上級医に確認',
                            style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade700)),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
