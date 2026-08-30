import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thoi_quen/chuoi.dart';
import 'package:thoi_quen/db/database.dart';
import 'package:thoi_quen/kho.dart';
import 'package:thoi_quen/mau.dart';
import 'package:thoi_quen/vo_app.dart';

Widget _app(Kho kho) {
  return MaterialApp(
    theme: Mau.theme(),
    home: VoApp(kho: kho),
  );
}

void main() {
  late AppDatabase db;
  late Kho kho;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    kho = Kho(db, bayGio: DateTime(2026, 8, 30, 13));
    await kho.tai();
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('first-run + tick hang + hoan tac', (tester) async {
    await tester.pumpWidget(_app(kho));
    await tester.pumpAndSettle();

    expect(find.text('Chủ Nhật, 30 tháng 8'), findsOneWidget);
    expect(find.text('0/0 hôm nay'), findsOneWidget);
    expect(find.text(Chuoi.themCan), findsOneWidget);
    expect(find.text(Chuoi.day6Gio), findsOneWidget);

    await tester.tap(find.text(Chuoi.day6Gio));
    await tester.pumpAndSettle();

    expect(find.text('0/1 hôm nay'), findsOneWidget);
    expect(find.text('0/25 tháng này'), findsOneWidget);

    await tester.tap(find.text(Chuoi.day6Gio));
    await tester.pumpAndSettle();
    expect(find.text('1/1 hôm nay'), findsOneWidget);
    expect(find.text('1/25 tháng này'), findsOneWidget);

    await tester.tap(find.text(Chuoi.day6Gio));
    await tester.pumpAndSettle();
    expect(find.text('0/1 hôm nay'), findsOneWidget);
  });

  testWidgets('chip can mo tab Co the, ghi can cap nhat chip', (tester) async {
    await tester.pumpWidget(_app(kho));
    await tester.pumpAndSettle();

    await tester.tap(find.text(Chuoi.themCan));
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.canHomNay), findsOneWidget);

    await tester.enterText(find.byType(TextField), '72,5');
    await tester.tap(find.text(Chuoi.luu));
    await tester.pumpAndSettle();

    await tester.tap(find.text(Chuoi.homNay));
    await tester.pumpAndSettle();
    expect(find.text('Cân 72,5'), findsOneWidget);
  });

  testWidgets('cham tuan: thu hai tap duoc, xem ngay do', (tester) async {
    await kho.themPreset(ten: Chuoi.day6Gio);
    await tester.pumpWidget(_app(kho));
    await tester.pumpAndSettle();

    await tester.tap(find.text('T2'));
    await tester.pumpAndSettle();
    expect(find.text('Thứ Hai, 24 tháng 8'), findsOneWidget);
    expect(find.text('0/1 ngày 24/8'), findsOneWidget);
  });
}
