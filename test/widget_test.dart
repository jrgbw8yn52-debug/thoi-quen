import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thoi_quen/chuoi.dart';
import 'package:thoi_quen/db/database.dart';
import 'package:thoi_quen/kho.dart';
import 'package:thoi_quen/man/mot_habit.dart';
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
    expect(kho.dongNgay, 'Thứ Tư, 15 tháng 7 2026');
    expect(kho.hang, isEmpty);
    expect(kho.nTickHom, 1);
    expect(kho.mHom, 1);
  });

  test('chonVaTick doi selected roi tick dung ngay', () async {
    await kho.themPreset(ten: Chuoi.day6Gio);
    await kho.themPreset(ten: Chuoi.doc20Trang);
    final h = kho.hang.first.habit;
    await kho.chonVaTick(h, DateTime(2026, 8, 31));
    expect(kho.selected, DateTime(2026, 8, 31));
    expect(kho.hang.first.ticked, isTrue);
    expect(kho.hang.last.ticked, isFalse);
    expect(kho.nTick, 1);
    expect(kho.tuan.first.ngay, DateTime(2026, 8, 31));
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

    expect(find.text('Chủ Nhật, 30 tháng 8 2026'), findsOneWidget);
    expect(find.textContaining('0/0'), findsOneWidget);
    expect(find.textContaining('hôm nay 30/8/2026'), findsOneWidget);
    expect(find.text(Chuoi.day6Gio), findsOneWidget);

    await tester.tap(find.text(Chuoi.day6Gio));
    await tester.pumpAndSettle();

    expect(find.textContaining('1/1'), findsOneWidget);

    await tester.tap(find.text(Chuoi.day6Gio));
    await tester.pumpAndSettle();
    expect(find.textContaining('0/1'), findsOneWidget);

    await tester.tap(find.text(Chuoi.day6Gio));
    await tester.pumpAndSettle();
    expect(find.textContaining('1/1'), findsOneWidget);
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

  testWidgets('nut + mo luoi 4 o, luu can cap nhat Tien do', (tester) async {
    tester.view.physicalSize = const Size(390, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(_app(kho));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.canNang), findsOneWidget);
    expect(find.text('${Chuoi.nhatKy}\n${Chuoi.seLam}'), findsOneWidget);

    await tester.tap(find.text(Chuoi.canNang));
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.canNang), findsWidgets);
    await tester.tap(find.text('+'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.luu));
    await tester.pumpAndSettle();

    expect(kho.canMoi, isNotNull);
    await tester.tap(find.text(Chuoi.tienDo));
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.banDau), findsOneWidget);
    expect(find.text(Chuoi.hienTai), findsOneWidget);
    expect(find.text('Ghi thêm cân để thấy đường'), findsNothing);
    expect(find.text(Chuoi.kcalTapSo(0)), findsOneWidget);
  });

  testWidgets('cham tuan doi selectedDate', (tester) async {
    await kho.themPreset(ten: Chuoi.day6Gio);
    await tester.pumpWidget(_app(kho));
    await tester.pumpAndSettle();

    await tester.tap(find.text('T2'));
    await tester.pumpAndSettle();
    expect(kho.selected, DateTime(2026, 8, 24));
    expect(find.text('Thứ Hai, 24 tháng 8 2026'), findsOneWidget);
    expect(find.textContaining('hôm nay 30/8/2026'), findsOneWidget);
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
    expect(find.text('Chủ Nhật, 30 tháng 8 2026'), findsOneWidget);
  });

  testWidgets('mo mot habit: chuoi, xoa dung cau khoa', (tester) async {
    await kho.themPreset(ten: Chuoi.day6Gio);
    final id = kho.hang.single.habit.id;
    await tester.pumpWidget(MaterialApp(
      theme: Mau.theme(),
      home: ManMotHabit(kho: kho, habitId: id),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Chuỗi 1 ngày'), findsOneWidget);
    expect(find.text('Còn 24 ngày nữa là đạt 25'), findsOneWidget);

    await tester.tap(find.text(Chuoi.xoa));
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.xoaKhoiMay), findsOneWidget);
    await tester.tap(find.text(Chuoi.huy));
    await tester.pumpAndSettle();
    expect(kho.dsHien.length, 1);
  });

  testWidgets('Lich: bam ngay doi selectedDate, Home theo', (tester) async {
    tester.view.physicalSize = const Size(390, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    await kho.themPreset(ten: Chuoi.day6Gio);
    await tester.pumpWidget(_app(kho));
    await tester.pumpAndSettle();

    await tester.tap(find.text(Chuoi.lich));
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.thang(8)), findsWidgets);
    expect(find.text('2026'), findsWidgets);
    await tester.tap(find.text('31'));
    await tester.pumpAndSettle();
    expect(kho.selected, DateTime(2026, 8, 31));

    await tester.tap(find.text(Chuoi.homNay));
    await tester.pumpAndSettle();
    expect(find.text('Thứ Hai, 31 tháng 8 2026'), findsOneWidget);
    expect(find.text(Chuoi.day6Gio), findsOneWidget);
    expect(find.textContaining('hôm nay 30/8/2026'), findsOneWidget);
  });

  test('habit moi tick dung ngay dang xem neu hien', () async {
    await kho.themPreset(ten: Chuoi.day6Gio);
    final ticks = kho.ticksCua(kho.hang.single.habit.id);
    expect(ticks, {'2026-08-30'});
    expect(kho.hang.single.ticked, isTrue);
    kho.chonNgay(DateTime(2026, 9, 1));
    expect(kho.hang.single.ticked, isFalse);
  });

  test('an khoi ds giu tick, khong hien Home', () async {
    await kho.themPreset(ten: Chuoi.day6Gio);
    final id = kho.hang.single.habit.id;
    expect(kho.ticksCua(id), {'2026-08-30'});
    await kho.anKhoiDs(id);
    expect(kho.dsHien, isEmpty);
    expect(kho.hang, isEmpty);
    expect(kho.ticksCua(id), {'2026-08-30'});
  });

  test('lap tuan tu createdOn, khong hien truoc', () async {
    await kho.themPreset(ten: 'Dậy sớm', thuBit: '1234', gioNhac: 7 * 60);
    expect(kho.hang, isEmpty);
    kho.chonNgay(DateTime(2026, 8, 28));
    expect(kho.hang, isEmpty);
    kho.chonNgay(DateTime(2026, 8, 29));
    expect(kho.hang, isEmpty);
    kho.chonNgay(DateTime(2026, 8, 31));
    expect(kho.hang.single.habit.ten, 'Dậy sớm');
    kho.chonNgay(DateTime(2026, 9, 1));
    expect(kho.hang, isNotEmpty);
    kho.chonNgay(DateTime(2026, 9, 3));
    expect(kho.hang, isNotEmpty);
    kho.chonNgay(DateTime(2026, 9, 2));
    expect(kho.hang, isNotEmpty);
    kho.chonNgay(DateTime(2026, 9, 4));
    expect(kho.hang, isEmpty);
  });

  test('khoa ghi: khong tick, khong them', () async {
    await kho.themPreset(ten: Chuoi.day6Gio);
    final id = kho.hang.single.habit.id;
    expect(kho.ticksCua(id), {'2026-08-30'});
    kho.chonNgay(DateTime(2026, 9, 8));
    expect(kho.khoaGhi, isTrue);
    expect(kho.hang, isNotEmpty);
    await kho.toggle(kho.hang.single);
    expect(kho.ticksCua(id), {'2026-08-30'});
    expect(await kho.themPreset(ten: Chuoi.doc20Trang), isFalse);
    expect(kho.dsHien.length, 1);
  });

  testWidgets('Co the: disclaimer, thieu du lieu, khong bia 70, Nguon', (tester) async {
    await tester.pumpWidget(_app(kho));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.taiKhoan));
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.taiKhoan), findsWidgets);
    expect(find.text(Chuoi.xoaDuLieu), findsOneWidget);
    expect(find.text(Chuoi.nguonDisclaimer), findsOneWidget);
    expect(find.text(Chuoi.phienBan), findsOneWidget);

    await tester.tap(find.text(Chuoi.thieuDuLieu).first);
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.uocTinh), findsWidgets);
    expect(find.text(Chuoi.itVanDong), findsOneWidget);
    expect(find.text(Chuoi.luuHoSo), findsOneWidget);
    expect(find.text(Chuoi.ghiTrongNgay), findsNothing);
    expect(find.text('70'), findsNothing);
    expect(find.text(Chuoi.bmi), findsNothing);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.nguonDisclaimer));
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.mifflin), findsOneWidget);
    expect(find.text(Chuoi.whoA), findsOneWidget);
    expect(find.text(Chuoi.heSoKhongMifflin), findsOneWidget);
  });

  testWidgets('Tien do: cot tuan doi selectedDate, Home theo', (tester) async {
    await kho.themPreset(ten: Chuoi.day6Gio);
    await tester.pumpWidget(_app(kho));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.tienDo));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.tuanNhan));
    await tester.pumpAndSettle();
    await tester.tap(find.text('T2').first);
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    expect(kho.selected, DateTime(2026, 8, 24));
    await tester.tap(find.text(Chuoi.homNay));
    await tester.pumpAndSettle();
    expect(find.text('Thứ Hai, 24 tháng 8 2026'), findsOneWidget);
  });
}
