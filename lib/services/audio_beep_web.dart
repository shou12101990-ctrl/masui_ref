import 'dart:web_audio' as wa;

import 'audio_beep.dart';

/// Web (Web Audio)用の実装.
AudioBeep createAudioBeep() => _WebAudioBeep();

class _WebAudioBeep implements AudioBeep {
  wa.AudioContext? _ctx;

  @override
  void resume() {
    try {
      _ctx ??= wa.AudioContext();
      _ctx!.resume();
    } catch (_) {}
  }

  @override
  void beep() {
    try {
      _ctx ??= wa.AudioContext();
      final ctx = _ctx!;
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

  @override
  void dispose() {
    _ctx?.close();
  }
}
