import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../chuoi.dart';
import '../kho.dart';
import '../mau.dart';
import '../ngay.dart';
import '../widget/duong_can.dart';

class ManTienDo extends StatefulWidget {
  const ManTienDo({super.key, required this.kho});

  final Kho kho;

  @override
  State<ManTienDo> createState() => _ManTienDoState();
}

class _ManTienDoState extends State<ManTienDo> {
  int _phinKcal = 0;

  Kho get kho => widget.kho;

  @override
  void initState() {
    super.initState();
    kho.tienDoBan.addListener(_ve);
  }

  void _ve() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    kho.tienDoBan.removeListener(_ve);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canDiem = <(DateTime, double)>[
      for (final c in kho.dsCan.reversed)
        if (!Ngay.sau(Ngay.parse(c.ngay), kho.homNay)) (Ngay.parse(c.ngay), c.kg),
    ];
    final bmi = kho.bmiTheoCan;
    final tieu = kho.diemKcalPhin(_phinKcal, kho.kcalTapCuaNgay);
    final nap = kho.diemKcalPhin(_phinKcal, kho.kcalNapCuaNgay);
    final goi = kho.kcalGoiYDoc;
    final goiPhin = goi == null
        ? null
        : switch (_phinKcal) {
            2 => goi * 7,
            3 => goi * 30,
            _ => goi,
          };
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
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              _Phin(
                key: const Key('phin-habit-0'),
                chu: Chuoi.phinNgay,
                bat: kho.phin == 0,
                onTap: () => kho.chonPhin(0),
              ),
              _Phin(
                key: const Key('phin-habit-1'),
                chu: Chuoi.tuanNhan,
                bat: kho.phin == 1,
                onTap: () => kho.chonPhin(1),
              ),
              _Phin(
                key: const Key('phin-habit-2'),
                chu: Chuoi.thangNhan,
                bat: kho.phin == 2,
                onTap: () => kho.chonPhin(2),
              ),
              _Phin(
                key: const Key('phin-habit-3'),
                chu: Chuoi.namNhan,
                bat: kho.phin == 3,
                onTap: () => kho.chonPhin(3),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            Chuoi.tieuVong(kho.phin),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Mau.muc),
          ),
          const SizedBox(height: 12),
          Center(
            child: SizedBox(
              width: 148,
              height: 148,
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _Vong(phan: kho.nTrenMKy.$2 == 0 ? 0 : kho.nTrenMKy.$1 / kho.nTrenMKy.$2),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          Chuoi.phanTram(kho.phanTramKy),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: Mau.muc,
                            letterSpacing: -0.6,
                          ),
                        ),
                        Text(
                          Chuoi.daTick(kho.nTrenMKy.$1, kho.nTrenMKy.$2),
                          style: const TextStyle(fontSize: 13, color: Mau.mo),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (kho.phin == 1) ...[
            const SizedBox(height: 28),
            const Text(Chuoi.hoanThanhTheoThu, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo)),
            const SizedBox(height: 8),
            Container(
              height: 88,
              padding: const EdgeInsets.fromLTRB(6, 8, 6, 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Mau.vien),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final c in kho.tuan)
                    Expanded(
                      child: _CotTuan(
                        cot: c,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          kho.chonNgay(c.ngay);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
          if (kho.phin == 2) ...[
            const SizedBox(height: 28),
            const Text(Chuoi.hoanThanhTheoNgay, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo)),
            const SizedBox(height: 8),
            Container(
              height: 72,
              padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Mau.vien),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final c in kho.cotThang)
                    Expanded(
                      child: _CotThangNho(
                        cot: c,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          kho.chonNgay(c.ngay);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
          if (kho.phin == 3) ...[
            const SizedBox(height: 28),
            const Text(Chuoi.hoanThanhTheoThang, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo)),
            const SizedBox(height: 8),
            Container(
              height: 88,
              padding: const EdgeInsets.fromLTRB(6, 8, 6, 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Mau.vien),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final c in kho.cotNam)
                    Expanded(
                      child: _CotThangNho(
                        cot: c,
                        soCot: true,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          final last = DateTime(c.ngay.year, c.ngay.month, Ngay.soNgayThang(c.ngay.year, c.ngay.month));
                          kho.chonNgay(last.isAfter(kho.homNay) ? kho.homNay : last);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 28),
          const Text(
            Chuoi.canNang,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo),
          ),
          const SizedBox(height: 8),
          DuongCan(
            key: const Key('duong-can'),
            diem: [for (final c in canDiem) c.$2],
            nhanNgay: [for (final c in canDiem) c.$1],
            sang: kho.netSang,
            mo: kho.netMo,
            soTrenDiem: true,
            truc: true,
          ),
          if (kho.banDauKg != null || kho.hienTaiKg != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  _SoCan(nhan: Chuoi.banDau, gia: kho.banDauKg ?? '—'),
                  _SoCan(nhan: Chuoi.hienTai, gia: kho.hienTaiKg ?? '—'),
                  _SoCan(nhan: Chuoi.doi, gia: kho.doiKg ?? '—'),
                ],
              ),
            ),
          const SizedBox(height: 28),
          const Text(
            Chuoi.bmiTheoThoiGian,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo),
          ),
          const SizedBox(height: 8),
          DuongCan(
            key: const Key('duong-bmi'),
            diem: [for (final b in bmi) b.$2],
            nhanNgay: [for (final b in bmi) b.$1],
            soTrenDiem: true,
            truc: true,
          ),
          const SizedBox(height: 28),
          const Text(
            Chuoi.nangLuong,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _Phin(
                key: const Key('phin-kcal-0'),
                chu: Chuoi.tuanNhan,
                bat: _phinKcal == 0,
                onTap: () => setState(() => _phinKcal = 0),
              ),
              _Phin(
                key: const Key('phin-kcal-1'),
                chu: Chuoi.thangNhan,
                bat: _phinKcal == 1,
                onTap: () => setState(() => _phinKcal = 1),
              ),
              _Phin(
                key: const Key('phin-kcal-2'),
                chu: Chuoi.sauThang,
                bat: _phinKcal == 2,
                onTap: () => setState(() => _phinKcal = 2),
              ),
              _Phin(
                key: const Key('phin-kcal-3'),
                chu: Chuoi.muoiHaiThang,
                bat: _phinKcal == 3,
                onTap: () => setState(() => _phinKcal = 3),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            Chuoi.kcalNap,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo),
          ),
          const SizedBox(height: 8),
          DuongCan(
            key: const Key('duong-nap'),
            diem: [for (final d in nap) d.$2.toDouble()],
            nhanNgay: [for (final d in nap) d.$1],
            sang: goiPhin == null ? const [] : [goiPhin.toDouble()],
            soTrenDiem: true,
            truc: true,
          ),
          if (!kho.coNap)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(Chuoi.chuaGhiNap, style: TextStyle(fontSize: 14, color: Mau.mo)),
            ),
          const SizedBox(height: 16),
          const Text(
            Chuoi.kcalTieuThu,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo),
          ),
          const SizedBox(height: 8),
          _CotKcalHang(diem: tieu),
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
            Text(
              '${cot.tick}',
              style: const TextStyle(fontSize: 9, color: Mau.mo),
            ),
            const SizedBox(height: 2),
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
                color: cot.tuongLai ? Mau.vien : (cot.laHomNay ? Mau.today : Mau.mo),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CotThangNho extends StatelessWidget {
  const _CotThangNho({required this.cot, required this.onTap, this.soCot = false});

  final CotThang cot;
  final VoidCallback? onTap;
  final bool soCot;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.5),
        child: Column(
          children: [
            if (soCot)
              Text(
                '${cot.tick}',
                style: const TextStyle(fontSize: 8, color: Mau.mo),
              ),
            Expanded(
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
          ],
        ),
      ),
    );
  }
}

class _CotKcalHang extends StatelessWidget {
  const _CotKcalHang({required this.diem});

  final List<(DateTime, int)> diem;

  @override
  Widget build(BuildContext context) {
    final max = diem.fold<int>(1, (a, b) => b.$2 > a ? b.$2 : a);
    return Container(
      key: const Key('duong-tieu-thu'),
      height: 132,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Mau.vien),
      ),
      child: diem.isEmpty
          ? const SizedBox.expand()
          : Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final d in diem)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: Column(
                        children: [
                          Text(
                            '${d.$2}',
                            style: const TextStyle(fontSize: 9, color: Mau.mo),
                          ),
                          const SizedBox(height: 2),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: FractionallySizedBox(
                                heightFactor: math.max(0.06, d.$2 / max),
                                widthFactor: 1,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Mau.reu.withValues(alpha: d.$2 == 0 ? 0.25 : 0.9),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${d.$1.day}/${d.$1.month}',
                            style: const TextStyle(fontSize: 9, color: Mau.mo),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _Phin extends StatelessWidget {
  const _Phin({
    super.key,
    required this.chu,
    required this.bat,
    required this.onTap,
  });

  final String chu;
  final bool bat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bat ? Mau.chipBat : Mau.beMat,
      shape: StadiumBorder(side: BorderSide(color: bat ? Mau.reu : Mau.vien)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 36),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              chu,
              style: const TextStyle(fontSize: 14, color: Mau.muc),
            ),
          ),
        ),
      ),
    );
  }
}

class _SoCan extends StatelessWidget {
  const _SoCan({required this.nhan, required this.gia});

  final String nhan;
  final String gia;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(nhan, style: const TextStyle(fontSize: 12, color: Mau.mo)),
          Text(
            gia,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Mau.muc),
          ),
        ],
      ),
    );
  }
}
