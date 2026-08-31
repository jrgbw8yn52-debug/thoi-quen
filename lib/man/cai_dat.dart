import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../cong_thuc.dart';
import '../kho.dart';
import '../mau.dart';
import '../so.dart';
import 'ho_so.dart';

class ManTaiKhoan extends StatefulWidget {
  const ManTaiKhoan({super.key, required this.kho});

  final Kho kho;

  @override
  State<ManTaiKhoan> createState() => _ManTaiKhoanState();
}

class _ManTaiKhoanState extends State<ManTaiKhoan> {
  final _dich = TextEditingController();
  double _nhip = 0.5;
  bool _nap = false;

  Kho get kho => widget.kho;

  void _napLan() {
    if (_nap) return;
    _nap = true;
    _nhip = kho.nhipKg;
    final kg = kho.targetKg ?? kho.canMoi?.kg;
    if (kg != null) _dich.text = So.kg(kg);
  }

  @override
  void dispose() {
    _dich.dispose();
    super.dispose();
  }

  Future<void> _moHoSo() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => ManHoSo(kho: kho)),
    );
  }

  Future<void> _luuMucTieu() async {
    await kho.luuMucTieu(dich: _dich.text, nhip: _nhip);
  }

  Future<void> _xuat() async {
    final duoc = await kho.xuatBanSao();
    if (!mounted || !duoc) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(Chuoi.daXuat)),
    );
  }

  Future<void> _khoiPhuc() async {
    final ok = await _hoi(Chuoi.khoiPhuc, '${Chuoi.thayToanBo}\n${Chuoi.haiMayLech}');
    if (ok != true) return;
    final duoc = await kho.khoiPhucBanSao();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(duoc ? Chuoi.daKhoiPhuc : Chuoi.khongCoBanSao)),
    );
  }

  Future<void> _xoa() async {
    final ok = await _hoi(Chuoi.xoaDuLieu, Chuoi.xoaKhoiMay);
    if (ok != true) return;
    await kho.xoaDuLieu();
  }

  Future<void> _nguon() async {
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Mau.muc),
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

  Future<bool?> _hoi(String tieu, String than) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(tieu),
        content: Text(than),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text(Chuoi.huy)),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(tieu)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _napLan();
    final duKien = CongThuc.duKien(
      homNay: kho.homNay,
      nhip: _nhip,
      kg: kho.canMoi?.kg,
      target: So.parseKg(_dich.text) ?? kho.targetKg,
    );
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 32),
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Text(
              Chuoi.taiKhoan,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, letterSpacing: -0.4, color: Mau.muc),
            ),
          ),
          Material(
            color: Mau.beMat,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: _moHoSo,
              borderRadius: BorderRadius.circular(12),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 44),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Text(
                    kho.dongTaiKhoan ?? Chuoi.thieuDuLieu,
                    style: const TextStyle(fontSize: 16, color: Mau.muc),
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 20, 12, 8),
            child: Text(
              Chuoi.mucTieuPhan,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Mau.muc),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 0, 12, 6),
            child: Text(Chuoi.canDich, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: _dich,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(suffixText: Chuoi.kg),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 16, 12, 4),
            child: Text(Chuoi.nhipTuan, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo)),
          ),
          Slider(
            value: _nhip,
            min: 0,
            max: 1,
            divisions: 10,
            label: '${CongThuc.nhipVietChu(_nhip)} kg',
            activeColor: Mau.reu,
            onChanged: (v) => setState(() => _nhip = (v * 10).round() / 10),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '${CongThuc.nhipVietChu(_nhip)} kg/tuần',
              style: const TextStyle(fontSize: 15, color: Mau.muc),
            ),
          ),
          if (_nhip > 0.5)
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 4, 12, 0),
              child: Text(Chuoi.trenNhipBacSi, style: TextStyle(fontSize: 13, color: Mau.canhBao, height: 1.35)),
            ),
          if (duKien != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Text(
                Chuoi.duKienNgay(duKien),
                style: const TextStyle(fontSize: 15, color: Mau.muc, height: 1.35),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: SizedBox(
              height: 44,
              child: FilledButton(
                onPressed: _luuMucTieu,
                child: const Text(Chuoi.luu),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Text(Chuoi.duLieuChiTrenMay, style: TextStyle(fontSize: 15, height: 1.4, color: Mau.mo)),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 0, 12, 16),
            child: Text(Chuoi.haiMayLech, style: TextStyle(fontSize: 15, height: 1.4, color: Mau.mo)),
          ),
          _Hang(chu: Chuoi.xuatBanSao, onTap: _xuat),
          _Hang(chu: Chuoi.khoiPhuc, onTap: _khoiPhuc),
          _Hang(chu: Chuoi.xoaDuLieu, onTap: _xoa),
          _Hang(chu: Chuoi.nguonDisclaimer, onTap: _nguon),
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 20, 12, 0),
            child: Text(Chuoi.phienBan, style: TextStyle(fontSize: 13, color: Mau.mo)),
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
              child: Text(chu, style: const TextStyle(fontSize: 16, color: Mau.muc)),
            ),
          ),
        ),
      ),
    );
  }
}
