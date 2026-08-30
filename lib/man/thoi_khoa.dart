import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../kho.dart';
import '../mau.dart';

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
    final nm = kho.nTrenMCua(_phin);
    final dg = Chuoi.danhGia(nm.$1, nm.$2);
    return Scaffold(
      backgroundColor: Mau.giay,
      body: SafeArea(
        child: ListView(
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
                    Chuoi.thoiKhoaBieu,
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
                _Phin(chu: Chuoi.phinNgay, bat: _phin == 0, onTap: () => setState(() => _phin = 0)),
                _Phin(chu: Chuoi.tuanNhan, bat: _phin == 1, onTap: () => setState(() => _phin = 1)),
                _Phin(chu: Chuoi.thangNhan, bat: _phin == 2, onTap: () => setState(() => _phin = 2)),
                _Phin(chu: Chuoi.namNhan, bat: _phin == 3, onTap: () => setState(() => _phin = 3)),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              Chuoi.hoanThanhDanhGia(nm.$1, nm.$2, dg),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Mau.muc),
            ),
            const SizedBox(height: 16),
            if (_phin == 0) _CotDon(phan: nm.$2 == 0 ? 0 : nm.$1 / nm.$2),
            if (_phin == 1)
              SizedBox(
                height: 72,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final c in kho.tuan)
                      Expanded(child: _Cot(phan: c.phan, nhan: Chuoi.thuNgan[c.ngay.weekday - 1])),
                  ],
                ),
              ),
            if (_phin == 2)
              SizedBox(
                height: 72,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final c in kho.cotThang)
                      Expanded(child: _Cot(phan: c.phan, nhan: '${c.ngay.day}')),
                  ],
                ),
              ),
            if (_phin == 3)
              SizedBox(
                height: 72,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final c in kho.cotNam)
                      Expanded(child: _Cot(phan: c.phan, nhan: '${c.ngay.month}')),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            const Text(
              Chuoi.chiXem,
              style: TextStyle(fontSize: 13, color: Mau.mo),
            ),
          ],
        ),
      ),
    );
  }
}

class _CotDon extends StatelessWidget {
  const _CotDon({required this.phan});

  final double phan;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 12,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Mau.beMat,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: phan.clamp(0.0, 1.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Mau.reu,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Cot extends StatelessWidget {
  const _Cot({required this.phan, required this.nhan});

  final double phan;
  final String nhan;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: phan.clamp(0.05, 1.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Mau.reu.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(nhan, style: const TextStyle(fontSize: 9, color: Mau.mo)),
        ],
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
