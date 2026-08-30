import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'kho.dart';
import 'man/cai_dat.dart';
import 'man/hom_nay.dart';
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
      listenable: kho,
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
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Mau.beMat,
          ),
          child: Scaffold(
            body: IndexedStack(
              index: kho.tab,
              children: [
                ManHomNay(kho: kho),
                ManTienDo(kho: kho),
                ManTaiKhoan(kho: kho),
              ],
            ),
            bottomNavigationBar: ThanhDay(
              tab: kho.tab,
              onTab: kho.chonTab,
              onCong: () => moLuoiGhi(context, kho),
            ),
          ),
        );
      },
    );
  }
}
