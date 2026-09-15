import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thoi_quen/chuoi.dart';
import 'package:thoi_quen/db/database.dart';
import 'package:thoi_quen/kho.dart';
import 'package:thoi_quen/man/focus.dart';
import 'package:thoi_quen/mau.dart';
import 'package:thoi_quen/nhac.dart';

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

  test('payload Focus f|id, noti id khong trung habit', () {
    expect(Nhac.payloadFocus(12), 'f|12');
    expect(Nhac.idFocusTu('f|12'), 12);
    expect(Nhac.idFocusTu('7|1'), isNull);
    expect(Nhac.notiIdFocus(12), 500012);
  });

  test('noti Xong tick Focus, khong toggle', () async {
    final id = await kho.themFocus(
      title: 'Họp',
      ngay: kho.homNay,
      gioPhut: 15 * 60,
      durationMin: 60,
    );
    await kho.tickTuNoti(Nhac.payloadFocus(id));
    expect(kho.dsFocus.single.done, isTrue);
    expect(kho.tab, 3);
    await kho.tickTuNoti(Nhac.payloadFocus(id));
    expect(kho.dsFocus.single.done, isTrue);
  });

  test('pomo 25/5 doi duoc, het lam hoi tick viec gan', () async {
    expect(kho.pomoLam, 25);
    expect(kho.pomoNghi, 5);
    expect(kho.pomoChu, '25:00');
    kho.doiPomoLam(30);
    expect(kho.pomoLam, 30);
    expect(kho.pomoChu, '30:00');
    kho.doiPomoNghi(10);
    expect(kho.pomoNghi, 10);
    final id = await kho.themFocus(
      title: 'Viết',
      ngay: kho.homNay,
      gioPhut: 14 * 60,
      durationMin: 60,
    );
    kho.ganPomo(id);
    kho.hetPomo();
    expect(kho.pomoHoiTick, isTrue);
    expect(kho.pomoLamDang, isFalse);
    expect(kho.pomoChu, '10:00');
    await kho.tickFocus(id, chiBat: true);
    expect(kho.dsFocus.single.done, isTrue);
  });

  testWidgets('tab Focus co pomodoro 25/5', (tester) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      MaterialApp(
        theme: Mau.theme(),
        home: Scaffold(body: ManFocus(kho: kho)),
      ),
    );
    expect(find.byKey(const Key('pomo-dong')), findsOneWidget);
    expect(find.text('25:00'), findsOneWidget);
    expect(find.text(Chuoi.batDau), findsOneWidget);
    await tester.tap(find.byKey(const Key('pomo-lam-cong')));
    await tester.pump();
    expect(kho.pomoLam, 26);
    await tester.tap(find.byKey(const Key('pomo-bat')));
    await tester.pump();
    expect(kho.pomoChay, isTrue);
    expect(find.text(Chuoi.tamDung), findsOneWidget);
    kho.dungPomo();
  });
}
