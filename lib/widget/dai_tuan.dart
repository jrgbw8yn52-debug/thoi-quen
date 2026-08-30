import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../kho.dart';
import '../mau.dart';

/// Chấm T2–CN. Bấm = selectedDate. Hôm nay hệ thống ×2 chỉ khi đang xem tuần đó.
class DaiTuan extends StatelessWidget {
  const DaiTuan({
    super.key,
    required this.tuan,
    required this.onChon,
    required this.tuanChuaHomNay,
  });

  final List<ChamTuan> tuan;
  final ValueChanged<DateTime> onChon;
  final bool tuanChuaHomNay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
      child: Row(
        children: [
          for (var i = 0; i < tuan.length; i++)
            Expanded(
              child: _Cham(
                thu: Chuoi.thuNgan[i],
                cham: tuan[i],
                phongHomNay: tuanChuaHomNay && tuan[i].laHomNay,
                onTap: () => onChon(tuan[i].ngay),
              ),
            ),
        ],
      ),
    );
  }
}

class _Cham extends StatelessWidget {
  const _Cham({
    required this.thu,
    required this.cham,
    required this.phongHomNay,
    required this.onTap,
  });

  final String thu;
  final ChamTuan cham;
  final bool phongHomNay;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              thu,
              style: TextStyle(
                fontSize: 11,
                fontWeight: phongHomNay ? FontWeight.w700 : FontWeight.w500,
                color: phongHomNay ? Mau.muc : Mau.mo,
              ),
            ),
            const SizedBox(height: 6),
            _HinhCham(cham: cham, phongHomNay: phongHomNay),
          ],
        ),
      ),
    );
  }
}

class _HinhCham extends StatelessWidget {
  const _HinhCham({required this.cham, required this.phongHomNay});

  final ChamTuan cham;
  final bool phongHomNay;

  @override
  Widget build(BuildContext context) {
    final size = phongHomNay ? 20.0 : 10.0;
    final du = cham.tong > 0 && cham.tick >= cham.tong;
    final motPhan = cham.tick > 0 && !du;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: cham.dangXem ? Mau.muc : (phongHomNay ? Mau.muc : Mau.vien),
          width: cham.dangXem || phongHomNay ? 2 : 1,
        ),
        color: du
            ? Mau.reu
            : (motPhan ? Mau.reu.withValues(alpha: 0.28) : Colors.transparent),
      ),
    );
  }
}
