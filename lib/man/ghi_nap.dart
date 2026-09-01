import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../cong_thuc.dart';
import '../db/database.dart';
import '../kho.dart';
import '../mau.dart';
import '../widget/hang_habit.dart';
import '../widget/vong_kcal.dart';
import 'to_mon.dart';

class ManGhiNap extends StatefulWidget {
  const ManGhiNap({super.key, required this.kho});

  final Kho kho;

  @override
  State<ManGhiNap> createState() => _ManGhiNapState();
}

class _ManGhiNapState extends State<ManGhiNap> {
  Kho get kho => widget.kho;

  Future<void> _suaLog(FoodLog log) async {
    if (kho.khoaGhi) return;
    final kq = await moDlgSuaLog(context, log);
    if (!mounted || kq == null) return;
    await Future<void>.delayed(Duration.zero);
    if (!mounted) return;
    await kho.suaLogGram(
      log.id,
      kq.gram,
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
                const SizedBox(height: 20),
                const Text(
                  Chuoi.thucDonHomNay,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Mau.muc),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: FilledButton(
                          key: const Key('nut-tao-cong-thuc'),
                          onPressed: () => moToTaoCongThuc(context, kho),
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
                          onPressed: () => moToMonDaLuu(context, kho),
                          child: const Text(Chuoi.monDaLuu),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                for (final l in logs)
                  Padding(
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
                  ),
                const SizedBox(height: 12),
                if (logs.isNotEmpty) ...[
                  VongKcalNgay(
                    nap: nap,
                    goi: goi,
                    dam: mac.dam,
                    bot: mac.bot,
                    beo: mac.beo,
                  ),
                  if (chuNhan != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(chuNhan, style: TextStyle(fontSize: 15, color: mau)),
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
