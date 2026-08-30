import 'package:flutter/foundation.dart';

import 'chuoi.dart';
import 'db/database.dart';
import 'ngay.dart';
import 'so.dart';

class HangHabitView {
  const HangHabitView({
    required this.habit,
    required this.ticked,
    required this.xThang,
  });

  final Habit habit;
  final bool ticked;
  final int xThang;
}

class ChamTuan {
  const ChamTuan({
    required this.ngay,
    required this.tick,
    required this.tong,
    required this.laHomNay,
    required this.tuongLai,
    required this.dangXem,
  });

  final DateTime ngay;
  final int tick;
  final int tong;
  final bool laHomNay;
  final bool tuongLai;
  final bool dangXem;
}

class Kho extends ChangeNotifier {
  Kho(this.db, {DateTime? bayGio}) : homNay = Ngay.cat(bayGio ?? DateTime.now()) {
    selected = homNay;
  }

  final AppDatabase db;
  final DateTime homNay;
  late DateTime selected;
  int tab = 0;

  List<HangHabitView> hang = const [];
  List<ChamTuan> tuan = const [];
  List<WeighIn> dsCan = const [];
  WeighIn? canMoi;
  double? targetKg;
  bool dangTai = true;

  int get nTick => hang.where((h) => h.ticked).length;
  int get mHabit => hang.length;
  bool get rong => hang.isEmpty;
  bool get xemHomNay => Ngay.cungNgay(selected, homNay);

  String get dongNgay => Chuoi.dongNgay(selected);

  String get nTrenM {
    if (xemHomNay) return Chuoi.nTrenMHomNay(nTick, mHabit);
    return Chuoi.nTrenMNgay(nTick, mHabit, selected);
  }

  String get chuChipCan {
    final c = canMoi;
    if (c == null) return Chuoi.themCan;
    final kg = So.kg(c.kg);
    final t = targetKg;
    if (t == null) return Chuoi.chipCan(kg);
    final con = c.kg - t;
    if (con <= 0.05) return Chuoi.chipCanDat(kg);
    return Chuoi.chipCanCon(kg, So.kg(con));
  }

  Future<void> tai() async {
    final habits = await db.dsHabit();
    final ticksNgay = await db.ticksNgay(selected);
    final ticked = {for (final t in ticksNgay) t.habitId};
    final thang = await db.ticksThang(selected);
    final theoHabit = <int, int>{};
    for (final t in thang) {
      theoHabit[t.habitId] = (theoHabit[t.habitId] ?? 0) + 1;
    }
    hang = [
      for (final h in habits)
        HangHabitView(
          habit: h,
          ticked: ticked.contains(h.id),
          xThang: theoHabit[h.id] ?? 0,
        ),
    ];

    final cacNgay = Ngay.tuan(homNay);
    final ticksTuan = await db.ticksKhoang(cacNgay.first, cacNgay.last);
    final demNgay = <String, int>{};
    for (final t in ticksTuan) {
      demNgay[t.ngay] = (demNgay[t.ngay] ?? 0) + 1;
    }
    tuan = [
      for (final d in cacNgay)
        ChamTuan(
          ngay: d,
          tick: demNgay[Ngay.iso(d)] ?? 0,
          tong: habits.length,
          laHomNay: Ngay.cungNgay(d, homNay),
          tuongLai: Ngay.sau(d, homNay),
          dangXem: Ngay.cungNgay(d, selected),
        ),
    ];

    final p = await db.docProfile();
    targetKg = p.targetKg;
    dsCan = await db.dsCan();
    canMoi = dsCan.isEmpty ? null : dsCan.first;
    dangTai = false;
    notifyListeners();
  }

  Future<void> chonNgay(DateTime d) async {
    if (Ngay.sau(d, homNay)) return;
    selected = Ngay.cat(d);
    await tai();
  }

  Future<void> toggle(HangHabitView h) async {
    await db.toggleTick(h.habit, selected);
    await tai();
  }

  Future<bool> themPreset({
    required String ten,
    double? met,
    int? phutMacDinh,
  }) async {
    final id = await db.themHabit(ten: ten, met: met, phutMacDinh: phutMacDinh);
    await tai();
    return id != null;
  }

  Future<bool> themVanDong() {
    return themPreset(
      ten: Chuoi.vanDong,
      met: AppDatabase.metVanDong,
      phutMacDinh: AppDatabase.phutVanDong,
    );
  }

  void moCoThe() {
    tab = 1;
    notifyListeners();
  }

  void chonTab(int i) {
    tab = i;
    notifyListeners();
  }

  Future<bool> ghiCan(String raw) async {
    final kg = So.parseKg(raw);
    if (kg == null) return false;
    await db.ghiCan(homNay, kg);
    await tai();
    return true;
  }
}
