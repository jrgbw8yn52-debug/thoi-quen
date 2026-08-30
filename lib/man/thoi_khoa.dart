import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../kho.dart';
import '../mau.dart';
import '../widget/duong_thong_ke.dart';

class ManThoiKhoa extends StatefulWidget {
  const ManThoiKhoa({super.key, required this.kho});

  final Kho kho;

  @override
  State<ManThoiKhoa> createState() => _ManThoiKhoaState();
}

class _ManThoiKhoaState extends State<ManThoiKhoa> {
  int _phin = 0;

  Kho get kho => widget.kho;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mau.giay,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: kho,
          builder: (context, _) {
            final nm2 = kho.nTrenMThongKe(_phin);
            final dg2 = Chuoi.danhGia(nm2.$1, nm2.$2);
            final diem2 = kho.diemThongKe(_phin);
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Expanded(
                      child: Text(
                        Chuoi.thongKe,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Mau.muc,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _Phin(chu: Chuoi.motTuan, bat: _phin == 0, onTap: () => setState(() => _phin = 0)),
                    _Phin(chu: Chuoi.motThang, bat: _phin == 1, onTap: () => setState(() => _phin = 1)),
                    _Phin(chu: Chuoi.sauThang, bat: _phin == 2, onTap: () => setState(() => _phin = 2)),
                    _Phin(chu: Chuoi.muoiHaiThang, bat: _phin == 3, onTap: () => setState(() => _phin = 3)),
                  ],
                ),
                const SizedBox(height: 16),
                DuongThongKe(
                  diem: diem2,
                  onChon: (d) {
                    kho.chonNgay(d);
                    setState(() {});
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  Chuoi.hoanThanhDanhGia(nm2.$1, nm2.$2, dg2),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Mau.muc,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  Chuoi.chiXem,
                  style: TextStyle(fontSize: 13, color: Mau.mo),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Phin extends StatelessWidget {
  const _Phin({required this.chu, required this.bat, required this.onTap});

  final String chu;
  final bool bat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bat ? Mau.chipBat : Mau.beMat,
      shape: StadiumBorder(side: BorderSide(color: bat ? Mau.reu : Mau.vien)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 36),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(chu, style: const TextStyle(fontSize: 14, color: Mau.muc)),
          ),
        ),
      ),
    );
  }
}
