import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../ngay.dart';
import '../ten.dart';

part 'database.g.dart';

class Habits extends Table {
  @override
  String get tableName => 'habits';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get ten => text()();
  IntColumn get mucTieuThang => integer().withDefault(const Constant(25))();
  RealColumn get met => real().nullable()();
  IntColumn get phutMacDinh => integer().nullable()();
  IntColumn get thuTu => integer().withDefault(const Constant(0))();
  DateTimeColumn get taoLuc => dateTime()();
}

class Ticks extends Table {
  @override
  String get tableName => 'ticks';

  IntColumn get habitId =>
      integer().references(Habits, #id, onDelete: KeyAction.cascade)();
  TextColumn get ngay => text()();
  IntColumn get phut => integer().nullable()();

  @override
  Set<Column> get primaryKey => {habitId, ngay};
}

class Profiles extends Table {
  @override
  String get tableName => 'profile';

  IntColumn get id => integer()();
  TextColumn get sex => text().nullable()();
  RealColumn get heightCm => real().nullable()();
  TextColumn get dob => text().nullable()();
  RealColumn get activity => real().withDefault(const Constant(1.2))();
  RealColumn get targetKg => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class WeighIns extends Table {
  @override
  String get tableName => 'weigh_ins';

  TextColumn get ngay => text()();
  RealColumn get kg => real()();

  @override
  Set<Column> get primaryKey => {ngay};
}

@DriftDatabase(tables: [Habits, Ticks, Profiles, WeighIns])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _moKetNoi());

  static const int maxHabit = 8;
  static const double metVanDong = 5.5;
  static const int phutVanDong = 30;

  @override
  int get schemaVersion => 1;

  static QueryExecutor _moKetNoi() {
    return driftDatabase(
      name: 'thoi_quen',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await into(profiles).insert(
            ProfilesCompanion.insert(
              id: const Value(1),
              activity: const Value(1.2),
            ),
          );
        },
        onUpgrade: (m, from, to) async {},
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
          await gopTenTrung();
        },
      );

  Future<int> soHabit() async {
    final r = await (select(habits)).get();
    return r.length;
  }

  Future<List<Habit>> dsHabit() {
    return (select(habits)
          ..orderBy([
            (h) => OrderingTerm.asc(h.thuTu),
            (h) => OrderingTerm.asc(h.id),
          ]))
        .get();
  }

  Future<int?> themHabit({
    required String ten,
    int mucTieuThang = 25,
    double? met,
    int? phutMacDinh,
  }) async {
    final tenSach = Ten.sach(ten);
    if (tenSach.isEmpty) return null;
    final ds = await dsHabit();
    if (ds.length >= maxHabit) return null;
    if (ds.any((h) => Ten.trung(h.ten, tenSach))) return null;
    return into(habits).insert(
      HabitsCompanion.insert(
        ten: tenSach,
        mucTieuThang: Value(mucTieuThang),
        met: Value(met),
        phutMacDinh: Value(phutMacDinh),
        thuTu: Value(ds.length),
        taoLuc: DateTime.now(),
      ),
    );
  }

  Future<bool> suaHabit({
    required int id,
    required String ten,
    required int mucTieuThang,
  }) async {
    final tenSach = Ten.sach(ten);
    if (tenSach.isEmpty) return false;
    if (mucTieuThang < 1 || mucTieuThang > 31) return false;
    final ds = await dsHabit();
    if (ds.any((h) => h.id != id && Ten.trung(h.ten, tenSach))) return false;
    final n = await (update(habits)..where((h) => h.id.equals(id))).write(
      HabitsCompanion(
        ten: Value(tenSach),
        mucTieuThang: Value(mucTieuThang),
      ),
    );
    return n > 0;
  }

  Future<void> xoaHabit(int id) async {
    await (delete(habits)..where((h) => h.id.equals(id))).go();
  }

  Future<void> gopTenTrung() async {
    final ds = await dsHabit();
    final giu = <String, Habit>{};
    for (final h in ds) {
      final k = Ten.khoa(h.ten);
      final cu = giu[k];
      if (cu == null) {
        giu[k] = h;
        continue;
      }
      final keep = cu.id <= h.id ? cu : h;
      final drop = cu.id <= h.id ? h : cu;
      await customStatement(
        'INSERT OR IGNORE INTO ticks (habit_id, ngay, phut) '
        'SELECT ?, ngay, phut FROM ticks WHERE habit_id = ?',
        [keep.id, drop.id],
      );
      await (delete(ticks)..where((t) => t.habitId.equals(drop.id))).go();
      await (delete(habits)..where((x) => x.id.equals(drop.id))).go();
      giu[k] = keep;
    }
  }

  Future<List<Tick>> ticksCuaHabit(int habitId) {
    return (select(ticks)..where((t) => t.habitId.equals(habitId))).get();
  }

  Future<List<Tick>> dsTick() => select(ticks).get();

  Future<void> ghiTick(Habit habit, DateTime ngay) async {
    await into(ticks).insert(
      TicksCompanion.insert(
        habitId: habit.id,
        ngay: Ngay.iso(ngay),
        phut: Value(habit.phutMacDinh),
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<void> toggleTick(Habit habit, DateTime ngay) async {
    final iso = Ngay.iso(ngay);
    final cu = await (select(ticks)
          ..where((t) => t.habitId.equals(habit.id) & t.ngay.equals(iso)))
        .getSingleOrNull();
    if (cu != null) {
      await (delete(ticks)
            ..where((t) => t.habitId.equals(habit.id) & t.ngay.equals(iso)))
          .go();
      return;
    }
    await into(ticks).insert(
      TicksCompanion.insert(
        habitId: habit.id,
        ngay: iso,
        phut: Value(habit.phutMacDinh),
      ),
    );
  }

  Future<List<Tick>> ticksNgay(DateTime ngay) {
    final iso = Ngay.iso(ngay);
    return (select(ticks)..where((t) => t.ngay.equals(iso))).get();
  }

  Future<List<Tick>> ticksKhoang(DateTime tu, DateTime den) {
    return (select(ticks)
          ..where(
            (t) => t.ngay.isBetweenValues(Ngay.iso(tu), Ngay.iso(den)),
          ))
        .get();
  }

  Future<List<Tick>> ticksThang(DateTime d) {
    final prefix = '${Ngay.prefixThang(d)}-%';
    return (select(ticks)..where((t) => t.ngay.like(prefix))).get();
  }

  Future<Profile> docProfile() {
    return (select(profiles)..where((p) => p.id.equals(1))).getSingle();
  }

  Future<WeighIn?> canMoiNhat() async {
    final r = await (select(weighIns)
          ..orderBy([(w) => OrderingTerm.desc(w.ngay)])
          ..limit(1))
        .get();
    return r.isEmpty ? null : r.first;
  }

  Future<List<WeighIn>> dsCan() {
    return (select(weighIns)
          ..orderBy([(w) => OrderingTerm.desc(w.ngay)]))
        .get();
  }

  Future<void> ghiCan(DateTime ngay, double kg) async {
    await into(weighIns).insertOnConflictUpdate(
      WeighInsCompanion.insert(ngay: Ngay.iso(ngay), kg: kg),
    );
  }
}
