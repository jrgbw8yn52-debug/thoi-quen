import 'dart:io';

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
  TextColumn get thuBit => text().withDefault(const Constant('1234567'))();
  IntColumn get gioNhac => integer().nullable()();
  BoolColumn get an => boolean().withDefault(const Constant(false))();
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
  TextColumn get tenGoi => text().nullable()();
  RealColumn get nhipKg => real().withDefault(const Constant(0.5))();

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

class EoIns extends Table {
  @override
  String get tableName => 'eo_ins';

  TextColumn get ngay => text()();
  RealColumn get cm => real()();

  @override
  Set<Column> get primaryKey => {ngay};
}

class MoIns extends Table {
  @override
  String get tableName => 'mo_ins';

  TextColumn get ngay => text()();
  RealColumn get pct => real()();

  @override
  Set<Column> get primaryKey => {ngay};
}

class TapIns extends Table {
  @override
  String get tableName => 'tap_ins';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get ngay => text()();
  TextColumn get loai => text()();
  IntColumn get phut => integer()();
}

class ChiSoIns extends Table {
  @override
  String get tableName => 'chi_so';

  TextColumn get ngay => text()();
  RealColumn get eo => real().nullable()();
  RealColumn get hong => real().nullable()();
  RealColumn get nguc => real().nullable()();
  RealColumn get bapTay => real().nullable()();

  @override
  Set<Column> get primaryKey => {ngay};
}

@DriftDatabase(tables: [
  Habits,
  Ticks,
  Profiles,
  WeighIns,
  EoIns,
  MoIns,
  TapIns,
  ChiSoIns,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _moKetNoi());

  static const int maxHabit = 8;
  static const double metVanDong = 5.5;
  static const int phutVanDong = 30;

  @override
  int get schemaVersion => 6;

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
              nhipKg: const Value(0.5),
            ),
          );
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(profiles, profiles.tenGoi);
          }
          if (from < 3) {
            await m.addColumn(profiles, profiles.nhipKg);
            await m.createTable(eoIns);
            await m.createTable(moIns);
          }
          if (from < 4) {
            await m.createTable(tapIns);
          }
          if (from < 5) {
            await customStatement('''
CREATE TABLE IF NOT EXISTS tap_ins_moi (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  ngay TEXT NOT NULL,
  loai TEXT NOT NULL,
  phut INTEGER NOT NULL
)''');
            await customStatement(
              'INSERT INTO tap_ins_moi (ngay, loai, phut) SELECT ngay, loai, phut FROM tap_ins',
            );
            await customStatement('DROP TABLE tap_ins');
            await customStatement(
              'ALTER TABLE tap_ins_moi RENAME TO tap_ins',
            );
            await m.createTable(chiSoIns);
            await customStatement(
              'INSERT INTO chi_so (ngay, eo) SELECT ngay, cm FROM eo_ins',
            );
          }
          if (from < 6) {
            await m.addColumn(habits, habits.thuBit);
            await m.addColumn(habits, habits.gioNhac);
            await m.addColumn(habits, habits.an);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
          await gopTenTrung();
        },
      );

  Future<int> soHabit() async {
    final r = await (select(habits)..where((h) => h.an.equals(false))).get();
    return r.length;
  }

  Future<List<Habit>> dsHabitTatCa() {
    return (select(habits)
          ..orderBy([
            (h) => OrderingTerm.asc(h.thuTu),
            (h) => OrderingTerm.asc(h.id),
          ]))
        .get();
  }

  Future<List<Habit>> dsHabit() {
    return (select(habits)
          ..where((h) => h.an.equals(false))
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
    String thuBit = '1234567',
    int? gioNhac,
  }) async {
    final tenSach = Ten.sach(ten);
    if (tenSach.isEmpty) return null;
    final hien = await dsHabit();
    if (hien.length >= maxHabit) return null;
    final tat = await dsHabitTatCa();
    if (tat.any((h) => Ten.trung(h.ten, tenSach))) return null;
    return into(habits).insert(
      HabitsCompanion.insert(
        ten: tenSach,
        mucTieuThang: Value(mucTieuThang),
        met: Value(met),
        phutMacDinh: Value(phutMacDinh),
        thuTu: Value(hien.length),
        thuBit: Value(thuBit),
        gioNhac: Value(gioNhac),
        taoLuc: DateTime.now(),
      ),
    );
  }

  Future<bool> suaHabit({
    required int id,
    required String ten,
    int? mucTieuThang,
    String? thuBit,
    int? gioNhac,
    bool xoaGioNhac = false,
  }) async {
    final tenSach = Ten.sach(ten);
    if (tenSach.isEmpty) return false;
    final tat = await dsHabitTatCa();
    if (tat.any((h) => h.id != id && Ten.trung(h.ten, tenSach))) return false;
    final n = await (update(habits)..where((h) => h.id.equals(id))).write(
      HabitsCompanion(
        ten: Value(tenSach),
        mucTieuThang: mucTieuThang == null
            ? const Value.absent()
            : Value(mucTieuThang),
        thuBit: thuBit == null ? const Value.absent() : Value(thuBit),
        gioNhac: xoaGioNhac
            ? const Value(null)
            : (gioNhac == null ? const Value.absent() : Value(gioNhac)),
      ),
    );
    return n > 0;
  }

  Future<void> anHabit(int id) async {
    await (update(habits)..where((h) => h.id.equals(id))).write(
      const HabitsCompanion(an: Value(true)),
    );
  }

  Future<void> xoaTick(int habitId, DateTime ngay) async {
    await (delete(ticks)
          ..where((t) => t.habitId.equals(habitId) & t.ngay.equals(Ngay.iso(ngay))))
        .go();
  }

  Future<void> xoaHabit(int id) async {
    await (delete(habits)..where((h) => h.id.equals(id))).go();
  }

  Future<void> gopTenTrung() async {
    final ds = await dsHabitTatCa();
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

  Future<void> ghiEo(DateTime ngay, double cm) async {
    await into(eoIns).insertOnConflictUpdate(
      EoInsCompanion.insert(ngay: Ngay.iso(ngay), cm: cm),
    );
  }

  Future<void> ghiMo(DateTime ngay, double pct) async {
    await into(moIns).insertOnConflictUpdate(
      MoInsCompanion.insert(ngay: Ngay.iso(ngay), pct: pct),
    );
  }

  Future<void> ghiTap(DateTime ngay, String loai, int phut) async {
    await into(tapIns).insert(
      TapInsCompanion.insert(ngay: Ngay.iso(ngay), loai: loai, phut: phut),
    );
  }

  Future<void> ghiChiSo(
    DateTime ngay, {
    double? eo,
    double? hong,
    double? nguc,
    double? bapTay,
  }) async {
    await into(chiSoIns).insertOnConflictUpdate(
      ChiSoInsCompanion.insert(
        ngay: Ngay.iso(ngay),
        eo: Value(eo),
        hong: Value(hong),
        nguc: Value(nguc),
        bapTay: Value(bapTay),
      ),
    );
  }

  Future<List<ChiSoIn>> dsChiSo() {
    return (select(chiSoIns)..orderBy([(c) => OrderingTerm.desc(c.ngay)])).get();
  }

  Future<List<TapIn>> dsTap() {
    return (select(tapIns)..orderBy([(t) => OrderingTerm.desc(t.ngay)])).get();
  }

  Future<List<EoIn>> dsEo() {
    return (select(eoIns)..orderBy([(e) => OrderingTerm.desc(e.ngay)])).get();
  }

  Future<List<MoIn>> dsMo() {
    return (select(moIns)..orderBy([(e) => OrderingTerm.desc(e.ngay)])).get();
  }

  Future<void> suaProfile({
    Value<String?> sex = const Value.absent(),
    Value<double?> heightCm = const Value.absent(),
    Value<String?> dob = const Value.absent(),
    Value<double> activity = const Value.absent(),
    Value<double?> targetKg = const Value.absent(),
    Value<String?> tenGoi = const Value.absent(),
    Value<double> nhipKg = const Value.absent(),
  }) async {
    await (update(profiles)..where((p) => p.id.equals(1))).write(
      ProfilesCompanion(
        sex: sex,
        heightCm: heightCm,
        dob: dob,
        activity: activity,
        targetKg: targetKg,
        tenGoi: tenGoi,
        nhipKg: nhipKg,
      ),
    );
  }

  Future<void> suaPhutMacDinh(int id, int phut) async {
    if (phut < 1 || phut > 300) return;
    await (update(habits)..where((h) => h.id.equals(id))).write(
      HabitsCompanion(phutMacDinh: Value(phut)),
    );
  }

  static const tenBanSao = 'thoi-quen-ban-sao.sqlite';

  Future<String> duongBanSao() async {
    final d = await getApplicationDocumentsDirectory();
    return '${d.path}/$tenBanSao';
  }

  Future<void> xuatVao(String path) async {
    final f = File(path);
    if (await f.exists()) await f.delete();
    final esc = path.replaceAll("'", "''");
    await customStatement("VACUUM INTO '$esc'");
  }

  Future<String> xuatBanSao() async {
    final path = await duongBanSao();
    await xuatVao(path);
    return path;
  }

  Future<bool> coBanSao() async {
    return File(await duongBanSao()).exists();
  }

  Future<void> khoiPhucTu(String path) async {
    final esc = path.replaceAll("'", "''");
    await customStatement("ATTACH DATABASE '$esc' AS src");
    try {
      await customStatement('DELETE FROM ticks');
      await customStatement('DELETE FROM habits');
      await customStatement('DELETE FROM weigh_ins');
      await customStatement('DELETE FROM eo_ins');
      await customStatement('DELETE FROM mo_ins');
      await customStatement('DELETE FROM profile');
      await customStatement('INSERT INTO habits SELECT * FROM src.habits');
      await customStatement('INSERT INTO ticks SELECT * FROM src.ticks');
      await customStatement('INSERT INTO weigh_ins SELECT * FROM src.weigh_ins');
      await customStatement('INSERT INTO profile SELECT * FROM src.profile');
      try {
        await customStatement('INSERT INTO eo_ins SELECT * FROM src.eo_ins');
        await customStatement('INSERT INTO mo_ins SELECT * FROM src.mo_ins');
        await customStatement('INSERT INTO tap_ins SELECT * FROM src.tap_ins');
        await customStatement('INSERT INTO chi_so SELECT * FROM src.chi_so');
      } catch (_) {}
    } finally {
      await customStatement('DETACH DATABASE src');
    }
  }

  Future<void> khoiPhucBanSao() async {
    final path = await duongBanSao();
    if (!await File(path).exists()) {
      throw StateError('missing');
    }
    await khoiPhucTu(path);
  }

  Future<void> xoaHet() async {
    await delete(ticks).go();
    await delete(habits).go();
    await delete(weighIns).go();
    await delete(eoIns).go();
    await delete(moIns).go();
    await delete(tapIns).go();
    await delete(chiSoIns).go();
    await (update(profiles)..where((p) => p.id.equals(1))).write(
      const ProfilesCompanion(
        sex: Value(null),
        heightCm: Value(null),
        dob: Value(null),
        activity: Value(1.2),
        targetKg: Value(null),
        tenGoi: Value(null),
        nhipKg: Value(0.5),
      ),
    );
  }
}
