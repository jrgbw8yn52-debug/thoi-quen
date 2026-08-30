import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../kho.dart';
import '../mau.dart';
import '../widget/chip_can.dart';
import '../widget/dai_tuan.dart';
import '../widget/hang_habit.dart';
import 'mot_habit.dart';
import 'them_habit.dart';

class ManHomNay extends StatelessWidget {
  const ManHomNay({super.key, required this.kho});

  final Kho kho;

  void _moThem(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ManThemHabit(kho: kho),
      ),
    );
  }

  void _moMot(BuildContext context, int id) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ManMotHabit(kho: kho, habitId: id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: ChipCan(chu: kho.chuChipCan, onTap: kho.moCoThe),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Text(
              kho.dongNgay,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                height: 1.15,
                letterSpacing: -0.4,
                color: Mau.muc,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 8),
            child: Text(
              kho.nTrenM,
              style: const TextStyle(fontSize: 15, color: Mau.mo, height: 1.3),
            ),
          ),
          DaiTuan(tuan: kho.tuan, onChon: kho.chonNgay),
          Expanded(
            child: kho.rong
                ? _FirstRun(
                    kho: kho,
                    onTuDatTen: () => _moThem(context),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                    itemCount: kho.hang.length + (kho.themDuoc ? 1 : 0),
                    separatorBuilder: (_, _) => const SizedBox(height: 6),
                    itemBuilder: (context, i) {
                      if (i == kho.hang.length) {
                        return _NutThem(onTap: () => _moThem(context));
                      }
                      final h = kho.hang[i];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: HangHabit(
                          hang: h,
                          onTap: () => kho.toggle(h),
                          onChiTiet: () => _moMot(context, h.habit.id),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _NutThem extends StatelessWidget {
  const _NutThem({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Center(
            child: Text(
              Chuoi.themThoiQuen,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Mau.reu,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FirstRun extends StatelessWidget {
  const _FirstRun({required this.kho, required this.onTuDatTen});

  final Kho kho;
  final VoidCallback onTuDatTen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            Chuoi.chonThoiQuen,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Mau.muc,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (!kho.daCoTen(Chuoi.day6Gio))
                _ChipThem(
                  chu: Chuoi.day6Gio,
                  onTap: () => kho.themPreset(ten: Chuoi.day6Gio),
                ),
              if (!kho.daCoTen(Chuoi.vanDong))
                _ChipThem(chu: Chuoi.vanDong, onTap: kho.themVanDong),
              if (!kho.daCoTen(Chuoi.doc20Trang))
                _ChipThem(
                  chu: Chuoi.doc20Trang,
                  onTap: () => kho.themPreset(ten: Chuoi.doc20Trang),
                ),
              _ChipThem(chu: Chuoi.tuDatTen, onTap: onTuDatTen),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChipThem extends StatelessWidget {
  const _ChipThem({required this.chu, required this.onTap});

  final String chu;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Mau.beMat,
      shape: const StadiumBorder(side: BorderSide(color: Mau.vien)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              chu,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Mau.muc,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
