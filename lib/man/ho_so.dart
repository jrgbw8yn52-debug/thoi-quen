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
  final _can = TextEditingController();
  final _cao = TextEditingController();
  final _dich = TextEditingController();
  final _goi = TextEditingController();

  @override
  void dispose() {
    _can.dispose();
    _cao.dispose();
    _dich.dispose();
    _goi.dispose();
    super.dispose();
  }

  Kho get kho => widget.kho;

  Future<void> _luuCan() async {
    await kho.ghiCan(_can.text, ngay: kho.homNay);
  }

  Future<void> _moSinh() async {
    final goc = kho.dob != null
        ? Ngay.parse(kho.dob!)
        : DateTime(kho.homNay.year - 30);
    final d = await moLanSinh(
      context: context,
      goc: goc,
      homNay: kho.homNay,
    );
    if (d != null) await kho.suaNgaySinh(d);
  }

  @override
  Widget build(BuildContext context) {
    final kho = this.kho;
    if (kho.heightCm != null && _cao.text.isEmpty) {
      _cao.text = So.kg(kho.heightCm!);
    }
    if (kho.targetKg != null && _dich.text.isEmpty) {
      _dich.text = So.kg(kho.targetKg!);
    }
    if (kho.tenGoi != null && _goi.text.isEmpty) {
      _goi.text = kho.tenGoi!;
    }
    if (kho.canMoi != null && _can.text.isEmpty) {
      _can.text = So.kg(kho.canMoi!.kg);
    }
    final bmi = kho.bmiDoc;
    final bmr = kho.bmrDoc;
    final tdee = kho.tdeeDoc;
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
              Chuoi.tenGoi,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Mau.mo,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _goi,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(hintText: Chuoi.tenGoi),
                    onSubmitted: (v) => kho.suaTenGoi(v),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 44,
                  child: FilledButton(
                    onPressed: () => kho.suaTenGoi(_goi.text),
                    child: const Text(Chuoi.luu),
                  ),
                ),
              ],
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
                  bat: kho.sex == 'nam',
                  onTap: () => kho.suaGioi('nam'),
                ),
                const SizedBox(width: 8),
                _ChipChon(
                  chu: Chuoi.nu,
                  bat: kho.sex == 'nu',
                  onTap: () => kho.suaGioi('nu'),
                ),
              ],
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cao,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(suffixText: Chuoi.cm),
                    onSubmitted: (v) => kho.suaChieuCao(v),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 44,
                  child: FilledButton(
                    onPressed: () => kho.suaChieuCao(_cao.text),
                    child: const Text(Chuoi.luu),
                  ),
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
                        kho.dob == null
                            ? Chuoi.ngaySinh
                            : Chuoi.dongNgay(Ngay.parse(kho.dob!)),
                        style: TextStyle(
                          fontSize: 15,
                          color: kho.dob == null ? Mau.mo : Mau.muc,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < CongThuc.heSo.length; i++)
                  _ChipChon(
                    chu: Chuoi.heSoNhan[i],
                    bat: (kho.activity - CongThuc.heSo[i]).abs() < 0.0001,
                    onTap: () => kho.suaHoatDong(CongThuc.heSo[i]),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              Chuoi.canDich,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Mau.mo,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _dich,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(suffixText: Chuoi.kg),
                    onSubmitted: (v) => kho.suaCanDich(v),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 44,
                  child: FilledButton(
                    onPressed: () => kho.suaCanDich(_dich.text),
                    child: const Text(Chuoi.luu),
                  ),
                ),
              ],
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _can,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      hintText: Chuoi.kg,
                      suffixText: Chuoi.kg,
                    ),
                    onSubmitted: (_) => _luuCan(),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 44,
                  child: FilledButton(
                    onPressed: _luuCan,
                    child: const Text(Chuoi.luu),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            if (duSo) ...[
              _HangSo(
                nhan: Chuoi.bmi,
                giaTri: So.kg(bmi),
                phu: kho.bmiNhan,
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
              if (kho.conToiDich != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    kho.conToiDich!,
                    style: const TextStyle(fontSize: 15, color: Mau.muc),
                  ),
                ),
              if (kho.nhipDoc != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    kho.nhipDoc!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Mau.mo,
                      height: 1.35,
                    ),
                  ),
                ),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
