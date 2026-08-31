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

  Future<void> _luu() async {
    await kho.luuHoSo(
      ten: _goi.text,
      cao: _cao.text,
      sex: _sex,
      dob: _dob,
      activity: _activity,
      banDau: _banDau.text,
    );
  }

  @override
  void dispose() {
    _cao.dispose();
    _goi.dispose();
    _banDau.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _napLanDau();
    final cao = So.parseCm(_cao.text) ?? kho.heightCm;
    final bmi = CongThuc.bmi(kho.canMoi?.kg, cao);
    final tuoi = CongThuc.tuoi(
      _dob == null ? null : Ngay.iso(_dob!),
      kho.homNay,
    );
    final bmr = CongThuc.bmr(
      sex: _sex,
      kg: kho.canMoi?.kg,
      cm: cao,
      tuoi: tuoi,
    );
    final tdee = CongThuc.tdee(bmr, _activity);
    final mo = CongThuc.moDeurenberg(bmi: bmi, tuoi: tuoi, sex: _sex);
    final goiY = CongThuc.kcalGoiY(
      tdee: tdee,
      nhip: kho.nhipKg,
      kg: kho.canMoi?.kg,
      target: kho.targetKg,
    );
    final duSo = bmi != null && bmr != null && tdee != null;

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
            const SizedBox(height: 8),
            const Text(
              Chuoi.uocTinh,
              style: TextStyle(fontSize: 13, color: Mau.mo, height: 1.35),
            ),
            const SizedBox(height: 20),
            const Text(
              Chuoi.hienTai,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Mau.muc,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              Chuoi.tenGoi,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Mau.mo,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _goi,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(hintText: Chuoi.tenGoi),
            ),
            const SizedBox(height: 16),
            const Text(
              Chuoi.gioi,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Mau.mo,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _ChipChon(
                  chu: Chuoi.nam,
                  bat: _sex == 'nam',
                  onTap: () => setState(() => _sex = 'nam'),
                ),
                const SizedBox(width: 8),
                _ChipChon(
                  chu: Chuoi.nu,
                  bat: _sex == 'nu',
                  onTap: () => setState(() => _sex = 'nu'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              Chuoi.ngaySinh,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Mau.mo,
              ),
            ),
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
                        style: TextStyle(
                          fontSize: 15,
                          color: _dob == null ? Mau.mo : Mau.muc,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              Chuoi.chieuCao,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Mau.mo,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _cao,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(suffixText: Chuoi.cm),
            ),
            const SizedBox(height: 16),
            const Text(
              Chuoi.canBanDau,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Mau.mo,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('can-ban-dau'),
              controller: _banDau,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(suffixText: Chuoi.kg),
            ),
            const SizedBox(height: 16),
            const Text(
              Chuoi.mucHoatDong,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Mau.mo,
              ),
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < CongThuc.heSo.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _ChipChon(
                  chu: Chuoi.heSoNhan[i],
                  bat: (_activity - CongThuc.heSo[i]).abs() < 0.0001,
                  onTap: () => setState(() => _activity = CongThuc.heSo[i]),
                ),
              ),
            const SizedBox(height: 20),
            SizedBox(
              height: 44,
              width: double.infinity,
              child: FilledButton(
                onPressed: _luu,
                child: const Text(Chuoi.luuHoSo),
              ),
            ),
            const SizedBox(height: 28),
            if (duSo) ...[
              _HangSo(
                nhan: Chuoi.bmi,
                giaTri: So.kg(bmi),
                phu: CongThuc.bmiNhan(bmi),
              ),
              if (mo != null)
                _HangSo(
                  nhan: Chuoi.moPhanTram,
                  giaTri: So.kg(mo),
                  phu: Chuoi.uocMo,
                ),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  Chuoi.mocA,
                  style: TextStyle(fontSize: 13, color: Mau.mo),
                ),
              ),
              _HangSo(nhan: Chuoi.bmr, giaTri: '${bmr.round()}'),
              _HangSo(
                nhan: Chuoi.tdee,
                giaTri: '${tdee.round()}',
                phu: Chuoi.saiSo,
              ),
              if (goiY != null)
                _HangSo(nhan: Chuoi.kcalGoiY, giaTri: '$goiY'),
            ] else
              Text(
                kho.thieuCan ? Chuoi.themCan : Chuoi.thieuDuLieu,
                style: const TextStyle(fontSize: 15, color: Mau.mo),
              ),
            const SizedBox(height: 12),
            const Text(
              Chuoi.uocTinh,
              style: TextStyle(fontSize: 13, color: Mau.mo, height: 1.35),
            ),
          ],
        ),
      ),
    );
  }
}

class _HangSo extends StatelessWidget {
  const _HangSo({required this.nhan, required this.giaTri, this.phu});

  final String nhan;
  final String giaTri;
  final String? phu;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(nhan, style: const TextStyle(fontSize: 15, color: Mau.mo)),
          const SizedBox(width: 12),
          Text(
            giaTri,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Mau.muc,
            ),
          ),
          if (phu != null) ...[
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                phu!,
                style: const TextStyle(fontSize: 13, color: Mau.mo),
              ),
            ),
          ],
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
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Mau.muc,
                height: 1.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
