import 'ngay.dart';

/// Tính lúc đọc. Không persist BMI / BMR / TDEE / kcal.
abstract final class CongThuc {
  static const mocA185 = 18.5;
  static const mocA23 = 23.0;
  static const mocA275 = 27.5;

  static const heSo = [1.2, 1.375, 1.55, 1.725, 1.9];
  static const metDiBo = 3.5;
  static const metChay = 8.0;
  static const metDapXe = 6.8;
  static const metKhangLuc = 5.0;
  static const metYoga = 3.0;
  static const metBoi = 6.0;
  static const metDaBong = 7.0;
  static const metCauLong = 5.5;
  static const metNhayDay = 8.8;
  static const metGianCo = 2.3;
  static const loaiDiBo = 'di_bo';
  static const loaiChay = 'chay';
  static const loaiDapXe = 'dap_xe';
  static const loaiKhangLuc = 'khang_luc';
  static const loaiYoga = 'yoga';
  static const loaiBoi = 'boi';
  static const loaiDaBong = 'da_bong';
  static const loaiCauLong = 'cau_long';
  static const loaiNhayDay = 'nhay_day';
  static const loaiGianCo = 'gian_co';

  static const mon = [
    (loai: loaiDiBo, met: metDiBo),
    (loai: loaiChay, met: metChay),
    (loai: loaiDapXe, met: metDapXe),
    (loai: loaiKhangLuc, met: metKhangLuc),
    (loai: loaiYoga, met: metYoga),
    (loai: loaiBoi, met: metBoi),
    (loai: loaiDaBong, met: metDaBong),
    (loai: loaiCauLong, met: metCauLong),
    (loai: loaiNhayDay, met: metNhayDay),
    (loai: loaiGianCo, met: metGianCo),
  ];

  static double? metCua(String? loai) {
    for (final m in mon) {
      if (m.loai == loai) return m.met;
    }
    return null;
  }

  static bool nhipHopLe(double v) {
    if (v < 0 || v > 1) return false;
    return ((v * 10).round() / 10 - v).abs() < 0.001;
  }

  static DateTime? duKien({
    required DateTime homNay,
    required double nhip,
    double? kg,
    double? target,
  }) {
    if (nhip <= 0 || kg == null || target == null) return null;
    final d = (kg - target).abs();
    if (d <= 0.05) return null;
    final ngay = (d / nhip * 7).ceil();
    return Ngay.cat(homNay).add(Duration(days: ngay));
  }

  /// Deurenberg 1991. Nam sex=1, nữ sex=0.
  /// BF% = 1.20×BMI + 0.23×tuổi − 10.8×sex − 5.4. Không persist.
  static double? moDeurenberg({
    required double? bmi,
    required int? tuoi,
    required String? sex,
  }) {
    if (bmi == null || tuoi == null) return null;
    if (sex != 'nam' && sex != 'nu') return null;
    final s = sex == 'nam' ? 1.0 : 0.0;
    return 1.20 * bmi + 0.23 * tuoi - 10.8 * s - 5.4;
  }

  static int? kcalGoiY({
    required double? tdee,
    required double nhip,
    double? kg,
    double? target,
  }) {
    if (tdee == null) return null;
    final delta = nhip * 7700 / 7;
    var v = tdee - delta;
    if (kg != null && target != null && target - kg > 0.05) {
      v = tdee + delta;
    }
    return (v / 10).round() * 10;
  }

  static int? tuoi(String? dobIso, DateTime homNay) {
    if (dobIso == null || dobIso.isEmpty) return null;
    final d = Ngay.parse(dobIso);
    var t = homNay.year - d.year;
    if (homNay.month < d.month ||
        (homNay.month == d.month && homNay.day < d.day)) {
      t--;
    }
    if (t < 0 || t > 120) return null;
    return t;
  }

  static double? bmi(double? kg, double? cm) {
    if (kg == null || cm == null || kg <= 0 || cm <= 0) return null;
    final m = cm / 100.0;
    return kg / (m * m);
  }

  /// <18,5 thiếu · 18,5–22,9 bình thường · 23–27,4 thừa · ≥27,5 béo
  static String? bmiNhan(double? bmi) {
    if (bmi == null) return null;
    if (bmi < mocA185) return 'thiếu';
    if (bmi < mocA23) return 'bình thường';
    if (bmi < mocA275) return 'thừa';
    return 'béo';
  }

  /// Mifflin–St Jeor 1990. Nam +5, nữ −161.
  static double? bmr({
    required String? sex,
    required double? kg,
    required double? cm,
    required int? tuoi,
  }) {
    if (kg == null || cm == null || tuoi == null) return null;
    if (sex != 'nam' && sex != 'nu') return null;
    final base = 10 * kg + 6.25 * cm - 5 * tuoi;
    return sex == 'nam' ? base + 5 : base - 161;
  }

  static double? tdee(double? bmr, double activity) {
    if (bmr == null) return null;
    return bmr * activity;
  }

  /// 0.0175 × MET × kg × phút. Thiếu cân → null.
  static double? kcalTap({double? met, double? kg, int? phut}) {
    if (met == null || kg == null || phut == null) return null;
    if (met <= 0 || kg <= 0 || phut <= 0) return null;
    return 0.0175 * met * kg * phut;
  }

  /// Chuỗi tập: chỉ ngày có phiên. Bỏ 1–2 ngày vẫn nối (gap ≤ 3).
  static LuaTap luaTap(Iterable<String> isoNgay, DateTime today) {
    final days = isoNgay.map(Ngay.parse).map(Ngay.cat).toSet().toList()
      ..sort((a, b) => b.compareTo(a));
    if (days.isEmpty) return const LuaTap(so: 0, sang: false);
    final last = days.first;
    final hom = Ngay.cat(today);
    final gap = hom.difference(last).inDays;
    var streak = 1;
    var cursor = last;
    for (var i = 1; i < days.length; i++) {
      final g = cursor.difference(days[i]).inDays;
      if (g <= 0) continue;
      if (g <= 3) {
        streak++;
        cursor = days[i];
      } else {
        break;
      }
    }
    return LuaTap(so: streak, sang: gap == 0);
  }

  static NhanNap? nhanNap(int nap, int? goiY) {
    if (goiY == null) return null;
    if (nap > goiY) return NhanNap.vuot;
    if (nap >= goiY - 500) return NhanNap.dung;
    if (nap >= goiY - 700) return NhanNap.hoiThap;
    return NhanNap.quaThap;
  }

  /// Số đứng trước kcal|calo|năng lượng. Không bịa.
  static int? docKcal(String vanBan) {
    final re = RegExp(
      r'(\d+(?:[.,]\d+)?)\s*(?:kcal|calo|năng lượng)',
      caseSensitive: false,
    );
    final m = re.firstMatch(vanBan);
    if (m == null) return null;
    final raw = m.group(1)!.replaceAll(',', '.');
    final v = double.tryParse(raw);
    if (v == null) return null;
    final n = v.round();
    if (n < 0 || n > 20000) return null;
    return n;
  }

  static final _soRe = RegExp(r'(\d+(?:[.,]\d+)?)');

  static final _nhanRe = RegExp(
    r'(MON|KHOI_LUONG|KCAL|DAM|BOT|BEO)\s*:\s*',
    caseSensitive: false,
  );

  static Map<String, String> _tachNhan(String vanBan) {
    final ms = _nhanRe.allMatches(vanBan).toList();
    final out = <String, String>{};
    for (var i = 0; i < ms.length; i++) {
      final khoa = ms[i].group(1)!.toUpperCase();
      final start = ms[i].end;
      final end = i + 1 < ms.length ? ms[i + 1].start : vanBan.length;
      final v = vanBan.substring(start, end).trim();
      if (v.isNotEmpty) out[khoa] = v;
    }
    return out;
  }

  static double? _soChu(String? raw) {
    if (raw == null) return null;
    final m = _soRe.firstMatch(raw);
    if (m == null) return null;
    return double.tryParse(m.group(1)!.replaceAll(',', '.'));
  }

  /// Ưu tiên MON: / KHOI_LUONG: / KCAL: / DAM: / BOT: / BEO: cả khối, một hàng cũng được.
  /// Không có KCAL: thì bắt số trước kcal|calo|năng lượng. Không bịa.
  static DocMon docMon(String vanBan) {
    final nhan = _tachNhan(vanBan);
    final ten = nhan['MON'];
    final gramRaw = _soChu(nhan['KHOI_LUONG']);
    final kcalRaw = _soChu(nhan['KCAL']);
    final dam = _soChu(nhan['DAM']);
    final bot = _soChu(nhan['BOT']);
    final beo = _soChu(nhan['BEO']);
    int? kcal;
    if (kcalRaw != null) {
      final n = kcalRaw.round();
      if (n >= 0 && n <= 20000) kcal = n;
    }
    kcal ??= docKcal(vanBan);
    double? gram;
    if (gramRaw != null && gramRaw > 0 && gramRaw <= 5000) gram = gramRaw;
    double? hop(double? v) {
      if (v == null || v < 0 || v > 500) return null;
      return v;
    }
    return DocMon(
      ten: ten,
      gram: gram,
      kcal: kcal,
      dam: hop(dam),
      bot: hop(bot),
      beo: hop(beo),
    );
  }

  static double motSo(double v) => (v * 10).round() / 10.0;

  /// foods lưu /100 g. Khối khác 100 g thì quy về 100 g.
  static DocMon quy100(DocMon d) {
    final g = d.gram;
    if (g == null || g <= 0 || (g - 100).abs() < 0.05) {
      return DocMon(
        ten: d.ten,
        gram: 100,
        kcal: d.kcal,
        dam: d.dam == null ? null : motSo(d.dam!),
        bot: d.bot == null ? null : motSo(d.bot!),
        beo: d.beo == null ? null : motSo(d.beo!),
      );
    }
    final k = 100 / g;
    return DocMon(
      ten: d.ten,
      gram: 100,
      kcal: d.kcal == null ? null : (d.kcal! * k).round(),
      dam: d.dam == null ? null : motSo(d.dam! * k),
      bot: d.bot == null ? null : motSo(d.bot! * k),
      beo: d.beo == null ? null : motSo(d.beo! * k),
    );
  }

  /// kcal_dung = kcal100 * g / 100. Macro cùng công thức, làm tròn 1 số.
  static DocMon dung({
    required int kcal100,
    required double g,
    double? dam100,
    double? bot100,
    double? beo100,
    String? ten,
  }) {
    final k = g / 100.0;
    return DocMon(
      ten: ten,
      gram: g,
      kcal: (kcal100 * k).round(),
      dam: dam100 == null ? null : motSo(dam100 * k),
      bot: bot100 == null ? null : motSo(bot100 * k),
      beo: beo100 == null ? null : motSo(beo100 * k),
    );
  }

  /// Tuần còn lại với nhịp đã chọn.
  static String? nhipDong(double? kg, double? target, double nhip) {
    if (kg == null || target == null) return null;
    final d = (kg - target).abs();
    if (d <= 0.05) return 'Đã đạt cân đích.';
    if (nhip <= 0) return null;
    final tuan = (d / nhip).ceil();
    final nhipViet = nhipVietChu(nhip);
    if (kg > target) {
      return 'Khoảng $tuan tuần nếu giảm $nhipViet kg/tuần.';
    }
    return 'Khoảng $tuan tuần nếu tăng $nhipViet kg/tuần.';
  }

  static String nhipVietChu(double nhip) {
    final s = nhip.toStringAsFixed(1).replaceAll('.', ',');
    return s.endsWith(',0') ? s.substring(0, s.length - 2) : s;
  }
}

class LuaTap {
  const LuaTap({required this.so, required this.sang});

  final int so;
  final bool sang;
}

enum NhanNap { vuot, dung, hoiThap, quaThap }

class DocMon {
  const DocMon({this.ten, this.gram, this.kcal, this.dam, this.bot, this.beo});

  final String? ten;
  final double? gram;
  final int? kcal;
  final double? dam;
  final double? bot;
  final double? beo;
}
