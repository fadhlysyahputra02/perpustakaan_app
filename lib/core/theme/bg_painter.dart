import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'app_theme.dart';

class BgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintFill = Paint()..style = PaintingStyle.fill;
    final paintStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    paintFill.color = AppTheme.primary.withOpacity(0.08);
    canvas.drawCircle(Offset(size.width + 40, -40), 180, paintFill);

    paintStroke.color = AppTheme.primary.withOpacity(0.12);
    canvas.drawCircle(Offset(size.width + 40, -40), 220, paintStroke);
    canvas.drawCircle(Offset(size.width + 40, -40), 260, paintStroke);

    paintFill.color = AppTheme.primaryLight.withOpacity(0.07);
    canvas.drawCircle(Offset(-60, size.height + 20), 160, paintFill);

    paintStroke.color = AppTheme.primaryLight.withOpacity(0.1);
    canvas.drawCircle(Offset(-60, size.height + 20), 200, paintStroke);
    canvas.drawCircle(Offset(-60, size.height + 20), 240, paintStroke);

    _drawLeaf(
        canvas, Offset(30, 80), 50, -0.3, AppTheme.primary.withOpacity(0.1));
    _drawLeaf(canvas, Offset(60, 50), 40, 0.4,
        AppTheme.primaryLight.withOpacity(0.08));
    _drawLeaf(canvas, Offset(size.width - 30, size.height - 80), 60,
        math.pi + 0.3, AppTheme.primary.withOpacity(0.1));
    _drawLeaf(canvas, Offset(size.width - 60, size.height - 50), 45,
        math.pi - 0.4, AppTheme.primaryLight.withOpacity(0.08));

    final dots = [
      Offset(size.width * 0.15, size.height * 0.3),
      Offset(size.width * 0.82, size.height * 0.4),
      Offset(size.width * 0.25, size.height * 0.75),
      Offset(size.width * 0.7, size.height * 0.85),
      Offset(size.width * 0.5, size.height * 0.12),
      Offset(size.width * 0.9, size.height * 0.7),
    ];
    paintFill.color = AppTheme.primary.withOpacity(0.15);
    for (final dot in dots) {
      canvas.drawCircle(dot, 4, paintFill);
    }

    paintStroke.color = AppTheme.primary.withOpacity(0.05);
    paintStroke.strokeWidth = 1;
    for (int i = 0; i < 6; i++) {
      final x = size.width * 0.1 * (i + 1);
      canvas.drawLine(
        Offset(x - 40, 0),
        Offset(x + 40, size.height),
        paintStroke,
      );
    }
  }

  void _drawLeaf(
      Canvas canvas, Offset center, double size, double angle, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    final path = Path();
    path.moveTo(0, -size);
    path.cubicTo(size * 0.6, -size * 0.6, size * 0.6, size * 0.6, 0, size);
    path.cubicTo(-size * 0.6, size * 0.6, -size * 0.6, -size * 0.6, 0, -size);
    path.close();
    canvas.drawPath(path, paint);

    final veinPaint = Paint()
      ..color = AppTheme.primary.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, -size * 0.8), Offset(0, size * 0.8), veinPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
