import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'chuoi.dart';
import 'kho.dart';
import 'man/cai_dat.dart';
import 'man/co_the.dart';
import 'man/hom_nay.dart';
import 'mau.dart';

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
          value: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Mau.beMat,
          ),
          child: Scaffold(
            body: IndexedStack(
              index: kho.tab,
              children: [
                ManHomNay(kho: kho),
                ManCoThe(kho: kho),
                const ManCaiDat(),
              ],
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: kho.tab,
              onDestinationSelected: kho.chonTab,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.check_circle_outline),
                  selectedIcon: Icon(Icons.check_circle),
                  label: Chuoi.homNay,
                ),
                NavigationDestination(
                  icon: Icon(Icons.monitor_weight_outlined),
                  selectedIcon: Icon(Icons.monitor_weight),
                  label: Chuoi.coThe,
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
