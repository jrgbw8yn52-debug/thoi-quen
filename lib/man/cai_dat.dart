import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../kho.dart';
import '../mau.dart';
import 'ho_so.dart';

class ManCaiDat extends StatelessWidget {
  const ManCaiDat({super.key, required this.kho});

  final Kho kho;

  Future<void> _moHoSo(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => ManHoSo(kho: kho)),
    );
  }

  Future<void> _xuat(BuildContext context) async {
    await kho.xuatBanSao();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(Chuoi.daXuat)),
    );
  }

  Future<void> _khoiPhuc(BuildContext context) async {
    final ok = await _hoi(
      context,
      Chuoi.khoiPhuc,
      '${Chuoi.thayToanBo}\n${Chuoi.haiMayLech}',
    );
    if (ok != true) return;
    final duoc = await kho.khoiPhucBanSao();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(duoc ? Chuoi.khoiPhuc : Chuoi.khongCoBanSao)),
    );
  }

  Future<void> _xoa(BuildContext context) async {
    final ok = await _hoi(context, Chuoi.xoaDuLieu, Chuoi.xoaKhoiMay);
    if (ok != true) return;
    await kho.xoaDuLieu();
  }

  Future<void> _nguon(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Mau.beMat,
      builder: (ctx) {
        return const SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Chuoi.nguonDisclaimer,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Mau.muc,
                  ),
                ),
                SizedBox(height: 12),
                Text(Chuoi.uocTinh, style: TextStyle(fontSize: 15, color: Mau.mo, height: 1.4)),
                SizedBox(height: 12),
                Text(Chuoi.mifflin, style: TextStyle(fontSize: 15, color: Mau.muc, height: 1.4)),
                SizedBox(height: 8),
                Text(Chuoi.whoA, style: TextStyle(fontSize: 15, color: Mau.muc, height: 1.4)),
                SizedBox(height: 8),
                Text(Chuoi.compendium, style: TextStyle(fontSize: 15, color: Mau.muc, height: 1.4)),
                SizedBox(height: 8),
                Text(Chuoi.heSoKhongMifflin, style: TextStyle(fontSize: 15, color: Mau.muc, height: 1.4)),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool?> _hoi(BuildContext context, String tieu, String than) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(tieu),
        content: Text(than),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(Chuoi.huy),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(tieu),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 32),
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Text(
              Chuoi.caiDat,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.4,
                color: Mau.muc,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Text(
              Chuoi.duLieuChiTrenMay,
              style: TextStyle(fontSize: 15, height: 1.4, color: Mau.mo),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 0, 12, 16),
            child: Text(
              Chuoi.haiMayLech,
              style: TextStyle(fontSize: 15, height: 1.4, color: Mau.mo),
            ),
          ),
          _Hang(
            chu: Chuoi.hoSoChiSo,
            onTap: () => _moHoSo(context),
          ),
          _Hang(chu: Chuoi.xuatBanSao, onTap: () => _xuat(context)),
          _Hang(chu: Chuoi.khoiPhuc, onTap: () => _khoiPhuc(context)),
          _Hang(chu: Chuoi.xoaDuLieu, onTap: () => _xoa(context)),
          _Hang(chu: Chuoi.nguonDisclaimer, onTap: () => _nguon(context)),
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 20, 12, 0),
            child: Text(
              Chuoi.phienBan,
              style: TextStyle(fontSize: 13, color: Mau.mo),
            ),
          ),
        ],
      ),
    );
  }
}

class _Hang extends StatelessWidget {
  const _Hang({required this.chu, required this.onTap});

  final String chu;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                chu,
                style: const TextStyle(fontSize: 16, color: Mau.muc),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
