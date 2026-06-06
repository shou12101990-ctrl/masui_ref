import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 点滴メトロノーム
class DripScreen extends StatefulWidget {
  const DripScreen({super.key});

  @override
  State<DripScreen> createState() => _DripScreenState();
}

// 流速選択肢: 10–180 mL/h (10刻み)
final _rateOptions = List.generate(18, (i) => (i + 1) * 10);

enum _SetType { adult, pediatric }

class _DripScreenState extends State<DripScreen> {
  int _rateMlH = 60;
  _SetType _setType = _SetType.adult;

  Timer? _timer;
  Timer? _arcTimer;
  bool _lit = false;
  bool _running = false;
  DateTime? _lastTickTime;

  @override
  void dispose() {
    _timer?.cancel();
    _arcTimer?.cancel();
    super.dispose();
  }

  int get _dropsPerMl => _setType == _SetType.adult ? 20 : 60;
  double get _dropsPerMin => _rateMlH / 60.0 * _dropsPerMl;
  int get _intervalMs => (60000 / _dropsPerMin).round();

  /// 次のフラッシュまでの進捗 0.0–1.0
  double get _arcProgress {
    if (!_running || _lastTickTime == null) return 0.0;
    final ms = _intervalMs;
    if (ms <= 0) return 0.0;
    final elapsed =
        DateTime.now().difference(_lastTickTime!).inMilliseconds;
    return (elapsed / ms).clamp(0.0, 1.0);
  }

  void _restartTimer() {
    _timer?.cancel();
    _arcTimer?.cancel();
    final ms = _intervalMs;
    if (ms < 100) return;
    _lastTickTime = DateTime.now();
    setState(() => _lit = true);
    // 主タイマー: 1滴ごとに点滅
    _timer = Timer.periodic(Duration(milliseconds: ms), (_) {
      _lastTickTime = DateTime.now();
      setState(() => _lit = !_lit);
    });
    // 弧アニメーション用タイマー (~30 fps)
    _arcTimer = Timer.periodic(const Duration(milliseconds: 33), (_) {
      if (mounted) setState(() {});
    });
  }

  void _toggleMetronome() {
    if (_running) {
      _timer?.cancel();
      _arcTimer?.cancel();
      setState(() {
        _running = false;
        _lit = false;
        _lastTickTime = null;
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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('点滴メトロノーム'),
        backgroundColor: scheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          // ── 設定 ────────────────────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 成人 / 小児 セグメント (中央揃え)
                  SegmentedButton<_SetType>(
                    segments: const [
                      ButtonSegment(
                          value: _SetType.adult,
                          label: Text('成人  1ml 20滴')),
                      ButtonSegment(
                          value: _SetType.pediatric,
                          label: Text('小児  1ml 60滴')),
                    ],
                    selected: {_setType},
                    onSelectionChanged: (s) {
                      setState(() => _setType = s.first);
                      if (_running) _restartTimer();
                    },
                  ),
                  const SizedBox(width: 14),
                  // 流量ドロップダウン (コンパクト)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('流量',
                          style: TextStyle(
                              fontSize: 11, color: Colors.black54)),
                      const SizedBox(height: 3),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<int>(
                          value: _rateMlH,
                          isDense: true,
                          underline: const SizedBox.shrink(),
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black87),
                          icon: const Icon(Icons.expand_more,
                              size: 18, color: Colors.black45),
                          items: _rateOptions
                              .map((v) => DropdownMenuItem(
                                    value: v,
                                    child: Text('$v mL/h'),
                                  ))
                              .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              setState(() => _rateMlH = v);
                              if (_running) _restartTimer();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── メトロノーム ────────────────────────────────────────────────
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
                  const SizedBox(height: 24),

                  // 円弧 + 点滅ランプ
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // 進捗弧（次の点滅までのカウントダウン）
                      SizedBox(
                        width: 148,
                        height: 148,
                        child: CustomPaint(
                          painter: _ArcPainter(
                            progress: _running ? _arcProgress : 0.0,
                            color: scheme.primary,
                          ),
                        ),
                      ),
                      // 点滅ランプ
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 80),
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (_running && _lit)
                              ? scheme.primary
                              : scheme.primary.withValues(alpha: 0.12),
                          boxShadow: (_running && _lit)
                              ? [
                                  BoxShadow(
                                    color: scheme.primary
                                        .withValues(alpha: 0.5),
                                    blurRadius: 24,
                                    spreadRadius: 4,
                                  )
                                ]
                              : [],
                        ),
                        child: Icon(
                          Icons.water_drop,
                          size: 44,
                          color: (_running && _lit)
                              ? Colors.white
                              : scheme.primary.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _running
                          ? Colors.red.shade400
                          : scheme.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(160, 44),
                    ),
                    onPressed:
                        _intervalMs >= 100 ? _toggleMetronome : null,
                    icon: Icon(_running ? Icons.stop : Icons.play_arrow),
                    label: Text(_running ? '停止' : '開始'),
                  ),
                  if (_intervalMs < 100) ...[
                    const SizedBox(height: 8),
                    const Text(
                      '流量が速すぎてメトロノームを表示できません',
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text, ColorScheme scheme) => Text(text,
      style: TextStyle(
          color: scheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14));
}

// ── 円弧 CustomPainter ────────────────────────────────────────────────────
class _ArcPainter extends CustomPainter {
  final double progress; // 0.0–1.0
  final Color color;
  const _ArcPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;

    // 背景リング
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2,
      false,
      Paint()
        ..color = color.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7
        ..strokeCap = StrokeCap.round,
    );

    // 進捗弧
    if (progress > 0.01) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        math.pi * 2 * progress,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_ArcPainter old) =>
      old.progress != progress || old.color != color;
}
