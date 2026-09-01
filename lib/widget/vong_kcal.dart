import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../cong_thuc.dart';
import '../mau.dart';
import '../so.dart';

/// Vòng kcal còn lại + 3 thanh macro. Style nhật ký.
class VongKcalNgay extends StatelessWidget {
  const VongKcalNgay({
    super.key,
    required this.nap,
    required this.goi,
    required this.dam,
    required this.bot,
    required this.beo,
    this.tieu = 0,
  });

  final int nap;
  final int? goi;
  final double dam;
  final double bot;
  final double beo;
  final int tieu;

  @override
  Widget build(BuildContext context) {
    final han = goi == null ? null : CongThuc.hanMacro(goi!);
    final con = goi == null ? null : goi! - nap;
    final vuot = con != null && con < 0;
    final mauSo = vuot ? Mau.canhBao : Mau.reu;
    return Container(
      key: const Key('vong-kcal'),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      decoration: BoxDecoration(
        color: Mau.beMat,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Mau.vien),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 188,
            height: 188,
            child: CustomPaint(
              painter: _VongPainter(
                nap: nap,
                goi: goi,
                vuot: vuot,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      con == null ? '$nap' : '$con',
                      key: const Key('kcal-con'),
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        height: 1,
                        color: con == null ? Mau.muc : mauSo,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      con == null
                          ? Chuoi.kcal
                          : (vuot ? Chuoi.kcalVuot : Chuoi.kcalConLai),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: vuot ? Mau.canhBao : Mau.mo,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _So3(nhan: Chuoi.nap, gia: '$nap', key: const Key('so-nap')),
              _So3(nhan: Chuoi.goiY, gia: goi == null ? '—' : '$goi', key: const Key('so-goi')),
              _So3(nhan: Chuoi.tieuThu, gia: '$tieu', key: const Key('so-tieu')),
            ],
          ),
          const SizedBox(height: 20),
          ThanhMacro(
            key: const Key('thanh-dam'),
            nhan: Chuoi.dam,
            nap: dam,
            han: han?.dam,
            mau: Mau.reu,
          ),
          const SizedBox(height: 12),
          ThanhMacro(
            key: const Key('thanh-bot'),
            nhan: Chuoi.bot,
            nap: bot,
            han: han?.bot,
            mau: Mau.lua,
          ),
          const SizedBox(height: 12),
          ThanhMacro(
            key: const Key('thanh-beo'),
            nhan: Chuoi.beo,
            nap: beo,
            han: han?.beo,
            mau: const Color(0xFFE89B2D),
          ),
        ],
      ),
    );
  }
}

class ThanhMacro extends StatelessWidget {
  const ThanhMacro({
    super.key,
    required this.nhan,
    required this.nap,
    required this.han,
    required this.mau,
  });

  final String nhan;
  final double nap;
  final double? han;
  final Color mau;

  @override
  Widget build(BuildContext context) {
    final vuot = han != null && han! > 0 && nap > han! + 0.05;
    final phan = han == null || han! <= 0 ? 0.0 : (nap / han!).clamp(0.0, 1.0);
    final mauThanh = vuot ? Mau.canhBao : mau;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              nhan,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Mau.muc,
              ),
            ),
            const Spacer(),
            Text(
              han == null
                  ? '${So.kg(nap)} g'
                  : '${So.kg(nap)} / ${So.kg(han!)} g',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: vuot ? Mau.canhBao : Mau.mo,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 10,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const ColoredBox(color: Color(0xFF2A2A2A)),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: phan,
                  child: ColoredBox(color: mauThanh),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _So3 extends StatelessWidget {
  const _So3({super.key, required this.nhan, required this.gia});

  final String nhan;
  final String gia;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(nhan, style: const TextStyle(fontSize: 12, color: Mau.mo)),
          const SizedBox(height: 4),
          Text(
            gia,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Mau.muc,
            ),
          ),
        ],
      ),
    );
  }
}

class _VongPainter extends CustomPainter {
  const _VongPainter({
    required this.nap,
    required this.goi,
    required this.vuot,
  });

  final int nap;
  final int? goi;
  final bool vuot;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 8;
    const stroke = 14.0;
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = const Color(0xFF2A2A2A)
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(c, r, track);

    final phan = goi == null || goi! <= 0 ? 0.0 : (nap / goi!).clamp(0.0, 1.0);
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = vuot ? Mau.canhBao : Mau.reu;
    if (vuot) {
      canvas.drawCircle(c, r, arc);
      return;
    }
    if (phan <= 0) return;
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r),
      -math.pi / 2,
      2 * math.pi * phan,
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(covariant _VongPainter old) =>
      old.nap != nap || old.goi != goi || old.vuot != vuot;
}
