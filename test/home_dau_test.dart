import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thoi_quen/chuoi.dart';
import 'package:thoi_quen/db/database.dart';
import 'package:thoi_quen/kho.dart';
import 'package:thoi_quen/mau.dart';
import 'package:thoi_quen/widget/dau_trang.dart';

void main() {
  late AppDatabase db;
  late Kho kho;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    kho = Kho(db, bayGio: DateTime(2026, 8, 30, 13));
    await kho.tai();
  });

  tearDown(() async {
    kho.dispose();
    await db.close();
  });

  testWidgets('Home dau trang HABIS + chao chieu + the chuoi', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: Mau.theme(),
      home: Scaffold(body: DauTrangHabis(kho: kho)),
    ));
    await tester.pump();
    expect(find.text(Chuoi.habisNhan), findsOneWidget);
    expect(find.text(Chuoi.chaoChieu), findsOneWidget);
    expect(find.text(Chuoi.totHonHomQua), findsOneWidget);
    expect(find.text(Chuoi.chuoiHienTai.toUpperCase()), findsOneWidget);
    expect(find.byKey(const Key('lua-home')), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
    expect(find.text('T2'), findsOneWidget);
    expect(find.text('CN'), findsOneWidget);
  });

  testWidgets('chao sang 8h', (tester) async {
    final k = Kho(db, bayGio: DateTime(2026, 8, 31, 8));
    addTearDown(k.dispose);
    await k.tai();
    await tester.pumpWidget(MaterialApp(
      theme: Mau.theme(),
      home: Scaffold(body: DauTrangHabis(kho: k)),
    ));
    await tester.pump();
    expect(find.text(Chuoi.chaoSang), findsOneWidget);
  });
}
