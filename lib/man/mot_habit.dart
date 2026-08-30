import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../chuoi.dart';
import '../db/database.dart';
import '../kho.dart';
import '../mau.dart';
import '../ngay.dart';
import 'them_habit.dart';

class ManMotHabit extends StatelessWidget {
  const ManMotHabit({super.key, required this.kho, required this.habitId});

  final Kho kho;
  final int habitId;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: kho,
      builder: (context, _) {
        final hang = kho.hang.where((h) => h.habit.id == habitId);
        if (hang.isEmpty) {
          return const SizedBox.shrink();
        }
        return _Than(kho: kho, habit: hang.first.habit);
      },
    );
  }
}

class _Than extends StatefulWidget {
  const _Than({required this.kho, required this.habit});

  final Kho kho;
  final Habit habit;

  @override
  State<_Than> createState() => _ThanState();
}

class _ThanState extends State<_Than> {
  late DateTime _thang;

  @override
  void initState() {
    super.initState();
    _thang = Ngay.dauThang(widget.kho.selected);
  }

  Future<void> _xoa() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Mau.beMat,
          content: const Text(Chuoi.xoaKhoiMay),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text(Chuoi.huy),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(
                Chuoi.xoa,
                style: TextStyle(color: Theme.of(ctx).colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
    if (ok != true || !mounted) return;
    await widget.kho.xoaHabit(widget.habit.id);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _sua() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ManThemHabit(kho: widget.kho, habit: widget.habit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final kho = widget.kho;
    final h = widget.habit;
    final ticks = kho.ticksCua(h.id);
    final x = kho.xThangCua(h.id, _thang);
    final k = h.mucTieuThang - x;
    final chuoi = kho.chuoiCua(h.id);
    final homNay = kho.homNay;
    final thangNay = Ngay.dauThang(homNay);
    final toiDuoc = Ngay.truoc(_thang, thangNay);

    return Scaffold(
      backgroundColor: Mau.giay,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
              child: Row(
                children: [
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Mau.muc),
                    ),
                  ),
                  const Spacer(),
                  TextButton(onPressed: _sua, child: const Text(Chuoi.sua)),
                  TextButton(onPressed: _xoa, child: const Text(Chuoi.xoa)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Text(
                h.ten,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.4,
                  color: Mau.muc,
                  height: 1.15,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Text(
                Chuoi.chuoiNNgay(chuoi),
                style: const TextStyle(fontSize: 16, color: Mau.muc),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Text(
                Chuoi.conKDatN(k, h.mucTieuThang),
                style: const TextStyle(fontSize: 15, color: Mau.mo),
              ),
            ),
            if (h.met != null) _KcalVaPhut(kho: kho, habit: h),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: IconButton(
                      onPressed: () =>
                          setState(() => _thang = Ngay.luiThang(_thang)),
                      icon: const Icon(Icons.chevron_left),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      Chuoi.thang(_thang.month),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Mau.muc,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: IconButton(
                      onPressed: toiDuoc
                          ? () => setState(() => _thang = Ngay.toiThang(_thang))
                          : null,
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  for (final t in Chuoi.thuNgan)
                    Expanded(
                      child: Text(
                        t,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 11, color: Mau.mo),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _LuoiThang(
                thang: _thang,
                homNay: homNay,
                selected: kho.selected,
                ticks: ticks,
                onChon: (d) {
                  HapticFeedback.selectionClick();
                  kho.chonVaTick(h, d);
                },
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

class _LuoiThang extends StatelessWidget {
  const _LuoiThang({
    required this.thang,
    required this.homNay,
    required this.selected,
    required this.ticks,
    required this.onChon,
  });

  final DateTime thang;
  final DateTime homNay;
  final DateTime selected;
  final Set<String> ticks;
  final ValueChanged<DateTime> onChon;

  @override
  Widget build(BuildContext context) {
    final days = Ngay.cacNgayThang(thang);
    final pad = days.first.weekday - 1; // Mon=1 → 0 empty
    final o = <Widget>[
      for (var i = 0; i < pad; i++) const SizedBox(height: 44),
      for (final d in days)
        _ONgay(
          ngay: d,
          homNay: homNay,
          dangXem: Ngay.cungNgay(d, selected),
          bat: ticks.contains(Ngay.iso(d)),
          onTap: Ngay.sau(d, homNay) ? null : () => onChon(d),
        ),
    ];
    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1,
      children: o,
    );
  }
}

class _ONgay extends StatelessWidget {
  const _ONgay({
    required this.ngay,
    required this.homNay,
    required this.dangXem,
    required this.bat,
    required this.onTap,
  });

  final DateTime ngay;
  final DateTime homNay;
  final bool dangXem;
  final bool bat;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hom = Ngay.cungNgay(ngay, homNay);
    final tuongLai = onTap == null;
    return InkWell(
      key: Key('o-ngay-${Ngay.iso(ngay)}'),
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bat ? Mau.reu : Colors.transparent,
            border: Border.all(
              color: dangXem || hom ? Mau.muc : (bat ? Mau.reu : Mau.vien),
              width: dangXem || hom ? 2 : 1,
            ),
          ),
          child: Text(
            '${ngay.day}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: dangXem || hom ? FontWeight.w700 : FontWeight.w500,
              color: tuongLai
                  ? Mau.vien
                  : (bat ? Mau.giay : Mau.muc),
            ),
          ),
        ),
      ),
    );
  }
}

class _KcalVaPhut extends StatelessWidget {
  const _KcalVaPhut({required this.kho, required this.habit});

  final Kho kho;
  final Habit habit;

  @override
  Widget build(BuildContext context) {
    final phut = habit.phutMacDinh ?? 30;
    final kcal = kho.kcalTapCua(habit, phut: phut);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (kcal != null)
            Text(
              Chuoi.kcalBuoiSo('${kcal.round()}'),
              style: const TextStyle(fontSize: 15, color: Mau.muc),
            )
          else if (kho.thieuCan)
            const Text(
              Chuoi.themCan,
              style: TextStyle(fontSize: 14, color: Mau.mo),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                width: 44,
                height: 44,
                child: IconButton(
                  onPressed: phut <= 5
                      ? null
                      : () => kho.suaPhutMacDinh(habit.id, phut - 5),
                  icon: const Icon(Icons.remove),
                ),
              ),
              Text(
                '$phut ${Chuoi.phut}',
                style: const TextStyle(fontSize: 15, color: Mau.muc),
              ),
              SizedBox(
                width: 44,
                height: 44,
                child: IconButton(
                  onPressed: phut >= 180
                      ? null
                      : () => kho.suaPhutMacDinh(habit.id, phut + 5),
                  icon: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
