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
    await kho.chonVaTick(h, DateTime(2026, 8, 24));
    expect(kho.selected, DateTime(2026, 8, 24));
    expect(kho.hang.first.ticked, isTrue);
    expect(kho.hang.last.ticked, isFalse);
    expect(kho.nTick, 1);
    expect(kho.tuan.first.ngay, DateTime(2026, 8, 24));
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

    expect(find.text('1/1 hôm nay'), findsOneWidget);
    expect(find.text('1/25 tháng này'), findsOneWidget);

    await tester.tap(find.text(Chuoi.day6Gio));
    await tester.pumpAndSettle();
    expect(find.text('0/1 hôm nay'), findsOneWidget);

    await tester.tap(find.text(Chuoi.day6Gio));
    await tester.pumpAndSettle();
    expect(find.text('1/1 hôm nay'), findsOneWidget);
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
    expect(kho.hang.single.ticked, isTrue);
    final fut = kho.toggle(kho.hang.single);
    expect(kho.hang.single.ticked, isFalse);
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

  testWidgets('cham tuan chi hien thi, khong doi ngay', (tester) async {
    await kho.themPreset(ten: Chuoi.day6Gio);
    await tester.pumpWidget(_app(kho));
    await tester.pumpAndSettle();

    await tester.tap(find.text('T2'));
    await tester.pumpAndSettle();
    expect(find.text('Chủ Nhật, 30 tháng 8'), findsOneWidget);
    expect(find.text('1/1 hôm nay'), findsOneWidget);
  });

  testWidgets('tieu de ngay mo con lan', (tester) async {
    await tester.pumpWidget(_app(kho));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('tieu-de-ngay')));
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.chonNgay), findsOneWidget);
    expect(find.text(Chuoi.thang(8)), findsWidgets);
    await tester.tap(find.text(Chuoi.huy));
    await tester.pumpAndSettle();
    expect(find.text('Chủ Nhật, 30 tháng 8'), findsOneWidget);
  });

  testWidgets('mo mot habit: chuoi, xoa dung cau khoa', (tester) async {
    await kho.themPreset(ten: Chuoi.day6Gio);
    await tester.pumpWidget(_app(kho));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('chi-tiet-${kho.hang.single.habit.id}')));
    await tester.pumpAndSettle();
    expect(find.text('Chuỗi 1 ngày'), findsOneWidget);
    expect(find.text('Còn 24 ngày nữa là đạt 25'), findsOneWidget);

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
    expect(find.text('0/1 ngày 15/7 · Chỉ xem.'), findsOneWidget);
    expect(find.text(Chuoi.day6Gio), findsOneWidget);
  });

  test('habit moi tick dung ngay dang xem, khong backfill', () async {
    kho.chonNgay(DateTime(2026, 8, 24));
    await kho.themPreset(ten: Chuoi.day6Gio);
    final ticks = kho.ticksCua(kho.hang.single.habit.id);
    expect(ticks, {'2026-08-24'});
    expect(kho.hang.single.ticked, isTrue);
    kho.chonNgay(DateTime(2026, 8, 30));
    expect(kho.hang.single.ticked, isFalse);
  });

  test('khoa ghi: khong tick, khong them', () async {
    await kho.themPreset(ten: Chuoi.day6Gio);
    final id = kho.hang.single.habit.id;
    expect(kho.ticksCua(id), {'2026-08-30'});
    kho.chonNgay(DateTime(2026, 8, 22));
    expect(kho.khoaGhi, isTrue);
    await kho.toggle(kho.hang.single);
    expect(kho.ticksCua(id), {'2026-08-30'});
    expect(await kho.themPreset(ten: Chuoi.doc20Trang), isFalse);
    expect(kho.hang.length, 1);
  });
}
