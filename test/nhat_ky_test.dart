import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thoi_quen/chuoi.dart';
import 'package:thoi_quen/db/database.dart';
import 'package:thoi_quen/kho.dart';
import 'package:thoi_quen/man/ghi_nap.dart';
import 'package:thoi_quen/man/to_mon.dart';
import 'package:thoi_quen/mau.dart';

void main() {
  late AppDatabase db;
  late Kho kho;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    kho = Kho(db, bayGio: DateTime(2026, 8, 31, 8));
    await kho.tai();
  });

  tearDown(() async {
    kho.dispose();
    await db.close();
  });

  testWidgets('nhat ky vong kcal con lai va 3 thanh macro', (tester) async {
    tester.view.physicalSize = const Size(390, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    await kho.luuHoSo(
      ten: 'A',
      cao: '170',
      sex: 'nam',
      dob: DateTime(1996, 1, 1),
      activity: 1.2,
      banDau: '70',
    );
    await kho.ghiCanKg(70);
    await kho.luuMucTieu(dich: '70', nhip: 0.5);
    final goi = kho.kcalGoiYDoc!;
    await kho.luuMon(ten: 'Cơm', kcal: 400, dam: 20, bot: 50, beo: 8, vaoNgay: true);
    await tester.pumpWidget(
      MaterialApp(
        theme: Mau.theme(),
        home: ManGhiNap(kho: kho),
      ),
    );
    await tester.pump();
    expect(find.byKey(const Key('vong-kcal')), findsOneWidget);
    expect(find.byKey(const Key('kcal-con')), findsOneWidget);
    expect(find.byKey(const Key('thanh-dam')), findsOneWidget);
    expect(find.byKey(const Key('thanh-bot')), findsOneWidget);
    expect(find.byKey(const Key('thanh-beo')), findsOneWidget);
    expect(find.text('${goi - 400}'), findsWidgets);
    expect(find.text(Chuoi.kcalConLai), findsOneWidget);
    expect(find.text(Chuoi.dam), findsOneWidget);
  });

  testWidgets('kho mon ABC va goi y realtime', (tester) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    await kho.luuMon(ten: 'Phở bò', kcal: 450);
    await kho.luuMon(ten: 'Cơm', kcal: 200);
    await kho.luuMon(ten: 'Bánh mì', kcal: 250);
    await tester.pumpWidget(
      MaterialApp(
        theme: Mau.theme(),
        home: Scaffold(body: ToMonDaLuu(kho: kho)),
      ),
    );
    await tester.pump();
    expect(find.byKey(const Key('tim-kho')), findsOneWidget);
    expect(find.textContaining('Bánh mì'), findsOneWidget);
    expect(find.textContaining('Cơm'), findsOneWidget);
    expect(find.textContaining('Phở bò'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('tim-kho')), 'Cơ');
    await tester.pump();
    expect(find.textContaining('Cơm'), findsOneWidget);
    expect(find.textContaining('Bánh mì'), findsNothing);
    expect(find.textContaining('Phở bò'), findsNothing);
  });
}
