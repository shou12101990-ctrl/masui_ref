import 'dart:async';
import 'dart:web_audio' as wa;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 点滴メトロノーム
class DripScreen extends StatefulWidget {
  const DripScreen({super.key});

  @override
  State<DripScreen> createState() => _DripScreenState();
}

// 流速選択肢: 10–180 mL/h (10刻み) + 高流量 200–500
final _rateOptions = [
  ...List.generate(18, (i) => (i + 1) * 10),
  200, 300, 400, 500,
];

enum _SetType { adult, pediatric }

enum _InputMode { rate, volTime }

class _DripScreenState extends State<DripScreen> {
  int _rateMlH = 60;
  _SetType _setType = _SetType.adult;

  // 量・時間モード
  _InputMode _inputMode = _InputMode.rate;
  final _volCtrl = TextEditingController(text: '500');
  final _timeCtrl = TextEditingController(text: '2');
  bool _timeInHours = true;

  Timer? _timer;
  Timer? _arcTimer;
  bool _lit = false;
  bool _running = false;
  bool _sound = true;
  DateTime? _lastTickTime;
  wa.AudioContext? _audioCtx;

  @override
  void initState() {
    super.initState();
    for (final c in [_volCtrl, _timeCtrl]) {
      c.addListener(() {
        if (!mounted) return;
        setState(() {});
        if (_running) _restartTimer();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _arcTimer?.cancel();
    _audioCtx?.close();
    _volCtrl.dispose();
    _timeCtrl.dispose();
    super.dispose();
  }

  // 1滴ごとの短いビープ (Web Audio)
  void _beep() {
    if (!_sound) return;
    try {
      _audioCtx ??= wa.AudioContext();
      final ctx = _audioCtx!;
      final osc = ctx.createOscillator();
      final gain = ctx.createGain();
      osc.frequency!.value = 1000;
      gain.gain!.value = 0.12;
      osc.connectNode(gain);
      gain.connectNode(ctx.destination!);
      final now = ctx.currentTime!.toDouble();
      osc.start2(now);
      osc.stop(now + 0.04);
    } catch (_) {}
  }

  int get _dropsPerMl => _setType == _SetType.adult ? 20 : 60;

  // 有効流速 (mL/h): 流速モード=ボタン値 / 量・時間モード=製剤量÷時間
  double get _effectiveRate {
    if (_inputMode == _InputMode.rate) return _rateMlH.toDouble();
    final vol = double.tryParse(_volCtrl.text.trim());
    final t = double.tryParse(_timeCtrl.text.trim());
    if (vol == null || t == null || t <= 0) return 0;
    final hours = _timeInHours ? t : t / 60.0;
    return hours > 0 ? vol / hours : 0;
  }

  double get _dropsPerMin => _effectiveRate / 60.0 * _dropsPerMl;
  int get _intervalMs {
    final dpm = _dropsPerMin;
    if (dpm <= 0) return 999999;
    return (60000 / dpm).round();
  }

  bool get _canRun => _dropsPerMin > 0 && _intervalMs >= 100;
  bool get _tooFast => _dropsPerMin > 0 && _intervalMs < 100;

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
    if (!_canRun) return;
    final ms = _intervalMs;
    _lastTickTime = DateTime.now();
    setState(() => _lit = true);
    // 主タイマー: 1滴ごとに点滅
    _timer = Timer.periodic(Duration(milliseconds: ms), (_) {
      _lastTickTime = DateTime.now();
      _beep();
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
      // ユーザー操作中に AudioContext を起動/再開（自動再生制限の回避）
      try {
        _audioCtx ??= wa.AudioContext();
        _audioCtx!.resume();
      } catch (_) {}
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
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Column(
                children: [
                  // 成人 / 小児 セグメント
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
                  const SizedBox(height: 12),
                  // 入力モード切替
                  SegmentedButton<_InputMode>(
                    segments: const [
                      ButtonSegment(
                          value: _InputMode.rate, label: Text('流速指定')),
                      ButtonSegment(
                          value: _InputMode.volTime, label: Text('量・時間')),
                    ],
                    selected: {_inputMode},
                    onSelectionChanged: (s) {
                      setState(() => _inputMode = s.first);
                      if (_running) _restartTimer();
                    },
                  ),
                  const SizedBox(height: 12),
                  if (_inputMode == _InputMode.rate) ...[
                  // 流速ボタングリッド
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    alignment: WrapAlignment.center,
                    children: _rateOptions.map((r) {
                      final sel = _rateMlH == r;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _rateMlH = r);
                          if (_running) _restartTimer();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 11, vertical: 7),
                          decoration: BoxDecoration(
                            color: sel
                                ? scheme.primary
                                : const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$r',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: sel
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color:
                                  sel ? Colors.white : Colors.black54,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 4),
                  const Text('mL/h',
                      style: TextStyle(
                          fontSize: 11, color: Colors.black38)),
                  ] else ...[
                    _volTimeInputs(scheme),
                  ],
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _sectionTitle('点滴メトロノーム', scheme),
                      const SizedBox(width: 8),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        iconSize: 20,
                        onPressed: () => setState(() => _sound = !_sound),
                        tooltip: _sound ? '音オン' : '音オフ',
                        icon: Icon(
                            _sound ? Icons.volume_up : Icons.volume_off,
                            color: _sound ? scheme.primary : Colors.black38),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text('ランプ・音に合わせて滴下速度を調節してください',
                      style: TextStyle(fontSize: 12, color: Colors.black54)),
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
                    onPressed: _canRun ? _toggleMetronome : null,
                    icon: Icon(_running ? Icons.stop : Icons.play_arrow),
                    label: Text(_running ? '停止' : '開始'),
                  ),
                  if (_tooFast) ...[
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

  // 量・時間モードの入力UI
  Widget _volTimeInputs(ColorScheme scheme) {
    final rate = _effectiveRate;
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(
                width: 70,
                child: Text('製剤量', style: TextStyle(fontSize: 13))),
            Expanded(child: _numField(_volCtrl, 'mL')),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const SizedBox(
                width: 70,
                child: Text('投与時間', style: TextStyle(fontSize: 13))),
            Expanded(child: _numField(_timeCtrl, '')),
            const SizedBox(width: 8),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('時間')),
                ButtonSegment(value: false, label: Text('分')),
              ],
              selected: {_timeInHours},
              onSelectionChanged: (s) {
                setState(() => _timeInHours = s.first);
                if (_running) _restartTimer();
              },
              style: const ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            rate > 0
                ? '→ ${rate.toStringAsFixed(rate >= 100 ? 0 : 1)} mL/h'
                : '→ 製剤量・投与時間を入力',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: scheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),
        ),
      ],
    );
  }

  Widget _numField(TextEditingController c, String suffix) => TextField(
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
        ],
        decoration: InputDecoration(
          suffixText: suffix.isEmpty ? null : suffix,
          isDense: true,
          filled: true,
          fillColor: const Color(0xFFF7F9FA),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      );
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
