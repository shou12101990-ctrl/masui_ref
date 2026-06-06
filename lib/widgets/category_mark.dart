import 'package:flutter/material.dart';

/// 薬剤カテゴリの色付き■マーカー。
/// diagonal=true のとき拮抗薬・血管拡張薬を示す白い斜線を重ねる。
class CategoryMark extends StatelessWidget {
  final Color color;
  final bool diagonal;
  final double size;
  const CategoryMark({
    super.key,
    required this.color,
    this.diagonal = false,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _MarkPainter(color: color, diagonal: diagonal),
      ),
    );
  }
}

class _MarkPainter extends CustomPainter {
  final Color color;
  final bool diagonal;
  const _MarkPainter({required this.color, required this.diagonal});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(3)),
      Paint()..color = color,
    );
    if (diagonal) {
      // 黒縁（border）
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0.5, 0.5, size.width - 1, size.height - 1),
          const Radius.circular(2.5),
        ),
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );
      // 斜線
      canvas.drawLine(
        Offset(size.width * 0.15, size.height * 0.85),
        Offset(size.width * 0.85, size.height * 0.15),
        Paint()
          ..color = Colors.black
          ..strokeWidth = 2.2
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_MarkPainter old) =>
      old.color != color || old.diagonal != diagonal;
}
