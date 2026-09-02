import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../kho.dart';
import '../mau.dart';
import '../ngay.dart';
import 'nhan_habis.dart';

/// Đầu Home: mark 28 + HABIS, chào theo giờ, câu cam, thẻ STREAK HIỆN TẠI.
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
          const Row(
            children: [
              NhanHabis(size: 28),
              SizedBox(width: 10),
              Text(
                Chuoi.habisNhan,
                style: TextStyle(
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
              fontSize: 28,
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
          padding: const EdgeInsets.fromLTRB(18, 14, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                Chuoi.chuoiHienTai,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.4,
                  color: Mau.mo,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${lua.so}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            height: 1,
                            color: Mau.reu,
                          ),
                        ),
                        const TextSpan(
                          text: ' ${Chuoi.ngayDonVi}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.1,
                            color: Mau.muc,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < tuan.length; i++)
                        Padding(
                          padding: EdgeInsets.only(left: i == 0 ? 0 : 7),
                          child: _ChamTap(
                            co: kho.tapNgay(tuan[i]).isNotEmpty,
                            homNay: Ngay.cungNgay(tuan[i], kho.homNay),
                            tuongLai: Ngay.sau(tuan[i], kho.homNay),
                          ),
                        ),
                    ],
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
    required this.co,
    required this.homNay,
    required this.tuongLai,
  });

  final bool co;
  final bool homNay;
  final bool tuongLai;

  @override
  Widget build(BuildContext context) {
    final r = homNay ? 7.0 : 5.0;
    final dac = co && !tuongLai;
    return Container(
      width: r * 2,
      height: r * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: dac ? Mau.reu : Colors.transparent,
        border: Border.all(
          color: dac ? Mau.reu : (homNay ? Mau.reu : Mau.vien),
          width: homNay ? 2 : 1.4,
        ),
      ),
    );
  }
}
