import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';

import 'chuoi.dart';
import 'cong_thuc.dart';
import 'db/database.dart';
import 'ngay.dart';
import 'nhac.dart';
import 'so.dart';
import 'ten.dart';
import 'thu.dart';

class HangHabitView {
  const HangHabitView({
    required this.habit,
    required this.ticked,
  });

  final Habit habit;
  final bool ticked;

  HangHabitView copyWith({bool? ticked, Habit? habit}) {
    return HangHabitView(
      habit: habit ?? this.habit,
      ticked: ticked ?? this.ticked,
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
  int phin = 0;

  List<HangHabitView> hang = const [];
  List<Habit> dsHien = const [];
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
  List<TapIn> dsTap = const [];
  List<ChiSoIn> dsChiSo = const [];
  bool dangTai = true;

  /// iso yyyy-MM-dd đã tick, theo habitId.
  Map<int, Set<String>> ticksIso = {};

  final Set<String> _dangThem = {};
  final Map<String, Future<void>> _ghiTick = {};

  int get nTick => hang.where((h) => h.ticked).length;
  int get mHabit => hang.length;
  bool get rong => dsHien.isEmpty;
  bool get xemHomNay => Ngay.cungNgay(selected, homNay);
  bool get khoaGhi => !Ngay.ghiDuoc(selected, homNay);
  bool get themDuoc => dsHien.length < AppDatabase.maxHabit && !khoaGhi;

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
    return [
      for (final d in Ngay.cacNgayThang(selected))
        CotThang(
          ngay: d,
          tick: _tickCuaNgay(d),
          tong: _tongCuaNgay(d),
          dangXem: Ngay.cungNgay(d, selected),
          tuongLai: Ngay.sau(d, homNay),
        ),
    ];
  }

  int _tickCuaNgay(DateTime d) {
    final iso = Ngay.iso(d);
    var n = 0;
    for (final h in dsHien) {
      if (!Thu.hop(h.thuBit, d)) continue;
      if (ticksCua(h.id).contains(iso)) n++;
    }
    return n;
  }

  int _tongCuaNgay(DateTime d) {
    var n = 0;
    for (final h in dsHien) {
      if (Thu.hop(h.thuBit, d)) n++;
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

  String? get daDoiDoc {
    if (dsCan.length < 2) return null;
    return Chuoi.daDoi(So.kg(dsCan.first.kg - dsCan.last.kg));
  }

  double? get moDoc => CongThuc.moDeurenberg(
        bmi: bmiDoc,
        tuoi: CongThuc.tuoi(dob, homNay),
        sex: sex,
      );

  String get chuKcalTap {
    final ds = tapNgay(selected);
    if (ds.isEmpty) return Chuoi.kcalTapSo(0);
    if (canMoi == null) return Chuoi.thieuDuLieu;
    return Chuoi.kcalTapSo(kcalTapCuaNgay(selected));
  }

  List<TapIn> tapNgay(DateTime d) {
    final iso = Ngay.iso(d);
    return [for (final t in dsTap) if (t.ngay == iso) t];
  }

  int kcalTapCuaNgay(DateTime d) {
    final kg = canMoi?.kg;
    var s = 0.0;
    for (final t in tapNgay(d)) {
      final k = CongThuc.kcalTap(
        met: CongThuc.metCua(t.loai),
        kg: kg,
        phut: t.phut,
      );
      if (k != null) s += k;
    }
    return s.round();
  }

  ChiSoIn? chiSoCua(DateTime d) {
    final iso = Ngay.iso(d);
    for (final c in dsChiSo) {
      if (c.ngay == iso) return c;
    }
    return null;
  }

  String? get dongTaiKhoan {
    final t = CongThuc.tuoi(dob, homNay);
    final kg = canMoi?.kg;
    if (t == null || kg == null || heightCm == null) return null;
    return Chuoi.tuoiCanCao('$t', So.kg(kg), So.kg(heightCm!));
  }

  DateTime? get duKienDoc => CongThuc.duKien(
        homNay: homNay,
        nhip: nhipKg,
        kg: canMoi?.kg,
        target: targetKg,
      );

  String? get banDauKg => dsCan.isEmpty ? null : So.kg(dsCan.last.kg);

  String? get hienTaiKg => dsCan.isEmpty ? null : So.kg(dsCan.first.kg);

  int get phanTramKy {
    final r = _ky;
    if (r.$2 == 0) return 0;
    return ((r.$1 / r.$2) * 100).round();
  }

  (int, int) get nTrenMKy => _ky;

  (int, int) get _ky {
    switch (phin) {
      case 1:
        return _tickKhoang(
          Ngay.thuHai(selected),
          Ngay.thuHai(selected).add(const Duration(days: 6)),
        );
      case 2:
        final a = Ngay.dauThang(selected);
        final b = DateTime(
          selected.year,
          selected.month,
          Ngay.soNgayThang(selected.year, selected.month),
        );
        return _tickKhoang(a, b);
      case 3:
        return _tickKhoang(
          DateTime(selected.year, 1, 1),
          DateTime(selected.year, 12, 31),
        );
      default:
        return (nTick, mHabit);
    }
  }

  (int, int) _tickKhoang(DateTime a, DateTime b) {
    var tick = 0;
    var tong = 0;
    var d = Ngay.cat(a);
    final end = Ngay.cat(b);
    while (!d.isAfter(end)) {
      if (!Ngay.sau(d, homNay)) {
        tick += _tickCuaNgay(d);
        tong += _tongCuaNgay(d);
      }
      d = d.add(const Duration(days: 1));
    }
    return (tick, tong);
  }

  List<CotThang> get cotNam {
    return [
      for (var m = 1; m <= 12; m++)
        CotThang(
          ngay: DateTime(selected.year, m, 1),
          tick: _tickKhoang(
            DateTime(selected.year, m, 1),
            DateTime(selected.year, m, Ngay.soNgayThang(selected.year, m)),
          ).$1,
          tong: _tickKhoang(
            DateTime(selected.year, m, 1),
            DateTime(selected.year, m, Ngay.soNgayThang(selected.year, m)),
          ).$2,
          dangXem: selected.month == m,
          tuongLai: DateTime(selected.year, m, 1).isAfter(homNay),
        ),
    ];
  }

  List<(String, int)> kcalThang12() {
    final out = <(String, int)>[];
    var y = homNay.year;
    var m = homNay.month;
    for (var i = 0; i < 12; i++) {
      final a = DateTime(y, m, 1);
      final b = DateTime(y, m, Ngay.soNgayThang(y, m));
      out.add(('${Chuoi.thang(m)} $y', _kcalKhoang(a, b)));
      m--;
      if (m == 0) {
        m = 12;
        y--;
      }
    }
    return out.reversed.toList();
  }

  List<(String, int)> kcalTuan12() {
    var thu = Ngay.thuHai(homNay);
    final out = <(String, int)>[];
    for (var i = 0; i < 12; i++) {
      final b = thu.add(const Duration(days: 6));
      out.add(('${thu.day}/${thu.month}', _kcalKhoang(thu, b)));
      thu = thu.subtract(const Duration(days: 7));
    }
    return out.reversed.toList();
  }

  int _kcalKhoang(DateTime a, DateTime b) {
    var s = 0;
    var d = Ngay.cat(a);
    final end = Ngay.cat(b);
    while (!d.isAfter(end)) {
      s += kcalTapCuaNgay(d);
      d = d.add(const Duration(days: 1));
    }
    return s;
  }

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
    return dsHien.any((h) => Ten.trung(h.ten, ten));
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
    dsHien = habits;
    final allTicks = await db.dsTick();
    ticksIso = {};
    for (final t in allTicks) {
      ticksIso.putIfAbsent(t.habitId, () => <String>{}).add(t.ngay);
    }
    _xepHang();
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
    dsTap = await db.dsTap();
    dsChiSo = await db.dsChiSo();
    dangTai = false;
    notifyListeners();
    await Nhac.dongBo(dsHien);
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
    _xepHang();
    _veTuan();
  }

  void _xepHang() {
    final isoSel = Ngay.iso(selected);
    final ds = [
      for (final h in dsHien)
        if (Thu.hop(h.thuBit, selected))
          HangHabitView(
            habit: h,
            ticked: ticksCua(h.id).contains(isoSel),
          ),
    ];
    ds.sort((a, b) {
      final ga = a.habit.gioNhac;
      final gb = b.habit.gioNhac;
      if (ga == null && gb != null) return 1;
      if (ga != null && gb == null) return -1;
      if (ga != null && gb != null && ga != gb) return ga.compareTo(gb);
      return a.habit.id.compareTo(b.habit.id);
    });
    hang = ds;
  }

  void _veTuan() {
    tuan = [
      for (final d in Ngay.tuan(selected))
        ChamTuan(
          ngay: d,
          tick: _tickCuaNgay(d),
          tong: _tongCuaNgay(d),
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
    String thuBit = Thu.tatCa,
    int? gioNhac,
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
        thuBit: thuBit,
        gioNhac: gioNhac,
      );
      if (id != null &&
          Ngay.ghiDuoc(selected, homNay) &&
          Thu.hop(thuBit, selected)) {
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
    String? thuBit,
    int? gioNhac,
    bool xoaGioNhac = false,
  }) async {
    final ok = await db.suaHabit(
      id: id,
      ten: ten,
      thuBit: thuBit,
      gioNhac: gioNhac,
      xoaGioNhac: xoaGioNhac,
    );
    if (ok) await tai();
    return ok;
  }

  Future<void> anKhoiDs(int id) async {
    await db.anHabit(id);
    await tai();
  }

  Future<void> boTickNgay(Habit h, DateTime ngay) async {
    if (!Ngay.ghiDuoc(ngay, homNay)) return;
    final iso = Ngay.iso(ngay);
    final set = ticksIso[h.id];
    if (set == null || !set.contains(iso)) return;
    set.remove(iso);
    _dongBoHangVaTuan();
    notifyListeners();
    await db.xoaTick(h.id, ngay);
  }

  Future<void> boTickTuan(Habit h) async {
    for (final d in Thu.ngayTrongTuan(h.thuBit, selected)) {
      if (!Ngay.sau(d, homNay)) await boTickNgay(h, d);
    }
  }

  Future<void> boTickThang(Habit h) async {
    for (final d in Thu.ngayTrongThang(h.thuBit, selected)) {
      if (!Ngay.sau(d, homNay) && Ngay.ghiDuoc(d, homNay)) {
        await boTickNgay(h, d);
      }
    }
  }

  Future<void> xoaHabit(int id) => anKhoiDs(id);

  void moTienDo() {
    tab = 2;
    notifyListeners();
  }

  void moCaiDat() {
    tab = 3;
    notifyListeners();
  }

  void moLich() {
    tab = 1;
    notifyListeners();
  }

  void chonTab(int i) {
    tab = i;
    notifyListeners();
  }

  void chonPhin(int i) {
    phin = i;
    notifyListeners();
  }

  Future<bool> ghiCanKg(double kg, {DateTime? ngay}) async {
    final d = Ngay.cat(ngay ?? selected);
    if (!Ngay.ghiDuoc(d, homNay)) return false;
    if (kg <= 0 || kg > 400) return false;
    await db.ghiCan(d, kg);
    await tai();
    return true;
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
    final d = Ngay.cat(ngay ?? selected);
    if (!Ngay.ghiDuoc(d, homNay)) return false;
    final cm = So.parseEo(raw);
    if (cm == null) return false;
    await db.ghiEo(d, cm);
    await tai();
    return true;
  }

  Future<bool> ghiTap(String loai, int phut, {DateTime? ngay}) async {
    final d = Ngay.cat(ngay ?? selected);
    if (!Ngay.ghiDuoc(d, homNay)) return false;
    if (CongThuc.metCua(loai) == null) return false;
    if (phut < 1 || phut > 300) return false;
    await db.ghiTap(d, loai, phut);
    await tai();
    return true;
  }

  Future<bool> luuHoSo({
    required String ten,
    required String cao,
    required String? sex,
    required DateTime? dob,
    required double activity,
  }) async {
    if (!CongThuc.heSo.contains(activity)) return false;
    await db.suaProfile(
      tenGoi: Value(ten.trim().isEmpty ? null : ten.trim()),
      heightCm: Value(So.parseCm(cao) ?? heightCm),
      sex: Value(sex),
      dob: Value(dob == null ? null : Ngay.iso(dob)),
      activity: Value(activity),
    );
    await tai();
    return true;
  }

  Future<bool> luuMucTieu({required String dich, required double nhip}) async {
    if (!CongThuc.nhipHopLe(nhip)) return false;
    await db.suaProfile(
      targetKg: Value(So.parseKg(dich) ?? targetKg ?? canMoi?.kg),
      nhipKg: Value(nhip),
    );
    await tai();
    return true;
  }

  Future<bool> ghiChiSoNgay({
    double? eo,
    double? hong,
    double? nguc,
    double? bapTay,
  }) async {
    if (khoaGhi) return false;
    await db.ghiChiSo(
      selected,
      eo: eo,
      hong: hong,
      nguc: nguc,
      bapTay: bapTay,
    );
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
    if (!CongThuc.nhipHopLe(v)) return;
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
