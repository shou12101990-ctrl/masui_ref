import 'audio_beep_stub.dart'
    if (dart.library.html) 'audio_beep_web.dart';

/// 短いビープ音を鳴らす薄いサービス.
/// Web では Web Audio で鳴らし, それ以外のプラットフォームでは no-op.
/// (画面から dart:web_audio への直接依存を切り離し, VM 上のテスト/将来の
///  非Web対応を可能にするための抽象化)
abstract interface class AudioBeep {
  factory AudioBeep() => createAudioBeep();

  /// 自動再生制限の回避のため, ユーザー操作中に一度呼んでおく.
  void resume();

  /// 短いビープを1回鳴らす.
  void beep();

  void dispose();
}
