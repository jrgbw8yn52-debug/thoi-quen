import 'dart:math' as math;

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
                Row(
                  children: [
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          key: const Key('tieu-de-chi-so'),
                          onTap: () => moLanNgay(context, kho),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 44),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                kho.dongNgay,
                                style: const TextStyle(color: Mau.mo, fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      key: const Key('nut-hom-nay-chi-so'),
                      onPressed: kho.veHomNay,
                      child: const Text(Chuoi.homNay),
                    ),
                  ],
                ),
                if (kho.khoaGhi)
                  const Text(Chuoi.chiXem, style: TextStyle(color: Mau.mo, fontSize: 13)),
                const SizedBox(height: 16),
                _O(
                  nhan: Chuoi.eoCm,
                  c: _eo,
                  enabled: !kho.khoaGhi,
                  truoc: kho.doiLanTruoc(d, lay: (x) => x.eo, hien: c?.eo ?? So.parseEo(_eo.text)),
                  dau: kho.doiBanDau(d, moc0: kho.startEo, hien: c?.eo ?? So.parseEo(_eo.text)),
                ),
                _O(
                  nhan: Chuoi.hongCm,
                  c: _hong,
                  enabled: !kho.khoaGhi,
                  truoc: kho.doiLanTruoc(d, lay: (x) => x.hong, hien: c?.hong ?? So.parseEo(_hong.text)),
                  dau: kho.doiBanDau(d, moc0: kho.startHong, hien: c?.hong ?? So.parseEo(_hong.text)),
                ),
                _O(
                  nhan: Chuoi.ngucCm,
                  c: _nguc,
                  enabled: !kho.khoaGhi,
                  truoc: kho.doiLanTruoc(d, lay: (x) => x.nguc, hien: c?.nguc ?? So.parseEo(_nguc.text)),
                  dau: kho.doiBanDau(d, moc0: kho.startNguc, hien: c?.nguc ?? So.parseEo(_nguc.text)),
                ),
                _O(
                  nhan: Chuoi.bapTayCm,
                  c: _tay,
                  enabled: !kho.khoaGhi,
                  truoc: kho.doiLanTruoc(d, lay: (x) => x.bapTay, hien: c?.bapTay ?? So.parseEo(_tay.text)),
                  dau: kho.doiBanDau(d, moc0: kho.startBapTay, hien: c?.bapTay ?? So.parseEo(_tay.text)),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 44,
                  child: FilledButton(
                    onPressed: kho.khoaGhi ? null : _luu,
                    child: const Text(Chuoi.luu),
                  ),
                ),
                const SizedBox(height: 28),
                _CotSoDo(nhom: kho.nhomSoDo(d)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _O extends StatelessWidget {
  const _O({
    required this.nhan,
    required this.c,
    required this.enabled,
    this.truoc,
    this.dau,
  });

  final String nhan;
  final TextEditingController c;
  final bool enabled;
  final ({double delta, int ngay})? truoc;
  final ({double delta, int ngay})? dau;

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
          if (truoc != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                Chuoi.soVoiLanTruocDong(truoc!.delta, truoc!.ngay),
                style: const TextStyle(fontSize: 13, color: Mau.mo),
              ),
            ),
          if (dau != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                Chuoi.soVoiBanDauDong(dau!.delta, dau!.ngay),
                style: const TextStyle(fontSize: 13, color: Mau.mo),
              ),
            ),
        ],
      ),
    );
  }
}

class _CotSoDo extends StatelessWidget {
  const _CotSoDo({required this.nhom});

  final List<({String ten, double? ban, double? moi})> nhom;

  @override
  Widget build(BuildContext context) {
    if (nhom.every((n) => n.ban == null && n.moi == null)) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          Chuoi.soDoSoVoiBanDau,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo),
        ),
        const SizedBox(height: 8),
        const Row(
          children: [
            _ChuThich(mau: Mau.mo, chu: Chuoi.banDau),
            SizedBox(width: 16),
            _ChuThich(mau: Mau.muc, chu: Chuoi.moiNhat),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          key: const Key('cot-so-do'),
          height: 132,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final n in nhom)
                Expanded(child: _NhomCot(nhom: n)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChuThich extends StatelessWidget {
  const _ChuThich({required this.mau, required this.chu});

  final Color mau;
  final String chu;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, color: mau),
        const SizedBox(width: 6),
        Text(chu, style: const TextStyle(fontSize: 12, color: Mau.mo)),
      ],
    );
  }
}

class _NhomCot extends StatelessWidget {
  const _NhomCot({required this.nhom});

  final ({String ten, double? ban, double? moi}) nhom;

  Color get _mauMoi {
    final b = nhom.ban;
    final m = nhom.moi;
    if (b == null || m == null) return Mau.muc;
    if (m < b - 0.05) return Mau.reu;
    if (m > b + 0.05) return Mau.canhBao;
    return Mau.muc;
  }

  @override
  Widget build(BuildContext context) {
    final maxV = math.max(nhom.ban ?? 0, nhom.moi ?? 0);
    double f(double? v) {
      if (v == null || maxV <= 0) return 0.06;
      return math.max(0.06, v / maxV);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: f(nhom.ban),
                      widthFactor: 0.7,
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          color: Mau.mo,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: f(nhom.moi),
                      widthFactor: 0.7,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: _mauMoi,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            nhom.ten,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: Mau.mo),
          ),
        ],
      ),
    );
  }
}
