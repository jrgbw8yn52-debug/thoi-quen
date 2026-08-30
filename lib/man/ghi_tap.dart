import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../cong_thuc.dart';
import '../kho.dart';
import '../mau.dart';

class ManGhiTap extends StatefulWidget {
  const ManGhiTap({super.key, required this.kho});

  final Kho kho;

  @override
  State<ManGhiTap> createState() => _ManGhiTapState();
}

class _ManGhiTapState extends State<ManGhiTap> {
  String _loai = CongThuc.loaiDiBo;
  int _phut = 30;

  static const _ten = {
    CongThuc.loaiDiBo: Chuoi.diBo,
    CongThuc.loaiChay: Chuoi.chay,
    CongThuc.loaiDapXe: Chuoi.dapXe,
    CongThuc.loaiKhangLuc: Chuoi.khangLuc,
    CongThuc.loaiYoga: Chuoi.yoga,
  };

  Future<void> _luu() async {
    if (widget.kho.khoaGhi) return;
    await widget.kho.ghiTap(_loai, _phut);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final kho = widget.kho;
    final kcal = CongThuc.kcalTap(
      met: CongThuc.metCua(_loai),
      kg: kho.canMoi?.kg,
      phut: _phut,
    );
    return Scaffold(
      backgroundColor: Mau.giay,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
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
                  Chuoi.hoatDongO,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Mau.muc,
                  ),
                ),
              ],
            ),
            Text(kho.dongNgay, style: const TextStyle(color: Mau.mo)),
            if (kho.khoaGhi)
              const Text(Chuoi.chiXem, style: TextStyle(color: Mau.mo, fontSize: 13)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final m in CongThuc.mon)
                  _Chip(
                    chu: _ten[m.loai]!,
                    bat: _loai == m.loai,
                    onTap: kho.khoaGhi ? null : () => setState(() => _loai = m.loai),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Buoc(
                  chu: '−',
                  onTap: kho.khoaGhi || _phut <= 5
                      ? null
                      : () => setState(() => _phut -= 5),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '$_phut ${Chuoi.phut}',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Mau.muc),
                  ),
                ),
                _Buoc(
                  chu: '+',
                  onTap: kho.khoaGhi || _phut >= 180
                      ? null
                      : () => setState(() => _phut += 5),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              kcal == null
                  ? (kho.thieuCan ? Chuoi.thieuDuLieu : Chuoi.kcalTapSo(0))
                  : Chuoi.kcalTapSo(kcal.round()),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Mau.mo),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 44,
              child: FilledButton(
                onPressed: kho.khoaGhi ? null : _luu,
                child: const Text(Chuoi.luu),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.chu, required this.bat, required this.onTap});

  final String chu;
  final bool bat;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bat ? Mau.chipBat : Mau.beMat,
      shape: StadiumBorder(side: BorderSide(color: bat ? Mau.reu : Mau.vien)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(chu, style: const TextStyle(fontSize: 15, color: Mau.muc)),
          ),
        ),
      ),
    );
  }
}

class _Buoc extends StatelessWidget {
  const _Buoc({required this.chu, required this.onTap});

  final String chu;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: Mau.muc,
          side: const BorderSide(color: Mau.vien),
          padding: EdgeInsets.zero,
        ),
        child: Text(chu, style: const TextStyle(fontSize: 22)),
      ),
    );
  }
}
