import 'package:flutter/material.dart';

import '../mau.dart';
import '../so.dart';

class DuongCan extends StatelessWidget {
  const DuongCan({
    super.key,
    required this.diem,
    this.dich,
    this.truc = false,
    this.sang = const [],
    this.mo = const [],
  });

  final List<double> diem;
  final double? dich;
  final bool truc;
  final List<double> sang;
  final List<double> mo;

  @override
  Widget build(BuildContext context) {
    if (diem.isEmpty && sang.isEmpty && mo.isEmpty && dich == null) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: truc ? 72 : 56,
      child: LayoutBuilder(
        builder: (context, c) {
          return CustomPaint(
            size: Size(c.maxWidth, truc ? 72 : 56),
            painter: _VeDuong(diem, dich, truc, sang, mo),
          );
        },
      ),
    );
  }
}

class _VeDuong extends CustomPainter {
  _VeDuong(this.diem, this.dich, this.truc, this.sang, this.mo);

  final List<double> diem;
  final double? dich;
  final bool truc;
  final List<double> sang;
  final List<double> mo;

  @override
  void paint(Canvas canvas, Size size) {
    final all = <double>[...diem, ...sang, ...mo];
    if (dich != null) all.add(dich!);
    if (all.isEmpty) return;
    var minV = all.first;
    var maxV = all.first;
    for (final v in all) {
      if (v < minV) minV = v;
      if (v > maxV) maxV = v;
    }
    final left = truc ? 28.0 : 0.0;
    final span = (maxV - minV).abs() < 0.05 ? 1.0 : (maxV - minV);
    double yOf(double v) =>
        size.height - ((v - minV) / span) * (size.height - 4) - 2;
    double xOf(int i) {
      final w = size.width - left;
      if (diem.length <= 1) return left + w / 2;
      return left + w * i / (diem.length - 1);
    }

    if (truc) {
      void veChu(String s, Offset o) {
        final tp = TextPainter(
          text: TextSpan(text: s, style: const TextStyle(fontSize: 10, color: Mau.mo)),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, o);
      }
      veChu(So.kg(maxV), Offset(0, 0));
      veChu(So.kg(minV), Offset(0, size.height - 12));
    }

    void netNgang(double v, Color c, double w) {
      final y = yOf(v);
      final p = Paint()
        ..color = c
        ..strokeWidth = w;
      canvas.drawLine(Offset(left, y), Offset(size.width, y), p);
    }

    for (final v in mo) {
      netNgang(v, Mau.mo.withValues(alpha: 0.35), 1);
    }
    for (final v in sang) {
      netNgang(v, Mau.reu, 1.6);
    }

    if (dich != null && !sang.any((x) => (x - dich!).abs() < 0.05)) {
      final y = yOf(dich!);
      final dash = Paint()
        ..color = Mau.mo
        ..strokeWidth = 1;
      const w = 6.0;
      for (var x = left; x < size.width; x += w * 2) {
        canvas.drawLine(Offset(x, y), Offset(x + w, y), dash);
      }
    }

    if (diem.isEmpty) return;
    final paint = Paint()
      ..color = Mau.muc
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path();
    for (var i = 0; i < diem.length; i++) {
      final x = xOf(i);
      final y = yOf(diem[i]);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
    final cham = Paint()
      ..color = Mau.muc
      ..style = PaintingStyle.fill;
    if (diem.length == 1) {
      canvas.drawCircle(Offset(xOf(0), yOf(diem.first)), 5, cham);
    } else {
      for (var i = 0; i < diem.length; i++) {
        canvas.drawCircle(Offset(xOf(i), yOf(diem[i])), 3, cham);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _VeDuong old) =>
      old.diem != diem ||
      old.dich != dich ||
      old.truc != truc ||
      old.sang != sang ||
      old.mo != mo;
}
