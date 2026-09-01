import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../cong_thuc.dart';
import '../db/database.dart';
import '../khung.dart';
import '../kho.dart';
import '../mau.dart';
import '../widget/hang_habit.dart';
import '../widget/khoi_gap.dart';
import '../widget/vong_kcal.dart';
import '../widget/xem_them.dart';
import 'to_mon.dart';

class ManGhiNap extends StatefulWidget {
  const ManGhiNap({super.key, required this.kho});

  final Kho kho;

  @override
  State<ManGhiNap> createState() => _ManGhiNapState();
}

class _ManGhiNapState extends State<ManGhiNap> {
  Kho get kho => widget.kho;
  late String _khung;
  String? _moKhung;

  @override
  void initState() {
    super.initState();
    _khung = Khung.theoGio(DateTime.now());
  }

  Future<void> _suaLog(FoodLog log) async {
    if (kho.khoaGhi) return;
    final kq = await moDlgSuaLog(context, log);
    if (!mounted || kq == null) return;
    await Future<void>.delayed(Duration.zero);
    if (!mounted) return;
    await kho.suaLogGram(log.id, kq.gram);
  }

  Future<void> _themTao() async {
    await moToTaoCongThuc(context, kho, khung: _khung);
    if (!mounted) return;
    setState(() => _moKhung = _khung);
  }

  Future<void> _themKho() async {
    await moToMonDaLuu(context, kho, khung: _khung);
    if (!mounted) return;
    setState(() => _moKhung = _khung);
  }

  Widget _hangLog(FoodLog l) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: HangVuot(
        key: Key('log-${l.id}'),
        choVuot: !kho.khoaGhi,
        onSua: kho.khoaGhi ? null : () => _suaLog(l),
        onXoa: () => kho.xoaLog(l.id),
        child: Material(
          color: Mau.beMat,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  Chuoi.dongMon(l.ten, l.kcal),
                  style: const TextStyle(fontSize: 15, color: Mau.muc),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: kho,
      builder: (context, _) {
        final goi = kho.kcalGoiYDoc;
        final tdee = kho.tdeeDoc;
        final nap = kho.kcalNapCuaNgay(kho.selected);
        final tieu = kho.kcalTapCuaNgay(kho.selected);
        final logs = kho.logNgay(kho.selected);
        final mac = kho.macroNgay(kho.selected);
        final nhan = logs.isEmpty ? null : CongThuc.nhanNap(nap, goi);
        final mau = switch (nhan) {
          NhanNap.vuot => Mau.canhBao,
          NhanNap.dung => Mau.reu,
          NhanNap.hoiThap => Mau.mo,
          NhanNap.quaThap => Mau.muc,
          null => Mau.muc,
        };
        final chuNhan = switch (nhan) {
          NhanNap.vuot => Chuoi.vuotChiTieu,
          NhanNap.dung => Chuoi.dungChiTieu,
          NhanNap.hoiThap => Chuoi.hoiThap,
          NhanNap.quaThap => Chuoi.quaThap,
          null => null,
        };
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
                      Chuoi.nhatKy,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Mau.muc),
                    ),
                  ],
                ),
                Text(kho.dongNgay, style: const TextStyle(color: Mau.mo)),
                if (kho.khoaGhi)
                  const Text(Chuoi.chiXem, style: TextStyle(color: Mau.mo, fontSize: 13)),
                const SizedBox(height: 12),
                if (goi != null && tdee != null)
                  Text(
                    Chuoi.tdeeGoiY(tdee.round(), goi),
                    style: const TextStyle(fontSize: 15, color: Mau.mo),
                  ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final k in Khung.ds)
                      ChipKhung(
                        ma: k,
                        chu: Chuoi.tenKhung(k),
                        bat: _khung == k,
                        onTap: () => setState(() => _khung = k),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: FilledButton(
                          key: const Key('nut-tao-cong-thuc'),
                          onPressed: kho.khoaGhi ? null : _themTao,
                          child: const Text(Chuoi.taoCongThuc),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: OutlinedButton(
                          key: const Key('nut-mon-da-luu'),
                          onPressed: kho.khoaGhi ? null : _themKho,
                          child: const Text(Chuoi.monDaLuu),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                VongKcalNgay(
                  nap: nap,
                  goi: goi,
                  tieu: tieu,
                  dam: mac.dam,
                  bot: mac.bot,
                  beo: mac.beo,
                ),
                if (chuNhan != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(chuNhan, style: TextStyle(fontSize: 15, color: mau)),
                  ),
                const SizedBox(height: 20),
                const Text(
                  Chuoi.thucDonHomNay,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Mau.muc),
                ),
                const SizedBox(height: 12),
                for (final k in Khung.ds) ...[
                  Builder(
                    builder: (context) {
                      final ds = [
                        for (final l in logs)
                          if (Khung.chuan(l.khung) == k) l,
                      ];
                      final kcal = ds.fold<int>(0, (a, b) => a + b.kcal);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: KhoiGap(
                          key: Key('khoi-$k'),
                          tieuDe: Chuoi.hangKhung(Chuoi.tenKhung(k), ds.length, kcal),
                          phu: '',
                          mo: _moKhung == k,
                          children: [
                            if (ds.isEmpty)
                              const Text('—', style: TextStyle(color: Mau.mo))
                            else
                              XemThem(hang: [for (final l in ds) _hangLog(l)]),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
