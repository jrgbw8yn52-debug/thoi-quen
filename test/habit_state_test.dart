import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thoi_quen/chuoi.dart';
import 'package:thoi_quen/db/database.dart';
import 'package:thoi_quen/habit_trang.dart';
import 'package:thoi_quen/kho.dart';
import 'package:thoi_quen/man/them_focus.dart';
import 'package:thoi_quen/mau.dart';
import 'package:thoi_quen/widget/hang_habit.dart';

void main() {
  late AppDatabase db;
  late Kho kho;
  final now = DateTime(2026, 8, 30, 13);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    kho = Kho(db, bayGio: now);
    await kho.tai();
  });

  tearDown(() async {
    await db.close();
  });

  test('habitState: done, override, locked_overdue, open', () {
    final ngay = DateTime(2026, 8, 30);
    expect(
      habitState(
        gioNhac: 8 * 60,
        ticked: true,
        override: true,
        ngay: ngay,
        now: now,
      ),
      HabitTrang.done,
    );
    expect(
      habitState(
        gioNhac: 8 * 60,
        ticked: false,
        override: true,
        ngay: ngay,
        now: now,
      ),
      HabitTrang.doneOverride,
    );
    expect(
      habitState(
        gioNhac: 8 * 60,
        ticked: false,
        override: false,
        ngay: ngay,
        now: now,
      ),
      HabitTrang.lockedOverdue,
    );
    expect(
      habitState(
        gioNhac: 14 * 60,
        ticked: false,
        override: false,
        ngay: ngay,
        now: now,
      ),
      HabitTrang.open,
    );
    expect(
      habitState(
        gioNhac: null,
        ticked: false,
        override: false,
        ngay: ngay,
        now: now,
      ),
      HabitTrang.open,
    );
    expect(HabitTrang.done.daLam, isTrue);
    expect(HabitTrang.doneOverride.daLam, isTrue);
    expect(HabitTrang.doneOverride.tickThat, isFalse);
    expect(HabitTrang.doneOverride.choTick, isFalse);
    expect(HabitTrang.lockedOverdue.gach, isTrue);
    expect(HabitTrang.lockedOverdue.khoa, isTrue);
    expect(HabitTrang.open.choTick, isTrue);
  });

  Future<Habit> _habit({String ten = 'Dậy 6 giờ', int? gio}) async {
    final id = await db.themHabit(
      ten: ten,
      gioNhac: gio,
      createdOn: kho.homNay,
    );
    await kho.tai();
    return kho.dsHien.firstWhere((h) => h.id == id);
  }

  test('habit co gio: het +30 khoa Quá giờ, khong tick bu', () async {
    final h = await _habit(gio: 6 * 60);
    expect(kho.trangCua(h, kho.homNay), HabitTrang.lockedOverdue);
    expect(kho.nTick, 0);
    await kho.toggleNgay(h, kho.homNay);
    expect(kho.ticksCua(h.id), isEmpty);
    expect(kho.hang.single.trang, HabitTrang.lockedOverdue);
  });

  test('habit khong gio: khong khoa 30 phut', () async {
    final h = await _habit(ten: 'Đọc 20 trang');
    expect(kho.trangCua(h, kho.homNay), HabitTrang.open);
    await kho.toggleNgay(h, kho.homNay);
    expect(kho.hang.single.ticked, isTrue);
    expect(kho.trangCua(h, kho.homNay), HabitTrang.done);
  });

  test('override: n/m +1, chuoi lua chi tick that', () async {
    final h = await _habit(gio: 8 * 60);
    expect(kho.chuoiCua(h.id), 0);
    expect(kho.nTick, 0);
    await kho.ghiOverride(kho.homNay, [h]);
    expect(kho.trangCua(h, kho.homNay), HabitTrang.doneOverride);
    expect(kho.nTick, 1);
    expect(kho.mHabit, 1);
    expect(kho.chuoiCua(h.id), 0);
    expect(kho.luaTapHom.so, 0);
  });

  test('xoa Focus nha override, habit mo lai neu con +30', () async {
    final h = await _habit(ten: 'Viết', gio: 15 * 60);
    final id = await kho.themFocus(
      title: 'Họp',
      ngay: kho.homNay,
      gioPhut: 14 * 60,
      durationMin: 120,
    );
    await kho.ghiOverride(kho.homNay, [h]);
    expect(kho.trangCua(h, kho.homNay), HabitTrang.doneOverride);
    await kho.xoaFocus(id);
    expect(kho.trangCua(h, kho.homNay), HabitTrang.open);
  });

  test('Focus qua han nha override; het +30 van khoa', () async {
    final h = await _habit(gio: 8 * 60);
    await kho.themFocus(
      title: 'Họp sáng',
      ngay: kho.homNay,
      gioPhut: 8 * 60,
      durationMin: 30,
    );
    await kho.ghiOverride(kho.homNay, [h]);
    expect(kho.trangCua(h, kho.homNay), HabitTrang.doneOverride);
    await kho.nhaOverrideQuaHan();
    expect(kho.trangCua(h, kho.homNay), HabitTrang.lockedOverdue);
  });

  testWidgets('dialog Uu tien Focus khi trung gio', (tester) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    await _habit(ten: 'Viết', gio: 8 * 60);
    await tester.pumpWidget(
      MaterialApp(
        theme: Mau.theme(),
        home: ManThemFocus(kho: kho),
      ),
    );
    await tester.enterText(find.byKey(const Key('ten-focus')), 'Họp');
    await tester.tap(find.text(Chuoi.luu));
    await tester.pumpAndSettle();
    expect(find.text(Chuoi.uuTienFocus), findsOneWidget);
    await tester.tap(find.text(Chuoi.co));
    await tester.pumpAndSettle();
    expect(kho.hang.single.trang, HabitTrang.doneOverride);
  });

  testWidgets('hang habit hien Quá giờ', (tester) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    await _habit(gio: 6 * 60);
    await tester.pumpWidget(
      MaterialApp(
        theme: Mau.theme(),
        home: Scaffold(
          body: HangHabit(
            hang: kho.hang.single,
            onTap: () {},
            onSua: () {},
            onXoa: () {},
          ),
        ),
      ),
    );
    expect(find.text(Chuoi.quaGio), findsOneWidget);
    expect(find.text('Dậy 6 giờ'), findsOneWidget);
  });
}
