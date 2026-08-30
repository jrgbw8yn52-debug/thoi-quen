import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../kho.dart';
import '../mau.dart';
import '../so.dart';

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

  @override
  void initState() {
    super.initState();
    final c = widget.kho.chiSoCua(widget.kho.selected);
    if (c?.eo != null) _eo.text = So.kg(c!.eo!);
    if (c?.hong != null) _hong.text = So.kg(c!.hong!);
    if (c?.nguc != null) _nguc.text = So.kg(c!.nguc!);
    if (c?.bapTay != null) _tay.text = So.kg(c!.bapTay!);
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
    if (widget.kho.khoaGhi) return;
    await widget.kho.ghiChiSoNgay(
      eo: So.parseEo(_eo.text),
      hong: So.parseEo(_hong.text),
      nguc: So.parseEo(_nguc.text),
      bapTay: So.parseEo(_tay.text),
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final kho = widget.kho;
    final mo = kho.moDoc;
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
            Text(kho.dongNgay, style: const TextStyle(color: Mau.mo)),
            if (kho.khoaGhi)
              const Text(Chuoi.chiXem, style: TextStyle(color: Mau.mo, fontSize: 13)),
            const SizedBox(height: 16),
            _O(nhan: Chuoi.eoCm, c: _eo, enabled: !kho.khoaGhi),
            _O(nhan: Chuoi.hongCm, c: _hong, enabled: !kho.khoaGhi),
            _O(nhan: Chuoi.ngucCm, c: _nguc, enabled: !kho.khoaGhi),
            _O(nhan: Chuoi.bapTayCm, c: _tay, enabled: !kho.khoaGhi),
            const SizedBox(height: 16),
            if (mo != null)
              Text(
                '${Chuoi.moPhanTram} ${So.kg(mo)} · ${Chuoi.uocMo}',
                style: const TextStyle(fontSize: 15, color: Mau.mo, height: 1.35),
              )
            else
              const Text(Chuoi.thieuDuLieu, style: TextStyle(color: Mau.mo)),
            const SizedBox(height: 8),
            const Text(
              Chuoi.uocTinh,
              style: TextStyle(fontSize: 13, color: Mau.mo, height: 1.35),
            ),
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

class _O extends StatelessWidget {
  const _O({required this.nhan, required this.c, required this.enabled});

  final String nhan;
  final TextEditingController c;
  final bool enabled;

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
        ],
      ),
    );
  }
}
