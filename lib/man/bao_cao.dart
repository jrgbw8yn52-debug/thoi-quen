import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../kho.dart';
import '../mau.dart';
import '../widget/duong_can.dart';

class ManBaoCao extends StatefulWidget {
  const ManBaoCao({super.key, required this.kho});

  final Kho kho;

  @override
  State<ManBaoCao> createState() => _ManBaoCaoState();
}

class _ManBaoCaoState extends State<ManBaoCao> {
  int _phin = 0;

  @override
  Widget build(BuildContext context) {
    final kho = widget.kho;
    return ListenableBuilder(
      listenable: kho,
      builder: (context, _) {
        final bmi = kho.bmiTheoCan;
        final tieu = kho.diemKcalPhin(_phin, kho.kcalTapCuaNgay);
        final nap = kho.diemKcalPhin(_phin, kho.kcalNapCuaNgay);
        return Scaffold(
          backgroundColor: Mau.giay,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 44,
                      height: 44,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Mau.muc),
                      ),
                    ),
                    const Text(
                      Chuoi.baoCao,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Mau.muc),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  Chuoi.bmiTheoThoiGian,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo),
                ),
                const SizedBox(height: 8),
                if (bmi.isEmpty)
                  const Text(Chuoi.thieuDuLieu, style: TextStyle(color: Mau.mo))
                else ...[
                  DuongCan(
                    key: const Key('duong-bmi'),
                    diem: [for (final b in bmi) b.$2],
                    truc: true,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${bmi.first.$1.day}/${bmi.first.$1.month}',
                        style: const TextStyle(fontSize: 11, color: Mau.mo),
                      ),
                      Text(
                        '${bmi.last.$1.day}/${bmi.last.$1.month}',
                        style: const TextStyle(fontSize: 11, color: Mau.mo),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  children: [
                    _Phin(chu: Chuoi.tuanNhan, bat: _phin == 0, onTap: () => setState(() => _phin = 0)),
                    _Phin(chu: Chuoi.thangNhan, bat: _phin == 1, onTap: () => setState(() => _phin = 1)),
                    _Phin(chu: Chuoi.sauThang, bat: _phin == 2, onTap: () => setState(() => _phin = 2)),
                    _Phin(chu: Chuoi.muoiHaiThang, bat: _phin == 3, onTap: () => setState(() => _phin = 3)),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  Chuoi.kcalTieuThu,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo),
                ),
                const SizedBox(height: 8),
                DuongCan(
                  key: const Key('duong-tieu-thu'),
                  diem: [for (final d in tieu) d.$2.toDouble()],
                  truc: true,
                ),
                const SizedBox(height: 16),
                const Text(
                  Chuoi.kcalNap,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo),
                ),
                const SizedBox(height: 8),
                DuongCan(
                  key: const Key('duong-nap'),
                  diem: [for (final d in nap) d.$2.toDouble()],
                  truc: true,
                ),
                if (!kho.coNap)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(Chuoi.chuaGhiNap, style: TextStyle(fontSize: 14, color: Mau.mo)),
                  ),
              ],
            ),
          ),
        );
      },
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
