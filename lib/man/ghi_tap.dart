import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../cong_thuc.dart';
import '../kho.dart';
import '../mau.dart';
import '../ngay.dart';

class ManGhiTap extends StatefulWidget {
  const ManGhiTap({super.key, required this.kho});

  final Kho kho;

  @override
  State<ManGhiTap> createState() => _ManGhiTapState();
}

class _ManGhiTapState extends State<ManGhiTap> {
  String _loai = CongThuc.loaiDiBo;
  int _phut = 30;
  int _phin = 0;

  static const _ten = {
    CongThuc.loaiDiBo: Chuoi.diBo,
    CongThuc.loaiChay: Chuoi.chay,
    CongThuc.loaiDapXe: Chuoi.dapXe,
    CongThuc.loaiKhangLuc: Chuoi.khangLuc,
    CongThuc.loaiYoga: Chuoi.yoga,
    CongThuc.loaiBoi: Chuoi.boi,
    CongThuc.loaiDaBong: Chuoi.daBong,
    CongThuc.loaiCauLong: Chuoi.cauLong,
    CongThuc.loaiNhayDay: Chuoi.nhayDay,
    CongThuc.loaiGianCo: Chuoi.gianCo,
  };

  Future<void> _luu() async {
    if (widget.kho.khoaGhi) return;
    await widget.kho.ghiTap(_loai, _phut);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final kho = widget.kho;
    return ListenableBuilder(
      listenable: kho,
      builder: (context, _) {
        final kcal = CongThuc.kcalTap(
          met: CongThuc.metCua(_loai),
          kg: kho.canMoi?.kg,
          phut: _phut,
        );
        final lua = kho.luaTapHom;
        return Scaffold(
          backgroundColor: Mau.giay,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 44,
                      height: 44,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Mau.muc),
                      ),
                    ),
                    const Text(
                      Chuoi.hoatDongO,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Mau.muc,
                      ),
                    ),
                    const Spacer(),
                    _Lua(lua: lua),
                  ],
                ),
                Text(kho.dongNgay, style: const TextStyle(color: Mau.mo)),
                if (kho.khoaGhi)
                  const Text(Chuoi.chiXem, style: TextStyle(color: Mau.mo, fontSize: 13)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final m in CongThuc.mon)
                      _Chip(
                        chu: _ten[m.loai]!,
                        bat: _loai == m.loai,
                        onTap: kho.khoaGhi ? null : () => setState(() => _loai = m.loai),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Buoc(
                      chu: '−',
                      onTap: kho.khoaGhi || _phut <= 5
                          ? null
                          : () => setState(() => _phut -= 5),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '$_phut ${Chuoi.phut}',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Mau.muc),
                      ),
                    ),
                    _Buoc(
                      chu: '+',
                      onTap: kho.khoaGhi || _phut >= 180
                          ? null
                          : () => setState(() => _phut += 5),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  kcal == null
                      ? (kho.thieuCan ? Chuoi.thieuDuLieu : Chuoi.kcalTapSo(0))
                      : Chuoi.kcalTapSo(kcal.round()),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Mau.mo),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 44,
                  child: FilledButton(
                    onPressed: kho.khoaGhi ? null : _luu,
                    child: const Text(Chuoi.luu),
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  children: [
                    _Phin(chu: Chuoi.tuanNhan, bat: _phin == 0, onTap: () => setState(() => _phin = 0)),
                    _Phin(chu: Chuoi.thangNhan, bat: _phin == 1, onTap: () => setState(() => _phin = 1)),
                    _Phin(chu: Chuoi.namNhan, bat: _phin == 2, onTap: () => setState(() => _phin = 2)),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 88,
                  child: _CotTap(
                    cot: switch (_phin) {
                      1 => kho.cotTapThang(kho.selected),
                      2 => kho.cotTapNam(kho.selected.year),
                      _ => kho.cotTapTuan(kho.selected),
                    },
                    nhan: switch (_phin) {
                      1 => (d) => '${d.day}',
                      2 => (d) => '${d.month}',
                      _ => (d) => Chuoi.thuNgan[d.weekday - 1],
                    },
                  ),
                ),
                const SizedBox(height: 20),
                _LuoiLuaThang(kho: kho, thang: kho.selected),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Lua extends StatelessWidget {
  const _Lua({required this.lua});

  final LuaTap lua;

  @override
  Widget build(BuildContext context) {
    final mau = lua.sang ? Mau.reu : Mau.mo;
    return Row(
      key: const Key('lua-tap'),
      children: [
        Icon(Icons.local_fire_department, color: mau, size: 22),
        const SizedBox(width: 4),
        Text(
          '${lua.so}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: mau),
        ),
      ],
    );
  }
}

class _LuoiLuaThang extends StatelessWidget {
  const _LuoiLuaThang({required this.kho, required this.thang});

  final Kho kho;
  final DateTime thang;

  @override
  Widget build(BuildContext context) {
    final ngay = Ngay.cacNgayThang(thang);
    final offset = ngay.first.weekday - 1;
    final o = List<DateTime?>.filled(offset, null) + ngay;
    while (o.length % 7 != 0) {
      o.add(null);
    }
    return Column(
      children: [
        Row(
          children: [
            for (final t in Chuoi.thuNgan)
              Expanded(
                child: Text(t, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: Mau.mo)),
              ),
          ],
        ),
        const SizedBox(height: 4),
        for (var r = 0; r < o.length / 7; r++)
          Row(
            children: [
              for (var c = 0; c < 7; c++)
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: o[r * 7 + c] == null
                        ? const SizedBox.shrink()
                        : _OLua(
                            ngay: o[r * 7 + c]!,
                            co: kho.phutTapCuaNgay(o[r * 7 + c]!) > 0,
                          ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class _OLua extends StatelessWidget {
  const _OLua({required this.ngay, required this.co});

  final DateTime ngay;
  final bool co;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.local_fire_department, size: 14, color: co ? Mau.reu : Mau.mo.withValues(alpha: 0.35)),
        Text('${ngay.day}', style: const TextStyle(fontSize: 10, color: Mau.mo)),
      ],
    );
  }
}

class _CotTap extends StatelessWidget {
  const _CotTap({required this.cot, required this.nhan});

  final List<(DateTime ngay, int phut)> cot;
  final String Function(DateTime) nhan;

  @override
  Widget build(BuildContext context) {
    final maxV = cot.fold<int>(0, (a, b) => math.max(a, b.$2));
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final c in cot)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        heightFactor: maxV == 0 ? 0.06 : math.max(0.06, c.$2 / maxV),
                        widthFactor: 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Mau.reu.withValues(alpha: c.$2 == 0 ? 0.25 : 0.85),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(nhan(c.$1), style: const TextStyle(fontSize: 11, color: Mau.mo)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.chu, required this.bat, required this.onTap});

  final String chu;
  final bool bat;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bat ? Mau.chipBat : Mau.beMat,
      shape: StadiumBorder(side: BorderSide(color: bat ? Mau.reu : Mau.vien)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(chu, style: const TextStyle(fontSize: 15, color: Mau.muc)),
          ),
        ),
      ),
    );
  }
}

class _Buoc extends StatelessWidget {
  const _Buoc({required this.chu, required this.onTap});

  final String chu;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: Mau.muc,
          side: const BorderSide(color: Mau.vien),
          padding: EdgeInsets.zero,
        ),
        child: Text(chu, style: const TextStyle(fontSize: 22)),
      ),
    );
  }
}

class _Phin extends StatelessWidget {
  const _Phin({required this.chu, required this.bat, required this.onTap});

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
            child: Text(chu, style: const TextStyle(fontSize: 14, color: Mau.muc)),
          ),
        ),
      ),
    );
  }
}
