import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'chuoi.dart';
import 'kho.dart';
import 'man/cai_dat.dart';
import 'man/he.dart';
import 'man/hom_nay.dart';
import 'man/lich.dart';
import 'man/luoi_ghi.dart';
import 'man/tien_do.dart';
import 'mau.dart';
import 'widget/thanh_day.dart';

class VoApp extends StatelessWidget {
  const VoApp({super.key, required this.kho});

  final Kho kho;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: kho.shellBan,
      builder: (context, _) {
        if (kho.dangTai) {
          return const Scaffold(
            body: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        return _ThanMay(kho: kho);
      },
    );
  }
}

/// Giữ instance tab. Tick Home không rebuild Lịch / Tiến độ.
class _ThanMay extends StatefulWidget {
  const _ThanMay({required this.kho});

  final Kho kho;

  @override
  State<_ThanMay> createState() => _ThanMayState();
}

class _ThanMayState extends State<_ThanMay> {
  late final List<Widget> _man;

  Kho get kho => widget.kho;

  @override
  void initState() {
    super.initState();
    _man = [
      ManHomNay(kho: kho),
      ManLich(kho: kho),
      ManTienDo(kho: kho),
      ManHe(kho: kho),
      ManTaiKhoan(kho: kho),
    ];
    kho.tabBan.addListener(_veTab);
  }

  void _veTab() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    kho.tabBan.removeListener(_veTab);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Mau.beMat,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Scaffold(
            body: IndexedStack(
              sizing: StackFit.expand,
              index: kho.tab,
              children: _man,
            ),
            bottomNavigationBar: ThanhDay(
              tab: kho.tab,
              onTab: kho.chonTab,
              onCong: () => moLuoiGhi(context, kho),
            ),
          ),
          HeLop(kho: kho),
        ],
      ),
    );
  }
}

/// Flash nhẹ + moment lên cấp 1.2s. IgnorePointer — không chặn UI.
class HeLop extends StatefulWidget {
  const HeLop({super.key, required this.kho});

  final Kho kho;

  @override
  State<HeLop> createState() => _HeLopState();
}

class _HeLopState extends State<HeLop> {
  int _flash = 0;
  bool _dangFlash = false;
  String? _momentHien;
  Timer? _flashTimer;
  Timer? _momentTimer;

  Kho get kho => widget.kho;

  @override
  void initState() {
    super.initState();
    _flash = kho.heFlash;
    kho.heBan.addListener(_ve);
  }

  void _ve() {
    if (!mounted) return;
    var flashMoi = false;
    if (kho.heFlash > _flash) {
      flashMoi = true;
      _flash = kho.heFlash;
      HapticFeedback.lightImpact();
      _dangFlash = true;
      _flashTimer?.cancel();
      _flashTimer = Timer(const Duration(milliseconds: 160), () {
        if (mounted) setState(() => _dangFlash = false);
      });
    } else {
      _flash = kho.heFlash;
    }
    final moment = kho.heMoment;
    if (moment != null && moment != _momentHien) {
      _momentHien = moment;
      _momentTimer?.cancel();
      _momentTimer = Timer(const Duration(milliseconds: 1200), () {
        _momentTimer = null;
        _momentHien = null;
        if (mounted) kho.tatMoment();
      });
    } else if (moment == null) {
      _momentHien = null;
    }
    if (flashMoi || moment != null || _dangFlash) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _flashTimer?.cancel();
    _momentTimer?.cancel();
    kho.heBan.removeListener(_ve);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moment = kho.heMoment;
    if (!_dangFlash && moment == null) {
      return const SizedBox.shrink();
    }
    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (_dangFlash) const ColoredBox(color: Color(0x22FF7A00)),
          if (moment != null)
            Align(
              alignment: Alignment.center,
              child: Container(
                key: const Key('he-moment'),
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
                decoration: BoxDecoration(
                  color: Mau.beMat,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Mau.reu, width: 1.4),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      Chuoi.he,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: Mau.reu,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      moment,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                        color: Mau.muc,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
