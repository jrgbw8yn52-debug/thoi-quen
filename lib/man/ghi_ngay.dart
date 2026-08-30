import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../cong_thuc.dart';
import '../kho.dart';
import '../mau.dart';
import '../ngay.dart';
import '../so.dart';

Future<void> moToGhi(BuildContext context, Kho kho) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Mau.beMat,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
        child: ToGhiNgay(kho: kho),
      );
    },
  );
}

class ToGhiNgay extends StatefulWidget {
  const ToGhiNgay({super.key, required this.kho});

  final Kho kho;

  @override
  State<ToGhiNgay> createState() => _ToGhiNgayState();
}

class _ToGhiNgayState extends State<ToGhiNgay> {
  final _can = TextEditingController();
  final _eo = TextEditingController();
  String _loai = CongThuc.loaiDiBo;
  int _phut = 30;
  DateTime? _gan;

  Kho get kho => widget.kho;

  @override
  void dispose() {
    _can.dispose();
    _eo.dispose();
    super.dispose();
  }

  void _dongBo() {
    if (_gan != null && Ngay.cungNgay(_gan!, kho.selected)) return;
    _gan = kho.selected;
    final c = kho.canCua(kho.selected);
    _can.text = c == null ? '' : So.kg(c.kg);
    final e = kho.dsEo.where((x) => x.ngay == Ngay.iso(kho.selected));
    _eo.text = e.isEmpty ? '' : So.kg(e.first.cm);
    final t = kho.tapCua(kho.selected);
    if (t != null) {
      _loai = t.loai;
      _phut = t.phut;
    } else {
      _loai = CongThuc.loaiDiBo;
      _phut = 30;
    }
  }

  Future<void> _luuCan() async {
    if (kho.khoaGhi) return;
    await kho.ghiCan(_can.text);
  }

  Future<void> _luuEo() async {
    if (kho.khoaGhi) return;
    await kho.ghiEo(_eo.text);
  }

  Future<void> _luuTap() async {
    if (kho.khoaGhi) return;
    await kho.ghiTap(_loai, _phut);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: kho,
      builder: (context, _) {
        _dongBo();
        final khoa = kho.khoaGhi;
        final kcal = CongThuc.kcalTap(
          met: CongThuc.metCua(_loai),
          kg: kho.canMoi?.kg,
          phut: _phut,
        );
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  Chuoi.ghiTrongNgay,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Mau.muc,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  kho.dongNgay,
                  style: const TextStyle(fontSize: 14, color: Mau.mo),
                ),
                if (khoa)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      Chuoi.chiXem,
                      style: TextStyle(fontSize: 13, color: Mau.mo),
                    ),
                  ),
                const SizedBox(height: 16),
                const Text(
                  Chuoi.canKg,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Mau.mo,
                  ),
                ),
                const SizedBox(height: 8),
                _HangNhap(
                  controller: _can,
                  suffix: Chuoi.kg,
                  enabled: !khoa,
                  onLuu: _luuCan,
                ),
                const SizedBox(height: 12),
                const Text(
                  Chuoi.eoCm,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Mau.mo,
                  ),
                ),
                const SizedBox(height: 8),
                _HangNhap(
                  controller: _eo,
                  suffix: Chuoi.cm,
                  enabled: !khoa,
                  onLuu: _luuEo,
                ),
                const SizedBox(height: 16),
                const Text(
                  Chuoi.tap,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Mau.mo,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _Chip(
                      chu: Chuoi.diBo,
                      bat: _loai == CongThuc.loaiDiBo,
                      onTap: khoa
                          ? null
                          : () => setState(() => _loai = CongThuc.loaiDiBo),
                    ),
                    const SizedBox(width: 8),
                    _Chip(
                      chu: Chuoi.khangLuc,
                      bat: _loai == CongThuc.loaiKhangLuc,
                      onTap: khoa
                          ? null
                          : () => setState(() => _loai = CongThuc.loaiKhangLuc),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _Nut(
                      chu: '−',
                      onTap: khoa || _phut <= 5
                          ? null
                          : () => setState(() => _phut -= 5),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '$_phut ${Chuoi.phut}',
                        style: const TextStyle(fontSize: 16, color: Mau.muc),
                      ),
                    ),
                    _Nut(
                      chu: '+',
                      onTap: khoa || _phut >= 180
                          ? null
                          : () => setState(() => _phut += 5),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 44,
                      child: FilledButton(
                        onPressed: khoa ? null : _luuTap,
                        child: const Text(Chuoi.luu),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  kcal == null
                      ? (kho.thieuCan ? Chuoi.thieuDuLieu : Chuoi.kcalTapSo(0))
                      : Chuoi.kcalTapSo(kcal.round()),
                  style: const TextStyle(fontSize: 14, color: Mau.mo),
                ),
                const SizedBox(height: 16),
                Opacity(
                  opacity: 0.4,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 44),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${Chuoi.anUong} · ${Chuoi.seLam}',
                        style: TextStyle(fontSize: 16, color: Mau.mo),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HangNhap extends StatelessWidget {
  const _HangNhap({
    required this.controller,
    required this.suffix,
    required this.enabled,
    required this.onLuu,
  });

  final TextEditingController controller;
  final String suffix;
  final bool enabled;
  final VoidCallback onLuu;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(suffixText: suffix),
            onSubmitted: (_) => onLuu(),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 44,
          child: FilledButton(
            onPressed: enabled ? onLuu : null,
            child: const Text(Chuoi.luu),
          ),
        ),
      ],
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
      color: bat ? Mau.chipBat : Mau.giay,
      shape: StadiumBorder(side: BorderSide(color: bat ? Mau.reu : Mau.vien)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              chu,
              style: const TextStyle(fontSize: 15, color: Mau.muc),
            ),
          ),
        ),
      ),
    );
  }
}

class _Nut extends StatelessWidget {
  const _Nut({required this.chu, required this.onTap});

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
        child: Text(chu, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
