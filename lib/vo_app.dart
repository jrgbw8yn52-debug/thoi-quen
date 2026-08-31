import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'kho.dart';
import 'man/cai_dat.dart';
import 'man/hom_nay.dart';
import 'man/lich.dart';
import 'man/luoi_ghi.dart';
import 'man/tien_do.dart';
import 'mau.dart';
import 'nhac.dart';
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

/// Giữ instance 4 tab. Tick Home không rebuild Lịch / Tiến độ.
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
      ManTaiKhoan(kho: kho),
    ];
    kho.tabBan.addListener(_veTab);
    Nhac.xinQuyen();
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
      child: Scaffold(
        body: IndexedStack(
          index: kho.tab,
          children: _man,
        ),
        bottomNavigationBar: ThanhDay(
          tab: kho.tab,
          onTab: kho.chonTab,
          onCong: () => moLuoiGhi(context, kho),
        ),
      ),
    );
  }
}
