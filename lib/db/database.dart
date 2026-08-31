import 'dart:async';
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
  TextColumn get anTu => text().nullable()();
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

class LoaiTruIns extends Table {
  @override
  String get tableName => 'loai_tru';

  IntColumn get habitId =>
      integer().references(Habits, #id, onDelete: KeyAction.cascade)();
  TextColumn get ngay => text()();

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
  RealColumn get startKg => real().nullable()();
  RealColumn get startEo => real().nullable()();
  RealColumn get startHong => real().nullable()();
  RealColumn get startNguc => real().nullable()();
  RealColumn get startBapTay => real().nullable()();
  TextColumn get startDoNgay => text().nullable()();

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

class MocCans extends Table {
  @override
  String get tableName => 'moc_can';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get loai => text()();
  TextColumn get ngay => text()();
  RealColumn get kg => real()();
}

class NapIns extends Table {
  @override
  String get tableName => 'nap_ins';

  TextColumn get ngay => text()();
  IntColumn get kcal => integer()();

  @override
  Set<Column> get primaryKey => {ngay};
}

class Foods extends Table {
  @override
  String get tableName => 'foods';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get ten => text()();
  IntColumn get kcal => integer()();
  RealColumn get gram => real().nullable()();
  TextColumn get vanBan => text().nullable()();
  RealColumn get dam => real().nullable()();
  RealColumn get bot => real().nullable()();
  RealColumn get beo => real().nullable()();
}

class FoodLogs extends Table {
  @override
  String get tableName => 'food_log';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get ngay => text()();
  IntColumn get foodId =>
      integer().nullable().references(Foods, #id, onDelete: KeyAction.setNull)();
  TextColumn get ten => text()();
  IntColumn get kcal => integer()();
  RealColumn get gram => real().nullable()();
  RealColumn get dam => real().nullable()();
  RealColumn get bot => real().nullable()();
  RealColumn get beo => real().nullable()();
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
  LoaiTruIns,
  MocCans,
  NapIns,
  Foods,
  FoodLogs,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _moKetNoi());

  static const int maxHabit = 8;
  static const double metVanDong = 5.5;
  static const int phutVanDong = 30;

  @override
  int get schemaVersion => 12;

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
          if (from < 7) {
            await m.addColumn(habits, habits.anTu);
            await m.createTable(loaiTruIns);
          }
          if (from < 8) {
            await m.addColumn(profiles, profiles.startKg);
            await m.createTable(mocCans);
          }
          if (from < 9) {
            await m.createTable(napIns);
          }
          if (from < 10) {
            await m.addColumn(profiles, profiles.startEo);
            await m.addColumn(profiles, profiles.startHong);
            await m.addColumn(profiles, profiles.startNguc);
            await m.addColumn(profiles, profiles.startBapTay);
            await m.addColumn(profiles, profiles.startDoNgay);
          }
          if (from < 11) {
            await m.createTable(foods);
            await m.createTable(foodLogs);
          } else if (from < 12) {
            await m.addColumn(foods, foods.dam);
            await m.addColumn(foods, foods.bot);
            await m.addColumn(foods, foods.beo);
            await m.addColumn(foodLogs, foodLogs.dam);
            await m.addColumn(foodLogs, foodLogs.bot);
            await m.addColumn(foodLogs, foodLogs.beo);
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
    required DateTime createdOn,
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
        taoLuc: Ngay.cat(createdOn),
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

  Future<void> anTuNgay(int id, DateTime tu) async {
    await (update(habits)..where((h) => h.id.equals(id))).write(
      HabitsCompanion(anTu: Value(Ngay.iso(tu))),
    );
  }

  Future<void> ghiLoaiTru(int habitId, DateTime ngay) async {
    await into(loaiTruIns).insert(
      LoaiTruInsCompanion.insert(
        habitId: habitId,
        ngay: Ngay.iso(ngay),
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<List<LoaiTruIn>> dsLoaiTru() => select(loaiTruIns).get();

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

  /// Home: chỉ habits còn hiện + ticks đúng ngày. Không watch cả DB.
  Stream<List<Habit>> watchHabit() {
    return (select(habits)
          ..where((h) => h.an.equals(false))
          ..orderBy([
            (h) => OrderingTerm.asc(h.thuTu),
            (h) => OrderingTerm.asc(h.id),
          ]))
        .watch();
  }

  Stream<List<Tick>> watchTickNgay(String iso) {
    return (select(ticks)..where((t) => t.ngay.equals(iso))).watch();
  }

  Stream<(List<Habit>, List<Tick>)> watchHomeNgay(String iso) {
    final hq = (select(habits)
          ..where((h) => h.an.equals(false))
          ..orderBy([
            (h) => OrderingTerm.asc(h.thuTu),
            (h) => OrderingTerm.asc(h.id),
          ]));
    final tq = select(ticks)..where((t) => t.ngay.equals(iso));
    late StreamController<(List<Habit>, List<Tick>)> c;
    List<Habit> hs = const [];
    List<Tick> ts = const [];
    var hOk = false;
    var tOk = false;
    StreamSubscription<List<Habit>>? subH;
    StreamSubscription<List<Tick>>? subT;
    void emit() {
      if (hOk && tOk && !c.isClosed) c.add((hs, ts));
    }

    c = StreamController<(List<Habit>, List<Tick>)>(
      onListen: () {
        subH = hq.watch().listen((v) {
          hs = v;
          hOk = true;
          emit();
        });
        subT = tq.watch().listen((v) {
          ts = v;
          tOk = true;
          emit();
        });
      },
      onCancel: () async {
        await subH?.cancel();
        await subT?.cancel();
      },
    );
    return c.stream;
  }

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

  Future<void> xoaTap(int id) async {
    await (delete(tapIns)..where((t) => t.id.equals(id))).go();
  }

  Future<void> suaTap(int id, String loai, int phut) async {
    await (update(tapIns)..where((t) => t.id.equals(id))).write(
      TapInsCompanion(loai: Value(loai), phut: Value(phut)),
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

  Future<void> ghiNap(DateTime ngay, int kcal) async {
    await into(napIns).insertOnConflictUpdate(
      NapInsCompanion.insert(ngay: Ngay.iso(ngay), kcal: kcal),
    );
  }

  Future<List<NapIn>> dsNap() {
    return (select(napIns)..orderBy([(n) => OrderingTerm.desc(n.ngay)])).get();
  }

  Future<int> themMon({
    required String ten,
    required int kcal,
    double? gram,
    String? vanBan,
    double? dam,
    double? bot,
    double? beo,
  }) async {
    final cu = await (select(foods)..where((f) => f.ten.equals(ten))).get();
    if (cu.isNotEmpty) {
      final id = cu.first.id;
      await (update(foods)..where((f) => f.id.equals(id))).write(
        FoodsCompanion(
          kcal: Value(kcal),
          gram: Value(gram),
          vanBan: Value(vanBan),
          dam: Value(dam),
          bot: Value(bot),
          beo: Value(beo),
        ),
      );
      return id;
    }
    return into(foods).insert(
      FoodsCompanion.insert(
        ten: ten,
        kcal: kcal,
        gram: Value(gram),
        vanBan: Value(vanBan),
        dam: Value(dam),
        bot: Value(bot),
        beo: Value(beo),
      ),
    );
  }

  Future<List<Food>> dsMon() {
    return (select(foods)..orderBy([(f) => OrderingTerm.asc(f.ten)])).get();
  }

  Future<int> ghiLog(
    DateTime ngay, {
    int? foodId,
    required String ten,
    required int kcal,
    double? gram,
    double? dam,
    double? bot,
    double? beo,
  }) {
    return into(foodLogs).insert(
      FoodLogsCompanion.insert(
        ngay: Ngay.iso(ngay),
        foodId: Value(foodId),
        ten: ten,
        kcal: kcal,
        gram: Value(gram),
        dam: Value(dam),
        bot: Value(bot),
        beo: Value(beo),
      ),
    );
  }

  Future<List<FoodLog>> dsLog() {
    return (select(foodLogs)..orderBy([(l) => OrderingTerm.desc(l.id)])).get();
  }

  Future<void> xoaLog(int id) async {
    await (delete(foodLogs)..where((l) => l.id.equals(id))).go();
  }

  Future<void> xoaMon(int id) async {
    await (delete(foods)..where((f) => f.id.equals(id))).go();
  }

  Future<void> suaLog(
    int id, {
    int? kcal,
    String? ten,
    Value<double?> gram = const Value.absent(),
    Value<double?> dam = const Value.absent(),
    Value<double?> bot = const Value.absent(),
    Value<double?> beo = const Value.absent(),
  }) async {
    await (update(foodLogs)..where((l) => l.id.equals(id))).write(
      FoodLogsCompanion(
        kcal: kcal == null ? const Value.absent() : Value(kcal),
        ten: ten == null ? const Value.absent() : Value(ten),
        gram: gram,
        dam: dam,
        bot: bot,
        beo: beo,
      ),
    );
  }

  Future<bool> suaMon({
    required int id,
    required String ten,
    required int kcal,
    double? gram,
    double? dam,
    double? bot,
    double? beo,
  }) async {
    final t = ten.trim();
    if (t.isEmpty) return false;
    if (kcal < 1 || kcal > 20000) return false;
    final trung = await (select(foods)..where((f) => f.ten.equals(t))).get();
    if (trung.any((f) => f.id != id)) return false;
    final n = await (update(foods)..where((f) => f.id.equals(id))).write(
      FoodsCompanion(
        ten: Value(t),
        kcal: Value(kcal),
        gram: Value(gram),
        dam: Value(dam),
        bot: Value(bot),
        beo: Value(beo),
      ),
    );
    return n > 0;
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
    Value<double?> startKg = const Value.absent(),
    Value<double?> startEo = const Value.absent(),
    Value<double?> startHong = const Value.absent(),
    Value<double?> startNguc = const Value.absent(),
    Value<double?> startBapTay = const Value.absent(),
    Value<String?> startDoNgay = const Value.absent(),
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
        startKg: startKg,
        startEo: startEo,
        startHong: startHong,
        startNguc: startNguc,
        startBapTay: startBapTay,
        startDoNgay: startDoNgay,
      ),
    );
  }

  static const loaiBanDau = 'ban_dau';
  static const loaiDich = 'dich';

  Future<void> ghiMoc({required String loai, required DateTime ngay, required double kg}) async {
    await into(mocCans).insert(
      MocCansCompanion.insert(loai: loai, ngay: Ngay.iso(ngay), kg: kg),
    );
  }

  Future<List<MocCan>> dsMoc(String loai) {
    return (select(mocCans)
          ..where((m) => m.loai.equals(loai))
          ..orderBy([(m) => OrderingTerm.desc(m.id)]))
        .get();
  }

  Future<void> suaPhutMacDinh(int id, int phut) async {
    if (phut < 1 || phut > 300) return;
    await (update(habits)..where((h) => h.id.equals(id))).write(
      HabitsCompanion(phutMacDinh: Value(phut)),
    );
  }

  static const tenBanSao = 'thoi-quen-ban-sao.sqlite';

  static const _bangBanSao = <String>[
    'habits',
    'ticks',
    'loai_tru',
    'profile',
    'weigh_ins',
    'eo_ins',
    'mo_ins',
    'tap_ins',
    'chi_so',
    'moc_can',
    'nap_ins',
    'foods',
    'food_log',
  ];

  static const _bangXoa = <String>[
    'food_log',
    'foods',
    'ticks',
    'loai_tru',
    'habits',
    'weigh_ins',
    'moc_can',
    'nap_ins',
    'eo_ins',
    'mo_ins',
    'tap_ins',
    'chi_so',
    'profile',
  ];

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

  Future<bool> laSqlite(String path) async {
    final f = File(path);
    if (!await f.exists()) return false;
    if (await f.length() < 16) return false;
    final raf = await f.open();
    final head = await raf.read(16);
    await raf.close();
    return String.fromCharCodes(head).startsWith('SQLite format 3');
  }

  Future<List<String>> _cot(String schema, String bang) async {
    final rows = await customSelect("PRAGMA $schema.table_info('$bang')").get();
    return [for (final r in rows) r.read<String>('name')];
  }

  Future<void> khoiPhucTu(String path) async {
    if (!await laSqlite(path)) {
      throw StateError('not-sqlite');
    }
    final esc = path.replaceAll("'", "''");
    await customStatement('PRAGMA foreign_keys = OFF');
    await customStatement("ATTACH DATABASE '$esc' AS src");
    try {
      for (final t in _bangXoa) {
        await customStatement('DELETE FROM $t');
      }
      for (final t in _bangBanSao) {
        final dest = await _cot('main', t);
        final src = await _cot('src', t);
        if (src.isEmpty || dest.isEmpty) continue;
        final destSet = dest.toSet();
        final cols = [for (final c in src) if (destSet.contains(c)) c];
        if (cols.isEmpty) continue;
        final list = cols.join(', ');
        await customStatement(
          'INSERT INTO $t ($list) SELECT $list FROM src.$t',
        );
      }
      for (final t in const [
        'habits',
        'tap_ins',
        'moc_can',
        'foods',
        'food_log',
      ]) {
        try {
          await customStatement(
            "INSERT OR REPLACE INTO sqlite_sequence(name, seq) "
            "SELECT '$t', IFNULL(MAX(id), 0) FROM $t",
          );
        } catch (_) {}
      }
      final p = await customSelect('SELECT id FROM profile WHERE id = 1').get();
      if (p.isEmpty) {
        await into(profiles).insert(
          ProfilesCompanion.insert(
            id: const Value(1),
            activity: const Value(1.2),
            nhipKg: const Value(0.5),
          ),
        );
      }
      await gopTenTrung();
    } finally {
      await customStatement('DETACH DATABASE src');
      await customStatement('PRAGMA foreign_keys = ON');
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
    await delete(loaiTruIns).go();
    await delete(habits).go();
    await delete(weighIns).go();
    await delete(eoIns).go();
    await delete(moIns).go();
    await delete(tapIns).go();
    await delete(chiSoIns).go();
    await delete(mocCans).go();
    await delete(napIns).go();
    await delete(foodLogs).go();
    await delete(foods).go();
    await (update(profiles)..where((p) => p.id.equals(1))).write(
      const ProfilesCompanion(
        sex: Value(null),
        heightCm: Value(null),
        dob: Value(null),
        activity: Value(1.2),
        targetKg: Value(null),
        tenGoi: Value(null),
        nhipKg: Value(0.5),
        startKg: Value(null),
        startEo: Value(null),
        startHong: Value(null),
        startNguc: Value(null),
        startBapTay: Value(null),
        startDoNgay: Value(null),
      ),
    );
  }
}
