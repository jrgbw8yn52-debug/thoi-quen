import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'chuoi.dart';
import 'db/database.dart';
import 'kho.dart';
import 'mau.dart';
import 'nhac.dart';
import 'vo_app.dart';
import 'wid_home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  final kho = Kho(db);
  Nhac.khoiTao(bam: kho.moTuNoti, xong: kho.tickTuNoti);
  WidHome.langNghe(kho.tickWid);
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
      home: _VoCoSplash(kho: kho),
    );
  }
}

/// Splash 900 ms rồi Home. Không chờ mạng.
class _VoCoSplash extends StatefulWidget {
  const _VoCoSplash({required this.kho});

  final Kho kho;

  @override
  State<_VoCoSplash> createState() => _VoCoSplashState();
}

class _VoCoSplashState extends State<_VoCoSplash> {
  bool _het = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _het = true);
    });
    widget.kho.shellBan.addListener(_ve);
  }

  void _ve() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.kho.shellBan.removeListener(_ve);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_het && !widget.kho.dangTai) {
      return VoApp(kho: widget.kho);
    }
    return const _ManSplash();
  }
}

class _ManSplash extends StatelessWidget {
  const _ManSplash();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFF0D0D0D),
      child: SizedBox.expand(
        child: Image(
          image: AssetImage('assets/habis_splash.png'),
          fit: BoxFit.contain,
          alignment: Alignment.center,
          filterQuality: FilterQuality.high,
          gaplessPlayback: true,
        ),
      ),
    );
  }
}
