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

  TextField field(WidgetTester tester, Key key) =>
      tester.widget<TextField>(find.byKey(key));

  void camTelex(TextField tf) {
    expect(tf.inputFormatters ?? const [], isEmpty);
    expect(tf.onChanged, isNull);
    expect(tf.controller, isNotNull);
  }

  Future<void> goComposing(
    WidgetTester tester, {
    required String text,
    required TextRange composing,
  }) async {
    tester.testTextInput.updateEditingValue(TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
      composing: composing,
    ));
    await tester.pump();
  }

  testWidgets('Telex ten habit taapj roi tap Luu', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: Mau.theme(),
      home: ManThemHabit(kho: kho),
    ));
    await tester.pump();
    final tf = field(tester, const Key('ten-habit'));
    camTelex(tf);
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

  testWidgets('Telex Gboard taapj thanh tap KHI DANG GO', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: Mau.theme(),
      home: ManThemHabit(kho: kho),
    ));
    await tester.pump();
    await tester.tap(find.byKey(const Key('ten-habit')));
    await tester.pump();
    await tester.showKeyboard(find.byKey(const Key('ten-habit')));

    const key = Key('ten-habit');
    await goComposing(tester, text: 't', composing: const TextRange(start: 0, end: 1));
    final c = field(tester, key).controller!;
    expect(c.value.composing.isValid, isTrue);
    expect(c.text, 't');

    await goComposing(tester, text: 'ta', composing: const TextRange(start: 0, end: 2));
    expect(c.value.composing.isValid, isTrue);
    expect(c.text, 'ta');

    await goComposing(tester, text: 'taa', composing: const TextRange(start: 0, end: 3));
    expect(c.value.composing.isValid, isTrue);
    expect(c.text, 'taa');

    await goComposing(tester, text: 'taap', composing: const TextRange(start: 0, end: 4));
    expect(c.value.composing.isValid, isTrue);
    expect(c.text, 'taap');

    await goComposing(tester, text: 'taapj', composing: const TextRange(start: 0, end: 5));
    expect(c.value.composing.isValid, isTrue);
    expect(c.text, 'taapj');

    tester.testTextInput.updateEditingValue(const TextEditingValue(
      text: 'tập',
      selection: TextSelection.collapsed(offset: 3),
    ));
    await tester.pump();
    expect(c.text, 'tập');
    expect(c.value.composing.isValid, isFalse);
  });

  testWidgets('tim mon TextField tran, onChanged khong gan composing', (tester) async {
    await kho.luuMon(ten: 'Cơm', kcal: 200);
    await tester.pumpWidget(MaterialApp(
      theme: Mau.theme(),
      home: Scaffold(body: ToMonDaLuu(kho: kho)),
    ));
    await tester.pump();
    final tf = field(tester, const Key('tim-kho'));
    camTelex(tf);
    await tester.enterText(find.byKey(const Key('tim-kho')), 'taapj');
    expect(tf.controller!.text, 'taapj');
    await tester.enterText(find.byKey(const Key('tim-kho')), 'tập');
    expect(tf.controller!.text, 'tập');
  });

  testWidgets('tim mon composing khong bi reset, debounce 200ms', (tester) async {
    await kho.luuMon(ten: 'tập', kcal: 100);
    await tester.pumpWidget(MaterialApp(
      theme: Mau.theme(),
      home: Scaffold(body: ToMonDaLuu(kho: kho)),
    ));
    await tester.pump();
    await tester.tap(find.byKey(const Key('tim-kho')));
    await tester.pump();
    await tester.showKeyboard(find.byKey(const Key('tim-kho')));
    const key = Key('tim-kho');
    await goComposing(tester, text: 'taapj', composing: const TextRange(start: 0, end: 5));
    final c = field(tester, key).controller!;
    expect(c.value.composing.isValid, isTrue);
    expect(c.text, 'taapj');
    await tester.pump(const Duration(milliseconds: 250));
    expect(c.value.composing.isValid, isTrue);
    expect(c.text, 'taapj');

    tester.testTextInput.updateEditingValue(const TextEditingValue(
      text: 'tập',
      selection: TextSelection.collapsed(offset: 3),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    expect(c.text, 'tập');
    expect(c.value.composing.isValid, isFalse);
  });

  testWidgets('ten mon va dan chu khong formatter khong onChanged', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: Mau.theme(),
      home: Scaffold(body: ToTaoCongThuc(kho: kho)),
    ));
    await tester.pump();
    camTelex(field(tester, const Key('ten-mon')));
    camTelex(field(tester, const Key('dan-chu')));

    await tester.tap(find.byKey(const Key('ten-mon')));
    await tester.pump();
    await tester.showKeyboard(find.byKey(const Key('ten-mon')));
    await goComposing(
      tester,
      text: 'taapj',
      composing: const TextRange(start: 0, end: 5),
    );
    final c = field(tester, const Key('ten-mon')).controller!;
    expect(c.value.composing.isValid, isTrue);
    expect(c.text, 'taapj');
    tester.testTextInput.updateEditingValue(const TextEditingValue(
      text: 'tập',
      selection: TextSelection.collapsed(offset: 3),
    ));
    await tester.pump();
    expect(c.text, 'tập');
  });
}
