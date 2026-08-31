import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../cong_thuc.dart';
import '../kho.dart';
import '../mau.dart';
import '../so.dart';

class ManGhiCan extends StatefulWidget {
  const ManGhiCan({super.key, required this.kho});

  final Kho kho;

  @override
  State<ManGhiCan> createState() => _ManGhiCanState();
}

class _ManGhiCanState extends State<ManGhiCan> {
  late double _kg;
  late final TextEditingController _so;
  bool _banPhim = false;

  @override
  void initState() {
    super.initState();
    final c = widget.kho.canCua(widget.kho.selected) ?? widget.kho.canMoi;
    _kg = c?.kg ?? 0;
    _so = TextEditingController(text: _kg > 0 ? So.kg(_kg) : '');
    _so.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _so.dispose();
    super.dispose();
  }

  void _tuSo() {
    final v = So.parseKg(_so.text);
    if (v != null) _kg = v;
  }

  void _buoc(double d) {
    _tuSo();
    setState(() {
      _kg = ((_kg + d) * 10).round() / 10;
      if (_kg < 0) _kg = 0;
      if (_kg > 400) _kg = 400;
      _banPhim = false;
      _so.text = _kg > 0 ? So.kg(_kg) : '';
    });
  }

  Future<void> _luu() async {
    if (widget.kho.khoaGhi) return;
    _tuSo();
    if (_kg <= 0) return;
    await widget.kho.ghiCanKg(_kg);
    if (mounted) Navigator.pop(context);
  }

  double? get _kgHien =>
      So.parseKg(_so.text) ?? (_kg > 0 ? _kg : widget.kho.canMoi?.kg);

  @override
  Widget build(BuildContext context) {
    final kho = widget.kho;
    final kg = _kgHien;
    final tuoi = CongThuc.tuoi(kho.dob, kho.homNay);
    final bmi = CongThuc.bmi(kg, kho.heightCm);
    final bmr = CongThuc.bmr(sex: kho.sex, kg: kg, cm: kho.heightCm, tuoi: tuoi);
    final tdee = CongThuc.tdee(bmr, kho.activity);
    final mo = CongThuc.moDeurenberg(bmi: bmi, tuoi: tuoi, sex: kho.sex);
    final goi = CongThuc.kcalGoiY(
      tdee: tdee,
      nhip: kho.nhipKg,
      kg: kg,
      target: kho.targetKg,
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
                  Chuoi.canNang,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Mau.muc,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(kho.dongNgay, style: const TextStyle(color: Mau.mo)),
            if (kho.khoaGhi)
              const Text(Chuoi.chiXem, style: TextStyle(color: Mau.mo, fontSize: 13)),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Buoc(chu: '−', onTap: kho.khoaGhi ? null : () => _buoc(-0.1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _banPhim
                      ? SizedBox(
                          width: 140,
                          child: TextField(
                            key: const Key('so-kg'),
                            controller: _so,
                            autofocus: true,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w600,
                              color: Mau.muc,
                            ),
                            decoration: const InputDecoration(
                              suffixText: Chuoi.kg,
                              border: InputBorder.none,
                            ),
                            onSubmitted: (_) => _luu(),
                          ),
                        )
                      : InkWell(
                          key: const Key('so-kg-nhan'),
                          onTap: kho.khoaGhi
                              ? null
                              : () => setState(() {
                                    _banPhim = true;
                                    _so.text = _kg > 0 ? So.kg(_kg) : '';
                                  }),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            child: Text(
                              '${So.kg(_kg)} ${Chuoi.kg}',
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w600,
                                color: Mau.muc,
                              ),
                            ),
                          ),
                        ),
                ),
                _Buoc(chu: '+', onTap: kho.khoaGhi ? null : () => _buoc(0.1)),
              ],
            ),
            const SizedBox(height: 28),
            if (bmi != null && bmr != null && tdee != null) ...[
              _HangSo(nhan: Chuoi.bmi, giaTri: So.kg(bmi), phu: CongThuc.bmiNhan(bmi)),
              if (mo != null)
                _HangSo(nhan: Chuoi.moPhanTram, giaTri: So.kg(mo), phu: Chuoi.uocMo),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(Chuoi.mocA, style: TextStyle(fontSize: 13, color: Mau.mo)),
              ),
              _HangSo(nhan: Chuoi.bmr, giaTri: '${bmr.round()}'),
              _HangSo(nhan: Chuoi.tdee, giaTri: '${tdee.round()}', phu: Chuoi.saiSo),
              if (goi != null) _HangSo(nhan: Chuoi.kcalGoiY, giaTri: '$goi'),
            ] else
              Text(
                kg == null ? Chuoi.themCan : Chuoi.thieuDuLieu,
                style: const TextStyle(fontSize: 15, color: Mau.mo),
              ),
            const SizedBox(height: 12),
            const Text(Chuoi.uocTinh, style: TextStyle(fontSize: 13, color: Mau.mo, height: 1.35)),
            const SizedBox(height: 24),
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
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Mau.muc),
          ),
          if (phu != null) ...[
            const SizedBox(width: 8),
            Expanded(child: Text(phu!, style: const TextStyle(fontSize: 13, color: Mau.mo))),
          ],
        ],
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
