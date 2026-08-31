import 'dart:math' as math;

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../cong_thuc.dart';
import '../db/database.dart';
import '../kho.dart';
import '../mau.dart';
import '../ngay.dart';
import '../widget/hang_habit.dart';
import '../widget/lua_tap.dart';
import 'to_mon.dart';

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

  void _moPhien(BuildContext context, Kho kho, DateTime ngay) {
    kho.chonNgay(ngay);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Mau.beMat,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
          child: _ToNgayTap(kho: kho, ngay: ngay),
        );
      },
    );
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
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final m in CongThuc.mon)
                      _Chip(
                        chu: Chuoi.tenMon(m.loai),
                        bat: _loai == m.loai,
                        onTap: kho.khoaGhi ? null : () => setState(() => _loai = m.loai),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _Buoc(
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
                    _Buoc(
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
                const SizedBox(height: 20),
                _LuoiLuaThang(
                  kho: kho,
                  thang: kho.selected,
                  onChon: (d) => _moPhien(context, kho, d),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ToNgayTap extends StatefulWidget {
  const _ToNgayTap({required this.kho, required this.ngay});

  final Kho kho;
  final DateTime ngay;

  @override
  State<_ToNgayTap> createState() => _ToNgayTapState();
}

class _ToNgayTapState extends State<_ToNgayTap> {
  String _loai = CongThuc.loaiDiBo;
  int _phut = 30;
  int? _suaId;

  bool get _xem => !Ngay.ghiDuoc(widget.ngay, widget.kho.homNay);

  int? _kcal(String loai, int phut) {
    if (widget.kho.thieuCan) return null;
    return CongThuc.kcalTap(
      met: CongThuc.metCua(loai),
      kg: widget.kho.canMoi?.kg,
      phut: phut,
    )?.round();
  }

  Future<void> _luu() async {
    if (_xem) return;
    final ok = _suaId == null
        ? await widget.kho.ghiTap(_loai, _phut, ngay: widget.ngay)
        : await widget.kho.suaTap(_suaId!, _loai, _phut, ngay: widget.ngay);
    if (!mounted || !ok) return;
    setState(() => _suaId = null);
  }

  Future<void> _suaLog(FoodLog log) async {
    if (_xem) return;
    final kq = await moDlgSuaLog(context, log);
    if (!mounted || kq == null) return;
    await Future<void>.delayed(Duration.zero);
    if (!mounted) return;
    await widget.kho.suaLog(
      log.id,
      kcal: kq.kcal,
      gram: Value(kq.gram),
      dam: Value(kq.dam),
      bot: Value(kq.bot),
      beo: Value(kq.beo),
      ngay: widget.ngay,
    );
  }

  @override
  Widget build(BuildContext context) {
    final kho = widget.kho;
    final ngay = widget.ngay;
    return ListenableBuilder(
      listenable: kho,
      builder: (context, _) {
        final ds = kho.tapNgay(ngay);
        final tong = kho.kcalTapCuaNgay(ngay);
        final logs = kho.logNgay(ngay);
        final nap = kho.kcalNapCuaNgay(ngay);
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.82,
            ),
            child: ListView(
              key: const Key('to-ngay-tap'),
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                Text(
                  Chuoi.dongNgay(ngay),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Mau.muc),
                ),
                if (_xem)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(Chuoi.chiXem, style: TextStyle(fontSize: 13, color: Mau.mo)),
                  ),
                if (!_xem) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final m in CongThuc.mon)
                        _Chip(
                          chu: Chuoi.tenMon(m.loai),
                          bat: _loai == m.loai,
                          onTap: () => setState(() => _loai = m.loai),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _Buoc(
                        chu: '−',
                        onTap: _phut <= 5 ? null : () => setState(() => _phut -= 5),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '$_phut ${Chuoi.phut}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Mau.muc),
                        ),
                      ),
                      _Buoc(
                        chu: '+',
                        onTap: _phut >= 180 ? null : () => setState(() => _phut += 5),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: FilledButton(
                            key: const Key('luu-to-ngay'),
                            onPressed: _luu,
                            child: const Text(Chuoi.luu),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                if (ds.isEmpty)
                  const Text('—', style: TextStyle(color: Mau.mo))
                else
                  for (final t in ds)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Material(
                        color: Mau.giay,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  Chuoi.dongPhien(Chuoi.tenMon(t.loai), t.phut, _kcal(t.loai, t.phut)),
                                  style: const TextStyle(fontSize: 15, color: Mau.muc),
                                ),
                              ),
                              if (!_xem) ...[
                                SizedBox(
                                  height: 44,
                                  child: TextButton(
                                    key: Key('sua-phien-${t.id}'),
                                    onPressed: () {
                                      setState(() {
                                        _suaId = t.id;
                                        _loai = t.loai;
                                        _phut = t.phut;
                                      });
                                    },
                                    child: const Text(Chuoi.sua),
                                  ),
                                ),
                                SizedBox(
                                  height: 44,
                                  child: TextButton(
                                    key: Key('xoa-phien-${t.id}'),
                                    onPressed: () => kho.xoaTap(t.id, ngay: ngay),
                                    child: const Text(Chuoi.xoa, style: TextStyle(color: Mau.canhBao)),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                const SizedBox(height: 20),
                const Text(
                  Chuoi.thucDon,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo),
                ),
                if (!_xem) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 44,
                    child: OutlinedButton(
                      key: const Key('nut-them-mon'),
                      onPressed: () => moChonThemMon(context, kho, ngay: ngay),
                      child: const Text(Chuoi.themMon),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                if (logs.isEmpty)
                  const Text('—', style: TextStyle(color: Mau.mo))
                else
                  for (final l in logs)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Material(
                        color: Mau.giay,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  Chuoi.dongMon(l.ten, l.kcal, g: l.gram),
                                  style: const TextStyle(fontSize: 15, color: Mau.muc),
                                ),
                              ),
                              if (!_xem) ...[
                                SizedBox(
                                  height: 44,
                                  child: TextButton(
                                    key: Key('sua-log-${l.id}'),
                                    onPressed: () => _suaLog(l),
                                    child: const Text(Chuoi.sua),
                                  ),
                                ),
                                SizedBox(
                                  height: 44,
                                  child: TextButton(
                                    key: Key('xoa-log-${l.id}'),
                                    onPressed: () => kho.xoaLog(l.id, ngay: ngay),
                                    child: const Text(Chuoi.xoa, style: TextStyle(color: Mau.canhBao)),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                const SizedBox(height: 12),
                Text(
                  key: const Key('tong-kcal-nap'),
                  Chuoi.tongKcalNap(nap),
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Mau.muc),
                ),
                const SizedBox(height: 4),
                Text(
                  key: const Key('tong-kcal-tieu'),
                  Chuoi.tongKcalTieuThu(tong),
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Mau.muc),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LuoiLuaThang extends StatelessWidget {
  const _LuoiLuaThang({required this.kho, required this.thang, required this.onChon});

  final Kho kho;
  final DateTime thang;
  final ValueChanged<DateTime> onChon;

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
                            onTap: () => onChon(o[r * 7 + c]!),
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
  const _OLua({required this.ngay, required this.co, required this.onTap});

  final DateTime ngay;
  final bool co;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: Key('lua-ngay-${Ngay.iso(ngay)}'),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_fire_department,
            size: 14,
            color: co ? Mau.canhBao : Mau.mo.withValues(alpha: 0.35),
          ),
          Text('${ngay.day}', style: const TextStyle(fontSize: 10, color: Mau.mo)),
        ],
      ),
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
