import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'chuoi.dart';
import 'kho.dart';
import 'man/cai_dat.dart';
import 'man/ghi_ngay.dart';
import 'man/hom_nay.dart';
import 'man/tien_do.dart';
import 'mau.dart';

class VoApp extends StatelessWidget {
  const VoApp({super.key, required this.kho});

  final Kho kho;

  int get _dest => kho.tab == 0 ? 0 : kho.tab + 1;

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
                ManCaiDat(kho: kho),
              ],
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _dest,
              onDestinationSelected: (i) {
                if (i == 1) {
                  moToGhi(context, kho);
                  return;
                }
                kho.chonTab(i == 0 ? 0 : i - 1);
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.check_circle_outline),
                  selectedIcon: Icon(Icons.check_circle),
                  label: Chuoi.homNay,
                ),
                NavigationDestination(
                  icon: Icon(Icons.add_circle_outline),
                  selectedIcon: Icon(Icons.add_circle),
                  label: Chuoi.ghi,
                ),
                NavigationDestination(
                  icon: Icon(Icons.insights_outlined),
                  selectedIcon: Icon(Icons.insights),
                  label: Chuoi.tienDo,
                ),
                NavigationDestination(
                  icon: Icon(Icons.tune),
                  selectedIcon: Icon(Icons.tune),
                  label: Chuoi.caiDat,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
