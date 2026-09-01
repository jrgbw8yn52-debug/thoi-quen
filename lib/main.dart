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
    return const Scaffold(
      backgroundColor: Mau.giay,
      body: Center(
        child: SizedBox(
          width: 96,
          height: 96,
          child: CustomPaint(painter: _NhanHabis()),
        ),
      ),
    );
  }
}

class _NhanHabis extends CustomPainter {
  const _NhanHabis();

  @override
  void paint(Canvas canvas, Size size) {
    final cam = Paint()..color = Mau.reu;
    final vang = Paint()..color = Mau.lua;
    final w = size.width;
    final h = size.height;
    final barW = w * 0.16;
    final gap = w * 0.10;
    final barH = h * 0.72;
    final dot = w * 0.22;
    final gapDot = w * 0.08;
    final groupW = barW * 2 + gap + gapDot + dot;
    final x0 = (w - groupW) / 2;
    final y0 = (h - barH) / 2;
    final r = Radius.circular(barW / 2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(x0, y0, barW, barH), r),
      cam,
    );
    final x1 = x0 + barW + gap;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(x1, y0, barW, barH), r),
      cam,
    );
    final cx = x1 + barW + gapDot + dot / 2;
    final cy = y0 + barH / 2;
    canvas.drawCircle(Offset(cx, cy), dot / 2, vang);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
