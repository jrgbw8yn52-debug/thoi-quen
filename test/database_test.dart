import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thoi_quen/db/database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('onCreate: 4 bang + profile id=1', () async {
    final bang = await db
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name",
        )
        .get();
    final ten = bang.map((r) => r.read<String>('name')).toSet();
    expect(ten.contains('habits'), isTrue);
    expect(ten.contains('ticks'), isTrue);
    expect(ten.contains('profile'), isTrue);
    expect(ten.contains('weigh_ins'), isTrue);
    expect(ten.contains('foods'), isFalse);

    final p = await db.docProfile();
    expect(p.id, 1);
    expect(p.activity, 1.2);
    expect(p.targetKg, isNull);
    expect(await db.canMoiNhat(), isNull);
  });

  test('schemaVersion = 4', () {
    expect(db.schemaVersion, 4);
  });

  test('ticks UNIQUE (habit_id, ngay)', () async {
    final id = await db.themHabit(ten: 'Dậy 6 giờ');
    await db.into(db.ticks).insert(
          TicksCompanion.insert(habitId: id!, ngay: '2026-08-30'),
        );
    await expectLater(
      db.into(db.ticks).insert(
            TicksCompanion.insert(habitId: id, ngay: '2026-08-30'),
          ),
      throwsA(isA<Exception>()),
    );
  });

  test('toggle tick roi hoan tac, ghi phut mac dinh', () async {
    final id = await db.themHabit(
      ten: 'Vận động',
      met: AppDatabase.metVanDong,
      phutMacDinh: AppDatabase.phutVanDong,
    );
    final h = (await db.dsHabit()).single;
    expect(h.met, 5.5);
    expect(h.phutMacDinh, 30);

    final ngay = DateTime(2026, 8, 30);
    await db.toggleTick(h, ngay);
    var ticks = await db.ticksNgay(ngay);
    expect(ticks.length, 1);
    expect(ticks.single.phut, 30);

    await db.toggleTick(h, ngay);
    ticks = await db.ticksNgay(ngay);
    expect(ticks, isEmpty);
    expect(id, isNotNull);
  });

  test('x/N thang nay khong dem thang khac', () async {
    await db.themHabit(ten: 'Đọc 20 trang');
    final h = (await db.dsHabit()).single;
    await db.toggleTick(h, DateTime(2026, 8, 1));
    await db.toggleTick(h, DateTime(2026, 8, 30));
    await db.toggleTick(h, DateTime(2026, 7, 31));
    final thang8 = await db.ticksThang(DateTime(2026, 8, 15));
    expect(thang8.length, 2);
  });

  test('toi da 8 habit', () async {
    for (var i = 0; i < 8; i++) {
      expect(await db.themHabit(ten: 'H$i'), isNotNull);
    }
    expect(await db.themHabit(ten: 'H9'), isNull);
    expect(await db.soHabit(), 8);
  });

  test('khong trung ten', () async {
    expect(await db.themHabit(ten: 'Dậy 6 giờ'), isNotNull);
    expect(await db.themHabit(ten: ' dậy 6 giờ '), isNull);
    expect(await db.soHabit(), 1);
  });

  test('gop ten trung giu hang cu, gop tick', () async {
    final a = await db.themHabit(ten: 'A');
    await db.into(db.habits).insert(
          HabitsCompanion.insert(
            ten: 'A',
            taoLuc: DateTime.now(),
          ),
        );
    expect(await db.soHabit(), 2);
    final ids = (await db.dsHabit()).map((h) => h.id).toList();
    final drop = ids.firstWhere((id) => id != a);
    await db.into(db.ticks).insert(
          TicksCompanion.insert(habitId: a!, ngay: '2026-08-30'),
        );
    await db.into(db.ticks).insert(
          TicksCompanion.insert(habitId: drop, ngay: '2026-08-29'),
        );
    await db.gopTenTrung();
    expect(await db.soHabit(), 1);
    final ticks = await db.ticksCuaHabit(a);
    expect(ticks.map((t) => t.ngay).toSet(), {'2026-08-29', '2026-08-30'});
  });

  test('khong bia 70 kg khi thieu can', () async {
    expect(await db.canMoiNhat(), isNull);
  });

  test('ghi can upsert theo ngay', () async {
    await db.ghiCan(DateTime(2026, 8, 30), 72.4);
    await db.ghiCan(DateTime(2026, 8, 30), 71.9);
    final ds = await db.dsCan();
    expect(ds.length, 1);
    expect(ds.single.kg, closeTo(71.9, 0.001));
  });
}
