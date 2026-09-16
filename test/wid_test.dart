import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thoi_quen/chuoi.dart';
import 'package:thoi_quen/db/database.dart';
import 'package:thoi_quen/habit_trang.dart';
import 'package:thoi_quen/kho.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('trongCuaSoWid: [gio − 2h, gio + 1h]', () {
    final ngay = DateTime(2026, 9, 4);
    expect(
      trongCuaSoWid(gioPhut: 8 * 60, ngay: ngay, now: DateTime(2026, 9, 4, 6)),
      isTrue,
    );
    expect(
      trongCuaSoWid(gioPhut: 8 * 60, ngay: ngay, now: DateTime(2026, 9, 4, 9)),
      isTrue,
    );
    expect(
      trongCuaSoWid(gioPhut: 8 * 60, ngay: ngay, now: DateTime(2026, 9, 4, 5, 59)),
      isFalse,
    );
    expect(
      trongCuaSoWid(gioPhut: 8 * 60, ngay: ngay, now: DateTime(2026, 9, 4, 9, 1)),
      isFalse,
    );
  });

  test('hangCam: cửa sổ giờ, không giờ ẩn, sort, tối đa 2 ô widget', () async {
    final kho = Kho(db, bayGio: DateTime(2026, 9, 4, 7));
    addTearDown(kho.dispose);
    await kho.tai();
    Future<void> them(String ten, int? gio) async {
      await kho.themPreset(ten: ten, gioNhac: gio);
    }

    await them('Sáu', 6 * 60);
    await them('Tám', 8 * 60);
    await them('Mười hai', 12 * 60);
    await them('Không giờ', null);

    for (final h in List.of(kho.hang)) {
      if (h.ticked) await kho.toggle(h);
    }
    // 7h: Sáu [4–7] + Tám [6–9]. 12h và không giờ ẩn.
    expect(kho.hangCam.map((h) => h.habit.ten).toList(), ['Sáu', 'Tám']);
    expect(kho.hangCam.take(2).length, 2);

    final tam = kho.hangCam.firstWhere((h) => h.habit.ten == 'Tám');
    await kho.toggle(tam);
    expect(kho.hangCam.map((h) => h.habit.ten).toList(), ['Sáu']);

    for (final h in List.of(kho.hangCam)) {
      await kho.toggle(h);
    }
    expect(kho.hangCam, isEmpty);
    expect(Chuoi.hetViecHomNay, 'Hết việc hôm nay');
    expect(Chuoi.xong, 'Xong');
  });

  test('tickWid ghi tick hôm nay, không hoàn tác', () async {
    final kho = Kho(db, bayGio: DateTime(2026, 9, 4, 5));
    addTearDown(kho.dispose);
    await kho.tai();
    await kho.themPreset(ten: 'Sáu', gioNhac: 6 * 60);
    final h = kho.hang.single;
    if (h.ticked) await kho.toggle(h);
    expect(h.habit.id, isNotNull);
    await kho.tickWid(h.habit.id);
    expect(kho.hangCam, isEmpty);
    await kho.tickWid(h.habit.id);
    expect(kho.hang.single.ticked, isTrue);
  });

  test('hangFocus: hôm nay trước, tối đa 1 tương lai, bỏ xong/quá hạn', () async {
    final kho = Kho(db, bayGio: DateTime(2026, 9, 4, 13));
    addTearDown(kho.dispose);
    await kho.tai();
    await kho.themFocus(
      title: 'Sáng',
      ngay: DateTime(2026, 9, 4),
      gioPhut: 8 * 60,
      durationMin: 60,
    );
    await kho.themFocus(
      title: 'Chiều',
      ngay: DateTime(2026, 9, 4),
      gioPhut: 15 * 60,
    );
    await kho.themFocus(
      title: 'Tối',
      ngay: DateTime(2026, 9, 4),
      gioPhut: 19 * 60,
    );
    await kho.themFocus(
      title: 'Mai',
      ngay: DateTime(2026, 9, 5),
      gioPhut: 9 * 60,
      durationMin: 30,
    );
    // 13h: Sáng quá hạn. 1 hôm nay (Chiều) + 1 tương lai (Mai).
    expect(kho.hangFocus.map((t) => t.title).toList(), ['Chiều', 'Mai']);
    expect(kho.focusHomNay.map((t) => t.title).toList(), ['Sáng', 'Chiều', 'Tối']);
    expect(kho.focusNgayMai?.title, 'Mai');

    await kho.tickFocus(kho.hangFocus.first.id, chiBat: true);
    expect(kho.hangFocus.map((t) => t.title).toList(), ['Tối', 'Mai']);

    final kho2 = Kho(db, bayGio: DateTime(2026, 9, 4, 23, 59, 1));
    addTearDown(kho2.dispose);
    await kho2.tai();
    expect(kho2.hangFocus.map((t) => t.title).toList(), ['Mai']);
    expect(Chuoi.hetFocus, 'Hết focus');
    expect(
      Chuoi.widFocusTuongLai(DateTime(2026, 9, 19), 'Party', 2),
      'T7 19/9 Party · còn 2 ngày',
    );
  });
}
