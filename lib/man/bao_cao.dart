import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../cong_thuc.dart';
import '../kho.dart';
import '../mau.dart';
import '../widget/duong_can.dart';

class ManBaoCao extends StatelessWidget {
  const ManBaoCao({super.key, required this.kho});

  final Kho kho;

  @override
  Widget build(BuildContext context) {
    final bmi = [
      for (final c in kho.dsCan.reversed)
        CongThuc.bmi(c.kg, kho.heightCm),
    ].whereType<double>().toList();
    final thang = kho.kcalThang12();
    final tuan = kho.kcalTuan12();
    return Scaffold(
      backgroundColor: Mau.giay,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
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
                  Chuoi.baoCao,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Mau.muc),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(Chuoi.bmi, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo)),
            const SizedBox(height: 8),
            if (bmi.isEmpty)
              const Text(Chuoi.thieuDuLieu, style: TextStyle(color: Mau.mo))
            else
              DuongCan(diem: bmi, truc: true),
            const SizedBox(height: 24),
            const Text(Chuoi.kcalTapNhan, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo)),
            const SizedBox(height: 4),
            Text(Chuoi.thangNhan, style: const TextStyle(fontSize: 13, color: Mau.mo)),
            const SizedBox(height: 8),
            _CotKcal(diem: thang),
            const SizedBox(height: 16),
            Text(Chuoi.tuanNhan, style: const TextStyle(fontSize: 13, color: Mau.mo)),
            const SizedBox(height: 8),
            _CotKcal(diem: tuan),
          ],
        ),
      ),
    );
  }
}

class _CotKcal extends StatelessWidget {
  const _CotKcal({required this.diem});

  final List<(String, int)> diem;

  @override
  Widget build(BuildContext context) {
    final max = diem.fold<int>(0, (a, b) => b.$2 > a ? b.$2 : a);
    return SizedBox(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final d in diem)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    heightFactor: max == 0 ? 0.08 : (d.$2 / max).clamp(0.08, 1),
                    widthFactor: 1,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: Mau.reu,
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
