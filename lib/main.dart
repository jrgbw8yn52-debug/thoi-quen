import 'package:flutter/material.dart';

import 'chuoi.dart';
import 'db/database.dart';
import 'kho.dart';
import 'mau.dart';
import 'vo_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  final kho = Kho(db)..tai();
  runApp(ThoiQuenApp(kho: kho));
}

class ThoiQuenApp extends StatelessWidget {
  const ThoiQuenApp({super.key, required this.kho});

  final Kho kho;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Chuoi.tenApp,
      debugShowCheckedModeBanner: false,
      theme: Mau.theme(),
      home: VoApp(kho: kho),
    );
  }
}
