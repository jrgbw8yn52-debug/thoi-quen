import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../cong_thuc.dart';
import '../kho.dart';
import '../mau.dart';
import '../widget/hang_habit.dart';
import '../widget/lua_tap.dart';
import '../widget/picker_mon.dart';

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

  Future<void> _luu() async {
    if (widget.kho.khoaGhi) return;
    await widget.kho.ghiTap(_loai, _phut);
    if (mounted) setState(() {});
  }

  int _kcalNhap(Kho kho) {
    final k = CongThuc.kcalTap(
      met: CongThuc.metCua(_loai),
      kg: kho.canMoi?.kg,
      phut: _phut,
    );
    return k?.round() ?? 0;
  }

  int? _kcalPhien(Kho kho, {required String loai, required int phut}) {
    if (kho.thieuCan) return null;
    return CongThuc.kcalTap(
      met: CongThuc.metCua(loai),
      kg: kho.canMoi?.kg,
      phut: phut,
    )?.round();
  }

  @override
  Widget build(BuildContext context) {
    final kho = widget.kho;
    return ListenableBuilder(
      listenable: kho,
      builder: (context, _) {
        final lua = kho.luaTapHom;
        final daLuu = kho.tapNgay(kho.selected);
        final tongNgay = kho.kcalTapCuaNgay(kho.selected);
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
                    LuaTapHien(key: const Key('lua-tap'), lua: lua),
                  ],
                ),
                Text(kho.dongNgay, style: const TextStyle(color: Mau.mo)),
                if (kho.khoaGhi)
                  const Text(Chuoi.chiXem, style: TextStyle(color: Mau.mo, fontSize: 13)),
                const SizedBox(height: 16),
                HangPickerMon(
                  loai: _loai,
                  onChon: kho.khoaGhi ? null : (v) => setState(() => _loai = v),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    NutBuocPhut(
                      chu: '−',
                      onTap: kho.khoaGhi || _phut <= 5
                          ? null
                          : () => setState(() => _phut -= 5),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '$_phut ${Chuoi.phut}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Mau.muc),
                      ),
                    ),
                    NutBuocPhut(
                      chu: '+',
                      onTap: kho.khoaGhi || _phut >= 180
                          ? null
                          : () => setState(() => _phut += 5),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: FilledButton(
                          onPressed: kho.khoaGhi ? null : _luu,
                          child: const Text(Chuoi.luu),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  kho.thieuCan ? Chuoi.thieuDuLieu : Chuoi.kcalTapSo(_kcalNhap(kho)),
                  style: const TextStyle(fontSize: 14, color: Mau.mo),
                ),
                const SizedBox(height: 16),
                Text(
                  key: const Key('tong-hom-nay'),
                  Chuoi.tongHomNay(tongNgay),
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Mau.muc),
                ),
                const SizedBox(height: 8),
                for (final t in daLuu)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: HangVuot(
                      key: Key('phien-tap-${t.id}'),
                      choVuot: !kho.khoaGhi,
                      onXoa: () => kho.xoaTap(t.id),
                      child: Material(
                        color: Mau.beMat,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 44),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                Chuoi.dongPhien(
                                  Chuoi.tenMon(t.loai),
                                  t.phut,
                                  _kcalPhien(kho, loai: t.loai, phut: t.phut),
                                ),
                                style: const TextStyle(fontSize: 15, color: Mau.muc),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                const Text(
                  Chuoi.kcalTapNhan,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo),
                ),
                const SizedBox(height: 8),
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
                  height: 108,
                  child: _CotTap(
                    cot: switch (_phin) {
                      1 => kho.cotKcalThang(kho.selected),
                      2 => kho.cotKcalNam(kho.selected.year),
                      _ => kho.cotKcalTuan(kho.selected),
                    },
                    nhan: switch (_phin) {
                      1 => (d) => '${d.day}',
                      2 => (d) => '${d.month}',
                      _ => (d) => Chuoi.thuNgan[d.weekday - 1],
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CotTap extends StatelessWidget {
  const _CotTap({required this.cot, required this.nhan});

  final List<(DateTime ngay, int kcal)> cot;
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
                  Text(
                    '${c.$2}',
                    style: const TextStyle(fontSize: 10, color: Mau.mo),
                  ),
                  const SizedBox(height: 2),
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
