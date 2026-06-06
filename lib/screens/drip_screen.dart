import 'dart:async';
import 'package:flutter/material.dart';

/// 点滴流速計算機 + 点滴速度メトロノーム（点滅）
class DripScreen extends StatefulWidget {
  const DripScreen({super.key});

  @override
  State<DripScreen> createState() => _DripScreenState();
}

// 流速選択肢: 10〜180 mL/h (10刻み)
final _rateOptions = List.generate(18, (i) => (i + 1) * 10);

enum _SetType { adult, pediatric }

class _DripScreenState extends State<DripScreen> {
  int _rateMlH = 60;          // 流速 (ドロップダウン)
  _SetType _setType = _SetType.adult;

  Timer? _timer;
  bool _lit = false;
  bool _running = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int get _dropsPerMl => _setType == _SetType.adult ? 20 : 60;

  double get _rate => _rateMlH.toDouble();

  /// drops/min
  double get _dropsPerMin => _rate / 60 * _dropsPerMl;

  /// 1滴の間隔 (ms)
  int get _intervalMs => (60000 / _dropsPerMin).round();

  void _restartTimer() {
    _timer?.cancel();
    final ms = _intervalMs;
    if (ms < 100) return;
    _timer = Timer.periodic(Duration(milliseconds: ms), (_) {
      setState(() => _lit = !_lit);
    });
  }

  void _toggleMetronome() {
    if (_running) {
      _timer?.cancel();
      setState(() {
        _running = false;
        _lit = false;
      });
    } else {
      setState(() => _running = true);
      _restartTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final dpm = _dropsPerMin;
    final ms  = _intervalMs;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('点滴流速 / メトロノーム'),
        backgroundColor: scheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          // ── 設定 ─────────────────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('設定', scheme),
                  const SizedBox(height: 12),
                  // 流速 ドロップダウン
                  DropdownButtonFormField<int>(
                    value: _rateMlH,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: '流量',
                      suffixText: 'mL/h',
                      isDense: true,
                      filled: true,
                      fillColor: const Color(0xFFF7F9FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                    ),
                    items: _rateOptions
                        .map((v) => DropdownMenuItem(
                              value: v,
                              child: Text('$v',
                                  style: const TextStyle(fontSize: 15)),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setState(() => _rateMlH = v);
                        if (_running) _restartTimer();
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<_SetType>(
                    segments: const [
                      ButtonSegment(
                          value: _SetType.adult,
                          label: Text('成人セット (20滴/mL)')),
                      ButtonSegment(
                          value: _SetType.pediatric,
                          label: Text('小児セット (60滴/mL)')),
                    ],
                    selected: {_setType},
                    onSelectionChanged: (s) {
                      setState(() => _setType = s.first);
                      if (_running) _restartTimer();
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── 計算結果 ──────────────────────────────────────────────────
          Card(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border:
                    Border(left: BorderSide(color: scheme.primary, width: 4)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.opacity, size: 18, color: scheme.primary),
                    const SizedBox(width: 6),
                    Text('計算結果',
                        style: TextStyle(
                            color: scheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                  ]),
                  const SizedBox(height: 14),
                  _resultRow('滴下速度', '${dpm.toStringAsFixed(1)} 滴/分'),
                  const Divider(height: 16),
                  _resultRow('1滴の間隔',
                      '${(ms / 1000).toStringAsFixed(2)} 秒/滴'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── メトロノーム ──────────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _sectionTitle('点滴メトロノーム', scheme),
                  const SizedBox(height: 4),
                  Text('ランプに合わせて滴下速度を調節してください',
                      style: const TextStyle(
                          fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 20),

                  // 点滅ランプ
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 80),
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (_running && _lit)
                          ? scheme.primary
                          : scheme.primary.withValues(alpha: 0.12),
                      boxShadow: (_running && _lit)
                          ? [
                              BoxShadow(
                                color: scheme.primary.withValues(alpha: 0.5),
                                blurRadius: 24,
                                spreadRadius: 4,
                              )
                            ]
                          : [],
                    ),
                    child: Icon(
                      Icons.water_drop,
                      size: 48,
                      color: (_running && _lit)
                          ? Colors.white
                          : scheme.primary.withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    '${dpm.toStringAsFixed(1)} 滴/分'
                    '  ·  ${(ms / 1000).toStringAsFixed(2)} 秒/滴',
                    style: TextStyle(
                        fontSize: 14,
                        color: scheme.primary,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _running ? Colors.red.shade400 : scheme.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(160, 44),
                    ),
                    onPressed: ms >= 100 ? _toggleMetronome : null,
                    icon: Icon(_running ? Icons.stop : Icons.play_arrow),
                    label: Text(_running ? '停止' : '開始'),
                  ),
                  if (ms < 100) ...[
                    const SizedBox(height: 8),
                    const Text('流量が速すぎてメトロノームを表示できません',
                        style:
                            TextStyle(fontSize: 12, color: Colors.red)),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),
          // 参考換算表
          _refTable(scheme),
        ],
      ),
    );
  }

  Widget _refTable(ColorScheme scheme) {
    const rows = [
      (30, '10 滴/分', '6 秒/滴'),
      (60, '20 滴/分', '3 秒/滴'),
      (90, '30 滴/分', '2 秒/滴'),
      (120, '40 滴/分', '1.5 秒/滴'),
      (180, '60 滴/分', '1 秒/滴'),
      (240, '80 滴/分', '0.75 秒/滴'),
      (300, '100 滴/分', '0.6 秒/滴'),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('参考: 成人セット換算表', scheme),
            const SizedBox(height: 10),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1.2),
                1: FlexColumnWidth(1.5),
                2: FlexColumnWidth(1.5),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.07),
                  ),
                  children: [
                    _th('流量 mL/h'),
                    _th('滴/分'),
                    _th('間隔'),
                  ],
                ),
                for (final r in rows)
                  TableRow(children: [
                    _td('${r.$1}'),
                    _td(r.$2),
                    _td(r.$3,
                        bold: r.$1 == 180),
                  ]),
              ],
            ),
          ],
        ),
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

  Widget _td(String text, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
        child: Text(text,
            style: TextStyle(
                fontSize: 12,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                color: bold ? Colors.teal.shade700 : null)),
      );

  Widget _resultRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(label,
              style:
                  const TextStyle(fontSize: 13, color: Colors.black54)),
        ),
        Expanded(
          child: Text(value,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _sectionTitle(String text, ColorScheme scheme) => Text(text,
      style: TextStyle(
          color: scheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14));
}
