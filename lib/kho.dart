import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';

import 'chuoi.dart';
import 'cong_thuc.dart';
import 'db/database.dart';
import 'ngay.dart';
import 'so.dart';
import 'ten.dart';

class HangHabitView {
  const HangHabitView({
    required this.habit,
    required this.ticked,
    required this.xThang,
  });

  final Habit habit;
  final bool ticked;
  final int xThang;

  HangHabitView copyWith({bool? ticked, int? xThang, Habit? habit}) {
    return HangHabitView(
      habit: habit ?? this.habit,
      ticked: ticked ?? this.ticked,
      xThang: xThang ?? this.xThang,
    );
  }
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

  double get phan => tong == 0 ? 0 : tick / tong;

  ChamTuan copyWith({int? tick, int? tong, bool? dangXem}) {
    return ChamTuan(
      ngay: ngay,
      tick: tick ?? this.tick,
      tong: tong ?? this.tong,
      laHomNay: laHomNay,
      tuongLai: tuongLai,
      dangXem: dangXem ?? this.dangXem,
    );
  }
}

class CotThang {
  const CotThang({
    required this.ngay,
    required this.tick,
    required this.tong,
    required this.dangXem,
    required this.tuongLai,
  });

  final DateTime ngay;
  final int tick;
  final int tong;
  final bool dangXem;
  final bool tuongLai;

  double get phan => tong == 0 ? 0 : tick / tong;
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
  String? sex;
  double? heightCm;
  String? dob;
  double activity = 1.2;
  String? tenGoi;
  double nhipKg = 0.5;
  EoIn? eoMoi;
  MoIn? moMoi;
  List<EoIn> dsEo = const [];
  List<MoIn> dsMo = const [];
  bool dangTai = true;

  /// iso yyyy-MM-dd đã tick, theo habitId.
  Map<int, Set<String>> ticksIso = {};

  final Set<String> _dangThem = {};
  final Map<String, Future<void>> _ghiTick = {};

  int get nTick => hang.where((h) => h.ticked).length;
  int get mHabit => hang.length;
  bool get rong => hang.isEmpty;
  bool get xemHomNay => Ngay.cungNgay(selected, homNay);
  bool get khoaGhi => !Ngay.ghiDuoc(selected, homNay);
  bool get themDuoc => hang.length < AppDatabase.maxHabit && !khoaGhi;

  String get dongNgay => Chuoi.dongNgay(selected);

  String get nTrenM {
    if (xemHomNay) return Chuoi.nTrenMHomNay(nTick, mHabit);
    return Chuoi.nTrenMNgay(nTick, mHabit, selected);
  }

  int get phanTramNgay {
    if (mHabit == 0) return 0;
    return ((nTick / mHabit) * 100).round();
  }

  List<CotThang> get cotThang {
    final tong = mHabit;
    return [
      for (final d in Ngay.cacNgayThang(selected))
        CotThang(
          ngay: d,
          tick: _tickCuaNgay(d),
          tong: tong,
          dangXem: Ngay.cungNgay(d, selected),
          tuongLai: Ngay.sau(d, homNay),
        ),
    ];
  }

  int _tickCuaNgay(DateTime d) {
    final iso = Ngay.iso(d);
    var n = 0;
    for (final h in hang) {
      if (ticksCua(h.habit.id).contains(iso)) n++;
    }
    return n;
  }

  WeighIn? canCua(DateTime d) {
    final iso = Ngay.iso(d);
    for (final c in dsCan) {
      if (c.ngay == iso) return c;
    }
    return null;
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

  bool get thieuCan => canMoi == null;

  double? get bmiDoc => CongThuc.bmi(canMoi?.kg, heightCm);

  double? get bmrDoc => CongThuc.bmr(
        sex: sex,
        kg: canMoi?.kg,
        cm: heightCm,
        tuoi: CongThuc.tuoi(dob, homNay),
      );

  double? get tdeeDoc => CongThuc.tdee(bmrDoc, activity);

  String? get bmiNhan => CongThuc.bmiNhan(bmiDoc);

  String? get nhipDoc => CongThuc.nhipDong(canMoi?.kg, targetKg, nhipKg);

  int? get kcalGoiYDoc => CongThuc.kcalGoiY(
        tdee: tdeeDoc,
        nhip: nhipKg,
        kg: canMoi?.kg,
        target: targetKg,
      );

  String? get dongCanHienTai {
    final c = canMoi;
    if (c == null) return null;
    final t = targetKg;
    if (t == null) return Chuoi.canHienTaiKhongDich(So.kg(c.kg));
    final z = (c.kg - t).abs();
    if (z <= 0.05) return Chuoi.chipCanDat(So.kg(c.kg));
    return Chuoi.canHienTai(So.kg(c.kg), So.kg(t), So.kg(z));
  }

  String? get conToiDich {
    final c = canMoi;
    final t = targetKg;
    if (c == null || t == null) return null;
    final d = c.kg - t;
    if (d.abs() <= 0.05) return Chuoi.chipCanDat(So.kg(c.kg));
    return Chuoi.conToiDich(So.kg(d.abs()));
  }

  double? kcalTapCua(Habit h, {int? phut}) {
    return CongThuc.kcalTap(
      met: h.met,
      kg: canMoi?.kg,
      phut: phut ?? h.phutMacDinh,
    );
  }

  bool daCoTen(String ten) {
    final k = Ten.khoa(ten);
    if (k.isEmpty) return false;
    if (_dangThem.contains(k)) return true;
    return hang.any((h) => Ten.trung(h.habit.ten, ten));
  }

  Set<String> ticksCua(int habitId) => ticksIso[habitId] ?? {};

  int chuoiCua(int habitId) =>
      Ngay.chuoiLienTiep(ticksCua(habitId), homNay);

  int xThangCua(int habitId, DateTime thang) {
    final prefix = Ngay.prefixThang(thang);
    return ticksCua(habitId).where((s) => s.startsWith(prefix)).length;
  }

  Future<void> tai() async {
    final habits = await db.dsHabit();
    final allTicks = await db.dsTick();
    ticksIso = {};
    for (final t in allTicks) {
      ticksIso.putIfAbsent(t.habitId, () => <String>{}).add(t.ngay);
    }
    final isoSel = Ngay.iso(selected);
    final prefix = Ngay.prefixThang(selected);
    hang = [
      for (final h in habits)
        HangHabitView(
          habit: h,
          ticked: ticksIso[h.id]?.contains(isoSel) ?? false,
          xThang: ticksIso[h.id]
                  ?.where((s) => s.startsWith(prefix))
                  .length ??
              0,
        ),
    ];
    _veTuan();

    final p = await db.docProfile();
    targetKg = p.targetKg;
    sex = p.sex;
    heightCm = p.heightCm;
    dob = p.dob;
    activity = p.activity;
    tenGoi = p.tenGoi;
    nhipKg = p.nhipKg;
    dsCan = await db.dsCan();
    canMoi = dsCan.isEmpty ? null : dsCan.first;
    dsEo = await db.dsEo();
    eoMoi = dsEo.isEmpty ? null : dsEo.first;
    dsMo = await db.dsMo();
    moMoi = dsMo.isEmpty ? null : dsMo.first;
    dangTai = false;
    notifyListeners();
  }

  void chonNgay(DateTime d) {
    if (Ngay.sau(d, homNay)) return;
    selected = Ngay.cat(d);
    _dongBoHangVaTuan();
    notifyListeners();
  }

  /// UI đổi ngay, ghi Drift sau. Ghi tuần tự theo (habit, ngày).
  Future<void> toggle(HangHabitView h) => toggleNgay(h.habit, selected);

  /// Ô tháng: đổi selectedDate; tick chỉ khi ngày còn ghi được.
  Future<void> chonVaTick(Habit habit, DateTime ngay) {
    if (Ngay.sau(ngay, homNay)) return Future.value();
    selected = Ngay.cat(ngay);
    if (!Ngay.ghiDuoc(ngay, homNay)) {
      _dongBoHangVaTuan();
      notifyListeners();
      return Future.value();
    }
    return toggleNgay(habit, ngay);
  }

  Future<void> toggleNgay(Habit habit, DateTime ngay) {
    if (!Ngay.ghiDuoc(ngay, homNay)) return Future.value();
    final iso = Ngay.iso(ngay);
    final set = ticksIso.putIfAbsent(habit.id, () => <String>{});
    final bat = !set.contains(iso);
    if (bat) {
      set.add(iso);
    } else {
      set.remove(iso);
    }
    _dongBoHangVaTuan();
    notifyListeners();

    final khoa = '${habit.id}-$iso';
    final viec = (_ghiTick[khoa] ?? Future.value()).then((_) {
      return db.toggleTick(habit, ngay);
    });
    _ghiTick[khoa] = viec;
    return viec;
  }

  void _dongBoHangVaTuan() {
    final isoSel = Ngay.iso(selected);
    final prefix = Ngay.prefixThang(selected);
    hang = [
      for (final h in hang)
        h.copyWith(
          ticked: ticksCua(h.habit.id).contains(isoSel),
          xThang: ticksCua(h.habit.id).where((s) => s.startsWith(prefix)).length,
        ),
    ];
    _veTuan();
  }

  void _veTuan() {
    tuan = [
      for (final d in Ngay.tuan(selected))
        ChamTuan(
          ngay: d,
          tick: hang.where((h) => ticksCua(h.habit.id).contains(Ngay.iso(d))).length,
          tong: hang.length,
          laHomNay: Ngay.cungNgay(d, homNay),
          tuongLai: Ngay.sau(d, homNay),
          dangXem: Ngay.cungNgay(d, selected),
        ),
    ];
  }

  Future<bool> themPreset({
    required String ten,
    int mucTieuThang = 25,
    double? met,
    int? phutMacDinh,
  }) async {
    final khoa = Ten.khoa(ten);
    if (khoa.isEmpty) return false;
    if (_dangThem.contains(khoa) || daCoTen(ten) || !themDuoc) return false;
    _dangThem.add(khoa);
    notifyListeners();
    try {
      final id = await db.themHabit(
        ten: ten,
        mucTieuThang: mucTieuThang,
        met: met,
        phutMacDinh: phutMacDinh,
      );
      if (id != null && Ngay.ghiDuoc(selected, homNay)) {
        final ds = await db.dsHabit();
        final h = ds.firstWhere((x) => x.id == id);
        await db.ghiTick(h, selected);
      }
      await tai();
      return id != null;
    } finally {
      _dangThem.remove(khoa);
      notifyListeners();
    }
  }

  Future<bool> themVanDong() {
    return themPreset(
      ten: Chuoi.vanDong,
      met: AppDatabase.metVanDong,
      phutMacDinh: AppDatabase.phutVanDong,
    );
  }

  Future<bool> suaHabit({
    required int id,
    required String ten,
    required int mucTieuThang,
  }) async {
    final ok = await db.suaHabit(id: id, ten: ten, mucTieuThang: mucTieuThang);
    if (ok) await tai();
    return ok;
  }

  Future<void> xoaHabit(int id) async {
    await db.xoaHabit(id);
    ticksIso.remove(id);
    await tai();
  }

  void moTienDo() {
    tab = 1;
    notifyListeners();
  }

  void moCaiDat() {
    tab = 2;
    notifyListeners();
  }

  void chonTab(int i) {
    tab = i;
    notifyListeners();
  }

  Future<bool> ghiCan(String raw, {DateTime? ngay}) async {
    final d = Ngay.cat(ngay ?? selected);
    if (!Ngay.ghiDuoc(d, homNay)) return false;
    final kg = So.parseKg(raw);
    if (kg == null) return false;
    await db.ghiCan(d, kg);
    await tai();
    return true;
  }

  Future<bool> ghiEo(String raw, {DateTime? ngay}) async {
    final d = Ngay.cat(ngay ?? homNay);
    if (!Ngay.ghiDuoc(d, homNay)) return false;
    final cm = So.parseEo(raw);
    if (cm == null) return false;
    await db.ghiEo(d, cm);
    await tai();
    return true;
  }

  Future<bool> ghiMo(String raw, {DateTime? ngay}) async {
    final d = Ngay.cat(ngay ?? homNay);
    if (!Ngay.ghiDuoc(d, homNay)) return false;
    final pct = So.parseMo(raw);
    if (pct == null) return false;
    await db.ghiMo(d, pct);
    await tai();
    return true;
  }

  Future<void> suaNhip(double v) async {
    if (!CongThuc.nhipKg.contains(v)) return;
    await db.suaProfile(nhipKg: Value(v));
    await tai();
  }

  Future<void> suaGioi(String v) async {
    await db.suaProfile(sex: Value(v));
    await tai();
  }

  Future<bool> suaChieuCao(String raw) async {
    final cm = So.parseCm(raw);
    if (cm == null) return false;
    await db.suaProfile(heightCm: Value(cm));
    await tai();
    return true;
  }

  Future<void> suaNgaySinh(DateTime d) async {
    if (Ngay.sau(d, homNay)) return;
    await db.suaProfile(dob: Value(Ngay.iso(d)));
    await tai();
  }

  Future<void> suaHoatDong(double v) async {
    if (!CongThuc.heSo.contains(v)) return;
    await db.suaProfile(activity: Value(v));
    await tai();
  }

  Future<bool> suaCanDich(String raw) async {
    final kg = So.parseKg(raw);
    if (kg == null) return false;
    await db.suaProfile(targetKg: Value(kg));
    await tai();
    return true;
  }

  Future<bool> suaTenGoi(String raw) async {
    final t = raw.trim();
    await db.suaProfile(tenGoi: Value(t.isEmpty ? null : t));
    await tai();
    return true;
  }

  Future<void> suaPhutMacDinh(int id, int phut) async {
    await db.suaPhutMacDinh(id, phut);
    await tai();
  }

  Future<bool> xuatBanSao() async {
    await db.xuatBanSao();
    return true;
  }

  Future<bool> khoiPhucBanSao() async {
    if (!await db.coBanSao()) return false;
    await db.khoiPhucBanSao();
    await tai();
    return true;
  }

  Future<void> xoaDuLieu() async {
    await db.xoaHet();
    selected = homNay;
    await tai();
  }
}
