import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../kho.dart';
import '../mau.dart';
import '../ngay.dart';
import 'nhan_habis.dart';

/// Đầu Home: mark + HABIS, chào theo giờ, câu cam, thẻ chuỗi tập.
class DauTrangHabis extends StatelessWidget {
  const DauTrangHabis({
    super.key,
    required this.kho,
    this.onChuoi,
  });

  final Kho kho;
  final VoidCallback? onChuoi;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const NhanHabis(size: 28),
              const SizedBox(width: 10),
              Text(
                Chuoi.habisNhan,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 6,
                  color: Mau.muc,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            Chuoi.chaoTheoGio(kho.bayGio),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
              height: 1.15,
              color: Mau.muc,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            Chuoi.totHonHomQua,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 1.3,
              color: Mau.reu,
            ),
          ),
          const SizedBox(height: 16),
          TheChuoiTap(
            kho: kho,
            onTap: onChuoi,
          ),
        ],
      ),
    );
  }
}

class TheChuoiTap extends StatelessWidget {
  const TheChuoiTap({super.key, required this.kho, this.onTap});

  final Kho kho;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final lua = kho.luaTapHom;
    final tuan = Ngay.tuan(kho.homNay);
    return Material(
      color: Mau.beMat,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        key: const Key('lua-home'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            children: [
              Text(
                Chuoi.chuoiHienTai.toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.6,
                  color: Mau.mo,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${lua.so}',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w700,
                  height: 1.05,
                  color: lua.sang ? Mau.lua : Mau.muc,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  for (final d in tuan)
                    Expanded(
                      child: _ChamTap(
                        thu: Chuoi.thuNgan[d.weekday - 1],
                        co: kho.tapNgay(d).isNotEmpty,
                        homNay: Ngay.cungNgay(d, kho.homNay),
                        tuongLai: Ngay.sau(d, kho.homNay),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChamTap extends StatelessWidget {
  const _ChamTap({
    required this.thu,
    required this.co,
    required this.homNay,
    required this.tuongLai,
  });

  final String thu;
  final bool co;
  final bool homNay;
  final bool tuongLai;

  @override
  Widget build(BuildContext context) {
    final r = homNay ? 9.0 : 6.0;
    final dac = co && !tuongLai;
    return Column(
      children: [
        Container(
          width: r * 2,
          height: r * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dac ? Mau.reu : Colors.transparent,
            border: Border.all(
              color: dac ? Mau.reu : (homNay ? Mau.muc : Mau.vien),
              width: homNay ? 2 : 1.4,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          thu,
          style: TextStyle(
            fontSize: 11,
            fontWeight: homNay ? FontWeight.w700 : FontWeight.w500,
            color: homNay ? Mau.muc : Mau.mo,
          ),
        ),
      ],
    );
  }
}
