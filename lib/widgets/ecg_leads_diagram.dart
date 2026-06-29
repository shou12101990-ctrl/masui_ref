import 'package:flutter/material.dart';

/// ECG電極の貼付位置イラスト.
/// 上段: 3点 / 5点誘導 (四肢電極中心の小パネル).
/// 下段: 12誘導 胸部誘導 — 肋骨・基準線 (鎖骨中線/前腋窩線/中腋窩線)とともに
///       V1-V6を標準色で配置した本格パネル + 色凡例.
/// 依存パッケージ無しで CustomPainter により描画 (色はIEC/慣用例, 位置で覚える).
class EcgLeadsDiagram extends StatelessWidget {
  const EcgLeadsDiagram({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        SizedBox(
          height: 132,
          child: Row(
            children: [
              Expanded(child: _PanelBox(title: '3点誘導', panel: _Panel.three)),
              SizedBox(width: 6),
              Expanded(child: _PanelBox(title: '5点誘導', panel: _Panel.five)),
            ],
          ),
        ),
        SizedBox(height: 8),
        _ChestPanel(),
      ],
    );
  }
}

// ─── 共通色 (四肢: IEC) ───────────────────────────────────────
const _cRA = Color(0xFFE53935); // 赤
const _cLA = Color(0xFFF9A825); // 黄
const _cLL = Color(0xFF43A047); // 緑
const _cRL = Color(0xFF616161); // 黒
const _cV = Color(0xFF8D6E63); // 茶 (V5 in 5点)

// ─── 胸部誘導V1-V6色 (参考図に合わせた慣用色) ─────────────────
const _chV1 = Color(0xFFE91E63); // マゼンタ
const _chV2 = Color(0xFFF9A825); // 黄
const _chV3 = Color(0xFF43A047); // 緑
const _chV4 = Color(0xFF795548); // 茶
const _chV5 = Color(0xFF212121); // 黒
const _chV6 = Color(0xFF8E24AA); // 紫

// ════════════════════════════════════════════════════════════
//  上段: 3点 / 5点 (簡易トルソ)
// ════════════════════════════════════════════════════════════
enum _Panel { three, five }

class _PanelBox extends StatelessWidget {
  final String title;
  final _Panel panel;
  const _PanelBox({required this.title, required this.panel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        const SizedBox(height: 3),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12),
            ),
            child: CustomPaint(size: Size.infinite, painter: _TorsoPainter(panel)),
          ),
        ),
      ],
    );
  }
}

class _Elec {
  final double x;
  final double y;
  final Color color;
  final String label;
  const _Elec(this.x, this.y, this.color, this.label);
}

class _TorsoPainter extends CustomPainter {
  final _Panel panel;
  _TorsoPainter(this.panel);

  List<_Elec> get _elecs {
    switch (panel) {
      case _Panel.three:
        return const [
          _Elec(0.25, 0.27, _cRA, 'RA'),
          _Elec(0.75, 0.27, _cLA, 'LA'),
          _Elec(0.66, 0.82, _cLL, 'LL'),
        ];
      case _Panel.five:
        return const [
          _Elec(0.21, 0.25, _cRA, 'RA'),
          _Elec(0.79, 0.25, _cLA, 'LA'),
          _Elec(0.29, 0.88, _cRL, 'RL'),
          _Elec(0.71, 0.88, _cLL, 'LL'),
          _Elec(0.63, 0.58, _cV, 'V5'),
        ];
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final pad = size.width * 0.07;
    final r =
        Rect.fromLTWH(pad, pad, size.width - 2 * pad, size.height - 2 * pad);
    _drawTorso(canvas, r);
    for (final e in _elecs) {
      _drawDot(canvas, Offset(r.left + e.x * r.width, r.top + e.y * r.height),
          e.color, size.width * 0.042);
    }
    for (final e in _elecs) {
      final c = Offset(r.left + e.x * r.width, r.top + e.y * r.height);
      _drawSideLabel(canvas, c, e.label, size, size.width * 0.042);
    }
  }

  void _drawTorso(Canvas canvas, Rect r) {
    final fill = Paint()..color = const Color(0xFFE6E9F0);
    final stroke = Paint()
      ..color = Colors.black26
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    double fx(double f) => r.left + f * r.width;
    double fy(double f) => r.top + f * r.height;
    final headR = r.width * 0.10;
    canvas.drawCircle(Offset(r.center.dx, r.top + headR), headR, fill);
    canvas.drawCircle(Offset(r.center.dx, r.top + headR), headR, stroke);
    final p = Path()
      ..moveTo(fx(0.16), fy(0.32))
      ..quadraticBezierTo(fx(0.5), fy(0.15), fx(0.84), fy(0.32))
      ..quadraticBezierTo(fx(0.80), fy(0.64), fx(0.74), fy(0.97))
      ..lineTo(fx(0.26), fy(0.97))
      ..quadraticBezierTo(fx(0.20), fy(0.64), fx(0.16), fy(0.32))
      ..close();
    canvas.drawPath(p, fill);
    canvas.drawPath(p, stroke);
  }

  @override
  bool shouldRepaint(covariant _TorsoPainter old) => old.panel != panel;
}

// ════════════════════════════════════════════════════════════
//  下段: 12誘導 胸部誘導
// ════════════════════════════════════════════════════════════
class _ChestPanel extends StatelessWidget {
  const _ChestPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('12誘導 胸部誘導 (V1-V6)',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        const SizedBox(height: 3),
        AspectRatio(
          aspectRatio: 1.7,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12),
            ),
            child: CustomPaint(size: Size.infinite, painter: _ChestPainter()),
          ),
        ),
        const SizedBox(height: 6),
        const Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 4,
          children: [
            _LegendDot(_chV1, 'V1'),
            _LegendDot(_chV2, 'V2'),
            _LegendDot(_chV3, 'V3'),
            _LegendDot(_chV4, 'V4'),
            _LegendDot(_chV5, 'V5'),
            _LegendDot(_chV6, 'V6'),
          ],
        ),
        const SizedBox(height: 3),
        Text('縦の点線: 左鎖骨中線 / 左前腋窩線 / 左中腋窩線',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 9.5, color: Colors.grey.shade600)),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot(this.color, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 3),
        Text(label,
            style: const TextStyle(
                fontSize: 10.5, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _ChestPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pad = size.width * 0.03;
    final r =
        Rect.fromLTWH(pad, pad, size.width - 2 * pad, size.height - 2 * pad);
    double fx(double f) => r.left + f * r.width;
    double fy(double f) => r.top + f * r.height;

    // 体幹 (肩+胸郭)
    final torsoFill = Paint()..color = const Color(0xFFF1E8E1);
    final torsoStroke = Paint()
      ..color = Colors.black26
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final t = Path()
      ..moveTo(fx(0.08), fy(0.22))
      ..quadraticBezierTo(fx(0.28), fy(0.03), fx(0.42), fy(0.06))
      ..lineTo(fx(0.58), fy(0.06))
      ..quadraticBezierTo(fx(0.72), fy(0.03), fx(0.92), fy(0.22))
      ..quadraticBezierTo(fx(0.95), fy(0.62), fx(0.88), fy(0.99))
      ..lineTo(fx(0.12), fy(0.99))
      ..quadraticBezierTo(fx(0.05), fy(0.62), fx(0.08), fy(0.22))
      ..close();
    canvas.drawPath(t, torsoFill);
    canvas.drawPath(t, torsoStroke);

    // 肋骨 (左右5対の弧)
    final rib = Paint()
      ..color = const Color(0xFFD8D0C4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.011
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 5; i++) {
      final yIn = 0.24 + i * 0.075;
      final yOut = 0.32 + i * 0.085;
      canvas.drawPath(
          Path()
            ..moveTo(fx(0.475), fy(yIn))
            ..quadraticBezierTo(fx(0.30), fy(yIn + 0.02), fx(0.12), fy(yOut)),
          rib);
      canvas.drawPath(
          Path()
            ..moveTo(fx(0.525), fy(yIn))
            ..quadraticBezierTo(fx(0.70), fy(yIn + 0.02), fx(0.88), fy(yOut)),
          rib);
    }

    // 胸骨
    final bone = Paint()..color = const Color(0xFFEAE3D8);
    final boneStroke = Paint()
      ..color = Colors.black.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.005;
    final stern = RRect.fromRectAndRadius(
        Rect.fromLTRB(fx(0.47), fy(0.15), fx(0.53), fy(0.56)),
        Radius.circular(size.width * 0.02));
    canvas.drawRRect(stern, bone);
    canvas.drawRRect(stern, boneStroke);

    // 基準線 (患者左=画像右): 鎖骨中線 / 前腋窩線 / 中腋窩線
    _dottedV(canvas, fx(0.64), fy(0.18), fy(0.95), size);
    _dottedV(canvas, fx(0.76), fy(0.18), fy(0.95), size);
    _dottedV(canvas, fx(0.86), fy(0.18), fy(0.95), size);

    // V電極 (x, y, 色, ラベル)
    final electrodes = <(double, double, Color, String)>[
      (0.47, 0.50, _chV1, 'V1'),
      (0.53, 0.50, _chV2, 'V2'),
      (0.585, 0.55, _chV3, 'V3'),
      (0.64, 0.61, _chV4, 'V4'),
      (0.76, 0.61, _chV5, 'V5'),
      (0.86, 0.61, _chV6, 'V6'),
    ];
    final dotR = size.width * 0.022;
    for (final e in electrodes) {
      _drawDot(canvas, Offset(fx(e.$1), fy(e.$2)), e.$3, dotR);
    }
    for (final e in electrodes) {
      _drawAboveLabel(canvas, Offset(fx(e.$1), fy(e.$2)), e.$4, size, dotR);
    }
  }

  void _dottedV(Canvas canvas, double x, double y1, double y2, Size size) {
    final p = Paint()..color = const Color(0xFFEB8DAE);
    final step = size.height * 0.05;
    for (double y = y1; y <= y2; y += step) {
      canvas.drawCircle(Offset(x, y), size.width * 0.006, p);
    }
  }

  void _drawAboveLabel(
      Canvas canvas, Offset c, String text, Size size, double dotR) {
    final tp = TextPainter(
      text: TextSpan(
          text: text,
          style: TextStyle(
              fontSize: size.width * 0.036,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.0)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(c.dx - tp.width / 2, c.dy - dotR - tp.height - 1));
  }

  @override
  bool shouldRepaint(covariant _ChestPainter old) => false;
}

// ─── 共通ドット/ラベル ───────────────────────────────────────
void _drawDot(Canvas canvas, Offset c, Color color, double rDot) {
  canvas.drawCircle(c, rDot + 1.4, Paint()..color = Colors.white);
  canvas.drawCircle(c, rDot, Paint()..color = color);
  canvas.drawCircle(
      c,
      rDot,
      Paint()
        ..color = Colors.black38
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8);
}

void _drawSideLabel(
    Canvas canvas, Offset c, String text, Size size, double dotR) {
  if (text.isEmpty) return;
  final tp = TextPainter(
    text: TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size.width * 0.085,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            height: 1.0)),
    textDirection: TextDirection.ltr,
  )..layout();
  final Offset pos = c.dx > size.width / 2
      ? Offset(c.dx - dotR - tp.width - 3, c.dy - tp.height / 2)
      : Offset(c.dx + dotR + 3, c.dy - tp.height / 2);
  tp.paint(canvas, pos);
}
