import 'ngay.dart';

/// Tính lúc đọc. Không persist BMI / BMR / TDEE / kcal.
abstract final class CongThuc {
  static const mocA185 = 18.5;
  static const mocA23 = 23.0;
  static const mocA275 = 27.5;

  static const heSo = [1.2, 1.375, 1.55, 1.725, 1.9];
  static const nhipKg = [0.25, 0.5];
  static const metDiBo = 3.5;
  static const metKhangLuc = 5.0;
  static const loaiDiBo = 'di_bo';
  static const loaiKhangLuc = 'khang_luc';

  static double? metCua(String? loai) {
    if (loai == loaiDiBo) return metDiBo;
    if (loai == loaiKhangLuc) return metKhangLuc;
    return null;
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

  /// Tuần còn lại với nhịp đã chọn.
  static String? nhipDong(double? kg, double? target, double nhip) {
    if (kg == null || target == null) return null;
    final d = (kg - target).abs();
    if (d <= 0.05) return 'Đã đạt cân đích.';
    final tuan = (d / nhip).ceil();
    if (kg > target) {
      return 'Khoảng $tuan tuần nếu giảm ${nhip == 0.25 ? '0,25' : '0,5'} kg/tuần.';
    }
    return 'Khoảng $tuan tuần nếu tăng ${nhip == 0.25 ? '0,25' : '0,5'} kg/tuần.';
  }
}
