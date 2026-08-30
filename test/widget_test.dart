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

  test('chonNgay thang truoc doi tuan Home', () async {
    await kho.themPreset(ten: Chuoi.day6Gio);
    kho.chonNgay(DateTime(2026, 7, 15));
    expect(kho.selected, DateTime(2026, 7, 15));
    expect(kho.tuan.first.ngay, DateTime(2026, 7, 13));
    expect(kho.tuan.last.ngay, DateTime(2026, 7, 19));
    expect(kho.dongNgay, 'Thứ Tư, 15 tháng 7');
    expect(kho.nTrenM, '0/1 ngày 15/7');
  });

  test('chonVaTick doi selected roi tick dung ngay', () async {
    await kho.themPreset(ten: Chuoi.day6Gio);
    await kho.themPreset(ten: Chuoi.doc20Trang);
    final h = kho.hang.first.habit;
    await kho.chonVaTick(h, DateTime(2026, 7, 15));
    expect(kho.selected, DateTime(2026, 7, 15));
    expect(kho.hang.first.ticked, isTrue);
    expect(kho.hang.last.ticked, isFalse);
    expect(kho.nTick, 1);
    expect(kho.tuan.first.ngay, DateTime(2026, 7, 13));
  });

  test('themPreset song song mot ten mot hang', () async {
    final r = await Future.wait([
      kho.themPreset(ten: Chuoi.day6Gio),
      kho.themPreset(ten: Chuoi.day6Gio),
      kho.themPreset(ten: Chuoi.day6Gio),
    ]);
    expect(r.where((x) => x).length, 1);
    expect(kho.hang.length, 1);
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

  testWidgets('chip tap lien tiep khong nhan ban ten', (tester) async {
    await tester.pumpWidget(_app(kho));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.day6Gio));
    await tester.tap(find.text(Chuoi.day6Gio));
    await tester.tap(find.text(Chuoi.day6Gio));
    await tester.pumpAndSettle();
    expect(kho.hang.length, 1);
    expect(kho.hang.single.habit.ten, Chuoi.day6Gio);
  });

  testWidgets('tick doi UI ngay', (tester) async {
    await kho.themPreset(ten: Chuoi.day6Gio);
    await tester.pumpWidget(_app(kho));
    await tester.pumpAndSettle();
    expect(kho.hang.single.ticked, isFalse);
    final fut = kho.toggle(kho.hang.single);
    expect(kho.hang.single.ticked, isTrue);
    await fut;
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

  testWidgets('mo mot habit: chuoi, xoa dung cau khoa', (tester) async {
    await kho.themPreset(ten: Chuoi.day6Gio);
    await tester.pumpWidget(_app(kho));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('chi-tiet-${kho.hang.single.habit.id}')));
    await tester.pumpAndSettle();
    expect(find.text('Chuỗi 0 ngày'), findsOneWidget);
    expect(find.text('Còn 25 ngày nữa là đạt 25'), findsOneWidget);

    await tester.tap(find.text(Chuoi.xoa));
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.xoaKhoiMay), findsOneWidget);
    await tester.tap(find.text(Chuoi.huy));
    await tester.pumpAndSettle();
    expect(kho.hang.length, 1);
  });

  testWidgets('o thang doi selectedDate, Back Home theo ngay do', (tester) async {
    await kho.themPreset(ten: Chuoi.day6Gio);
    await tester.pumpWidget(_app(kho));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('chi-tiet-${kho.hang.single.habit.id}')));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('o-ngay-2026-07-15')));
    await tester.pumpAndSettle();
    expect(kho.selected, DateTime(2026, 7, 15));

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('Thứ Tư, 15 tháng 7'), findsOneWidget);
    expect(find.text('1/1 ngày 15/7'), findsOneWidget);
    expect(find.text(Chuoi.day6Gio), findsOneWidget);
  });
}
