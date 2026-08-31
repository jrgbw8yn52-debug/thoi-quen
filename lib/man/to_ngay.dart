import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../cong_thuc.dart';
import '../db/database.dart';
import '../kho.dart';
import '../mau.dart';
import '../ngay.dart';
import '../widget/hang_habit.dart';
import '../widget/picker_mon.dart';
import '../widget/the_ngay.dart';
import 'to_mon.dart';

Future<void> moToNgay(BuildContext context, Kho kho, DateTime ngay) async {
  FocusManager.instance.primaryFocus?.unfocus();
  await Future<void>.delayed(Duration.zero);
  if (!context.mounted) return;
  kho.chonNgay(ngay);
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Mau.beMat,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
        child: ToNgay(kho: kho, ngay: ngay),
      );
    },
  );
}

class ToNgay extends StatefulWidget {
  const ToNgay({super.key, required this.kho, required this.ngay});

  final Kho kho;
  final DateTime ngay;

  @override
  State<ToNgay> createState() => _ToNgayState();
}

class _ToNgayState extends State<ToNgay> {
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

  Future<void> _luuTap() async {
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
              maxHeight: MediaQuery.sizeOf(context).height * 0.86,
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
                const SizedBox(height: 12),
                TheNgayDangXem(
                  key: const Key('the-ngay-to'),
                  kho: kho,
                  ngay: ngay,
                ),
                const SizedBox(height: 16),
                const Text(
                  Chuoi.thoiQuen,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo),
                ),
                const SizedBox(height: 6),
                Text(
                  Chuoi.hoanThanhThoiQuen(
                    kho.hang.where((h) => h.ticked).length,
                    kho.hang.length,
                  ),
                  style: const TextStyle(fontSize: 15, color: Mau.mo),
                ),
                const SizedBox(height: 8),
                if (kho.hang.isEmpty)
                  const Text('—', style: TextStyle(color: Mau.mo))
                else
                  for (final h in kho.hang)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: HangHabit(
                        hang: h,
                        khoaGhi: true,
                        choVuot: false,
                        onTap: () {},
                        onSua: () {},
                        onXoa: () {},
                      ),
                    ),
                const SizedBox(height: 16),
                const Text(
                  Chuoi.tap,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo),
                ),
                if (!_xem) ...[
                  const SizedBox(height: 8),
                  HangPickerMon(
                    loai: _loai,
                    onChon: (v) => setState(() => _loai = v),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      NutBuocPhut(
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
                      NutBuocPhut(
                        chu: '+',
                        onTap: _phut >= 180 ? null : () => setState(() => _phut += 5),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: FilledButton(
                            key: const Key('luu-to-ngay'),
                            onPressed: _luuTap,
                            child: const Text(Chuoi.luu),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
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
                const SizedBox(height: 16),
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
                  key: const Key('nap-tieu'),
                  Chuoi.napTieu(nap, tong),
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
