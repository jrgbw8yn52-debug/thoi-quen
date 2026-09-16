import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../kho.dart';
import 'tien_do.dart';

void hienSnackKcal({
  required ScaffoldMessengerState messenger,
  required NavigatorState nav,
  required Kho kho,
}) {
  final nap = kho.kcalNapCuaNgay(kho.homNay);
  final goi = kho.kcalGoiYDoc;
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(Chuoi.homNayAbKcal(nap, goi)),
      duration: const Duration(seconds: 4),
      action: SnackBarAction(
        label: Chuoi.thongKe,
        onPressed: () {
          nav.push(
            MaterialPageRoute<void>(builder: (_) => ManTienDo(kho: kho)),
          );
        },
      ),
    ),
  );
}
