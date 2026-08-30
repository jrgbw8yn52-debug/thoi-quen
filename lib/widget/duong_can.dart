import 'package:flutter/material.dart';

import '../mau.dart';

class DuongCan extends StatelessWidget {
  const DuongCan({super.key, required this.diem});

  final List<double> diem;

  @override
  Widget build(BuildContext context) {
    if (diem.length < 2) return const SizedBox.shrink();
    return SizedBox(
      height: 56,
      child: LayoutBuilder(
        builder: (context, c) {
          return CustomPaint(
            size: Size(c.maxWidth, 56),
            painter: _VeDuong(diem),
          );
        },
      ),
    );
  }
}

class _VeDuong extends CustomPainter {
  _VeDuong(this.diem);

  final List<double> diem;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Mau.reu
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    var minV = diem.first;
    var maxV = diem.first;
    for (final v in diem) {
      if (v < minV) minV = v;
      if (v > maxV) maxV = v;
    }
    final span = (maxV - minV).abs() < 0.05 ? 1.0 : (maxV - minV);
    final path = Path();
    for (var i = 0; i < diem.length; i++) {
      final x = diem.length == 1
          ? size.width / 2
          : size.width * i / (diem.length - 1);
      final y = size.height - ((diem[i] - minV) / span) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _VeDuong old) => old.diem != diem;
}
