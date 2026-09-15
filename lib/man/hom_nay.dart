import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../chuoi.dart';
import '../db/database.dart';
import '../kho.dart';
import '../mau.dart';
import '../ngay.dart';
import '../widget/dai_tuan.dart';
import '../widget/dau_trang.dart';
import '../widget/hang_habit.dart';
import '../widget/lan_ngay.dart';
import 'them_habit.dart';
import 'xoa_habit.dart';
import 'ghi_tap.dart';

class ManHomNay extends StatefulWidget {
  const ManHomNay({super.key, required this.kho});

  final Kho kho;

  @override
  State<ManHomNay> createState() => _ManHomNayState();
}

class _ManHomNayState extends State<ManHomNay> {
  Kho get kho => widget.kho;
  String? _iso;
  Stream<(List<Habit>, List<Tick>)>? _stream;

  Stream<(List<Habit>, List<Tick>)> _homeStream() {
    final iso = Ngay.iso(kho.selected);
    if (_iso != iso || _stream == null) {
      _iso = iso;
      _stream = kho.db.watchHomeNgay(iso);
    }
    return _stream!;
  }

  @override
  void initState() {
    super.initState();
    kho.homeBan.addListener(_ve);
    kho.focusBan.addListener(_ve);
  }

  void _ve() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    kho.homeBan.removeListener(_ve);
    kho.focusBan.removeListener(_ve);
    super.dispose();
  }

  void _moThem(BuildContext context) {
    if (!kho.themDuoc) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ManThemHabit(kho: kho),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<(List<Habit>, List<Tick>)>(
      stream: _homeStream(),
      builder: (context, snap) {
        return _ThanHome(
          kho: kho,
          onThem: () => _moThem(context),
        );
      },
    );
  }
}

class _ThanHome extends StatelessWidget {
  const _ThanHome({required this.kho, required this.onThem});

  final Kho kho;
  final VoidCallback onThem;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DauTrangHabis(
            kho: kho,
            onChuoi: () {
              kho.veHomNay();
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ManGhiTap(kho: kho),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                key: const Key('tieu-de-ngay'),
                onTap: () => moLanNgay(context, kho),
                borderRadius: BorderRadius.circular(12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 44),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            kho.dongNgay,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Mau.muc,
                            ),
                          ),
                        ),
                        const Icon(Icons.calendar_today_outlined, size: 18, color: Mau.mo),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                key: const Key('hang-hom-nay'),
                onTap: kho.veHomNay,
                borderRadius: BorderRadius.circular(8),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 44),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text.rich(
                        TextSpan(
                          style: const TextStyle(fontSize: 15, color: Mau.mo, height: 1.3),
                          children: [
                            TextSpan(text: '${kho.nTickHom}/${kho.mHom} '),
                            TextSpan(
                              text: Chuoi.homNayNgay(kho.homNay),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Mau.muc,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onHorizontalDragEnd: (d) {
              final v = d.primaryVelocity ?? 0;
              if (v < -120) {
                kho.toiTuan();
              } else if (v > 120) {
                kho.luiTuan();
              }
            },
            child: RepaintBoundary(
              child: DaiTuan(
                tuan: kho.tuan,
                onChon: kho.chonNgay,
                tuanChuaHomNay: kho.tuanChuaHomNay,
              ),
            ),
          ),
          Expanded(
            child: kho.rong &&
                    kho.focusHomNay.isEmpty &&
                    kho.focusNgayMai == null
                ? _FirstRun(
                    kho: kho,
                    onTuDatTen: onThem,
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                    children: [
                      if (kho.focusHomNay.isNotEmpty ||
                          kho.focusNgayMai != null)
                        _KhoiFocusHom(kho: kho),
                      if (kho.rong)
                        _FirstRun(
                          kho: kho,
                          onTuDatTen: onThem,
                        )
                      else
                        for (var i = 0; i < kho.hang.length; i++) ...[
                          if (i > 0 ||
                              kho.focusHomNay.isNotEmpty ||
                              kho.focusNgayMai != null)
                            const SizedBox(height: 6),
                          RepaintBoundary(
                            child: HangHabit(
                              key: ValueKey(kho.hang[i].habit.id),
                              hang: kho.hang[i],
                              khoaGhi: kho.khoaGhi,
                              onTap: () => kho.toggle(kho.hang[i]),
                              onSua: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => ManThemHabit(
                                      kho: kho,
                                      habit: kho.hang[i].habit,
                                    ),
                                  ),
                                );
                              },
                              onXoa: () =>
                                  moXoaHabit(context, kho, kho.hang[i].habit),
                            ),
                          ),
                        ],
                    ],
                  ),
          ),
          if (kho.themDuoc)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: _NutThem(onTap: onThem),
            ),
        ],
      ),
    );
  }
}

class _NutThem extends StatelessWidget {
  const _NutThem({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: const Key('them-thoi-quen'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: const Center(
            child: Text(
              Chuoi.themThoiQuen,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Mau.reu,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FirstRun extends StatelessWidget {
  const _FirstRun({required this.kho, required this.onTuDatTen});

  final Kho kho;
  final VoidCallback onTuDatTen;

  @override
  Widget build(BuildContext context) {
    if (kho.khoaGhi) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Text(
          Chuoi.chiXem,
          style: TextStyle(fontSize: 15, color: Mau.mo),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            Chuoi.chonThoiQuen,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Mau.muc,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (!kho.daCoTen(Chuoi.day6Gio))
                _ChipThem(
                  chu: Chuoi.day6Gio,
                  onTap: () => kho.themPreset(ten: Chuoi.day6Gio),
                ),
              if (!kho.daCoTen(Chuoi.vanDong))
                _ChipThem(chu: Chuoi.vanDong, onTap: kho.themVanDong),
              if (!kho.daCoTen(Chuoi.doc20Trang))
                _ChipThem(
                  chu: Chuoi.doc20Trang,
                  onTap: () => kho.themPreset(ten: Chuoi.doc20Trang),
                ),
              _ChipThem(chu: Chuoi.tuDatTen, onTap: onTuDatTen),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChipThem extends StatelessWidget {
  const _ChipThem({required this.chu, required this.onTap});

  final String chu;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Mau.beMat,
      shape: const StadiumBorder(side: BorderSide(color: Mau.vien)),
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

class _KhoiFocusHom extends StatelessWidget {
  const _KhoiFocusHom({required this.kho});

  final Kho kho;

  @override
  Widget build(BuildContext context) {
    final mai = kho.focusNgayMai;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(4, 4, 4, 6),
            child: Text(
              Chuoi.focusHomNay,
              key: Key('khoi-focus-hom'),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Mau.mo,
              ),
            ),
          ),
          for (final t in kho.focusHomNay)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _HangFocusHom(kho: kho, viec: t),
            ),
          if (mai != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 2, 4, 4),
              child: Text(
                Chuoi.ngayMaiDong(mai.gioPhut, mai.title),
                key: const Key('dong-ngay-mai'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: Mau.mo),
              ),
            ),
        ],
      ),
    );
  }
}

class _HangFocusHom extends StatelessWidget {
  const _HangFocusHom({required this.kho, required this.viec});

  final Kho kho;
  final FocusTask viec;

  @override
  Widget build(BuildContext context) {
    final tre = kho.quaHanFocus(viec);
    final khoaTick = !kho.tickDuocFocus(viec);
    final gach = tre || viec.done;
    final chu = viec.ghiChu;
    return Material(
      color: Mau.beMat,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: khoaTick
            ? null
            : () {
                HapticFeedback.selectionClick();
                kho.tickFocus(viec.id);
              },
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: [
                _TickHom(bat: viec.done, mo: khoaTick),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        viec.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: tre ? Mau.mo : Mau.muc,
                          decoration: gach
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      if (chu != null && chu.isNotEmpty)
                        Text(
                          chu,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: Mau.mo),
                        ),
                      if (tre)
                        const Text(
                          Chuoi.chuaLam,
                          style: TextStyle(fontSize: 12, color: Mau.canhBao),
                        )
                      else if (viec.durationMin != null)
                        Text(
                          Chuoi.luongPhut(viec.durationMin!),
                          style: const TextStyle(fontSize: 12, color: Mau.mo),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  Chuoi.gioNhacChu(viec.gioPhut),
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Mau.muc,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TickHom extends StatelessWidget {
  const _TickHom({required this.bat, this.mo = false});

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
