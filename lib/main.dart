import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'chuoi.dart';
import 'db/database.dart';
import 'kho.dart';
import 'mau.dart';
import 'nhac.dart';
import 'vo_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  final kho = Kho(db);
  Nhac.khoiTao(bam: kho.moTuNoti);
  kho.tai().then((_) => Nhac.xuLyLanMo());
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
      locale: const Locale('vi'),
      supportedLocales: const [Locale('vi')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: VoApp(kho: kho),
    );
  }
}
