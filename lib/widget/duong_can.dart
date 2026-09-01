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
    this.nhanNgay = const [],
    this.soTrenDiem = false,
    this.khung = true,
  });

  final List<double> diem;
  final double? dich;
  final bool truc;
  final List<double> sang;
  final List<double> mo;
  final List<DateTime> nhanNgay;
  final bool soTrenDiem;
  final bool khung;

  @override
  Widget build(BuildContext context) {
    final h = soTrenDiem || nhanNgay.isNotEmpty ? 148.0 : (truc ? 96.0 : 72.0);
    return SizedBox(
      height: h,
      child: LayoutBuilder(
        builder: (context, c) {
          return RepaintBoundary(
            child: CustomPaint(
              size: Size(c.maxWidth, h),
              painter: _VeDuong(
                diem,
                dich,
                truc,
                sang,
                mo,
                nhanNgay,
                soTrenDiem,
                khung,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _VeDuong extends CustomPainter {
  _VeDuong(
    this.diem,
    this.dich,
    this.truc,
    this.sang,
    this.mo,
    this.nhanNgay,
    this.soTrenDiem,
    this.khung,
  );

  final List<double> diem;
  final double? dich;
  final bool truc;
  final List<double> sang;
  final List<double> mo;
  final List<DateTime> nhanNgay;
  final bool soTrenDiem;
  final bool khung;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 32.0;
    const top = 18.0;
    final bot = nhanNgay.isNotEmpty ? 22.0 : 8.0;
    final plot = Rect.fromLTRB(left, top, size.width - 6, size.height - bot);

    if (khung) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(plot.inflate(4), const Radius.circular(8)),
        Paint()
          ..color = Mau.vien
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    final all = <double>[...diem, ...sang, ...mo];
    if (dich != null) all.add(dich!);
    var minV = 0.0;
    var maxV = 1.0;
    if (all.isNotEmpty) {
      minV = all.first;
      maxV = all.first;
      for (final v in all) {
        if (v < minV) minV = v;
        if (v > maxV) maxV = v;
      }
      if ((maxV - minV).abs() < 0.05) {
        minV -= 1;
        maxV += 1;
      }
    }

    final span = (maxV - minV).abs() < 0.05 ? 1.0 : (maxV - minV);
    double yOf(double v) => plot.bottom - ((v - minV) / span) * plot.height;
    double xOf(int i) {
      if (diem.length <= 1) return plot.left + plot.width / 2;
      return plot.left + plot.width * i / (diem.length - 1);
    }

    void chu(String s, Offset o, {double fs = 10}) {
      final tp = TextPainter(
        text: TextSpan(text: s, style: TextStyle(fontSize: fs, color: Mau.mo)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, o);
    }

    chu(So.kg(maxV), Offset(2, plot.top - 2));
    chu(So.kg(minV), Offset(2, plot.bottom - 10));

    final grid = Paint()
      ..color = Mau.vien
      ..strokeWidth = 1;
    canvas.drawLine(Offset(plot.left, plot.bottom), Offset(plot.right, plot.bottom), grid);
    canvas.drawLine(Offset(plot.left, plot.top), Offset(plot.left, plot.bottom), grid);

    void netNgang(double v, Color c, double w) {
      final y = yOf(v);
      canvas.drawLine(
        Offset(plot.left, y),
        Offset(plot.right, y),
        Paint()
          ..color = c
          ..strokeWidth = w,
      );
    }

    for (final v in mo) {
      netNgang(v, Mau.mo.withValues(alpha: 0.35), 1);
    }
    for (final v in sang) {
      netNgang(v, Mau.reu, 1.6);
    }

    if (diem.isEmpty) return;

    final paint = Paint()
      ..color = Mau.muc
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    if (diem.length > 1) {
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
    }

    final cham = Paint()
      ..color = Mau.reu
      ..style = PaintingStyle.fill;
    for (var i = 0; i < diem.length; i++) {
      final o = Offset(xOf(i), yOf(diem[i]));
      canvas.drawCircle(o, diem.length == 1 ? 5 : 3.2, cham);
      if (soTrenDiem) {
        final s = diem[i] == 0 ? '0' : So.kg(diem[i]);
        chu(s, Offset(o.dx - 8, o.dy - 16), fs: 9);
      }
    }

    if (nhanNgay.isNotEmpty && diem.isNotEmpty) {
      final n = nhanNgay.length < diem.length ? nhanNgay.length : diem.length;
      final step = n > 8 ? (n / 4).ceil() : 1;
      for (var i = 0; i < n; i += step) {
        final d = nhanNgay[i];
        chu('${d.day}/${d.month}', Offset(xOf(i) - 10, plot.bottom + 2), fs: 9);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _VeDuong old) =>
      old.diem != diem || old.soTrenDiem != soTrenDiem;
}
