import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thoi_quen/chuoi.dart';
import 'package:thoi_quen/db/database.dart';
import 'package:thoi_quen/kho.dart';
import 'package:thoi_quen/man/them_habit.dart';
import 'package:thoi_quen/man/to_mon.dart';
import 'package:thoi_quen/mau.dart';

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

  testWidgets('Telex ten habit taapj roi tap Luu', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: Mau.theme(),
      home: ManThemHabit(kho: kho),
    ));
    await tester.pump();
    final tf = tester.widget<TextField>(find.byKey(const Key('ten-habit')));
    expect(tf.inputFormatters ?? const [], isEmpty);
    expect(tf.onChanged, isNull);
    expect(tf.textCapitalization, TextCapitalization.sentences);
    expect(tf.enableIMEPersonalizedLearning, isTrue);
    await tester.enterText(find.byKey(const Key('ten-habit')), 'taapj');
    expect(tf.controller!.text, 'taapj');
    await tester.enterText(find.byKey(const Key('ten-habit')), 'tập');
    expect(tf.controller!.text, 'tập');
    await tester.tap(find.text(Chuoi.luu));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(kho.dsHien.any((h) => h.ten == 'tập'), isTrue);
  });

  testWidgets('tim mon TextField tran, onChanged khong gan composing', (tester) async {
    await kho.luuMon(ten: 'Cơm', kcal: 200);
    await tester.pumpWidget(MaterialApp(
      theme: Mau.theme(),
      home: Scaffold(body: ToMonDaLuu(kho: kho)),
    ));
    await tester.pump();
    final tf = tester.widget<TextField>(find.byKey(const Key('tim-kho')));
    expect(tf.inputFormatters ?? const [], isEmpty);
    expect(tf.onChanged, isNull);
    expect(tf.controller, isNotNull);
    await tester.enterText(find.byKey(const Key('tim-kho')), 'taapj');
    expect(tf.controller!.text, 'taapj');
    await tester.enterText(find.byKey(const Key('tim-kho')), 'tập');
    expect(tf.controller!.text, 'tập');
  });
}
