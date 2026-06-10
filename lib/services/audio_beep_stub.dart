import 'audio_beep.dart';

/// 非Webプラットフォーム用の no-op 実装.
AudioBeep createAudioBeep() => _NoopAudioBeep();

class _NoopAudioBeep implements AudioBeep {
  @override
  void resume() {}
  @override
  void beep() {}
  @override
  void dispose() {}
}
