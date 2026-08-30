import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../kho.dart';
import '../mau.dart';
import 'ghi_can.dart';
import 'ghi_chi_so.dart';
import 'ghi_tap.dart';

Future<void> moLuoiGhi(BuildContext context, Kho kho) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Mau.beMat,
    builder: (ctx) => LuoiGhi(kho: kho),
  );
}

class LuoiGhi extends StatelessWidget {
  const LuoiGhi({super.key, required this.kho});

  final Kho kho;

  void _mo(BuildContext context, Widget man) {
    final nav = Navigator.of(context, rootNavigator: true);
    Navigator.pop(context);
    nav.push(MaterialPageRoute<void>(builder: (_) => man));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              kho.dongNgay,
              style: const TextStyle(fontSize: 15, color: Mau.mo),
            ),
            if (kho.khoaGhi)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(Chuoi.chiXem, style: TextStyle(fontSize: 13, color: Mau.mo)),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                _O(
                  chu: Chuoi.canNang,
                  onTap: () => _mo(context, ManGhiCan(kho: kho)),
                ),
                const SizedBox(width: 10),
                _O(
                  chu: Chuoi.hoatDongO,
                  onTap: () => _mo(context, ManGhiTap(kho: kho)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const _O(chu: '${Chuoi.nhatKy}\n${Chuoi.seLam}', mo: true),
                const SizedBox(width: 10),
                _O(
                  chu: Chuoi.chiSo,
                  onTap: () => _mo(context, ManGhiChiSo(kho: kho)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _O extends StatelessWidget {
  const _O({required this.chu, this.onTap, this.mo = false});

  final String chu;
  final VoidCallback? onTap;
  final bool mo;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Opacity(
        opacity: mo ? 0.4 : 1,
        child: Material(
          color: Mau.giay,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 88),
              child: Center(
                child: Text(
                  chu,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Mau.muc,
                    height: 1.3,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
