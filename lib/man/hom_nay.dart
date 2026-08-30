import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../kho.dart';
import '../mau.dart';
import '../widget/dai_tuan.dart';
import '../widget/hang_habit.dart';
import '../widget/lan_ngay.dart';
import 'them_habit.dart';
import 'xoa_habit.dart';

class ManHomNay extends StatelessWidget {
  const ManHomNay({super.key, required this.kho});

  final Kho kho;

  void _moThem(BuildContext context) {
    if (!kho.themDuoc) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ManThemHabit(kho: kho),
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
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                key: const Key('tieu-de-ngay'),
                onTap: () => moLanNgay(context, kho),
                borderRadius: BorderRadius.circular(12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 44),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
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
                        const Icon(Icons.expand_more, color: Mau.mo),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 8),
            child: Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 15, color: Mau.mo, height: 1.3),
                children: [
                  TextSpan(text: '${kho.nTickHom}/${kho.mHom} '),
                  TextSpan(
                    text: Chuoi.homNayNgay(kho.homNay),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Mau.muc,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onHorizontalDragEnd: (d) {
              final v = d.primaryVelocity ?? 0;
              if (v < -120) {
                kho.toiTuan();
              } else if (v > 120) {
                kho.luiTuan();
              }
            },
            child: DaiTuan(
              tuan: kho.tuan,
              onChon: kho.chonNgay,
              tuanChuaHomNay: kho.tuanChuaHomNay,
            ),
          ),
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
                      return HangHabit(
                        hang: h,
                        khoaGhi: kho.khoaGhi,
                        onTap: () => kho.toggle(h),
                        onSua: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => ManThemHabit(
                                kho: kho,
                                habit: h.habit,
                              ),
                            ),
                          );
                        },
                        onXoa: () => moXoaHabit(context, kho, h.habit),
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
          child: const Center(
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
    if (kho.khoaGhi) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Text(
          Chuoi.chiXem,
          style: TextStyle(fontSize: 15, color: Mau.mo),
        ),
      );
    }
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
