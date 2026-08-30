import 'package:flutter/material.dart';

import '../mau.dart';

class DuongCan extends StatelessWidget {
  const DuongCan({super.key, required this.diem, this.dich});

  final List<double> diem;
  final double? dich;

  @override
  Widget build(BuildContext context) {
    if (diem.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 56,
      child: LayoutBuilder(
        builder: (context, c) {
          return CustomPaint(
            size: Size(c.maxWidth, 56),
            painter: _VeDuong(diem, dich),
          );
        },
      ),
    );
  }
}

class _VeDuong extends CustomPainter {
  _VeDuong(this.diem, this.dich);

  final List<double> diem;
  final double? dich;

  @override
  void paint(Canvas canvas, Size size) {
    var minV = diem.first;
    var maxV = diem.first;
    for (final v in diem) {
      if (v < minV) minV = v;
      if (v > maxV) maxV = v;
    }
    final d = dich;
    if (d != null) {
      if (d < minV) minV = d;
      if (d > maxV) maxV = d;
    }
    final span = (maxV - minV).abs() < 0.05 ? 1.0 : (maxV - minV);
    double yOf(double v) =>
        size.height - ((v - minV) / span) * size.height;

    if (d != null) {
      final y = yOf(d);
      final dash = Paint()
        ..color = Mau.mo
        ..strokeWidth = 1;
      const w = 6.0;
      for (var x = 0.0; x < size.width; x += w * 2) {
        canvas.drawLine(Offset(x, y), Offset(x + w, y), dash);
      }
    }

    final paint = Paint()
      ..color = Mau.reu
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path();
    for (var i = 0; i < diem.length; i++) {
      final x = diem.length == 1
          ? size.width / 2
          : size.width * i / (diem.length - 1);
      final y = yOf(diem[i]);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
    final cham = Paint()
      ..color = Mau.reu
      ..style = PaintingStyle.fill;
    if (diem.length == 1) {
      canvas.drawCircle(Offset(size.width / 2, yOf(diem.first)), 5, cham);
    } else {
      for (var i = 0; i < diem.length; i++) {
        final x = size.width * i / (diem.length - 1);
        canvas.drawCircle(Offset(x, yOf(diem[i])), 3, cham);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _VeDuong old) =>
      old.diem != diem || old.dich != dich;
}
