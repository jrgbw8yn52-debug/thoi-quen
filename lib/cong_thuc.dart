import 'ngay.dart';

/// Tính lúc đọc. Không persist BMI / BMR / TDEE / kcal.
abstract final class CongThuc {
  static const mocA23 = 23.0;
  static const mocA275 = 27.5;

  static const heSo = [1.2, 1.375, 1.55, 1.725, 1.9];

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
}
