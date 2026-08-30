import 'package:flutter/material.dart';

import '../kho.dart';
import '../mau.dart';

class DuongThongKe extends StatelessWidget {
  const DuongThongKe({
    super.key,
    required this.diem,
    required this.onChon,
  });

  final List<CotThang> diem;
  final ValueChanged<DateTime> onChon;

  @override
  Widget build(BuildContext context) {
    if (diem.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      key: const Key('duong-thong-ke'),
      height: 168,
      child: LayoutBuilder(
        builder: (context, c) {
          return GestureDetector(
            onTapDown: (e) {
              final i = _gan(e.localPosition.dx, c.maxWidth, diem.length);
              onChon(diem[i].ngay);
            },
            child: CustomPaint(
              size: Size(c.maxWidth, 168),
              painter: _Ve(diem),
            ),
          );
        },
      ),
    );
  }

  static int _gan(double x, double w, int n) {
    if (n <= 1) return 0;
    final t = (x / w).clamp(0.0, 1.0);
    return (t * (n - 1)).round().clamp(0, n - 1);
  }
}

class _Ve extends CustomPainter {
  _Ve(this.diem);

  final List<CotThang> diem;

  static const _left = 28.0;

  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height - 8;
    final w = size.width - _left;
    double yOf(double p) => 4 + (1 - p.clamp(0.0, 1.0)) * h;
    double xOf(int i) {
      if (diem.length == 1) return _left + w / 2;
      return _left + w * i / (diem.length - 1);
    }

    void vach(double p, Color mau) {
      final y = yOf(p);
      final paint = Paint()
        ..color = mau
        ..strokeWidth = 1;
      const dash = 5.0;
      for (var x = _left; x < size.width; x += dash * 2) {
        canvas.drawLine(Offset(x, y), Offset(x + dash, y), paint);
      }
    }

    void nhan(String s, double p) {
      final tp = TextPainter(
        text: TextSpan(text: s, style: const TextStyle(fontSize: 10, color: Mau.mo)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, yOf(p) - 6));
    }

    vach(0.9, Mau.reu);
    vach(0.75, Mau.mo);
    nhan('90', 0.9);
    nhan('75', 0.75);
    nhan('0', 0);

    final path = Path();
    for (var i = 0; i < diem.length; i++) {
      final o = Offset(xOf(i), yOf(diem[i].phan));
      if (i == 0) {
        path.moveTo(o.dx, o.dy);
      } else {
        path.lineTo(o.dx, o.dy);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = Mau.reu
        ..strokeWidth = 1.8
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    final fill = Paint()
      ..color = Mau.reu
      ..style = PaintingStyle.fill;
    final xem = Paint()
      ..color = Mau.muc
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (var i = 0; i < diem.length; i++) {
      final o = Offset(xOf(i), yOf(diem[i].phan));
      canvas.drawCircle(o, diem[i].dangXem ? 5 : 3.5, fill);
      if (diem[i].dangXem) canvas.drawCircle(o, 7, xem);
    }
  }

  @override
  bool shouldRepaint(covariant _Ve old) => old.diem != diem;
}
