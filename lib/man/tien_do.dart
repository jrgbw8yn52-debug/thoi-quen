import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../chuoi.dart';
import '../kho.dart';
import '../mau.dart';
import '../ngay.dart';
import '../so.dart';
import '../widget/duong_can.dart';
import '../widget/lan_ngay.dart';
import 'ghi_can.dart';
import 'ghi_tap.dart';

class ManTienDo extends StatefulWidget {
  const ManTienDo({super.key, required this.kho});

  final Kho kho;

  @override
  State<ManTienDo> createState() => _ManTienDoState();
}

class _ManTienDoState extends State<ManTienDo> {
  int _phin = 0;
  late DateTime _tu;
  bool _veHom = true;

  Kho get kho => widget.kho;

  DateTime get _den => Ngay.cuoiKy(_tu, _phin);

  @override
  void initState() {
    super.initState();
    _tu = Ngay.dauKyHomNay(kho.homNay, _phin);
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

  void _doiPhin(int p) {
    setState(() {
      _phin = p;
      _tu = _veHom
          ? Ngay.dauKyHomNay(kho.homNay, p)
          : Ngay.snapTu(_tu, p);
    });
  }

  DateTime _luiTu(DateTime tu, int phin) {
    switch (phin) {
      case 0:
        return tu.subtract(const Duration(days: 1));
      case 1:
        return tu.subtract(const Duration(days: 7));
      case 2:
        return Ngay.congThang(tu, -1);
      case 3:
        return Ngay.congThang(tu, -6);
      default:
        return Ngay.congThang(tu, -12);
    }
  }

  DateTime _toiTu(DateTime tu, int phin) {
    switch (phin) {
      case 0:
        return tu.add(const Duration(days: 1));
      case 1:
        return tu.add(const Duration(days: 7));
      case 2:
        return Ngay.congThang(tu, 1);
      case 3:
        return Ngay.congThang(tu, 6);
      default:
        return Ngay.congThang(tu, 12);
    }
  }

  void _luiKy() {
    setState(() {
      _veHom = false;
      _tu = Ngay.snapTu(_luiTu(_tu, _phin), _phin);
    });
  }

  void _toiKy() {
    final n = Ngay.snapTu(_toiTu(_tu, _phin), _phin);
    if (n.isAfter(kho.homNay)) return;
    setState(() {
      _veHom = false;
      _tu = n;
    });
  }

  Future<void> _chonTu() async {
    final d = await moChonNgay(context: context, goc: _tu);
    if (d == null) return;
    setState(() {
      _veHom = false;
      _tu = Ngay.snapTu(d, _phin);
    });
  }

  void _homNayKy() {
    setState(() {
      _veHom = true;
      _tu = Ngay.dauKyHomNay(kho.homNay, _phin);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ky = kho.bangKy(_phin, _tu);
    final cot = kho.cotHabitKy(_phin, _tu);
    final can = kho.diemCanKy(_phin, _tu);
    final bmi = kho.diemBmiKy(_phin, _tu);
    final nap = kho.diemKcalKy(_phin, _tu, kho.kcalNapCuaNgay);
    final tieu = kho.diemKcalKy(_phin, _tu, kho.kcalTapCuaNgay);
    final goi = kho.kcalGoiYDoc;
    final napHom = kho.kcalNapCuaNgay(kho.homNay);
    final tieuHom = kho.kcalTapCuaNgay(kho.homNay);
    final damNap = kho.macroNgay(kho.homNay).dam.round();
    final damGoi = kho.hanMacroDoc?.dam.round();
    final canHom = kho.canMoi;
    final conKg = kho.canMoi == null || kho.targetKg == null
        ? null
        : So.kg((kho.canMoi!.kg - kho.targetKg!).abs());
    final deltaChu = ky.deltaCan == null
        ? null
        : (ky.deltaCan! > 0.05
            ? '+${So.kg(ky.deltaCan!)}'
            : So.kg(ky.deltaCan!));
    return Scaffold(
      backgroundColor: Mau.giay,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 12, 0),
              child: Row(
                children: [
                  IconButton(
                    key: const Key('thong-ke-lui'),
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Expanded(
                    child: Text(
                      Chuoi.thongKe,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Mau.muc,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _Phin(
                    key: const Key('phin-habit-0'),
                    chu: Chuoi.phinNgay,
                    bat: _phin == 0,
                    onTap: () => _doiPhin(0),
                  ),
                  _Phin(
                    key: const Key('phin-habit-1'),
                    chu: Chuoi.tuanNhan,
                    bat: _phin == 1,
                    onTap: () => _doiPhin(1),
                  ),
                  _Phin(
                    key: const Key('phin-habit-2'),
                    chu: Chuoi.thangNhan,
                    bat: _phin == 2,
                    onTap: () => _doiPhin(2),
                  ),
                  _Phin(
                    key: const Key('phin-habit-3'),
                    chu: Chuoi.sauThang,
                    bat: _phin == 3,
                    onTap: () => _doiPhin(3),
                  ),
                  _Phin(
                    key: const Key('phin-habit-4'),
                    chu: Chuoi.namNhan,
                    bat: _phin == 4,
                    onTap: () => _doiPhin(4),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: Row(
                children: [
                  IconButton(
                    key: const Key('phin-lui'),
                    onPressed: _luiKy,
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Expanded(
                    child: InkWell(
                      key: const Key('tu-ngay'),
                      onTap: _chonTu,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 44),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _phin == 0
                                  ? Chuoi.khoangNgay(_tu, _den)
                                  : '${Chuoi.tuNgay} ${_tu.day}/${_tu.month}/${_tu.year}',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Mau.muc,
                              ),
                            ),
                            if (_phin != 0)
                              Text(
                                Chuoi.denNgay(_den),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Mau.mo,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    key: const Key('phin-toi'),
                    onPressed: _toiKy,
                    icon: const Icon(Icons.chevron_right),
                  ),
                  TextButton(
                    key: const Key('nut-hom-nay-ky'),
                    onPressed: _homNayKy,
                    child: const Text(Chuoi.homNay),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                children: [
                  _HangHomNay(
                    n: kho.nTickHom,
                    m: kho.mHom,
                    nap: napHom,
                    goi: goi,
                    tieu: tieuHom,
                    can: canHom == null ? null : So.kg(canHom.kg),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _The(chu: Chuoi.conXKg(conKg)),
                      _The(
                        chu: Chuoi.goiYKcalPct(goi, kho.phanTramTdeeDoc),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      Chuoi.damGoiNap(damGoi, damNap),
                      style: const TextStyle(fontSize: 14, color: Mau.muc),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      Chuoi.uocTinh,
                      style: TextStyle(fontSize: 12, color: Mau.mo, height: 1.35),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _The(
                        key: const Key('the-ky-habit'),
                        chu: Chuoi.theKyPct(ky.phanTram),
                      ),
                      _The(
                        key: const Key('the-ky-nap'),
                        chu: Chuoi.theTbNap(ky.tbNap),
                      ),
                      _The(
                        key: const Key('the-ky-dot'),
                        chu: Chuoi.theTbDot(ky.tbDot),
                      ),
                      _The(
                        key: const Key('the-ky-can'),
                        chu: Chuoi.theDeltaCan(deltaChu),
                      ),
                    ],
                  ),
                  if (ky.thieuCanKy || ky.thieuTap3) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: [
                        if (ky.thieuCanKy)
                          TextButton(
                            key: const Key('nut-ghi-can-ky'),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => ManGhiCan(kho: kho),
                                ),
                              );
                            },
                            child: const Text(Chuoi.ghiCanNut),
                          ),
                        if (ky.thieuTap3)
                          TextButton(
                            key: const Key('nut-hoat-dong-ky'),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => ManGhiTap(kho: kho),
                                ),
                              );
                            },
                            child: const Text(Chuoi.hoatDongO),
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 20),
                  _TieuChart(
                    ten: Chuoi.thoiQuen,
                    so: Chuoi.nTrenM(ky.nTick, ky.mHabit),
                    tu: ky.tu,
                    den: ky.den,
                  ),
                  Text(
                    Chuoi.hoanThanhDanhGia(
                      ky.nTick,
                      ky.mHabit,
                      Chuoi.danhGia(ky.nTick, ky.mHabit),
                    ),
                    style: const TextStyle(fontSize: 13, color: Mau.muc),
                  ),
                  const SizedBox(height: 8),
                  _BieuHabit(
                    phin: _phin,
                    cot: cot,
                    onTap: (d) {
                      HapticFeedback.selectionClick();
                      final x = d.isAfter(kho.homNay) ? kho.homNay : d;
                      kho.chonNgay(x);
                    },
                  ),
                  const SizedBox(height: 24),
                  _TieuChart(
                    ten: Chuoi.canNang,
                    so: can.isEmpty ? '—' : So.kg(can.last.$2),
                    tu: ky.tu,
                    den: ky.den,
                  ),
                  const SizedBox(height: 8),
                  DuongCan(
                    key: const Key('duong-can'),
                    diem: [for (final c in can) c.$2],
                    nhanNgay: [for (final c in can) c.$1],
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
                  const SizedBox(height: 24),
                  _TieuChart(
                    ten: Chuoi.bmi,
                    so: bmi.isEmpty ? '—' : So.kg(bmi.last.$2),
                    tu: ky.tu,
                    den: ky.den,
                  ),
                  const SizedBox(height: 8),
                  DuongCan(
                    key: const Key('duong-bmi'),
                    diem: [for (final b in bmi) b.$2],
                    nhanNgay: [for (final b in bmi) b.$1],
                    soTrenDiem: true,
                    truc: true,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    Chuoi.nangLuong,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Mau.mo,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _TieuChart(
                    ten: Chuoi.kcalNap,
                    so: '${nap.fold<int>(0, (s, x) => s + x.$2)}',
                    tu: ky.tu,
                    den: ky.den,
                  ),
                  const SizedBox(height: 8),
                  DuongCan(
                    key: const Key('duong-nap'),
                    diem: [for (final d in nap) d.$2.toDouble()],
                    nhanNgay: [for (final d in nap) d.$1],
                    sang: goi == null ? const [] : [goi.toDouble()],
                    soTrenDiem: true,
                    truc: true,
                  ),
                  const SizedBox(height: 16),
                  _TieuChart(
                    ten: Chuoi.kcalTieuThu,
                    so: '${tieu.fold<int>(0, (s, x) => s + x.$2)}',
                    tu: ky.tu,
                    den: ky.den,
                  ),
                  const SizedBox(height: 8),
                  DuongCan(
                    key: const Key('duong-tieu-thu'),
                    diem: [for (final d in tieu) d.$2.toDouble()],
                    nhanNgay: [for (final d in tieu) d.$1],
                    soTrenDiem: true,
                    truc: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HangHomNay extends StatelessWidget {
  const _HangHomNay({
    required this.n,
    required this.m,
    required this.nap,
    required this.goi,
    required this.tieu,
    required this.can,
  });

  final int n;
  final int m;
  final int nap;
  final int? goi;
  final int tieu;
  final String? can;

  @override
  Widget build(BuildContext context) {
    final napChu = goi == null ? '$nap kcal' : '$nap / $goi kcal';
    return Container(
      key: const Key('hang-hom-nay-tk'),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Mau.beMat,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Mau.vien),
      ),
      child: Text(
        '${Chuoi.nTrenM(n, m)} · $napChu · $tieu kcal · ${can ?? '—'} kg',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Mau.muc,
        ),
      ),
    );
  }
}

class _The extends StatelessWidget {
  const _The({super.key, required this.chu});

  final String chu;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Mau.beMat,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Mau.vien),
      ),
      child: Text(
        chu,
        style: const TextStyle(fontSize: 14, color: Mau.muc),
      ),
    );
  }
}

class _BieuHabit extends StatelessWidget {
  const _BieuHabit({
    required this.phin,
    required this.cot,
    required this.onTap,
  });

  final int phin;
  final List<CotThang> cot;
  final ValueChanged<DateTime> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('duong-thong-ke'),
      height: phin <= 1 ? 88 : 72,
      padding: const EdgeInsets.fromLTRB(6, 8, 6, 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Mau.vien),
      ),
      child: cot.isEmpty
          ? const Center(
              child: Text('—', style: TextStyle(color: Mau.mo)),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final c in cot)
                  Expanded(
                    child: phin <= 1
                        ? _CotTuan(
                            cot: ChamTuan(
                              ngay: c.ngay,
                              tick: c.tick,
                              tong: c.tong,
                              laHomNay: false,
                              tuongLai: c.tuongLai,
                              dangXem: c.dangXem,
                            ),
                            onTap: () => onTap(c.ngay),
                          )
                        : _CotThangNho(
                            cot: c,
                            soCot: phin >= 3,
                            onTap: () => onTap(
                              phin == 2
                                  ? c.ngay
                                  : DateTime(
                                      c.ngay.year,
                                      c.ngay.month,
                                      Ngay.soNgayThang(
                                        c.ngay.year,
                                        c.ngay.month,
                                      ),
                                    ),
                            ),
                          ),
                  ),
              ],
            ),
    );
  }
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
                      color: cot.dangXem
                          ? Mau.reu
                          : Mau.reu.withValues(alpha: 0.45),
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
                color: cot.tuongLai
                    ? Mau.vien
                    : (cot.laHomNay ? Mau.today : Mau.mo),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CotThangNho extends StatelessWidget {
  const _CotThangNho({
    required this.cot,
    required this.onTap,
    this.soCot = false,
  });

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
                      color: cot.dangXem
                          ? Mau.reu
                          : Mau.reu.withValues(alpha: 0.4),
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

class _TieuChart extends StatelessWidget {
  const _TieuChart({
    required this.ten,
    required this.so,
    required this.tu,
    required this.den,
  });

  final String ten;
  final String so;
  final DateTime tu;
  final DateTime den;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ten,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Mau.mo,
          ),
        ),
        Text(
          '$so · ${Chuoi.khoangNgay(tu, den)}',
          style: const TextStyle(fontSize: 13, color: Mau.muc),
        ),
      ],
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
        children: [
          Text(nhan, style: const TextStyle(fontSize: 12, color: Mau.mo)),
          Text(
            gia,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Mau.muc,
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
