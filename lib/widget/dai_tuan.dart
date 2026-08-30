import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../chuoi.dart';
import '../kho.dart';
import '../mau.dart';

class DaiTuan extends StatelessWidget {
  const DaiTuan({super.key, required this.tuan, required this.onChon});

  final List<ChamTuan> tuan;
  final ValueChanged<DateTime> onChon;

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
                onTap: tuan[i].tuongLai
                    ? null
                    : () {
                        HapticFeedback.selectionClick();
                        onChon(tuan[i].ngay);
                      },
              ),
            ),
        ],
      ),
    );
  }
}

class _Cham extends StatelessWidget {
  const _Cham({required this.thu, required this.cham, required this.onTap});

  final String thu;
  final ChamTuan cham;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final mo = cham.tuongLai;
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: SizedBox(
        height: 56,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              thu,
              style: TextStyle(
                fontSize: 11,
                fontWeight: cham.laHomNay ? FontWeight.w700 : FontWeight.w500,
                color: mo ? Mau.vien : (cham.laHomNay ? Mau.muc : Mau.mo),
              ),
            ),
            const SizedBox(height: 6),
            _HinhCham(cham: cham),
          ],
        ),
      ),
    );
  }
}

class _HinhCham extends StatelessWidget {
  const _HinhCham({required this.cham});

  final ChamTuan cham;

  @override
  Widget build(BuildContext context) {
    final size = cham.laHomNay ? 14.0 : 10.0;
    final du = cham.tong > 0 && cham.tick >= cham.tong;
    final motPhan = cham.tick > 0 && !du;
    return Container(
      width: size + (cham.dangXem ? 8 : 0),
      height: size + (cham.dangXem ? 8 : 0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: cham.dangXem
              ? Mau.muc
              : (cham.laHomNay ? Mau.muc : Mau.vien),
          width: cham.laHomNay || cham.dangXem ? 2 : 1,
        ),
        color: du
            ? Mau.reu
            : (motPhan ? Mau.reu.withValues(alpha: 0.28) : Colors.transparent),
      ),
    );
  }
}
