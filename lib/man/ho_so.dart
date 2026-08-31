import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../cong_thuc.dart';
import '../kho.dart';
import '../mau.dart';
import '../ngay.dart';
import '../so.dart';
import '../widget/lan_ngay.dart';

class ManHoSo extends StatefulWidget {
  const ManHoSo({super.key, required this.kho});

  final Kho kho;

  @override
  State<ManHoSo> createState() => _ManHoSoState();
}

class _ManHoSoState extends State<ManHoSo> {
  final _cao = TextEditingController();
  final _goi = TextEditingController();
  final _banDau = TextEditingController();
  final _eo0 = TextEditingController();
  final _hong0 = TextEditingController();
  final _nguc0 = TextEditingController();
  final _tay0 = TextEditingController();
  String? _sex;
  DateTime? _dob;
  double _activity = 1.2;
  bool _nap = false;

  Kho get kho => widget.kho;

  void _napLanDau() {
    if (_nap) return;
    _nap = true;
    if (kho.heightCm != null) _cao.text = So.kg(kho.heightCm!);
    if (kho.tenGoi != null) _goi.text = kho.tenGoi!;
    _sex = kho.sex;
    _dob = kho.dob == null ? null : Ngay.parse(kho.dob!);
    _activity = kho.activity;
    final bd = kho.startKg ??
        (kho.dsCan.isEmpty ? kho.canMoi?.kg : kho.dsCan.last.kg);
    if (bd != null) _banDau.text = So.kg(bd);
    if (kho.startEo != null) _eo0.text = So.kg(kho.startEo!);
    if (kho.startHong != null) _hong0.text = So.kg(kho.startHong!);
    if (kho.startNguc != null) _nguc0.text = So.kg(kho.startNguc!);
    if (kho.startBapTay != null) _tay0.text = So.kg(kho.startBapTay!);
  }

  Future<void> _moSinh() async {
    final goc = _dob ?? DateTime(kho.homNay.year - 30);
    final d = await moLanSinh(
      context: context,
      goc: goc,
      homNay: kho.homNay,
    );
    if (d != null) setState(() => _dob = d);
  }

  Future<void> _moHeSo() async {
    var tam = _activity;
    var i0 = CongThuc.heSo.indexWhere((h) => (h - _activity).abs() < 0.0001);
    if (i0 < 0) i0 = 0;
    final ok = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Mau.beMat,
      builder: (ctx) {
        return SafeArea(
          child: SizedBox(
            height: 280,
            child: Column(
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text(Chuoi.huy),
                    ),
                    const Expanded(
                      child: Text(
                        Chuoi.mucHoatDong,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Mau.muc),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text(Chuoi.xong),
                    ),
                  ],
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 44,
                    scrollController: FixedExtentScrollController(initialItem: i0),
                    onSelectedItemChanged: (i) => tam = CongThuc.heSo[i],
                    children: [
                      for (final s in Chuoi.heSoNhan)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              s,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 15, color: Mau.muc),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (ok == true) setState(() => _activity = tam);
  }

  Future<void> _luu() async {
    await kho.luuHoSo(
      ten: _goi.text,
      cao: _cao.text,
      sex: _sex,
      dob: _dob,
      activity: _activity,
      banDau: _banDau.text,
      eo0: _eo0.text,
      hong0: _hong0.text,
      nguc0: _nguc0.text,
      tay0: _tay0.text,
    );
    if (mounted) Navigator.pop(context);
  }

  String get _nhanHeSo {
    final i = CongThuc.heSo.indexWhere((h) => (h - _activity).abs() < 0.0001);
    if (i < 0) return Chuoi.mucHoatDong;
    return Chuoi.heSoNhan[i];
  }

  @override
  void dispose() {
    _cao.dispose();
    _goi.dispose();
    _banDau.dispose();
    _eo0.dispose();
    _hong0.dispose();
    _nguc0.dispose();
    _tay0.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _napLanDau();
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
                const Expanded(
                  child: Text(
                    Chuoi.hoSoChiSo,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Mau.muc,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              Chuoi.hienTai,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Mau.muc),
            ),
            const SizedBox(height: 16),
            const Text(Chuoi.tenGoi, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo)),
            const SizedBox(height: 8),
            TextField(
              controller: _goi,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(hintText: Chuoi.tenGoi),
            ),
            const SizedBox(height: 16),
            const Text(Chuoi.gioi, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo)),
            const SizedBox(height: 8),
            Row(
              children: [
                _ChipChon(chu: Chuoi.nam, bat: _sex == 'nam', onTap: () => setState(() => _sex = 'nam')),
                const SizedBox(width: 8),
                _ChipChon(chu: Chuoi.nu, bat: _sex == 'nu', onTap: () => setState(() => _sex = 'nu')),
              ],
            ),
            const SizedBox(height: 16),
            const Text(Chuoi.ngaySinh, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo)),
            const SizedBox(height: 8),
            Material(
              color: Mau.beMat,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: _moSinh,
                borderRadius: BorderRadius.circular(12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 44),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _dob == null ? Chuoi.ngaySinh : Chuoi.dongNgay(_dob!),
                        style: TextStyle(fontSize: 15, color: _dob == null ? Mau.mo : Mau.muc),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(Chuoi.chieuCao, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo)),
            const SizedBox(height: 8),
            TextField(
              controller: _cao,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(suffixText: Chuoi.cm),
            ),
            const SizedBox(height: 16),
            const Text(Chuoi.canBanDau, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo)),
            const SizedBox(height: 8),
            TextField(
              key: const Key('can-ban-dau'),
              controller: _banDau,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(suffixText: Chuoi.kg),
            ),
            const SizedBox(height: 16),
            const Text(Chuoi.mucHoatDong, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo)),
            const SizedBox(height: 8),
            Material(
              color: Mau.beMat,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                key: const Key('he-so-picker'),
                onTap: _moHeSo,
                borderRadius: BorderRadius.circular(12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 44),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(_nhanHeSo, style: const TextStyle(fontSize: 15, color: Mau.muc)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              Chuoi.soDoBanDau,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Mau.muc),
            ),
            const SizedBox(height: 16),
            _O(nhan: Chuoi.eoCm, c: _eo0),
            _O(nhan: Chuoi.hongCm, c: _hong0),
            _O(nhan: Chuoi.ngucCm, c: _nguc0),
            _O(nhan: Chuoi.bapTayCm, c: _tay0),
            const SizedBox(height: 8),
            SizedBox(
              height: 44,
              width: double.infinity,
              child: FilledButton(
                onPressed: _luu,
                child: const Text(Chuoi.luuHoSo),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _O extends StatelessWidget {
  const _O({required this.nhan, required this.c});

  final String nhan;
  final TextEditingController c;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(nhan, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo)),
          const SizedBox(height: 6),
          TextField(
            controller: c,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(suffixText: Chuoi.cm),
          ),
        ],
      ),
    );
  }
}

class _ChipChon extends StatelessWidget {
  const _ChipChon({required this.chu, required this.bat, required this.onTap});

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
          constraints: const BoxConstraints(minHeight: 44),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              chu,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Mau.muc, height: 1.3),
            ),
          ),
        ),
      ),
    );
  }
}
