import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../kho.dart';
import '../mau.dart';

class TheNgayDangXem extends StatelessWidget {
  const TheNgayDangXem({super.key, required this.kho, this.ngay});

  final Kho kho;
  final DateTime? ngay;

  @override
  Widget build(BuildContext context) {
    final d = ngay ?? kho.selected;
    final n = kho.tickCuaNgay(d);
    final m = kho.tongCuaNgay(d);
    final nap = kho.kcalNapCuaNgay(d);
    final goi = kho.kcalGoiYDoc;
    final tieu = kho.kcalTapCuaNgay(d);
    final lua = kho.luaTapCua(d);
    return Material(
      color: Mau.beMat,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              Chuoi.ngayDangXem,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Mau.mo),
            ),
            const SizedBox(height: 4),
            Text(
              Chuoi.theNgayDangXem(
                n: n,
                m: m,
                nap: nap,
                goi: goi,
                tieu: tieu,
                lua: lua.so,
              ),
              style: const TextStyle(fontSize: 15, height: 1.35, color: Mau.muc),
            ),
          ],
        ),
      ),
    );
  }
}
