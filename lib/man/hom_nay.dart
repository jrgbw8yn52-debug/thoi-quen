import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../kho.dart';
import '../mau.dart';
import '../widget/chip_can.dart';
import '../widget/dai_tuan.dart';
import '../widget/hang_habit.dart';

class ManHomNay extends StatelessWidget {
  const ManHomNay({super.key, required this.kho});

  final Kho kho;

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
                ? _FirstRun(kho: kho)
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                    itemCount: kho.hang.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 6),
                    itemBuilder: (context, i) {
                      final h = kho.hang[i];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: HangHabit(hang: h, onTap: () => kho.toggle(h)),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FirstRun extends StatelessWidget {
  const _FirstRun({required this.kho});

  final Kho kho;

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
              _ChipThem(
                chu: Chuoi.day6Gio,
                onTap: () => kho.themPreset(ten: Chuoi.day6Gio),
              ),
              _ChipThem(chu: Chuoi.vanDong, onTap: kho.themVanDong),
              _ChipThem(
                chu: Chuoi.doc20Trang,
                onTap: () => kho.themPreset(ten: Chuoi.doc20Trang),
              ),
              _ChipThem(
                chu: Chuoi.tuDatTen,
                onTap: () => _moDatTen(context, kho),
              ),
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

Future<void> _moDatTen(BuildContext context, Kho kho) async {
  final ctrl = TextEditingController();
  final ten = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Mau.beMat,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.viewInsetsOf(ctx).bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              Chuoi.tuDatTen,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Mau.muc,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              Chuoi.haiLamNamNgay,
              style: TextStyle(fontSize: 13, color: Mau.mo),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              autofocus: true,
              maxLength: 40,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: Chuoi.tenThoiQuen,
                counterText: '',
              ),
              onSubmitted: (v) => Navigator.pop(ctx, v),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(Chuoi.huy),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, ctrl.text),
                  child: const Text(Chuoi.luu),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
  ctrl.dispose();
  if (ten != null) await kho.themPreset(ten: ten);
}
