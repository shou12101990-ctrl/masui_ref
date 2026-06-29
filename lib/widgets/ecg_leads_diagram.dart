import 'package:flutter/material.dart';

/// ECG電極の貼付位置イラスト (3点 / 5点 / 12誘導の3パネル横並び).
/// 依存パッケージ無しで CustomPainter により描画する. 色はIEC例
/// (RA赤・LA黄・LL緑・RL黒・V茶), 規格で異なるため位置で覚える.
class EcgLeadsDiagram extends StatelessWidget {
  const EcgLeadsDiagram({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.3,
      child: Row(
        children: const [
          Expanded(child: _PanelBox(title: '3点誘導', panel: _Panel.three)),
          SizedBox(width: 6),
          Expanded(child: _PanelBox(title: '5点誘導', panel: _Panel.five)),
          SizedBox(width: 6),
          Expanded(child: _PanelBox(title: '12誘導 (胸部)', panel: _Panel.twelve)),
        ],
      ),
    );
  }
}

enum _Panel { three, five, twelve }

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
            child: CustomPaint(
              size: Size.infinite,
              painter: _TorsoPainter(panel),
            ),
          ),
        ),
      ],
    );
  }
}

const _cRA = Color(0xFFE53935); // 赤
const _cLA = Color(0xFFF9A825); // 黄
const _cLL = Color(0xFF43A047); // 緑
const _cRL = Color(0xFF616161); // 黒
const _cV = Color(0xFF8D6E63); // 茶

class _Elec {
  final double x; // torso矩形内の割合
  final double y;
  final Color color;
  final String label;
  final bool above; // ラベルをドットの上に置く
  const _Elec(this.x, this.y, this.color, this.label, {this.above = false});
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
      case _Panel.twelve:
        return const [
          _Elec(0.18, 0.22, _cRA, ''),
          _Elec(0.82, 0.22, _cLA, ''),
          _Elec(0.30, 0.90, _cRL, ''),
          _Elec(0.70, 0.90, _cLL, ''),
          _Elec(0.46, 0.50, _cV, '1', above: true),
          _Elec(0.55, 0.50, _cV, '2', above: true),
          _Elec(0.585, 0.585, _cV, '3', above: true),
          _Elec(0.62, 0.66, _cV, '4', above: true),
          _Elec(0.71, 0.655, _cV, '5', above: true),
          _Elec(0.80, 0.65, _cV, '6', above: true),
        ];
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final pad = size.width * 0.07;
    final r = Rect.fromLTWH(
        pad, pad, size.width - 2 * pad, size.height - 2 * pad);
    _drawTorso(canvas, r);
    for (final e in _elecs) {
      final c = Offset(r.left + e.x * r.width, r.top + e.y * r.height);
      _drawDot(canvas, c, e.color, size);
    }
    // ラベルはドットの上に描いて重なりを避ける
    for (final e in _elecs) {
      if (e.label.isEmpty) continue;
      final c = Offset(r.left + e.x * r.width, r.top + e.y * r.height);
      _drawLabel(canvas, c, e.label, size, e.above);
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

    // 頭
    final headR = r.width * 0.10;
    final headC = Offset(r.center.dx, r.top + headR * 1.0);
    canvas.drawCircle(headC, headR, fill);
    canvas.drawCircle(headC, headR, stroke);

    // 体幹 (肩→ウエスト)
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

  void _drawDot(Canvas canvas, Offset c, Color color, Size size) {
    final rDot = size.width * 0.042;
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

  void _drawLabel(
      Canvas canvas, Offset c, String text, Size size, bool above) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size.width * 0.085,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            height: 1.0),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final rDot = size.width * 0.042;
    Offset pos;
    if (above) {
      pos = Offset(c.dx - tp.width / 2, c.dy - rDot - tp.height - 1);
    } else if (c.dx > size.width / 2) {
      // 右側のドットはラベルを左へ
      pos = Offset(c.dx - rDot - tp.width - 3, c.dy - tp.height / 2);
    } else {
      pos = Offset(c.dx + rDot + 3, c.dy - tp.height / 2);
    }
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant _TorsoPainter old) => old.panel != panel;
}
