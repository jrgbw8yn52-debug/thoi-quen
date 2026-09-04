import 'dart:math';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thoi_quen/chuoi.dart';
import 'package:thoi_quen/cong_thuc.dart';
import 'package:thoi_quen/db/database.dart';
import 'package:thoi_quen/he.dart';
import 'package:thoi_quen/kho.dart';
import 'package:thoi_quen/man/he.dart';
import 'package:thoi_quen/mau.dart';
import 'package:thoi_quen/ngay.dart';
import 'package:thoi_quen/widget/thanh_day.dart';

void main() {
  test('cong thuc EXP cap suc tam, pool cau', () {
    expect(He.canCap(1), 120);
    expect(He.canCap(2), 160);
    expect(He.canCap(3), 200);
    expect(He.expTick, 10);
    expect(He.expCan, 10);
    expect(He.expTap(0), 20);
    expect(He.expTap(24), 20);
    expect(He.expTap(25), 21);
    expect(He.expTap(70), 22);
    expect(He.sucTam(luc: 0, ben: 0, coKy: false), 10);
    expect(He.sucTam(luc: 3, ben: 2, coKy: true), 23);
    expect(He.cauLenCap.length, greaterThanOrEqualTo(8));
    expect(He.cauKhichLe.length, greaterThanOrEqualTo(12));
    expect(He.manhPool, isNotEmpty);
    final r = Random(1);
    final a = He.xoay(He.cauLenCap, null, r);
    final b = He.xoay(He.cauLenCap, a, r);
    expect(b, isNot(equals(a)));
    final kq = He.lenCap(level: 1, exp: 120, unspent: 0);
    expect(kq.level, 2);
    expect(kq.exp, 0);
    expect(kq.unspent, 3);
    expect(kq.lan, 1);
  });

  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('tick Home → quest xong + EXP + câu', () async {
    final kho = Kho(db, bayGio: DateTime(2026, 8, 30, 13), rng: Random(2));
    addTearDown(kho.dispose);
    await kho.tai();
    final id = await db.themHabit(ten: 'Dậy 6 giờ', createdOn: kho.homNay);
    await kho.tai();
    expect(kho.he.level, 1);
    expect(kho.he.exp, 0);
    final q0 = kho.heQuest.where((q) => q.kind == He.kindHabit).single;
    expect(q0.ten, 'Làm: Dậy 6 giờ');
    expect(q0.xong, isFalse);
    expect(kho.heKhichLe, isNull);

    await kho.toggle(kho.hang.single);
    expect(kho.hang.single.ticked, isTrue);
    expect(kho.heQuest.where((q) => q.kind == He.kindHabit).single.xong, isTrue);
    expect(kho.he.exp, 10);
    expect(kho.heKhichLe, isNotNull);
    expect(He.cauKhichLe.contains(kho.heKhichLe), isTrue);
    expect(kho.heFlash, 1);
    expect(id, isNotNull);

    await kho.toggle(kho.hang.single);
    expect(kho.hang.single.ticked, isFalse);
    expect(kho.he.exp, 10);
    await kho.toggle(kho.hang.single);
    expect(kho.he.exp, 10);
  });

  test('tập → EXP, đủ exp → lên cấp +3 điểm + moment', () async {
    final kho = Kho(db, bayGio: DateTime(2026, 8, 30, 13), rng: Random(3));
    addTearDown(kho.dispose);
    await kho.tai();
    expect(kho.he.level, 1);
    expect(kho.he.unspent, 0);
    for (var i = 0; i < 6; i++) {
      expect(await kho.ghiTap(CongThuc.loaiDiBo, 30), isTrue);
    }
    expect(kho.he.level, 2);
    expect(kho.he.exp, 0);
    expect(kho.he.unspent, 3);
    expect(kho.heMoment, isNotNull);
    expect(He.cauLenCap.contains(kho.heMoment), isTrue);
    expect(kho.heQuest.where((q) => q.kind == He.kindTap).single.xong, isTrue);
    expect(kho.heVienCam, isTrue);
    expect(kho.heLuaCau, Chuoi.luaTang);

    expect(await kho.congChiSo('luc'), isTrue);
    expect(kho.he.luc, 1);
    expect(kho.he.unspent, 2);
    expect(kho.sucTam, 17);
  });

  test('mở lại app: status còn', () async {
    final k1 = Kho(db, bayGio: DateTime(2026, 8, 30, 13), rng: Random(4));
    addTearDown(k1.dispose);
    await k1.tai();
    for (var i = 0; i < 6; i++) {
      await k1.ghiTap(CongThuc.loaiDiBo, 30);
    }
    await k1.congChiSo('ben');
    expect(k1.he.level, 2);
    expect(k1.he.unspent, 2);
    expect(k1.he.ben, 1);

    final k2 = Kho(db, bayGio: DateTime(2026, 8, 30, 13));
    addTearDown(k2.dispose);
    await k2.tai();
    expect(k2.he.level, 2);
    expect(k2.he.exp, 0);
    expect(k2.he.unspent, 2);
    expect(k2.he.ben, 1);
    expect(k2.he.luc, 0);
    expect(k2.heQuest.where((q) => q.kind == He.kindTap).single.xong, isTrue);
  });

  test('không EXP khi sửa >6 ngày; nắp 200/ngày', () async {
    final kho = Kho(db, bayGio: DateTime(2026, 8, 30, 13), rng: Random(5));
    addTearDown(kho.dispose);
    await kho.tai();
    await db.themHabit(ten: 'Đọc 20 trang', createdOn: DateTime(2026, 8, 1));
    await kho.tai();
    expect(
      await kho.ghiTap(CongThuc.loaiDiBo, 30, ngay: DateTime(2026, 8, 23)),
      isFalse,
    );
    expect(kho.he.exp, 0);

    kho.chonNgay(kho.homNay);
    for (var i = 0; i < 20; i++) {
      await kho.ghiTap(CongThuc.loaiDiBo, 30);
    }
    final nap = await db.expHomNay(Ngay.iso(kho.homNay));
    expect(nap, 200);
    expect(kho.he.exp + He.canCap(1), lessThanOrEqualTo(200));
  });

  test('cân 1 lần/ngày, kỹ mặc định theo streak', () async {
    final kho = Kho(db, bayGio: DateTime(2026, 8, 30, 13), rng: Random(6));
    addTearDown(kho.dispose);
    await kho.tai();
    expect(kho.heKy.length, 2);
    expect(kho.kyNhipThoLuc, isFalse);
    expect(kho.kyBuocDauLuc, isFalse);
    expect(kho.sucTam, 10);
    expect(await kho.ghiCanKg(70), isTrue);
    expect(kho.he.exp, 10);
    expect(await kho.ghiCanKg(71), isTrue);
    expect(kho.he.exp, 10);
    expect(kho.heQuest.where((q) => q.kind == He.kindCan).single.xong, isTrue);
    expect(await kho.ghiTap(CongThuc.loaiDiBo, 30), isTrue);
    expect(kho.kyNhipThoLuc, isTrue);
    expect(kho.heKy.first.hieuLuc, isTrue);
  });

  testWidgets('màn Hệ hiện cấp EXP quest kỹ', (tester) async {
    tester.view.physicalSize = const Size(390, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    final kho = Kho(db, bayGio: DateTime(2026, 8, 30, 13), rng: Random(7));
    addTearDown(kho.dispose);
    await kho.tai();
    await db.themHabit(ten: 'Dậy 6 giờ', createdOn: kho.homNay);
    await kho.tai();
    await tester.pumpWidget(MaterialApp(
      theme: Mau.theme(),
      home: Scaffold(body: ManHe(kho: kho)),
    ));
    await tester.pump();
    expect(find.text(Chuoi.he), findsOneWidget);
    expect(find.text(Chuoi.capSo(1)), findsOneWidget);
    expect(find.textContaining(Chuoi.expNhan), findsOneWidget);
    expect(find.text(Chuoi.lamQuest('Dậy 6 giờ')), findsOneWidget);
    expect(find.text(Chuoi.tapHomNayQuest), findsOneWidget);
    expect(find.text(Chuoi.ghiCanQuest), findsOneWidget);
    expect(find.text(Chuoi.nhipThoVung), findsOneWidget);
    expect(find.text(Chuoi.buocDau), findsOneWidget);
    expect(find.text(Chuoi.tamYeu), findsWidgets);
    expect(find.byKey(const Key('he-cong-luc')), findsNothing);

    await kho.toggle(kho.hang.single);
    await tester.pump();
    expect(find.text(Chuoi.lamQuest('Dậy 6 giờ')), findsOneWidget);
    expect(find.textContaining('10 / 120'), findsOneWidget);
    expect(find.text(Chuoi.dangHieuLuc), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });

  testWidgets('tab Hệ sau Tiến độ; tick Home rồi mở — quest xong + EXP', (tester) async {
    tester.view.physicalSize = const Size(390, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    final kho = Kho(db, bayGio: DateTime(2026, 8, 30, 13), rng: Random(8));
    addTearDown(kho.dispose);
    await kho.tai();
    await db.themHabit(ten: 'Dậy 6 giờ', createdOn: kho.homNay);
    await kho.tai();
    var tab = 0;
    await tester.pumpWidget(MaterialApp(
      theme: Mau.theme(),
      home: Scaffold(
        body: ManHe(kho: kho),
        bottomNavigationBar: ThanhDay(
          tab: tab,
          onTab: (i) {
            tab = i;
            kho.chonTab(i);
          },
          onCong: () {},
        ),
      ),
    ));
    await tester.pump();
    expect(find.text(Chuoi.homNay), findsOneWidget);
    expect(find.text(Chuoi.lich), findsOneWidget);
    expect(find.text(Chuoi.tienDo), findsOneWidget);
    expect(find.text(Chuoi.he), findsWidgets);
    expect(find.text(Chuoi.taiKhoan), findsOneWidget);
    expect(find.byKey(const Key('tab-he')), findsOneWidget);
    await kho.toggle(kho.hang.single);
    await tester.pump();
    await tester.tap(find.byKey(const Key('tab-he')));
    await tester.pump();
    expect(tab, 3);
    expect(kho.tab, 3);
    expect(find.byKey(const Key('he-man')), findsOneWidget);
    expect(find.text(Chuoi.capSo(1)), findsOneWidget);
    expect(find.textContaining('10 / 120'), findsOneWidget);
    expect(find.text(Chuoi.lamQuest('Dậy 6 giờ')), findsOneWidget);
    expect(find.byKey(const Key('he-khich-le')), findsOneWidget);
    expect(kho.he.exp, 10);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });
}
