import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../kho.dart';
import '../mau.dart';
import '../ngay.dart';
import '../so.dart';
import '../widget/lan_ngay.dart';

class ManGhiChiSo extends StatefulWidget {
  const ManGhiChiSo({super.key, required this.kho});

  final Kho kho;

  @override
  State<ManGhiChiSo> createState() => _ManGhiChiSoState();
}

class _ManGhiChiSoState extends State<ManGhiChiSo> {
  final _eo = TextEditingController();
  final _hong = TextEditingController();
  final _nguc = TextEditingController();
  final _tay = TextEditingController();
  String _iso = '';

  Kho get kho => widget.kho;

  void _napO() {
    final iso = Ngay.iso(kho.selected);
    if (iso == _iso) return;
    _iso = iso;
    final c = kho.chiSoCua(kho.selected);
    _eo.text = c?.eo == null ? '' : So.kg(c!.eo!);
    _hong.text = c?.hong == null ? '' : So.kg(c!.hong!);
    _nguc.text = c?.nguc == null ? '' : So.kg(c!.nguc!);
    _tay.text = c?.bapTay == null ? '' : So.kg(c!.bapTay!);
  }

  @override
  void dispose() {
    _eo.dispose();
    _hong.dispose();
    _nguc.dispose();
    _tay.dispose();
    super.dispose();
  }

  Future<void> _luu() async {
    if (kho.khoaGhi) return;
    await kho.ghiChiSoNgay(
      eo: So.parseEo(_eo.text),
      hong: So.parseEo(_hong.text),
      nguc: So.parseEo(_nguc.text),
      bapTay: So.parseEo(_tay.text),
    );
    _iso = '';
    if (mounted) setState(_napO);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: kho,
      builder: (context, _) {
        _napO();
        final d = kho.selected;
        final c = kho.chiSoCua(d);
        final doiEo = kho.doiDo(d, lay: (x) => x.eo, moc0: kho.startEo, hien: c?.eo ?? So.parseEo(_eo.text));
        final doiHong = kho.doiDo(d, lay: (x) => x.hong, moc0: kho.startHong, hien: c?.hong ?? So.parseEo(_hong.text));
        final doiNguc = kho.doiDo(d, lay: (x) => x.nguc, moc0: kho.startNguc, hien: c?.nguc ?? So.parseEo(_nguc.text));
        final doiTay = kho.doiDo(d, lay: (x) => x.bapTay, moc0: kho.startBapTay, hien: c?.bapTay ?? So.parseEo(_tay.text));
        final duSo = kho.bmiDoc != null && kho.bmrDoc != null && kho.tdeeDoc != null;
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
                      Chuoi.chiSo,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Mau.muc),
                    ),
                  ],
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    key: const Key('tieu-de-chi-so'),
                    onTap: () => moLanNgay(context, kho),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 44),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(kho.dongNgay, style: const TextStyle(color: Mau.mo, fontSize: 15)),
                      ),
                    ),
                  ),
                ),
                if (kho.khoaGhi)
                  const Text(Chuoi.chiXem, style: TextStyle(color: Mau.mo, fontSize: 13)),
                const SizedBox(height: 16),
                _O(nhan: Chuoi.eoCm, c: _eo, enabled: !kho.khoaGhi, doi: doiEo),
                _O(nhan: Chuoi.hongCm, c: _hong, enabled: !kho.khoaGhi, doi: doiHong),
                _O(nhan: Chuoi.ngucCm, c: _nguc, enabled: !kho.khoaGhi, doi: doiNguc),
                _O(nhan: Chuoi.bapTayCm, c: _tay, enabled: !kho.khoaGhi, doi: doiTay),
                const SizedBox(height: 8),
                SizedBox(
                  height: 44,
                  child: FilledButton(
                    onPressed: kho.khoaGhi ? null : _luu,
                    child: const Text(Chuoi.luu),
                  ),
                ),
                const SizedBox(height: 28),
                if (duSo) ...[
                  _HangSo(nhan: Chuoi.bmi, giaTri: So.kg(kho.bmiDoc!), phu: kho.bmiNhan),
                  if (kho.moDoc != null)
                    _HangSo(nhan: Chuoi.moPhanTram, giaTri: So.kg(kho.moDoc!), phu: Chuoi.uocMo),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(Chuoi.mocA, style: TextStyle(fontSize: 13, color: Mau.mo)),
                  ),
                  _HangSo(nhan: Chuoi.bmr, giaTri: '${kho.bmrDoc!.round()}'),
                  _HangSo(nhan: Chuoi.tdee, giaTri: '${kho.tdeeDoc!.round()}', phu: Chuoi.saiSo),
                  if (kho.kcalGoiYDoc != null)
                    _HangSo(nhan: Chuoi.kcalGoiY, giaTri: '${kho.kcalGoiYDoc}'),
                ] else
                  Text(
                    kho.thieuCan ? Chuoi.themCan : Chuoi.thieuDuLieu,
                    style: const TextStyle(fontSize: 15, color: Mau.mo),
                  ),
                const SizedBox(height: 12),
                const Text(Chuoi.uocTinh, style: TextStyle(fontSize: 13, color: Mau.mo, height: 1.35)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _O extends StatelessWidget {
  const _O({required this.nhan, required this.c, required this.enabled, this.doi});

  final String nhan;
  final TextEditingController c;
  final bool enabled;
  final ({double delta, int ngay})? doi;

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
            enabled: enabled,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(suffixText: Chuoi.cm),
          ),
          if (doi != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                Chuoi.doiCm(doi!.delta, doi!.ngay),
                style: const TextStyle(fontSize: 13, color: Mau.mo),
              ),
            ),
        ],
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
