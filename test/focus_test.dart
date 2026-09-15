import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thoi_quen/chuoi.dart';
import 'package:thoi_quen/db/database.dart';
import 'package:thoi_quen/focus_han.dart';
import 'package:thoi_quen/kho.dart';
import 'package:thoi_quen/man/focus.dart';
import 'package:thoi_quen/mau.dart';
import 'package:thoi_quen/ngay.dart';

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

  test('hetHan = gio + duration, khong duration → 23:59', () {
    expect(
      FocusHan.hetHan(ngay: '2026-08-30', gioPhut: 8 * 60, durationMin: 30),
      DateTime(2026, 8, 30, 8, 30),
    );
    expect(
      FocusHan.hetHan(ngay: '2026-08-30', gioPhut: 22 * 60, durationMin: 180),
      DateTime(2026, 8, 31, 1, 0),
    );
    expect(
      FocusHan.hetHan(ngay: '2026-08-30', gioPhut: 9 * 60, durationMin: null),
      DateTime(2026, 8, 30, 23, 59),
    );
  });

  test('tick truoc han, khong tick bu sau han', () async {
    final idSom = await kho.themFocus(
      title: 'Họp',
      ngay: kho.homNay,
      gioPhut: 8 * 60,
      durationMin: 30,
    );
    final idMuon = await kho.themFocus(
      title: 'Viết',
      ngay: kho.homNay,
      gioPhut: 15 * 60,
      durationMin: 60,
    );
    expect(idSom, greaterThan(0));
    expect(kho.quaHanFocus(kho.dsFocus.firstWhere((t) => t.id == idSom)), isTrue);
    expect(kho.tickDuocFocus(kho.dsFocus.firstWhere((t) => t.id == idSom)), isFalse);
    await kho.tickFocus(idSom);
    expect(kho.dsFocus.firstWhere((t) => t.id == idSom).done, isFalse);

    expect(kho.quaHanFocus(kho.dsFocus.firstWhere((t) => t.id == idMuon)), isFalse);
    await kho.tickFocus(idMuon);
    expect(kho.dsFocus.firstWhere((t) => t.id == idMuon).done, isTrue);
  });

  test('khong duration, 13h van tick duoc den 23:59', () async {
    final id = await kho.themFocus(
      title: 'Đọc',
      ngay: kho.homNay,
      gioPhut: 9 * 60,
    );
    expect(kho.tickDuocFocus(kho.dsFocus.single), isTrue);
    await kho.tickFocus(id);
    expect(kho.dsFocus.single.done, isTrue);
  });

  test('cua so sua [today-6, +∞), xoa ngoai cua so bi chan', () async {
    final tre = DateTime(2026, 8, 23);
    expect(Ngay.ghiDuoc(tre, kho.homNay), isFalse);
    final id = await db.themFocus(
      title: 'Cũ',
      ngay: tre,
      gioPhut: 10 * 60,
      durationMin: 30,
      createdAt: tre,
    );
    await kho.tai();
    expect(kho.suaDuocFocus(kho.dsFocus.single), isFalse);
    await kho.xoaFocus(id);
    expect(kho.dsFocus, isNotEmpty);

    final ok = await kho.themFocus(
      title: 'Mai',
      ngay: DateTime(2026, 8, 31),
      gioPhut: 9 * 60,
      durationMin: 30,
    );
    expect(ok, greaterThan(0));
  });

  test('list nhom ngay, sort gio trong ngay', () async {
    await kho.themFocus(title: 'C', ngay: kho.homNay, gioPhut: 18 * 60, durationMin: 30);
    await kho.themFocus(title: 'A', ngay: kho.homNay, gioPhut: 7 * 60, durationMin: 30);
    await kho.themFocus(
      title: 'B',
      ngay: DateTime(2026, 8, 31),
      gioPhut: 8 * 60,
      durationMin: 30,
    );
    final nhom = kho.nhomFocus;
    expect(nhom.length, 2);
    expect(nhom.first.$1, '2026-08-30');
    expect(nhom.first.$2.map((t) => t.title).toList(), ['A', 'C']);
    expect(nhom.last.$2.single.title, 'B');
  });

  testWidgets('tab Focus nut Viec quan trong, tao viec, Chua lam khi qua han',
      (tester) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);

    await kho.themFocus(
      title: 'Họp sáng',
      ngay: kho.homNay,
      gioPhut: 8 * 60,
      durationMin: 30,
    );
    await kho.themFocus(
      title: 'Viết bài',
      ngay: kho.homNay,
      gioPhut: 16 * 60,
      durationMin: 60,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: Mau.theme(),
        home: Scaffold(body: ManFocus(kho: kho)),
      ),
    );
    expect(find.byKey(const Key('man-focus')), findsOneWidget);
    expect(find.text(Chuoi.viecQuanTrong), findsOneWidget);
    expect(find.text('Họp sáng'), findsOneWidget);
    expect(find.text(Chuoi.chuaLam), findsOneWidget);
    expect(find.text('Viết bài'), findsWidgets);

    await tester.tap(find.text('Họp sáng'));
    await tester.pumpAndSettle();
    expect(kho.dsFocus.firstWhere((t) => t.title == 'Họp sáng').done, isFalse);

    await tester.tap(
      find.descendant(
        of: find.byType(ListView),
        matching: find.text('Viết bài'),
      ),
    );
    await tester.pumpAndSettle();
    expect(kho.dsFocus.firstWhere((t) => t.title == 'Viết bài').done, isTrue);

    await tester.tap(find.byKey(const Key('nut-viec-quan-trong')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('ten-focus')), findsOneWidget);
    await tester.enterText(find.byKey(const Key('ten-focus')), 'Tập tối');
    await tester.tap(find.text(Chuoi.luu));
    await tester.pumpAndSettle();
    expect(kho.dsFocus.any((t) => t.title == 'Tập tối'), isTrue);
    expect(find.text('Tập tối'), findsOneWidget);
  });

  test('ghiChu lưu, list 1 dòng, không vào n/m habit', () async {
    final id = await kho.themFocus(
      title: 'Họp',
      ngay: kho.homNay,
      gioPhut: 16 * 60,
      durationMin: 30,
      ghiChu: '  mang  laptop  ',
    );
    expect(id, greaterThan(0));
    expect(kho.dsFocus.single.ghiChu, 'mang laptop');
    expect(kho.nTickHom, 0);
    expect(kho.mHom, 0);
    expect(kho.coFocusNgay(kho.homNay), isTrue);
    await kho.suaFocus(
      id: id,
      title: 'Họp',
      ngay: kho.homNay,
      gioPhut: 16 * 60,
      durationMin: 30,
      ghiChu: '',
    );
    expect(kho.dsFocus.single.ghiChu, isNull);
  });

  test('moTuNoti Focus về tab 2', () {
    kho.moTuNoti('f|12');
    expect(kho.tab, 2);
  });
}
