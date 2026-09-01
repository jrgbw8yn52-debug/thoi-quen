import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thoi_quen/chuoi.dart';
import 'package:thoi_quen/cong_thuc.dart';
import 'package:thoi_quen/db/database.dart';
import 'package:thoi_quen/kho.dart';
import 'package:thoi_quen/man/mot_habit.dart';
import 'package:thoi_quen/man/them_habit.dart';
import 'package:thoi_quen/mau.dart';
import 'package:thoi_quen/ngay.dart';
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
    expect(find.byKey(const Key('them-thoi-quen')), findsOneWidget);

    await tester.tap(find.text(Chuoi.day6Gio));
    await tester.pumpAndSettle();

    expect(find.textContaining('1/1'), findsOneWidget);
    expect(find.byKey(const Key('them-thoi-quen')), findsOneWidget);

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
    expect(find.text(Chuoi.nhatKy), findsOneWidget);

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
    expect(find.text(Chuoi.kcalTieuThu), findsOneWidget);
    expect(find.text(Chuoi.kcalNap), findsOneWidget);
    expect(find.text(Chuoi.kcalTieuThuHomNay(0)), findsNothing);
    expect(find.text(Chuoi.xemBaoCao), findsNothing);
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
    await tester.tap(find.byKey(Key('lua-ngay-${Ngay.iso(DateTime(2026, 8, 31))}')));
    await tester.pumpAndSettle();
    expect(kho.selected, DateTime(2026, 8, 31));
    expect(find.byKey(const Key('to-ngay-tap')), findsOneWidget);
    Navigator.of(tester.element(find.byKey(const Key('to-ngay-tap')))).pop();
    await tester.pumpAndSettle();

    await tester.tap(find.text(Chuoi.homNay).last);
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
    expect(kho.hang, isEmpty);
    expect(kho.hienO(kho.dsHien.single, kho.homNay), isFalse);
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
    kho.chonNgay(DateTime(2026, 8, 23));
    expect(kho.khoaGhi, isTrue);
    expect(kho.hang, isEmpty);
    expect(await kho.themPreset(ten: Chuoi.doc20Trang), isFalse);
    expect(kho.dsHien.length, 1);
  });

  testWidgets('Co the: disclaimer, thieu du lieu, khong bia 70, Nguon', (tester) async {
    tester.view.physicalSize = const Size(390, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(_app(kho));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.taiKhoan));
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.taiKhoan), findsWidgets);
    expect(find.text(Chuoi.xoaDuLieu), findsOneWidget);
    expect(find.text(Chuoi.nguonDisclaimer), findsOneWidget);
    expect(find.text(Chuoi.phienBan), findsOneWidget);

    expect(find.textContaining(Chuoi.thieuChieuCao), findsOneWidget);
    await tester.tap(find.textContaining(Chuoi.thieuGioi));
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.itVanDong), findsOneWidget);
    expect(find.text(Chuoi.luuHoSo), findsOneWidget);
    expect(find.text(Chuoi.ghiTrongNgay), findsNothing);
    expect(find.text('70'), findsNothing);
    expect(find.text(Chuoi.bmi), findsNothing);
    expect(find.text(Chuoi.soDoBanDau), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.nguonDisclaimer));
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.mifflin), findsOneWidget);
    expect(find.text(Chuoi.whoA), findsOneWidget);
    expect(find.text(Chuoi.heSoKhongMifflin), findsOneWidget);
    Navigator.of(tester.element(find.text(Chuoi.mifflin))).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.chiSo));
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.bmi), findsNothing);
    expect(find.text(Chuoi.uocTinh), findsNothing);
  });

  testWidgets('Tien do: cot tuan doi selectedDate, Home theo', (tester) async {
    await kho.themPreset(ten: Chuoi.day6Gio);
    await tester.pumpWidget(_app(kho));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.tienDo));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('phin-habit-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('T2').first);
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    expect(kho.selected, DateTime(2026, 8, 24));
    await tester.tap(find.text(Chuoi.homNay));
    await tester.pumpAndSettle();
    expect(find.text('Thứ Hai, 24 tháng 8 2026'), findsOneWidget);
  });

  testWidgets('Telex ten habit khong cat', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: Mau.theme(),
      home: ManThemHabit(kho: kho),
    ));
    await tester.pumpAndSettle();
    final tf = tester.widget<TextField>(find.byKey(const Key('ten-habit')));
    expect(tf.inputFormatters ?? const [], isEmpty);
    expect(tf.onChanged, isNull);
    expect(tf.autocorrect, isFalse);
    expect(tf.enableSuggestions, isFalse);
    expect(tf.textCapitalization, TextCapitalization.sentences);
    expect(tf.enableIMEPersonalizedLearning, isTrue);
    await tester.enterText(find.byKey(const Key('ten-habit')), 'taapj');
    expect(tf.controller!.text, 'taapj');
    await tester.enterText(find.byKey(const Key('ten-habit')), 'tập');
    expect(tf.controller!.text, 'tập');
    await tester.tap(find.text(Chuoi.luu));
    await tester.pumpAndSettle();
    expect(kho.dsHien.any((h) => h.ten == 'tập'), isTrue);
  });

  testWidgets('Hom nay 31/8: 1/9 co, 29/8 khong, hang phu co dinh', (tester) async {
    tester.view.physicalSize = const Size(390, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    final k = Kho(db, bayGio: DateTime(2026, 8, 31, 8));
    await k.tai();
    await k.themPreset(ten: 'Dậy sớm', thuBit: '1234', gioNhac: 7 * 60);
    expect(k.hienO(k.dsHien.single, DateTime(2026, 9, 1)), isTrue);
    expect(k.hienO(k.dsHien.single, DateTime(2026, 8, 29)), isFalse);

    await tester.pumpWidget(_app(k));
    await tester.pumpAndSettle();
    expect(find.textContaining('hôm nay 31/8/2026'), findsOneWidget);

    k.chonNgay(DateTime(2026, 8, 29));
    await tester.pumpAndSettle();
    expect(find.textContaining('hôm nay 31/8/2026'), findsOneWidget);
    expect(k.khoaGhi, isFalse);
    expect(k.hang, isEmpty);

    k.chonNgay(DateTime(2026, 8, 31));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.lich));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.thongKe));
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.thongKe), findsWidgets);
    expect(find.byKey(const Key('duong-thong-ke')), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(PageView), const Offset(-300, 0));
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.thang(9)), findsWidgets);
    await tester.tap(find.byKey(Key('lua-ngay-${Ngay.iso(DateTime(2026, 9, 1))}')));
    await tester.pumpAndSettle();
    expect(k.selected, DateTime(2026, 9, 1));
    expect(find.text('Dậy sớm · 7:00 SA'), findsOneWidget);
    expect(find.text(Chuoi.hoanThanhThoiQuen(0, 1)), findsOneWidget);
    await tester.tap(find.text('Dậy sớm · 7:00 SA'));
    await tester.pumpAndSettle();
    expect(k.ticksCua(k.dsHien.single.id).contains('2026-09-01'), isFalse);
  });

  test('createdOn = selectedDate: 26/8 co, 24/8 khong', () async {
    final k = Kho(db, bayGio: DateTime(2026, 8, 31, 8));
    await k.tai();
    k.chonNgay(DateTime(2026, 8, 26));
    expect(await k.themPreset(ten: 'Đọc sách', thuBit: '123'), isTrue);
    expect(Ngay.cat(k.dsHien.single.taoLuc), DateTime(2026, 8, 26));
    expect(k.hang.single.habit.ten, 'Đọc sách');
    expect(k.mHabit, 1);
    expect(k.nTick, 1);
    k.chonNgay(DateTime(2026, 8, 24));
    expect(k.hienO(k.dsHien.single, DateTime(2026, 8, 24)), isFalse);
    expect(k.hang, isEmpty);
    k.chonNgay(DateTime(2026, 8, 26));
    expect(k.hang, isNotEmpty);
  });

  testWidgets('hang phu hom nay 31/8 khi tieu de 26/8', (tester) async {
    tester.view.physicalSize = const Size(390, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    final k = Kho(db, bayGio: DateTime(2026, 8, 31, 8));
    await k.tai();
    k.chonNgay(DateTime(2026, 8, 26));
    await k.themPreset(ten: 'Đọc sách', thuBit: '123');
    await tester.pumpWidget(_app(k));
    await tester.pumpAndSettle();
    expect(find.text('Thứ Tư, 26 tháng 8 2026'), findsOneWidget);
    expect(find.textContaining('hôm nay 31/8/2026'), findsOneWidget);
    expect(find.text('Đọc sách'), findsOneWidget);

    await tester.tap(find.byKey(const Key('hang-hom-nay')));
    await tester.pumpAndSettle();
    expect(k.selected, DateTime(2026, 8, 31));
    expect(find.text('Thứ Hai, 31 tháng 8 2026'), findsOneWidget);
    expect(find.textContaining('hôm nay 31/8/2026'), findsOneWidget);

    k.chonNgay(DateTime(2026, 8, 26));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.lich));
    await tester.pumpAndSettle();
    expect(k.selected, DateTime(2026, 8, 31));
    expect(find.byKey(const Key('nut-hom-nay')), findsNothing);
    expect(find.text(Chuoi.thongKe), findsOneWidget);
    await tester.tap(find.byKey(Key('lua-ngay-${Ngay.iso(DateTime(2026, 8, 31))}')));
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.hoanThanhThoiQuen(k.hang.where((h) => h.ticked).length, k.hang.length)), findsOneWidget);
    expect(k.hang.length, 1);
    expect(find.text(Chuoi.hoanThanhThoiQuen(0, 1)), findsOneWidget);
    Navigator.of(tester.element(find.byKey(const Key('to-ngay-tap')))).pop();
    await tester.pumpAndSettle();

    await tester.tap(find.text(Chuoi.thongKe));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('duong-thong-ke')), findsOneWidget);
    expect(find.textContaining('Hoàn thành'), findsOneWidget);
    expect(find.textContaining('Đánh giá'), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
  });

  testWidgets('thang 7 bam hang hom nay ve 31/8', (tester) async {
    tester.view.physicalSize = const Size(390, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    final k = Kho(db, bayGio: DateTime(2026, 8, 31, 8));
    await k.tai();
    await k.themPreset(ten: Chuoi.day6Gio);
    k.chonNgay(DateTime(2026, 7, 15));
    await tester.pumpWidget(_app(k));
    await tester.pumpAndSettle();
    expect(find.text('Thứ Tư, 15 tháng 7 2026'), findsOneWidget);
    await tester.tap(find.byKey(const Key('hang-hom-nay')));
    await tester.pumpAndSettle();
    expect(k.selected, DateTime(2026, 8, 31));
    expect(find.text('Thứ Hai, 31 tháng 8 2026'), findsOneWidget);
    expect(k.tuan.first.ngay, DateTime(2026, 8, 31));
  });

  test('lich n/m bang so hang', () async {
    final k = Kho(db, bayGio: DateTime(2026, 8, 31, 8));
    await k.tai();
    await k.themPreset(ten: 'A', thuBit: '1234567');
    k.chonNgay(DateTime(2026, 8, 31));
    await k.themPreset(ten: 'B', thuBit: '6');
    expect(k.hang.length, 1);
    expect(k.mHabit, 1);
    expect(k.dsHien.length, 2);
    expect(Chuoi.hoanThanhThoiQuen(k.nTick, k.mHabit), 'Hoàn thành 1/1 thói quen');
  });

  test('cong thang kep cuoi thang', () {
    expect(Ngay.congThang(DateTime(2026, 8, 12), 1), DateTime(2026, 9, 12));
    expect(Ngay.congThang(DateTime(2026, 1, 31), 1), DateTime(2026, 2, 28));
    expect(Ngay.congThang(DateTime(2024, 1, 31), 1), DateTime(2024, 2, 29));
    expect(Ngay.cuoiKhoang(DateTime(2026, 8, 12), 0), DateTime(2026, 8, 18));
    expect(Ngay.cuoiKhoang(DateTime(2026, 8, 12), 1), DateTime(2026, 9, 12));
  });

  testWidgets('bam 127 go 126,5 Luu — Tien do them diem', (tester) async {
    tester.view.physicalSize = const Size(390, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    await kho.ghiCanKg(127);
    await tester.pumpWidget(_app(kho));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.canNang));
    await tester.pumpAndSettle();
    expect(find.text('127 ${Chuoi.kg}'), findsOneWidget);
    await tester.tap(find.byKey(const Key('so-kg-nhan')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('so-kg')), '126,5');
    await tester.tap(find.text(Chuoi.luu));
    await tester.pumpAndSettle();
    expect(kho.canMoi!.kg, closeTo(126.5, 0.01));
    expect(kho.dsCan.length, 1);
    await tester.tap(find.text(Chuoi.tienDo));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('duong-can')), findsOneWidget);
  });

  test('lua 31/8 14, bo 1-2 xam 14, 3/9 luu 15', () async {
    final k = Kho(db, bayGio: DateTime(2026, 8, 31, 8));
    await k.tai();
    for (var i = 0; i < 13; i++) {
      await db.ghiTap(DateTime(2026, 8, 18).add(Duration(days: i)), CongThuc.loaiDiBo, 20);
    }
    await k.tai();
    expect(k.luaTapHom.so, 13);
    expect(k.luaTapHom.sang, isFalse);
    await k.ghiTap(CongThuc.loaiDiBo, 20, ngay: DateTime(2026, 8, 31));
    expect(k.luaTapHom.so, 14);
    expect(k.luaTapHom.sang, isTrue);

    final k2 = Kho(db, bayGio: DateTime(2026, 9, 2, 8));
    await k2.tai();
    expect(k2.luaTapHom.so, 14);
    expect(k2.luaTapHom.sang, isFalse);

    final k3 = Kho(db, bayGio: DateTime(2026, 9, 3, 8));
    await k3.tai();
    await k3.ghiTap(CongThuc.loaiDiBo, 20, ngay: DateTime(2026, 9, 3));
    expect(k3.luaTapHom.so, 15);
    expect(k3.luaTapHom.sang, isTrue);
  });

  test('doi can ban dau 2 lan: 1 net sang + 2 net mo', () async {
    final k = Kho(db, bayGio: DateTime(2026, 8, 31, 8));
    await k.tai();
    await k.luuHoSo(ten: '', cao: '', sex: null, dob: null, activity: 1.2, banDau: '70');
    await k.luuHoSo(ten: '', cao: '', sex: null, dob: null, activity: 1.2, banDau: '72');
    await k.luuHoSo(ten: '', cao: '', sex: null, dob: null, activity: 1.2, banDau: '68');
    expect(k.startKg, 68);
    expect(k.dsMocBanDau.length, 3);
    expect(k.netSang, [68.0]);
    expect(k.netMo.length, 2);
    expect(k.netMo, containsAll([72.0, 70.0]));
  });

  test('ban dau 150 can 120: tai khoan hien tai, tien do 150/120/-30', () async {
    final k = Kho(db, bayGio: DateTime(2026, 8, 31, 8));
    await k.tai();
    await k.luuHoSo(
      ten: 'A',
      cao: '170',
      sex: 'nam',
      dob: DateTime(1996, 8, 31),
      activity: 1.2,
      banDau: '150',
    );
    await k.ghiCanKg(120);
    expect(k.startKg, 150);
    expect(k.canMoi!.kg, 120);
    expect(k.banDauKg, '150');
    expect(k.hienTaiKg, '120');
    expect(k.doiKg, '-30');
    expect(k.dongTaiKhoan, contains('120 kg'));
    expect(k.dongTaiKhoan, isNot(contains('150 kg')));
  });

  testWidgets('vong tien do co tieu de Thoi quen', (tester) async {
    tester.view.physicalSize = const Size(390, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(_app(kho));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.tienDo));
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.tieuVongNgay), findsOneWidget);
    expect(find.textContaining('đã tick'), findsOneWidget);
    await tester.tap(find.byKey(const Key('phin-habit-1')));
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.tieuVongTuan), findsOneWidget);
    expect(find.text(Chuoi.hoanThanhTheoThu), findsOneWidget);
    expect(find.text(Chuoi.canNang), findsWidgets);
  });

  testWidgets('luu Di bo 30 roi Chay 20: 2 dong; Home lua mo Hoat dong', (tester) async {
    tester.view.physicalSize = const Size(390, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    await kho.ghiCanKg(70);
    await tester.pumpWidget(_app(kho));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('lua-home')), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.hoatDongO));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.luu));
    await tester.pumpAndSettle();
    expect(kho.tapNgay(kho.selected).length, 1);
    expect(
      find.text(Chuoi.dongPhien(
        Chuoi.diBo,
        30,
        CongThuc.kcalTap(met: 3.5, kg: 70, phut: 30)!.round(),
      )),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('mon-picker')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('chon-mon-chay')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('−'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('−'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.luu));
    await tester.pumpAndSettle();
    expect(kho.tapNgay(kho.selected).length, 2);
    expect(
      find.text(Chuoi.dongPhien(
        Chuoi.chay,
        20,
        CongThuc.kcalTap(met: 8.0, kg: 70, phut: 20)!.round(),
      )),
      findsOneWidget,
    );
    expect(find.text(Chuoi.tongHomNay(kho.kcalTapCuaNgay(kho.selected))), findsWidgets);
    expect(find.byKey(const Key('mon-picker')), findsOneWidget);
    expect(find.byKey(Key('lua-ngay-${Ngay.iso(kho.selected)}')), findsNothing);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('lua-home')));
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.hoatDongO), findsWidgets);
    expect(kho.selected, kho.homNay);
  });

  test('26/8 sua tap duoc, 24/8 khong', () async {
    final k = Kho(db, bayGio: DateTime(2026, 8, 31, 8));
    await k.tai();
    k.chonNgay(DateTime(2026, 8, 26));
    expect(k.khoaGhi, isFalse);
    expect(await k.ghiTap(CongThuc.loaiDiBo, 30), isTrue);
    expect(k.tapNgay(DateTime(2026, 8, 26)).length, 1);
    final id = k.tapNgay(DateTime(2026, 8, 26)).first.id;
    k.chonNgay(DateTime(2026, 8, 24));
    expect(k.khoaGhi, isTrue);
    expect(await k.ghiTap(CongThuc.loaiChay, 20), isFalse);
    expect(k.tapNgay(DateTime(2026, 8, 24)), isEmpty);
    expect(await k.xoaTap(id, ngay: DateTime(2026, 8, 24)), isFalse);
    k.chonNgay(DateTime(2026, 8, 26));
    expect(await k.xoaTap(id), isTrue);
    expect(k.tapNgay(DateTime(2026, 8, 26)), isEmpty);
  });

  test('suaTap 29/8 duoc, 24/8 khoa', () async {
    final k = Kho(db, bayGio: DateTime(2026, 8, 31, 8));
    await k.tai();
    k.chonNgay(DateTime(2026, 8, 29));
    expect(await k.ghiTap(CongThuc.loaiDiBo, 30), isTrue);
    final id = k.tapNgay(DateTime(2026, 8, 29)).first.id;
    expect(await k.suaTap(id, CongThuc.loaiChay, 20), isTrue);
    expect(k.tapNgay(DateTime(2026, 8, 29)).first.loai, CongThuc.loaiChay);
    expect(k.tapNgay(DateTime(2026, 8, 29)).first.phut, 20);
    expect(await k.suaTap(id, CongThuc.loaiYoga, 15, ngay: DateTime(2026, 8, 24)), isFalse);
    expect(k.tapNgay(DateTime(2026, 8, 29)).first.loai, CongThuc.loaiChay);
  });

  testWidgets('to ngay 29/8 sua xoa luu, 24/8 chi xem', (tester) async {
    tester.view.physicalSize = const Size(390, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    final k = Kho(db, bayGio: DateTime(2026, 8, 31, 8));
    await k.tai();
    await k.ghiCanKg(70);
    await k.ghiTap(CongThuc.loaiDiBo, 30, ngay: DateTime(2026, 8, 29));
    await db.ghiTap(DateTime(2026, 8, 24), CongThuc.loaiYoga, 15);
    await k.tai();
    await tester.pumpWidget(_app(k));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.lich));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('lua-ngay-${Ngay.iso(DateTime(2026, 8, 29))}')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('to-ngay-tap')), findsOneWidget);
    expect(find.descendant(of: find.byKey(const Key('to-ngay-tap')), matching: find.text(Chuoi.chiXem)), findsNothing);
    expect(find.byKey(const Key('luu-to-ngay')), findsOneWidget);
    expect(find.descendant(of: find.byKey(const Key('to-ngay-tap')), matching: find.text(Chuoi.sua)), findsOneWidget);
    expect(find.descendant(of: find.byKey(const Key('to-ngay-tap')), matching: find.text(Chuoi.xoa)), findsOneWidget);
    await tester.tap(find.byKey(const Key('luu-to-ngay')));
    await tester.pumpAndSettle();
    expect(k.tapNgay(DateTime(2026, 8, 29)).length, 2);
    final id = k.tapNgay(DateTime(2026, 8, 29)).first.id;
    await tester.tap(find.byKey(Key('sua-phien-$id')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('mon-picker')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('chon-mon-chay')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('luu-to-ngay')));
    await tester.pumpAndSettle();
    expect(k.tapNgay(DateTime(2026, 8, 29)).any((t) => t.id == id && t.loai == CongThuc.loaiChay), isTrue);
    await tester.tap(find.byKey(Key('xoa-phien-$id')));
    await tester.pumpAndSettle();
    expect(k.tapNgay(DateTime(2026, 8, 29)).any((t) => t.id == id), isFalse);
    Navigator.of(tester.element(find.byKey(const Key('to-ngay-tap')))).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('lua-ngay-${Ngay.iso(DateTime(2026, 8, 24))}')));
    await tester.pumpAndSettle();
    expect(find.descendant(of: find.byKey(const Key('to-ngay-tap')), matching: find.text(Chuoi.chiXem)), findsOneWidget);
    expect(find.byKey(const Key('luu-to-ngay')), findsNothing);
    expect(find.descendant(of: find.byKey(const Key('to-ngay-tap')), matching: find.text(Chuoi.sua)), findsNothing);
    expect(find.descendant(of: find.byKey(const Key('to-ngay-tap')), matching: find.text(Chuoi.xoa)), findsNothing);
    expect(find.descendant(of: find.byKey(const Key('to-ngay-tap')), matching: find.textContaining(Chuoi.yoga)), findsOneWidget);
  });

  test('can 110: header hien tai, ban dau 150, doi -40, vach dich 100', () async {
    final k = Kho(db, bayGio: DateTime(2026, 8, 31, 8));
    await k.tai();
    await k.luuHoSo(
      ten: 'A',
      cao: '170',
      sex: 'nam',
      dob: DateTime(1996, 8, 31),
      activity: 1.2,
      banDau: '150',
    );
    await k.luuMucTieu(dich: '100', nhip: 0.5);
    await k.ghiCanKg(110);
    expect(k.startKg, 150);
    expect(k.targetKg, 100);
    expect(k.hienTaiKg, '110');
    expect(k.banDauKg, '150');
    expect(k.doiKg, '-40');
    expect(k.dongTaiKhoan, contains('110 kg'));
    expect(k.dongTaiKhoan, isNot(contains('150 kg')));
    expect(k.netSang, containsAll([150.0, 100.0]));
    expect(k.bmiTheoCan, isNotEmpty);
    expect(k.bmiTheoCan.last.$2, closeTo(110 / (1.7 * 1.7), 0.05));
    final du = k.duKienDoc;
    expect(du, isNotNull);
  });

  testWidgets('bao cao BMI doi khi doi can, nhat ky 1800 co diem nap', (tester) async {
    tester.view.physicalSize = const Size(390, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    await kho.luuHoSo(
      ten: 'A',
      cao: '170',
      sex: 'nam',
      dob: DateTime(1996, 1, 1),
      activity: 1.2,
      banDau: '150',
    );
    await kho.ghiCanKg(110);
    final bmi1 = kho.bmiTheoCan.last.$2;
    await tester.pumpWidget(_app(kho));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.nhatKy));
    await tester.pumpAndSettle();
    await kho.luuMon(ten: 'Cơm', kcal: 1800, vaoNgay: true);
    await tester.pumpAndSettle();
    expect(kho.kcalNapCuaNgay(kho.selected), 1800);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await kho.ghiCanKg(100);
    expect(kho.hienTaiKg, '100');
    expect(kho.bmiTheoCan.last.$2, isNot(bmi1));
    await tester.tap(find.text(Chuoi.tienDo));
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.xemBaoCao), findsNothing);
    expect(find.byKey(const Key('duong-bmi')), findsOneWidget);
    expect(find.byKey(const Key('duong-nap')), findsOneWidget);
    expect(find.byKey(const Key('duong-tieu-thu')), findsOneWidget);
    expect(find.text(Chuoi.chuaGhiNap), findsNothing);
    expect(find.text(Chuoi.kcalTieuThu), findsOneWidget);
    expect(find.text(Chuoi.kcalNap), findsOneWidget);
    expect(find.text(Chuoi.kcalTieuThuHomNay(0)), findsNothing);
    expect(find.text(Chuoi.nangLuong), findsOneWidget);
  });

  test('25/8 nguc 110, 31/8 nguc 108: so voi lan truoc -2 cm · 6 ngay', () async {
    final k = Kho(db, bayGio: DateTime(2026, 8, 31, 8));
    await k.tai();
    expect(await k.ghiChiSoNgay(nguc: 110, ngay: DateTime(2026, 8, 25)), isTrue);
    expect(k.startNguc, isNull);
    expect(await k.ghiChiSoNgay(nguc: 108, ngay: DateTime(2026, 8, 31)), isTrue);
    final truoc = k.doiLanTruoc(
      DateTime(2026, 8, 31),
      lay: (c) => c.nguc,
      hien: 108,
    );
    expect(truoc, isNotNull);
    expect(truoc!.delta, closeTo(-2, 0.01));
    expect(truoc.ngay, 6);
    expect(
      Chuoi.soVoiLanTruocDong(truoc.delta, truoc.ngay),
      'so với lần trước: -2 cm · 6 ngày',
    );
    expect(
      k.doiBanDau(DateTime(2026, 8, 31), moc0: k.startNguc, hien: 108),
      isNull,
    );
  });

  testWidgets('chi so man hien so voi lan truoc -2 cm · 6 ngay', (tester) async {
    tester.view.physicalSize = const Size(390, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    final k = Kho(db, bayGio: DateTime(2026, 8, 31, 8));
    await k.tai();
    await k.ghiChiSoNgay(nguc: 110, ngay: DateTime(2026, 8, 25));
    await k.ghiChiSoNgay(nguc: 108, ngay: DateTime(2026, 8, 31));
    await tester.pumpWidget(_app(k));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.chiSo));
    await tester.pumpAndSettle();
    expect(find.text('so với lần trước: -2 cm · 6 ngày'), findsOneWidget);
    expect(find.textContaining('so với ban đầu:'), findsNothing);
    expect(find.text(Chuoi.bmi), findsNothing);
  });

  testWidgets('ho so eo 135, 2/9 eo 131 so voi ban dau; Hom nay ve 31/8', (tester) async {
    tester.view.physicalSize = const Size(390, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    final k = Kho(db, bayGio: DateTime(2026, 8, 31, 8));
    await k.tai();
    await k.luuHoSo(
      ten: 'A',
      cao: '170',
      sex: 'nam',
      dob: DateTime(1996, 1, 1),
      activity: 1.2,
      eo0: '135',
    );
    expect(k.startEo, 135);
    expect(k.startDoNgay, '2026-08-31');
    expect(await k.ghiChiSoNgay(eo: 131, ngay: DateTime(2026, 9, 2)), isTrue);
    final dau = k.doiBanDau(DateTime(2026, 9, 2), moc0: k.startEo, hien: 131);
    expect(dau, isNotNull);
    expect(dau!.delta, closeTo(-4, 0.01));
    expect(dau.ngay, 2);
    expect(
      Chuoi.soVoiBanDauDong(dau.delta, dau.ngay),
      'so với ban đầu: -4 cm · 2 ngày',
    );

    k.chonNgay(DateTime(2026, 9, 2));
    await tester.pumpWidget(_app(k));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.chiSo));
    await tester.pumpAndSettle();
    expect(find.text('so với ban đầu: -4 cm · 2 ngày'), findsOneWidget);
    expect(find.text(Chuoi.soDoSoVoiBanDau), findsOneWidget);
    expect(find.byKey(const Key('cot-so-do')), findsOneWidget);
    expect(find.text(Chuoi.bmi), findsNothing);
    expect(k.selected, DateTime(2026, 9, 2));
    await tester.tap(find.byKey(const Key('nut-hom-nay-chi-so')));
    await tester.pumpAndSettle();
    expect(k.selected, DateTime(2026, 8, 31));
    expect(find.text('Thứ Hai, 31 tháng 8 2026'), findsOneWidget);
  });

  testWidgets('BMI nam trong Can, khong trong Chi so', (tester) async {
    tester.view.physicalSize = const Size(390, 1800);
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
    await tester.pumpWidget(_app(kho));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.chiSo));
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.bmi), findsNothing);
    expect(find.text(Chuoi.uocTinh), findsNothing);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.canNang));
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.bmi), findsOneWidget);
    expect(find.text(Chuoi.uocTinh), findsOneWidget);
    expect(find.text(Chuoi.tdee), findsOneWidget);
    expect(find.text(Chuoi.saiSo), findsOneWidget);
  });

  testWidgets('nhat ky TDEE goi y, 4 mau tu log', (tester) async {
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
    final goi = kho.kcalGoiYDoc;
    expect(goi, isNotNull);
    final tdee = kho.tdeeDoc;
    expect(tdee, isNotNull);
    await tester.pumpWidget(_app(kho));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.nhatKy));
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.tdeeGoiY(tdee!.round(), goi!)), findsOneWidget);
    await kho.luuMon(ten: 'A', kcal: goi + 200, vaoNgay: true);
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.vuotChiTieu), findsOneWidget);
    expect(find.byKey(const Key('vong-kcal')), findsOneWidget);
    expect(find.byKey(const Key('kcal-con')), findsOneWidget);
    final id = kho.logNgay(kho.selected).first.id;
    await kho.suaLog(id, kcal: goi);
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.dungChiTieu), findsOneWidget);
    await kho.suaLog(id, kcal: goi - 701);
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.quaThap), findsOneWidget);
  });

  testWidgets('Bo luc lac chi kho roi 1/9 chon mon cong nap', (tester) async {
    tester.view.physicalSize = const Size(390, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    final k = Kho(db, bayGio: DateTime(2026, 8, 31, 8));
    await k.tai();
    await tester.pumpWidget(_app(k));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.nhatKy));
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.thucDonHomNay), findsOneWidget);
    await tester.tap(find.byKey(const Key('nut-tao-cong-thuc')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('ten-mon')), 'Bò lúc lắc');
    await tester.enterText(find.byKey(const Key('dan-chu')), 'Bò lúc lắc 520 kcal');
    await tester.pump();
    expect(find.text(Chuoi.docNKcal(520)), findsOneWidget);
    await tester.tap(find.byKey(const Key('chi-luu-kho')));
    await tester.pumpAndSettle();
    expect(k.dsMon.any((f) => f.ten == 'Bò lúc lắc' && f.kcal == 520), isTrue);
    k.chonNgay(DateTime(2026, 9, 1));
    await tester.pumpAndSettle();
    expect(k.kcalNapCuaNgay(DateTime(2026, 9, 1)), 0);
    expect(k.logNgay(DateTime(2026, 9, 1)), isEmpty);
    await tester.tap(find.byKey(const Key('nut-mon-da-luu')));
    await tester.pumpAndSettle();
    final id = k.dsMon.firstWhere((f) => f.ten == 'Bò lúc lắc').id;
    await tester.tap(find.byKey(Key('mon-kho-$id')));
    await tester.pumpAndSettle();
    expect(k.kcalNapCuaNgay(DateTime(2026, 9, 1)), 520);
    expect(k.logNgay(DateTime(2026, 9, 1)).single.ten, 'Bò lúc lắc');
    expect(k.dsMon.any((f) => f.ten == 'Bò lúc lắc'), isTrue);
  });

  testWidgets('to 25/8 tap + thuc don + 2 tong; 24/8 chi xem', (tester) async {
    tester.view.physicalSize = const Size(390, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    final k = Kho(db, bayGio: DateTime(2026, 8, 31, 8));
    await k.tai();
    await k.ghiCanKg(70);
    await k.ghiTap(CongThuc.loaiDiBo, 30, ngay: DateTime(2026, 8, 25));
    await k.luuMon(ten: 'Phở', kcal: 400, vaoNgay: true, ngay: DateTime(2026, 8, 25));
    await db.ghiTap(DateTime(2026, 8, 24), CongThuc.loaiYoga, 15);
    await db.ghiLog(DateTime(2026, 8, 24), ten: 'Cơm', kcal: 200);
    await k.tai();
    await tester.pumpWidget(_app(k));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.lich));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('lua-ngay-${Ngay.iso(DateTime(2026, 8, 25))}')));
    await tester.pumpAndSettle();
    final to = find.byKey(const Key('to-ngay-tap'));
    expect(to, findsOneWidget);
    expect(find.descendant(of: to, matching: find.text(Chuoi.thucDon)), findsOneWidget);
    expect(find.descendant(of: to, matching: find.text(Chuoi.thoiQuen)), findsOneWidget);
    expect(find.descendant(of: to, matching: find.text(Chuoi.tap)), findsOneWidget);
    await tester.tap(find.byKey(const Key('khoi-tap')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('khoi-thuc-don')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('nut-them-mon')), findsOneWidget);
    expect(find.descendant(of: to, matching: find.textContaining('Phở')), findsOneWidget);
    expect(find.descendant(of: to, matching: find.textContaining('Đi bộ ·')), findsOneWidget);
    expect(find.byKey(const Key('nap-tieu')), findsOneWidget);
    expect(find.text(Chuoi.napTieu(400, k.kcalTapCuaNgay(DateTime(2026, 8, 25)))), findsOneWidget);
    expect(find.descendant(of: to, matching: find.text(Chuoi.sua)), findsWidgets);
    expect(find.descendant(of: to, matching: find.text(Chuoi.xoa)), findsWidgets);
    Navigator.of(tester.element(to)).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('lua-ngay-${Ngay.iso(DateTime(2026, 8, 24))}')));
    await tester.pumpAndSettle();
    expect(find.descendant(of: find.byKey(const Key('to-ngay-tap')), matching: find.text(Chuoi.chiXem)), findsOneWidget);
    await tester.tap(find.byKey(const Key('khoi-tap')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('khoi-thuc-don')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('nut-them-mon')), findsNothing);
    expect(find.descendant(of: find.byKey(const Key('to-ngay-tap')), matching: find.text(Chuoi.sua)), findsNothing);
    expect(find.descendant(of: find.byKey(const Key('to-ngay-tap')), matching: find.text(Chuoi.xoa)), findsNothing);
    expect(find.descendant(of: find.byKey(const Key('to-ngay-tap')), matching: find.textContaining(Chuoi.yoga)), findsOneWidget);
    expect(find.descendant(of: find.byKey(const Key('to-ngay-tap')), matching: find.textContaining('Cơm')), findsOneWidget);
    expect(find.text(Chuoi.napTieu(200, k.kcalTapCuaNgay(DateTime(2026, 8, 24)))), findsOneWidget);
  });

  testWidgets('dan MON KCAL DAM BOT BEO, dam bot beo cong log', (tester) async {
    tester.view.physicalSize = const Size(390, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    final k = Kho(db, bayGio: DateTime(2026, 8, 31, 8));
    await k.tai();
    await tester.pumpWidget(_app(k));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.nhatKy));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('ten-mon')), findsNothing);
    await tester.tap(find.byKey(const Key('nut-tao-cong-thuc')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('dan-chu')),
      'MON: Bò lúc lắc\nKHOI_LUONG: 250\nKCAL: 520\nDAM: 40\nBOT: 12\nBEO: 28',
    );
    await tester.pump();
    expect(find.text(Chuoi.docNKcal(520)), findsOneWidget);
    expect(find.byKey(const Key('ten-mon')), findsNothing);
    expect(tester.widget<TextField>(find.byKey(const Key('doc-kcal'))).controller!.text, '520');
    expect(tester.widget<TextField>(find.byKey(const Key('gram-mon'))).controller!.text, '250');
    expect(tester.widget<TextField>(find.byKey(const Key('dam-mon'))).controller!.text, '40');
    expect(tester.widget<TextField>(find.byKey(const Key('bot-mon'))).controller!.text, '12');
    expect(tester.widget<TextField>(find.byKey(const Key('beo-mon'))).controller!.text, '28');
    await tester.tap(find.byKey(const Key('tinh-vao-ngay')));
    await tester.pumpAndSettle();
    expect(k.logNgay(k.selected).single.dam, 40);
    expect(k.macroNgay(k.selected).dam, 40);
    expect(find.byKey(const Key('vong-kcal')), findsOneWidget);
    expect(find.byKey(const Key('thanh-dam')), findsOneWidget);
    expect(find.text(Chuoi.dongMon('Bò lúc lắc', 520)), findsOneWidget);
  });

  testWidgets('chi dan MON Bo luc lac ten tu co Luu', (tester) async {
    tester.view.physicalSize = const Size(390, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    final k = Kho(db, bayGio: DateTime(2026, 8, 31, 8));
    await k.tai();
    await tester.pumpWidget(_app(k));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.nhatKy));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nut-tao-cong-thuc')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('dan-chu')),
      'MON: Bò lúc lắc\nKCAL: 520',
    );
    await tester.pump();
    expect(find.byKey(const Key('ten-mon')), findsNothing);
    expect(find.text(Chuoi.docNKcal(520)), findsOneWidget);
    await tester.tap(find.byKey(const Key('tinh-vao-ngay')));
    await tester.pumpAndSettle();
    expect(k.dsMon.any((f) => f.ten == 'Bò lúc lắc' && f.kcal == 520), isTrue);
    expect(k.logNgay(k.selected).single.ten, 'Bò lúc lắc');
    expect(k.logNgay(k.selected).single.kcal, 520);
  });

  test('sua kho khong doi log cu, chon sau dung so moi', () async {
    final k = Kho(db, bayGio: DateTime(2026, 8, 31, 8));
    await k.tai();
    await k.luuMon(ten: 'Cơm', kcal: 620, dam: 10, vaoNgay: true);
    final id = k.dsMon.single.id;
    expect(k.logNgay(k.selected).single.kcal, 620);
    expect(await k.suaMon(id: id, ten: 'Cơm', kcal: 500, dam: 8), isTrue);
    expect(k.logNgay(k.selected).single.kcal, 620);
    expect(k.logNgay(k.selected).single.dam, 10);
    expect(k.dsMon.single.kcal, 500);
    expect(await k.chonMon(id), isTrue);
    final logs = k.logNgay(k.selected);
    expect(logs.length, 2);
    expect(logs.map((e) => e.kcal), containsAll([620, 500]));
    expect(logs.firstWhere((e) => e.kcal == 500).dam, 8);
  });

  testWidgets('sua 620 thanh 600 tren to lich, tong nap doi, khong do', (tester) async {
    tester.view.physicalSize = const Size(390, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    final k = Kho(db, bayGio: DateTime(2026, 8, 31, 8));
    await k.tai();
    await k.ghiCanKg(70);
    await k.luuMon(ten: 'Cơm', kcal: 620, vaoNgay: true, ngay: DateTime(2026, 8, 25));
    await tester.pumpWidget(_app(k));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.lich));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('lua-ngay-${Ngay.iso(DateTime(2026, 8, 25))}')));
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.napTieu(620, 0)), findsOneWidget);
    await tester.tap(find.byKey(const Key('khoi-thuc-don')));
    await tester.pumpAndSettle();
    final id = k.logNgay(DateTime(2026, 8, 25)).single.id;
    await tester.tap(find.byKey(Key('sua-log-$id')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('sua-gram')), findsOneWidget);
    expect(find.byKey(const Key('sua-kcal')), findsNothing);
    expect(find.byKey(const Key('sua-dam')), findsNothing);
    await tester.enterText(find.byKey(const Key('sua-gram')), '96,8');
    await tester.pump();
    await tester.tap(find.byKey(const Key('sua-log-luu')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(k.logNgay(DateTime(2026, 8, 25)).single.kcal, 600);
    expect(find.text(Chuoi.napTieu(600, 0)), findsOneWidget);
    expect(find.text(Chuoi.napTieu(620, 0)), findsNothing);
  });

  test('xoa kho khong xoa food_log', () async {
    final k = Kho(db, bayGio: DateTime(2026, 8, 31, 8));
    await k.tai();
    await k.luuMon(ten: 'Cơm', kcal: 400, vaoNgay: true);
    final id = k.dsMon.single.id;
    expect(k.logNgay(k.selected).single.ten, 'Cơm');
    expect(await k.xoaMon(id), isTrue);
    expect(k.dsMon, isEmpty);
    expect(k.logNgay(k.selected).single.ten, 'Cơm');
    expect(k.logNgay(k.selected).single.kcal, 400);
  });

  testWidgets('lich lua do ngay co phien; hoat dong khong luoi thang', (tester) async {
    tester.view.physicalSize = const Size(390, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    final k = Kho(db, bayGio: DateTime(2026, 8, 31, 8));
    await k.tai();
    await k.ghiTap(CongThuc.loaiDiBo, 30, ngay: DateTime(2026, 8, 31));
    await tester.pumpWidget(_app(k));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.lich));
    await tester.pumpAndSettle();
    final o = find.byKey(Key('lua-ngay-${Ngay.iso(DateTime(2026, 8, 31))}'));
    expect(o, findsOneWidget);
    expect(
      find.descendant(of: o, matching: find.byIcon(Icons.local_fire_department)),
      findsOneWidget,
    );
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.hoatDongO));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('mon-picker')), findsOneWidget);
    expect(find.byKey(Key('lua-ngay-${Ngay.iso(DateTime(2026, 8, 31))}')), findsNothing);
    expect(find.text(Chuoi.kcalTapNhan), findsOneWidget);
    expect(find.text(Chuoi.tuanNhan), findsOneWidget);
  });

  test('mau so ky khong dem habit ngay tuong lai', () async {
    await kho.themPreset(ten: Chuoi.day6Gio);
    kho.chonPhin(2);
    expect(kho.nTrenMKy.$2, 1);
    expect(kho.nTrenMKy.$1, 1);
    kho.chonPhin(1);
    expect(kho.nTrenMKy.$2, 1);
    kho.chonNgay(DateTime(2026, 8, 31));
    expect(kho.tongCuaNgay(DateTime(2026, 8, 31)), 1);
    kho.chonPhin(2);
    expect(kho.nTrenMKy.$2, 1);
  });

  testWidgets('lich the ngay dang xem + to ngay', (tester) async {
    tester.view.physicalSize = const Size(390, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    await kho.themPreset(ten: Chuoi.day6Gio);
    await tester.pumpWidget(_app(kho));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Chuoi.lich));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('the-ngay-dang-xem')), findsOneWidget);
    expect(find.text(Chuoi.ngayDangXem), findsOneWidget);
    expect(find.textContaining('Lửa'), findsOneWidget);
    expect(find.text(Chuoi.xemBaoCao), findsNothing);
    await tester.tap(find.byKey(Key('lua-ngay-${Ngay.iso(DateTime(2026, 8, 30))}')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('the-ngay-to')), findsOneWidget);
    expect(find.byKey(const Key('nap-tieu')), findsOneWidget);
    expect(find.text(Chuoi.ngayDangXem), findsWidgets);
  });
}


