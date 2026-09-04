import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thoi_quen/chuoi.dart';
import 'package:thoi_quen/db/database.dart';
import 'package:thoi_quen/kho.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('hàng đợi Cam: chưa tick, sort giờ, không giờ cuối, tối đa 3 ô', () async {
    final kho = Kho(db, bayGio: DateTime(2026, 9, 4, 13));
    addTearDown(kho.dispose);
    await kho.tai();
    Future<void> them(String ten, int? gio) async {
      await kho.themPreset(ten: ten, gioNhac: gio);
    }

    await them('Sáu', 6 * 60);
    await them('Tám', 8 * 60);
    await them('Mười hai', 12 * 60);
    await them('Mười bốn', 14 * 60);
    await them('Mười tám', 18 * 60);
    await them('Không giờ', null);

    // themPreset tự tick ngày tạo. Gỡ tick để còn hàng đợi.
    for (final h in List.of(kho.hang)) {
      if (h.ticked) await kho.toggle(h);
    }
    expect(kho.hangCam.map((h) => h.habit.ten).toList(), [
      'Sáu',
      'Tám',
      'Mười hai',
      'Mười bốn',
      'Mười tám',
      'Không giờ',
    ]);
    expect(kho.hangCam.take(3).map((h) => h.habit.ten).toList(), [
      'Sáu',
      'Tám',
      'Mười hai',
    ]);

    final tam = kho.hangCam.firstWhere((h) => h.habit.ten == 'Tám');
    await kho.toggle(tam);
    expect(kho.hangCam.take(3).map((h) => h.habit.ten).toList(), [
      'Sáu',
      'Mười hai',
      'Mười bốn',
    ]);

    for (final h in List.of(kho.hangCam)) {
      await kho.toggle(h);
    }
    expect(kho.hangCam, isEmpty);
    expect(Chuoi.hetViecHomNay, 'Hết việc hôm nay');
    expect(Chuoi.xong, 'Xong');
  });

  test('tickWid ghi tick hôm nay, không hoàn tác', () async {
    final kho = Kho(db, bayGio: DateTime(2026, 9, 4, 13));
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
}
