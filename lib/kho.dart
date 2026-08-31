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

class ChuaTick {
  const ChuaTick({required this.ten, required this.so});

  final String ten;
  final int so;
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
  double? startKg;
  double? startEo;
  double? startHong;
  double? startNguc;
  double? startBapTay;
  String? startDoNgay;
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
  List<NapIn> dsNap = const [];
  List<Food> dsMon = const [];
  List<FoodLog> dsLog = const [];
  List<ChiSoIn> dsChiSo = const [];
  List<MocCan> dsMocBanDau = const [];
  List<MocCan> dsMocDich = const [];
  bool dangTai = true;

  /// iso yyyy-MM-dd đã tick, theo habitId.
  Map<int, Set<String>> ticksIso = {};
  Map<int, Set<String>> loaiTru = {};

  final Set<String> _dangThem = {};
  final Map<String, Future<void>> _ghiTick = {};

  int get nTick => hang.where((h) => h.ticked).length;
  int get mHabit => hang.length;
  bool get rong => dsHien.isEmpty;
  bool get xemHomNay => Ngay.cungNgay(selected, homNay);
  bool get khoaGhi => !Ngay.ghiDuoc(selected, homNay);
  bool get themDuoc => soConHien < AppDatabase.maxHabit && !khoaGhi;

  int get soConHien {
    var n = 0;
    for (final h in dsHien) {
      if (h.anTu == null || Ngay.truoc(homNay, Ngay.parse(h.anTu!))) n++;
    }
    return n;
  }

  String get dongNgay => Chuoi.dongNgay(selected);

  String get nTrenM {
    if (xemHomNay) return Chuoi.nTrenMHomNay(nTick, mHabit);
    return Chuoi.nTrenMNgay(nTick, mHabit, selected);
  }

  int get nTickHom => _tickCuaNgay(homNay);
  int get mHom => _tongCuaNgay(homNay);

  bool get tuanChuaHomNay =>
      Ngay.cungNgay(Ngay.thuHai(selected), Ngay.thuHai(homNay));

  bool hienO(Habit h, DateTime d) {
    if (h.anTu != null && !Ngay.truoc(d, Ngay.parse(h.anTu!))) return false;
    if (loaiTru[h.id]?.contains(Ngay.iso(d)) ?? false) return false;
    return Thu.hien(
      thuBit: h.thuBit,
      createdOn: Ngay.cat(h.taoLuc),
      d: d,
    );
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
      if (!hienO(h, d)) continue;
      if (ticksCua(h.id).contains(iso)) n++;
    }
    return n;
  }

  int _tongCuaNgay(DateTime d) {
    var n = 0;
    for (final h in dsHien) {
      if (hienO(h, d)) n++;
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

  String get chuKcalTap => Chuoi.kcalTieuThuHomNay(kcalTapCuaNgay(selected));

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

  int phutTapCuaNgay(DateTime d) {
    var s = 0;
    for (final t in tapNgay(d)) {
      s += t.phut;
    }
    return s;
  }

  NapIn? napCua(DateTime d) {
    final iso = Ngay.iso(d);
    for (final n in dsNap) {
      if (n.ngay == iso) return n;
    }
    return null;
  }

  List<FoodLog> logNgay(DateTime d) {
    final iso = Ngay.iso(d);
    return [for (final x in dsLog) if (x.ngay == iso) x];
  }

  int kcalNapCuaNgay(DateTime d) {
    final logs = logNgay(d);
    if (logs.isNotEmpty) {
      var s = 0;
      for (final x in logs) {
        s += x.kcal;
      }
      return s;
    }
    return napCua(d)?.kcal ?? 0;
  }

  ({double dam, double bot, double beo}) macroNgay(DateTime d) {
    var dam = 0.0, bot = 0.0, beo = 0.0;
    for (final x in logNgay(d)) {
      dam += x.dam ?? 0;
      bot += x.bot ?? 0;
      beo += x.beo ?? 0;
    }
    return (dam: dam, bot: bot, beo: beo);
  }

  bool get coNap => dsLog.isNotEmpty || dsNap.isNotEmpty;

  List<(DateTime ngay, double bmi)> get bmiTheoCan {
    final out = <(DateTime, double)>[];
    for (final c in dsCan.reversed) {
      final b = CongThuc.bmi(c.kg, heightCm);
      if (b == null) continue;
      out.add((Ngay.parse(c.ngay), b));
    }
    return out;
  }

  List<(DateTime ngay, int kcal)> diemKcalPhin(int p, int Function(DateTime) cua) {
    switch (p) {
      case 1:
        return [for (final d in Ngay.cacNgayThang(selected)) (d, cua(d))];
      case 2:
        return _gopTuan(Ngay.congThang(selected, -6), selected, cua);
      case 3:
        final out = <(DateTime, int)>[];
        for (var i = 11; i >= 0; i--) {
          final d = DateTime(selected.year, selected.month - i, 1);
          final a = DateTime(d.year, d.month, 1);
          final b = DateTime(d.year, d.month, Ngay.soNgayThang(d.year, d.month));
          out.add((a, _kcalKhoangFn(a, b, cua)));
        }
        return out;
      default:
        return [for (final d in Ngay.tuan(selected)) (d, cua(d))];
    }
  }

  List<(DateTime, int)> _gopTuan(DateTime a, DateTime b, int Function(DateTime) cua) {
    final out = <(DateTime, int)>[];
    var thu = Ngay.thuHai(a);
    final end = Ngay.cat(b);
    while (!thu.isAfter(end)) {
      final cuoi = thu.add(const Duration(days: 6));
      out.add((thu, _kcalKhoangFn(thu, cuoi.isAfter(end) ? end : cuoi, cua)));
      thu = thu.add(const Duration(days: 7));
    }
    return out;
  }

  int _kcalKhoangFn(DateTime a, DateTime b, int Function(DateTime) cua) {
    var s = 0;
    var d = Ngay.cat(a);
    final end = Ngay.cat(b);
    while (!d.isAfter(end)) {
      s += cua(d);
      d = d.add(const Duration(days: 1));
    }
    return s;
  }

  LuaTap get luaTapHom {
    return CongThuc.luaTap([for (final t in dsTap) t.ngay], homNay);
  }

  List<double> get netSang {
    final o = <double>[];
    if (startKg != null) o.add(startKg!);
    if (targetKg != null) o.add(targetKg!);
    return o;
  }

  List<double> get netMo {
    final o = <double>[];
    var n = 0;
    for (final m in dsMocBanDau) {
      if (startKg != null && (m.kg - startKg!).abs() < 0.05) continue;
      if (o.any((v) => (v - m.kg).abs() < 0.05)) continue;
      o.add(m.kg);
      n++;
      if (n == 2) break;
    }
    n = 0;
    for (final m in dsMocDich) {
      if (targetKg != null && (m.kg - targetKg!).abs() < 0.05) continue;
      if (o.any((v) => (v - m.kg).abs() < 0.05)) continue;
      o.add(m.kg);
      n++;
      if (n == 2) break;
    }
    return o;
  }

  List<(DateTime ngay, int kcal)> cotKcalTuan(DateTime d) {
    return [for (final x in Ngay.tuan(d)) (x, kcalTapCuaNgay(x))];
  }

  List<(DateTime ngay, int kcal)> cotKcalThang(DateTime d) {
    final out = <(DateTime, int)>[];
    DateTime? dau;
    var kcal = 0;
    for (final x in Ngay.cacNgayThang(d)) {
      final t2 = Ngay.thuHai(x);
      if (dau == null || !Ngay.cungNgay(dau, t2)) {
        if (dau != null) out.add((dau, kcal));
        dau = t2;
        kcal = 0;
      }
      kcal += kcalTapCuaNgay(x);
    }
    if (dau != null) out.add((dau, kcal));
    return out;
  }

  List<(DateTime ngay, int kcal)> cotKcalNam(int nam) {
    return [
      for (var m = 1; m <= 12; m++)
        (
          DateTime(nam, m, 1),
          [
            for (final x in Ngay.cacNgayThang(DateTime(nam, m, 1)))
              kcalTapCuaNgay(x),
          ].fold<int>(0, (a, b) => a + b),
        ),
    ];
  }

  ChiSoIn? chiSoCua(DateTime d) {
    final iso = Ngay.iso(d);
    for (final c in dsChiSo) {
      if (c.ngay == iso) return c;
    }
    return null;
  }

  double? doMoiNhat(DateTime ngay, double? Function(ChiSoIn) lay) {
    final d0 = Ngay.cat(ngay);
    for (final c in dsChiSo) {
      final d = Ngay.parse(c.ngay);
      if (d.isAfter(d0)) continue;
      final x = lay(c);
      if (x != null) return x;
    }
    return null;
  }

  ({double delta, int ngay})? doiLanTruoc(
    DateTime ngay, {
    required double? Function(ChiSoIn) lay,
    required double? hien,
  }) {
    if (hien == null) return null;
    final d0 = Ngay.cat(ngay);
    DateTime? t;
    double? v;
    for (final c in dsChiSo) {
      final d = Ngay.parse(c.ngay);
      if (!d.isBefore(d0)) continue;
      final x = lay(c);
      if (x == null) continue;
      t = d;
      v = x;
      break;
    }
    if (t == null || v == null) return null;
    return (delta: hien - v, ngay: d0.difference(t).inDays);
  }

  ({double delta, int ngay})? doiBanDau(
    DateTime ngay, {
    required double? moc0,
    required double? hien,
  }) {
    if (hien == null || moc0 == null || startDoNgay == null) return null;
    final d0 = Ngay.cat(ngay);
    final mocD = Ngay.parse(startDoNgay!);
    if (mocD.isAfter(d0)) return null;
    return (delta: hien - moc0, ngay: d0.difference(mocD).inDays);
  }

  List<({String ten, double? ban, double? moi})> nhomSoDo(DateTime ngay) {
    return [
      (ten: Chuoi.eoCm, ban: startEo, moi: doMoiNhat(ngay, (c) => c.eo)),
      (ten: Chuoi.hongCm, ban: startHong, moi: doMoiNhat(ngay, (c) => c.hong)),
      (ten: Chuoi.ngucCm, ban: startNguc, moi: doMoiNhat(ngay, (c) => c.nguc)),
      (ten: Chuoi.bapTayCm, ban: startBapTay, moi: doMoiNhat(ngay, (c) => c.bapTay)),
    ];
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

  String? get banDauKg => startKg == null ? null : So.kg(startKg!);

  String? get hienTaiKg => canMoi == null ? null : So.kg(canMoi!.kg);

  String? get doiKg {
    if (startKg == null || canMoi == null) return null;
    return So.kg(canMoi!.kg - startKg!);
  }

  int get phanTramKy {
    final r = nTrenMCua(phin);
    if (r.$2 == 0) return 0;
    return ((r.$1 / r.$2) * 100).round();
  }

  (int, int) get nTrenMKy => nTrenMCua(phin);

  (int, int) nTrenMCua(int p) {
    switch (p) {
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

  /// 0 tuần, 1 tháng, 2 sáu tháng, 3 mười hai tháng. [tu] = ngày bắt đầu.
  List<CotThang> diemThongKe(int phin, {DateTime? tu}) {
    final a = Ngay.cat(tu ?? homNay);
    final b = Ngay.cuoiKhoang(a, phin);
    if (phin == 2 || phin == 3) {
      final n = phin == 2 ? 6 : 12;
      final out = <CotThang>[];
      for (var i = 0; i < n; i++) {
        final dau = Ngay.congThang(a, i);
        final cuoi = i == n - 1
            ? b
            : Ngay.congThang(a, i + 1).subtract(const Duration(days: 1));
        final r = _tickKhoang(dau, cuoi);
        out.add(
          CotThang(
            ngay: dau,
            tick: r.$1,
            tong: r.$2,
            dangXem: Ngay.cungThang(dau, selected),
            tuongLai: Ngay.sau(dau, homNay),
          ),
        );
      }
      return out;
    }
    return [
      for (final d in Ngay.cacNgayKhoang(a, b))
        CotThang(
          ngay: d,
          tick: _tickCuaNgay(d),
          tong: _tongCuaNgay(d),
          dangXem: Ngay.cungNgay(d, selected),
          tuongLai: Ngay.sau(d, homNay),
        ),
    ];
  }

  (int, int) nTrenMThongKe(int phin, {DateTime? tu}) {
    final a = Ngay.cat(tu ?? homNay);
    final b = Ngay.cuoiKhoang(a, phin);
    return _tickKhoang(a, b);
  }

  List<ChuaTick> chuaTick({required int phin, DateTime? tu}) {
    final a = Ngay.cat(tu ?? homNay);
    final b = Ngay.cuoiKhoang(a, phin);
    final out = <ChuaTick>[];
    for (final h in dsHien) {
      if (h.anTu != null && !Ngay.truoc(homNay, Ngay.parse(h.anTu!))) continue;
      var n = 0;
      for (final d in Ngay.cacNgayKhoang(a, b)) {
        if (!hienO(h, d)) continue;
        if (!ticksCua(h.id).contains(Ngay.iso(d))) n++;
      }
      if (n > 0) out.add(ChuaTick(ten: h.ten, so: n));
    }
    out.sort((x, y) => y.so.compareTo(x.so));
    return out;
  }

  (int, int) _tickKhoang(DateTime a, DateTime b) {
    var tick = 0;
    var tong = 0;
    var d = Ngay.cat(a);
    final end = Ngay.cat(b);
    while (!d.isAfter(end)) {
      tick += _tickCuaNgay(d);
      tong += _tongCuaNgay(d);
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
    loaiTru = {};
    for (final x in await db.dsLoaiTru()) {
      loaiTru.putIfAbsent(x.habitId, () => <String>{}).add(x.ngay);
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
    startKg = p.startKg;
    startEo = p.startEo;
    startHong = p.startHong;
    startNguc = p.startNguc;
    startBapTay = p.startBapTay;
    startDoNgay = p.startDoNgay;
    dsCan = await db.dsCan();
    canMoi = dsCan.isEmpty ? null : dsCan.first;
    dsEo = await db.dsEo();
    eoMoi = dsEo.isEmpty ? null : dsEo.first;
    dsMo = await db.dsMo();
    moMoi = dsMo.isEmpty ? null : dsMo.first;
    dsTap = await db.dsTap();
    dsNap = await db.dsNap();
    dsMon = await db.dsMon();
    dsLog = await db.dsLog();
    dsChiSo = await db.dsChiSo();
    dsMocBanDau = await db.dsMoc(AppDatabase.loaiBanDau);
    dsMocDich = await db.dsMoc(AppDatabase.loaiDich);
    dangTai = false;
    notifyListeners();
    await Nhac.dongBo(dsHien);
  }

  void chonNgay(DateTime d) {
    selected = Ngay.cat(d);
    _dongBoHangVaTuan();
    notifyListeners();
  }

  void veHomNay() => chonNgay(homNay);

  void luiTuan() => chonNgay(Ngay.cat(selected).subtract(const Duration(days: 7)));

  void toiTuan() => chonNgay(Ngay.cat(selected).add(const Duration(days: 7)));

  /// UI đổi ngay, ghi Drift sau. Ghi tuần tự theo (habit, ngày).
  Future<void> toggle(HangHabitView h) => toggleNgay(h.habit, selected);

  /// Ô tháng: đổi selectedDate; tick chỉ khi ngày còn ghi được.
  Future<void> chonVaTick(Habit habit, DateTime ngay) {
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
        if (hienO(h, selected))
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
      final goc = Ngay.cat(selected);
      final id = await db.themHabit(
        ten: ten,
        mucTieuThang: mucTieuThang,
        met: met,
        phutMacDinh: phutMacDinh,
        thuBit: thuBit,
        gioNhac: gioNhac,
        createdOn: goc,
      );
      if (id != null &&
          Ngay.ghiDuoc(goc, homNay) &&
          Thu.hien(thuBit: thuBit, createdOn: goc, d: goc)) {
        final ds = await db.dsHabit();
        final h = ds.firstWhere((x) => x.id == id);
        await db.ghiTick(h, goc);
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
    if (!Ngay.ghiDuoc(selected, homNay)) return;
    await db.anTuNgay(id, homNay);
    await tai();
  }

  Future<void> xoaKhoiNgay(Habit h, DateTime ngay) async {
    if (!Ngay.ghiDuoc(selected, homNay)) return;
    loaiTru.putIfAbsent(h.id, () => <String>{}).add(Ngay.iso(ngay));
    _dongBoHangVaTuan();
    notifyListeners();
    await db.ghiLoaiTru(h.id, ngay);
  }

  Future<void> xoaKhoiTuanSau(Habit h) async {
    if (!Ngay.ghiDuoc(selected, homNay)) return;
    final tuanSau = Ngay.tuan(Ngay.cat(selected).add(const Duration(days: 7)));
    for (final d in tuanSau) {
      if (!Thu.hop(h.thuBit, d)) continue;
      loaiTru.putIfAbsent(h.id, () => <String>{}).add(Ngay.iso(d));
      await db.ghiLoaiTru(h.id, d);
    }
    _dongBoHangVaTuan();
    notifyListeners();
  }

  Future<void> xoaKhoiThangSau(Habit h) async {
    if (!Ngay.ghiDuoc(selected, homNay)) return;
    final thangSau = Ngay.toiThang(selected);
    for (final d in Ngay.cacNgayThang(thangSau)) {
      if (!Thu.hop(h.thuBit, d)) continue;
      loaiTru.putIfAbsent(h.id, () => <String>{}).add(Ngay.iso(d));
      await db.ghiLoaiTru(h.id, d);
    }
    _dongBoHangVaTuan();
    notifyListeners();
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

  void moLich() => chonTab(1);

  void chonTab(int i) {
    tab = i;
    if (i == 1) {
      selected = homNay;
      _dongBoHangVaTuan();
    }
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
    return ghiNhieuTap([(loai, phut)], ngay: ngay);
  }

  Future<bool> ghiNhieuTap(Iterable<(String loai, int phut)> ds, {DateTime? ngay}) async {
    final d = Ngay.cat(ngay ?? selected);
    if (!Ngay.ghiDuoc(d, homNay)) return false;
    var ok = false;
    for (final x in ds) {
      if (CongThuc.metCua(x.$1) == null) continue;
      if (x.$2 < 1 || x.$2 > 300) continue;
      await db.ghiTap(d, x.$1, x.$2);
      ok = true;
    }
    if (!ok) return false;
    await tai();
    return true;
  }

  Future<bool> ghiNap(int kcal, {DateTime? ngay}) async {
    final d = Ngay.cat(ngay ?? selected);
    if (!Ngay.ghiDuoc(d, homNay)) return false;
    if (kcal < 1 || kcal > 20000) return false;
    await db.ghiNap(d, kcal);
    await tai();
    return true;
  }

  Future<Food?> luuMon({
    required String ten,
    required int kcal,
    double? gram,
    String? vanBan,
    double? dam,
    double? bot,
    double? beo,
    bool vaoNgay = false,
    DateTime? ngay,
  }) async {
    final t = ten.trim();
    if (t.isEmpty) return null;
    if (kcal < 1 || kcal > 20000) return null;
    final id = await db.themMon(
      ten: t,
      kcal: kcal,
      gram: gram,
      vanBan: vanBan,
      dam: dam,
      bot: bot,
      beo: beo,
    );
    if (vaoNgay) {
      final d = Ngay.cat(ngay ?? selected);
      if (Ngay.ghiDuoc(d, homNay)) {
        await db.ghiLog(
          d,
          foodId: id,
          ten: t,
          kcal: kcal,
          gram: gram,
          dam: dam,
          bot: bot,
          beo: beo,
        );
      }
    }
    await tai();
    for (final f in dsMon) {
      if (f.id == id) return f;
    }
    return null;
  }

  Future<bool> chonMon(int foodId, {DateTime? ngay}) async {
    final d = Ngay.cat(ngay ?? selected);
    if (!Ngay.ghiDuoc(d, homNay)) return false;
    Food? f;
    for (final x in dsMon) {
      if (x.id == foodId) f = x;
    }
    if (f == null) return false;
    await db.ghiLog(
      d,
      foodId: f.id,
      ten: f.ten,
      kcal: f.kcal,
      gram: f.gram,
      dam: f.dam,
      bot: f.bot,
      beo: f.beo,
    );
    await tai();
    return true;
  }

  Future<bool> xoaLog(int id, {DateTime? ngay}) async {
    final d = Ngay.cat(ngay ?? selected);
    if (!Ngay.ghiDuoc(d, homNay)) return false;
    final iso = Ngay.iso(d);
    final co = dsLog.any((l) => l.id == id && l.ngay == iso);
    if (!co) return false;
    await db.xoaLog(id);
    await tai();
    return true;
  }

  Future<bool> suaLog(int id, {int? kcal, String? ten, DateTime? ngay}) async {
    final d = Ngay.cat(ngay ?? selected);
    if (!Ngay.ghiDuoc(d, homNay)) return false;
    final iso = Ngay.iso(d);
    final co = dsLog.any((l) => l.id == id && l.ngay == iso);
    if (!co) return false;
    if (kcal != null && (kcal < 1 || kcal > 20000)) return false;
    await db.suaLog(id, kcal: kcal, ten: ten);
    await tai();
    return true;
  }

  Future<bool> xoaTap(int id, {DateTime? ngay}) async {
    final d = Ngay.cat(ngay ?? selected);
    if (!Ngay.ghiDuoc(d, homNay)) return false;
    final iso = Ngay.iso(d);
    final co = dsTap.any((t) => t.id == id && t.ngay == iso);
    if (!co) return false;
    await db.xoaTap(id);
    await tai();
    return true;
  }

  Future<bool> suaTap(int id, String loai, int phut, {DateTime? ngay}) async {
    final d = Ngay.cat(ngay ?? selected);
    if (!Ngay.ghiDuoc(d, homNay)) return false;
    if (CongThuc.metCua(loai) == null) return false;
    if (phut < 1 || phut > 300) return false;
    final iso = Ngay.iso(d);
    final co = dsTap.any((t) => t.id == id && t.ngay == iso);
    if (!co) return false;
    await db.suaTap(id, loai, phut);
    await tai();
    return true;
  }

  Future<bool> luuHoSo({
    required String ten,
    required String cao,
    required String? sex,
    required DateTime? dob,
    required double activity,
    String? banDau,
    String? eo0,
    String? hong0,
    String? nguc0,
    String? tay0,
  }) async {
    if (!CongThuc.heSo.contains(activity)) return false;
    final kg = So.parseKg(banDau ?? '');
    final eo = So.parseEo(eo0 ?? '');
    final hong = So.parseEo(hong0 ?? '');
    final nguc = So.parseEo(nguc0 ?? '');
    final tay = So.parseEo(tay0 ?? '');
    final coMoc = eo != null || hong != null || nguc != null || tay != null;
    await db.suaProfile(
      tenGoi: Value(ten.trim().isEmpty ? null : ten.trim()),
      heightCm: Value(So.parseCm(cao) ?? heightCm),
      sex: Value(sex),
      dob: Value(dob == null ? null : Ngay.iso(dob)),
      activity: Value(activity),
      startKg: kg != null ? Value(kg) : const Value.absent(),
      startEo: eo != null ? Value(eo) : const Value.absent(),
      startHong: hong != null ? Value(hong) : const Value.absent(),
      startNguc: nguc != null ? Value(nguc) : const Value.absent(),
      startBapTay: tay != null ? Value(tay) : const Value.absent(),
      startDoNgay: coMoc ? Value(Ngay.iso(homNay)) : const Value.absent(),
    );
    if (kg != null && (startKg == null || (startKg! - kg).abs() >= 0.05)) {
      await db.ghiMoc(loai: AppDatabase.loaiBanDau, ngay: homNay, kg: kg);
    }
    await tai();
    return true;
  }

  Future<bool> luuMucTieu({required String dich, required double nhip}) async {
    if (!CongThuc.nhipHopLe(nhip)) return false;
    final kg = So.parseKg(dich) ?? targetKg ?? canMoi?.kg;
    await db.suaProfile(
      targetKg: Value(kg),
      nhipKg: Value(nhip),
    );
    if (kg != null && (targetKg == null || (targetKg! - kg).abs() >= 0.05)) {
      await db.ghiMoc(loai: AppDatabase.loaiDich, ngay: homNay, kg: kg);
    }
    await tai();
    return true;
  }

  Future<bool> ghiChiSoNgay({
    double? eo,
    double? hong,
    double? nguc,
    double? bapTay,
    DateTime? ngay,
  }) async {
    final d = Ngay.cat(ngay ?? selected);
    if (!Ngay.ghiDuoc(d, homNay)) return false;
    final cu = chiSoCua(d);
    final e = eo ?? cu?.eo;
    final h = hong ?? cu?.hong;
    final n = nguc ?? cu?.nguc;
    final t = bapTay ?? cu?.bapTay;
    await db.ghiChiSo(d, eo: e, hong: h, nguc: n, bapTay: t);
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
    if (targetKg == null || (targetKg! - kg).abs() >= 0.05) {
      await db.ghiMoc(loai: AppDatabase.loaiDich, ngay: homNay, kg: kg);
    }
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
