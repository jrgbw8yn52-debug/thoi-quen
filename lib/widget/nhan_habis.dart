import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../mau.dart';

/// Mark Habis: 2 thanh chéo gradient + chấm cam trái dưới.
class NhanHabis extends StatelessWidget {
  const NhanHabis({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const CustomPaint(painter: NhanHabisPainter()),
    );
  }
}

class NhanHabisPainter extends CustomPainter {
  const NhanHabisPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    const theta = 38 * math.pi / 180;
    final dx = -math.sin(theta);
    final dy = math.cos(theta);
    final length = s * 0.42;
    final radius = s * 0.055;
    final gap = s * 0.129;
    final cx = s * 0.518;
    final cy = s * 0.459;
    final px = dy;
    final py = -dx;

    Offset barCenter(double ox, double oy) => Offset(cx + ox, cy + oy);

    void capsule(Offset bot, Offset top, Paint paint) {
      final path = Path()
        ..moveTo(bot.dx, bot.dy)
        ..lineTo(top.dx, top.dy);
      canvas.drawPath(path, paint);
    }

    final barPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 2
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [Mau.reu, Mau.lua],
      ).createShader(Offset.zero & size);

    void barAt(Offset c) {
      final half = length / 2;
      final top = Offset(c.dx - dx * half, c.dy - dy * half);
      final bot = Offset(c.dx + dx * half, c.dy + dy * half);
      capsule(bot, top, barPaint);
    }

    final left = barCenter(-px * gap / 2, -py * gap / 2);
    final right = Offset(
      cx + px * gap / 2 + dx * s * 0.035,
      cy + py * gap / 2 + dy * s * 0.035,
    );
    barAt(left);
    barAt(right);

    final half = length / 2;
    final botLeft = Offset(left.dx + dx * half, left.dy + dy * half);
    final dotR = s * 0.076;
    canvas.drawCircle(
      Offset(botLeft.dx - s * 0.018, botLeft.dy + s * 0.008),
      dotR,
      Paint()..color = Mau.reu,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
