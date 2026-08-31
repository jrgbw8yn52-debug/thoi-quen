import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../cong_thuc.dart';
import '../db/database.dart';
import '../kho.dart';
import '../mau.dart';
import '../so.dart';
import '../widget/hang_habit.dart';

class ManGhiNap extends StatefulWidget {
  const ManGhiNap({super.key, required this.kho});

  final Kho kho;

  @override
  State<ManGhiNap> createState() => _ManGhiNapState();
}

class _ManGhiNapState extends State<ManGhiNap> {
  Kho get kho => widget.kho;

  Future<void> _suaLog(FoodLog log) async {
    if (kho.khoaGhi) return;
    final c = TextEditingController(text: '${log.kcal}');
    final v = await showDialog<int>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Mau.beMat,
          title: Text(log.ten, style: const TextStyle(color: Mau.muc)),
          content: TextField(
            controller: c,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(suffixText: 'kcal'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(Chuoi.huy),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, So.parseKcal(c.text)),
              child: const Text(Chuoi.luu),
            ),
          ],
        );
      },
    );
    c.dispose();
    if (v == null) return;
    await kho.suaLog(log.id, kcal: v);
  }

  void _moTao() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Mau.beMat,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
          child: _ToTaoCongThuc(kho: kho),
        );
      },
    );
  }

  void _moKho() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Mau.beMat,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
          child: _ToMonDaLuu(kho: kho),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: kho,
      builder: (context, _) {
        final goi = kho.kcalGoiYDoc;
        final tdee = kho.tdeeDoc;
        final nap = kho.kcalNapCuaNgay(kho.selected);
        final logs = kho.logNgay(kho.selected);
        final mac = kho.macroNgay(kho.selected);
        final nhan = logs.isEmpty ? null : CongThuc.nhanNap(nap, goi);
        final mau = switch (nhan) {
          NhanNap.vuot => Mau.canhBao,
          NhanNap.dung => Mau.reu,
          NhanNap.hoiThap => Mau.mo,
          NhanNap.quaThap => Mau.muc,
          null => Mau.muc,
        };
        final chuNhan = switch (nhan) {
          NhanNap.vuot => Chuoi.vuotChiTieu,
          NhanNap.dung => Chuoi.dungChiTieu,
          NhanNap.hoiThap => Chuoi.hoiThap,
          NhanNap.quaThap => Chuoi.quaThap,
          null => null,
        };
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
                      Chuoi.nhatKy,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Mau.muc),
                    ),
                  ],
                ),
                Text(kho.dongNgay, style: const TextStyle(color: Mau.mo)),
                if (kho.khoaGhi)
                  const Text(Chuoi.chiXem, style: TextStyle(color: Mau.mo, fontSize: 13)),
                const SizedBox(height: 12),
                if (goi != null && tdee != null)
                  Text(
                    Chuoi.tdeeGoiY(tdee.round(), goi),
                    style: const TextStyle(fontSize: 15, color: Mau.mo),
                  ),
                const SizedBox(height: 20),
                const Text(
                  Chuoi.thucDonHomNay,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Mau.muc),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: FilledButton(
                          key: const Key('nut-tao-cong-thuc'),
                          onPressed: _moTao,
                          child: const Text(Chuoi.taoCongThuc),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: OutlinedButton(
                          key: const Key('nut-mon-da-luu'),
                          onPressed: _moKho,
                          child: const Text(Chuoi.monDaLuu),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                for (final l in logs)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: HangVuot(
                      key: Key('log-${l.id}'),
                      choVuot: !kho.khoaGhi,
                      onSua: kho.khoaGhi ? null : () => _suaLog(l),
                      onXoa: () => kho.xoaLog(l.id),
                      child: Material(
                        color: Mau.beMat,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 44),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                Chuoi.dongMon(l.ten, l.kcal),
                                style: const TextStyle(fontSize: 15, color: Mau.muc),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                if (logs.isNotEmpty && goi != null) ...[
                  Text(
                    Chuoi.napTrenGoi(nap, goi),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: mau),
                  ),
                  if (chuNhan != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(chuNhan, style: TextStyle(fontSize: 15, color: mau)),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      Chuoi.damBotBeo(mac.dam, mac.bot, mac.beo),
                      style: const TextStyle(fontSize: 15, color: Mau.mo),
                    ),
                  ),
                ] else if (logs.isNotEmpty) ...[
                  Text(
                    '$nap',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Mau.muc),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      Chuoi.damBotBeo(mac.dam, mac.bot, mac.beo),
                      style: const TextStyle(fontSize: 15, color: Mau.mo),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ToTaoCongThuc extends StatefulWidget {
  const _ToTaoCongThuc({required this.kho});

  final Kho kho;

  @override
  State<_ToTaoCongThuc> createState() => _ToTaoCongThucState();
}

class _ToTaoCongThucState extends State<_ToTaoCongThuc> {
  final _ten = TextEditingController();
  final _dan = TextEditingController();
  final _kcal = TextEditingController();
  final _gram = TextEditingController();
  final _dam = TextEditingController();
  final _bot = TextEditingController();
  final _beo = TextEditingController();
  bool _suaTay = false;

  Kho get kho => widget.kho;

  @override
  void initState() {
    super.initState();
    _dan.addListener(_docDan);
    _kcal.addListener(_ve);
    _dam.addListener(_ve);
    _bot.addListener(_ve);
    _beo.addListener(_ve);
  }

  void _ve() {
    if (mounted) setState(() {});
  }

  void _docDan() {
    if (_suaTay) {
      _ve();
      return;
    }
    final d = CongThuc.docMon(_dan.text);
    if (d.kcal != null) _kcal.text = '${d.kcal}';
    if (d.gram != null) _gram.text = So.kg(d.gram!);
    if (d.dam != null) _dam.text = So.kg(d.dam!);
    if (d.bot != null) _bot.text = So.kg(d.bot!);
    if (d.beo != null) _beo.text = So.kg(d.beo!);
    if (d.ten != null && _ten.text.trim().isEmpty) _ten.text = d.ten!;
    _ve();
  }

  @override
  void dispose() {
    _dan.removeListener(_docDan);
    _ten.dispose();
    _dan.dispose();
    _kcal.dispose();
    _gram.dispose();
    _dam.dispose();
    _bot.dispose();
    _beo.dispose();
    super.dispose();
  }

  Future<void> _luuCongThuc() async {
    final ten = _ten.text.trim();
    final kcal = So.parseKcal(_kcal.text);
    if (ten.isEmpty || kcal == null) return;
    final g = So.parseG(_gram.text);
    final dam = So.parseMacro(_dam.text);
    final bot = So.parseMacro(_bot.text);
    final beo = So.parseMacro(_beo.text);
    final van = _dan.text.trim();
    String? chon = 'kho';
    if (mounted) {
      chon = await showDialog<String>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Mau.beMat,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!kho.khoaGhi)
                  TextButton(
                    key: const Key('tinh-vao-ngay'),
                    onPressed: () => Navigator.pop(ctx, 'ngay'),
                    child: const Text(Chuoi.tinhVaoThucDon),
                  ),
                TextButton(
                  key: const Key('chi-luu-kho'),
                  onPressed: () => Navigator.pop(ctx, 'kho'),
                  child: const Text(Chuoi.chiLuuKho),
                ),
              ],
            ),
          );
        },
      );
    }
    if (chon == null) return;
    await kho.luuMon(
      ten: ten,
      kcal: kcal,
      gram: g,
      vanBan: van.isEmpty ? null : van,
      dam: dam,
      bot: bot,
      beo: beo,
      vaoNgay: chon == 'ngay',
    );
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final doc = CongThuc.docMon(_dan.text);
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.9,
        ),
        child: ListView(
          key: const Key('to-tao-cong-thuc'),
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            const Text(
              Chuoi.taoCongThuc,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Mau.muc),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('ten-mon'),
              controller: _ten,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(hintText: Chuoi.taoCongThuc),
            ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('dan-chu'),
              controller: _dan,
              minLines: 4,
              maxLines: 8,
              decoration: const InputDecoration(hintText: Chuoi.danChuGrok),
            ),
            if (doc.kcal != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(Chuoi.docNKcal(doc.kcal!), style: const TextStyle(fontSize: 13, color: Mau.mo)),
              ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('doc-kcal'),
              controller: _kcal,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(suffixText: 'kcal'),
              onTap: () => _suaTay = true,
            ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('gram-mon'),
              controller: _gram,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(hintText: Chuoi.khoiLuongG, suffixText: 'g'),
              onTap: () => _suaTay = true,
            ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('dam-mon'),
              controller: _dam,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(hintText: Chuoi.dam, suffixText: 'g'),
              onTap: () => _suaTay = true,
            ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('bot-mon'),
              controller: _bot,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(hintText: Chuoi.bot, suffixText: 'g'),
              onTap: () => _suaTay = true,
            ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('beo-mon'),
              controller: _beo,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(hintText: Chuoi.beo, suffixText: 'g'),
              onTap: () => _suaTay = true,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 44,
              child: FilledButton(
                key: const Key('luu-cong-thuc'),
                onPressed: _luuCongThuc,
                child: const Text(Chuoi.luu),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToMonDaLuu extends StatelessWidget {
  const _ToMonDaLuu({required this.kho});

  final Kho kho;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: kho,
      builder: (context, _) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.7,
            ),
            child: ListView(
              key: const Key('mon-da-luu'),
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                const Text(
                  Chuoi.monDaLuu,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Mau.muc),
                ),
                const SizedBox(height: 12),
                if (kho.dsMon.isEmpty)
                  const Text('—', style: TextStyle(color: Mau.mo))
                else
                  for (final f in kho.dsMon)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Material(
                        color: Mau.giay,
                        child: InkWell(
                          key: Key('mon-kho-${f.id}'),
                          onTap: kho.khoaGhi ? null : () => kho.chonMon(f.id),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 44),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  Chuoi.dongMon(f.ten, f.kcal, g: f.gram),
                                  style: const TextStyle(fontSize: 15, color: Mau.muc),
                                ),
                              ),
                            ),
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
