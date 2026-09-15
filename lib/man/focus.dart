import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../chuoi.dart';
import '../db/database.dart';
import '../kho.dart';
import '../mau.dart';
import '../ngay.dart';
import '../widget/hang_habit.dart';
import 'them_focus.dart';

class ManFocus extends StatefulWidget {
  const ManFocus({super.key, required this.kho});

  final Kho kho;

  @override
  State<ManFocus> createState() => _ManFocusState();
}

class _ManFocusState extends State<ManFocus> {
  Kho get kho => widget.kho;
  late String _mo;

  @override
  void initState() {
    super.initState();
    _mo = Ngay.iso(kho.homNay);
    kho.focusBan.addListener(_ve);
  }

  void _ve() {
    if (!mounted) return;
    setState(() {});
    if (kho.pomoHoiTick) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _hoiTickPomo();
      });
    }
  }

  Future<void> _hoiTickPomo() async {
    if (!kho.pomoHoiTick) return;
    kho.pomoHoiTick = false;
    final id = kho.pomoViecId;
    if (id == null) return;
    FocusTask? t;
    for (final x in kho.dsFocus) {
      if (x.id == id) {
        t = x;
        break;
      }
    }
    if (t == null || !kho.tickDuocFocus(t) || t.done) return;
    if (!mounted) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(Chuoi.danhDauXong),
        content: Text(t!.title),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(Chuoi.khong),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(Chuoi.co),
          ),
        ],
      ),
    );
    if (ok == true) await kho.tickFocus(id, chiBat: true);
  }

  @override
  void dispose() {
    kho.focusBan.removeListener(_ve);
    super.dispose();
  }

  void _moForm({FocusTask? viec}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ManThemFocus(kho: kho, viec: viec),
      ),
    );
  }

  Future<void> _xoa(FocusTask t) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(Chuoi.xoa),
        content: Text(t.title),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(Chuoi.huy),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(Chuoi.xoa),
          ),
        ],
      ),
    );
    if (ok == true) await kho.xoaFocus(t.id);
  }

  @override
  Widget build(BuildContext context) {
    final nhom = kho.nhomFocus;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 12, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  Chuoi.focus,
                  key: Key('man-focus'),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.4,
                    color: Mau.muc,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    key: const Key('nut-viec-quan-trong'),
                    onPressed: () => _moForm(),
                    child: const Text(Chuoi.viecQuanTrong),
                  ),
                ),
                _Pomo(kho: kho),
              ],
            ),
          ),
          Expanded(
            child: nhom.isEmpty
                ? const Center(
                    child: Text(
                      Chuoi.chuaCoViec,
                      style: TextStyle(fontSize: 16, color: Mau.mo),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 24),
                    children: [
                      for (final g in nhom) ...[
                        _DauNhom(
                          iso: g.$1,
                          so: g.$2.length,
                          mo: _mo == g.$1,
                          homNay: g.$1 == Ngay.iso(kho.homNay),
                          onTap: () => setState(() {
                            _mo = _mo == g.$1 ? '' : g.$1;
                          }),
                        ),
                        if (_mo == g.$1)
                          for (final t in g.$2)
                            _HangFocus(
                              viec: t,
                              kho: kho,
                              onTick: () {
                                HapticFeedback.selectionClick();
                                kho.tickFocus(t.id);
                              },
                              onSua: kho.suaDuocFocus(t)
                                  ? () => _moForm(viec: t)
                                  : null,
                              onXoa: kho.suaDuocFocus(t) ? () => _xoa(t) : null,
                            ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _DauNhom extends StatelessWidget {
  const _DauNhom({
    required this.iso,
    required this.so,
    required this.mo,
    required this.homNay,
    required this.onTap,
  });

  final String iso;
  final int so;
  final bool mo;
  final bool homNay;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final d = Ngay.parse(iso);
    final chu = homNay ? Chuoi.homNay : Chuoi.dongNgay(d);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Row(
          children: [
            Icon(
              mo ? Icons.expand_more : Icons.chevron_right,
              color: Mau.mo,
              size: 22,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                chu,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Mau.mo,
                ),
              ),
            ),
            Text(
              '$so',
              style: const TextStyle(fontSize: 13, color: Mau.mo),
            ),
          ],
        ),
      ),
    );
  }
}

class _HangFocus extends StatelessWidget {
  const _HangFocus({
    required this.viec,
    required this.kho,
    required this.onTick,
    required this.onSua,
    required this.onXoa,
  });

  final FocusTask viec;
  final Kho kho;
  final VoidCallback onTick;
  final VoidCallback? onSua;
  final VoidCallback? onXoa;

  @override
  Widget build(BuildContext context) {
    final tre = kho.quaHanFocus(viec);
    final khoaTick = !kho.tickDuocFocus(viec);
    final gach = tre || viec.done;
    return HangVuot(
      choVuot: onSua != null || onXoa != null,
      onSua: onSua,
      onXoa: onXoa ?? () {},
      child: Material(
        color: Mau.beMat,
        child: InkWell(
          onTap: khoaTick ? null : onTick,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _Tick(bat: viec.done, mo: khoaTick),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          viec.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                            color: tre ? Mau.mo : Mau.muc,
                            decoration: gach
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        if (viec.ghiChu != null && viec.ghiChu!.isNotEmpty)
                          Text(
                            viec.ghiChu!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Mau.mo,
                            ),
                          ),
                        if (tre)
                          const Text(
                            Chuoi.chuaLam,
                            style: TextStyle(
                              fontSize: 13,
                              color: Mau.canhBao,
                            ),
                          )
                        else if (viec.durationMin != null)
                          Text(
                            Chuoi.luongPhut(viec.durationMin!),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Mau.mo,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(
                      Chuoi.gioNhacChu(viec.gioPhut),
                      maxLines: 1,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                        color: Mau.muc,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tick extends StatelessWidget {
  const _Tick({required this.bat, this.mo = false});

  final bool bat;
  final bool mo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bat
            ? (mo ? Mau.reu.withValues(alpha: 0.45) : Mau.reu)
            : Colors.transparent,
        border: Border.all(
          color: bat ? Mau.reu : (mo ? Mau.vien : Mau.muc),
          width: 1.6,
        ),
      ),
      child: bat ? const Icon(Icons.check, size: 14, color: Mau.giay) : null,
    );
  }
}

class _Pomo extends StatelessWidget {
  const _Pomo({required this.kho});

  final Kho kho;

  @override
  Widget build(BuildContext context) {
    final viec = kho.viecPomo;
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Mau.beMat,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                kho.pomoChu,
                key: const Key('pomo-dong'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                  color: Mau.muc,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              Text(
                kho.pomoLamDang ? Chuoi.lamViec : Chuoi.nghi,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Mau.mo),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    key: const Key('pomo-bat'),
                    onPressed: kho.pomoChay ? kho.dungPomo : kho.batPomo,
                    child: Text(kho.pomoChay ? Chuoi.tamDung : Chuoi.batDau),
                  ),
                  TextButton(
                    onPressed: kho.datLaiPomo,
                    child: const Text(Chuoi.datLai),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _PomoPhut(
                      nhan: Chuoi.lamViec,
                      phut: kho.pomoLam,
                      onCong: () => kho.doiPomoLam(kho.pomoLam + 1),
                      onTru: () => kho.doiPomoLam(kho.pomoLam - 1),
                      congKey: 'pomo-lam-cong',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PomoPhut(
                      nhan: Chuoi.nghi,
                      phut: kho.pomoNghi,
                      onCong: () => kho.doiPomoNghi(kho.pomoNghi + 1),
                      onTru: () => kho.doiPomoNghi(kho.pomoNghi - 1),
                    ),
                  ),
                ],
              ),
              if (viec.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text(
                  Chuoi.ganViec,
                  style: TextStyle(fontSize: 13, color: Mau.mo),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _GanChip(
                      chu: Chuoi.khongGan,
                      bat: kho.pomoViecId == null,
                      onTap: () => kho.ganPomo(null),
                    ),
                    for (final t in viec.take(6))
                      _GanChip(
                        chu: t.title,
                        bat: kho.pomoViecId == t.id,
                        onTap: () => kho.ganPomo(t.id),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PomoPhut extends StatelessWidget {
  const _PomoPhut({
    required this.nhan,
    required this.phut,
    required this.onCong,
    required this.onTru,
    this.congKey,
  });

  final String nhan;
  final int phut;
  final VoidCallback onCong;
  final VoidCallback onTru;
  final String? congKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$nhan $phut',
            style: const TextStyle(fontSize: 13, color: Mau.muc),
          ),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: onTru,
          icon: const Icon(Icons.remove, size: 18, color: Mau.mo),
        ),
        IconButton(
          key: congKey == null ? null : Key(congKey!),
          visualDensity: VisualDensity.compact,
          onPressed: onCong,
          icon: const Icon(Icons.add, size: 18, color: Mau.mo),
        ),
      ],
    );
  }
}

class _GanChip extends StatelessWidget {
  const _GanChip({
    required this.chu,
    required this.bat,
    required this.onTap,
  });

  final String chu;
  final bool bat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bat ? Mau.chipBat : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: bat ? Mau.reu : Mau.vien),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(
            chu,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: bat ? Mau.reu : Mau.mo,
            ),
          ),
        ),
      ),
    );
  }
}

