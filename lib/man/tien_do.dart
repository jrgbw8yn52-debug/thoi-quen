import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../chuoi.dart';
import '../kho.dart';
import '../mau.dart';
import '../widget/duong_can.dart';

class ManTienDo extends StatelessWidget {
  const ManTienDo({super.key, required this.kho});

  final Kho kho;

  @override
  Widget build(BuildContext context) {
    final spark = kho.dsCan.reversed.map((c) => c.kg).toList();
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          const Text(
            Chuoi.tienDo,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.4,
              color: Mau.muc,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            kho.dongNgay,
            style: const TextStyle(fontSize: 15, color: Mau.mo),
          ),
          if (kho.khoaGhi)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                Chuoi.chiXem,
                style: TextStyle(fontSize: 13, color: Mau.mo),
              ),
            ),
          const SizedBox(height: 24),
          Center(
            child: SizedBox(
              width: 148,
              height: 148,
              child: CustomPaint(
                painter: _Vong(phan: kho.mHabit == 0 ? 0 : kho.nTick / kho.mHabit),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Chuoi.phanTram(kho.phanTramNgay),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: Mau.muc,
                          letterSpacing: -0.6,
                        ),
                      ),
                      Text(
                        Chuoi.nTrenM(kho.nTick, kho.mHabit),
                        style: const TextStyle(fontSize: 15, color: Mau.mo),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            Chuoi.tuanNhan,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Mau.mo,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 72,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final c in kho.tuan)
                  Expanded(
                    child: _CotTuan(
                      cot: c,
                      onTap: c.tuongLai
                          ? null
                          : () {
                              HapticFeedback.selectionClick();
                              kho.chonNgay(c.ngay);
                            },
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '${Chuoi.thang(kho.selected.month)} ${kho.selected.year}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Mau.mo,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 56,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final c in kho.cotThang)
                  Expanded(
                    child: _CotThangNho(
                      cot: c,
                      onTap: c.tuongLai
                          ? null
                          : () {
                              HapticFeedback.selectionClick();
                              kho.chonNgay(c.ngay);
                            },
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            Chuoi.canKg,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Mau.mo,
            ),
          ),
          const SizedBox(height: 8),
          if (spark.isNotEmpty) DuongCan(diem: spark, dich: kho.targetKg),
          if (kho.daDoiDoc != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                kho.daDoiDoc!,
                style: const TextStyle(fontSize: 14, color: Mau.mo),
              ),
            ),
          if (kho.dongCanHienTai != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                kho.dongCanHienTai!,
                style: const TextStyle(fontSize: 14, color: Mau.mo, height: 1.35),
              ),
            ),
          const SizedBox(height: 8),
          Text(
            kho.chuKcalTap,
            style: const TextStyle(fontSize: 15, color: Mau.muc),
          ),
        ],
      ),
    );
  }
}

class _Vong extends CustomPainter {
  _Vong({required this.phan});

  final double phan;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 8;
    final nen = Paint()
      ..color = Mau.vien
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    final tot = Paint()
      ..color = Mau.reu
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8;
    canvas.drawCircle(c, r, nen);
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r),
      -math.pi / 2,
      2 * math.pi * phan.clamp(0.0, 1.0),
      false,
      tot,
    );
  }

  @override
  bool shouldRepaint(covariant _Vong old) => old.phan != phan;
}

class _CotTuan extends StatelessWidget {
  const _CotTuan({required this.cot, required this.onTap});

  final ChamTuan cot;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: math.max(0.06, cot.phan),
                  widthFactor: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: cot.dangXem ? Mau.reu : Mau.reu.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              Chuoi.thuNgan[cot.ngay.weekday - 1],
              style: TextStyle(
                fontSize: 11,
                fontWeight: cot.dangXem ? FontWeight.w700 : FontWeight.w500,
                color: cot.tuongLai ? Mau.vien : (cot.laHomNay ? Mau.muc : Mau.mo),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CotThangNho extends StatelessWidget {
  const _CotThangNho({required this.cot, required this.onTap});

  final CotThang cot;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.5),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: math.max(0.08, cot.phan),
            widthFactor: 1,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: cot.dangXem ? Mau.reu : Mau.reu.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
