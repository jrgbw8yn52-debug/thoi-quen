import 'ngay.dart';

/// Hết hạn Focus: giờ + duration. Không duration → 23:59 ngày đó.
abstract final class FocusHan {
  static DateTime hetHan({
    required String ngay,
    required int gioPhut,
    required int? durationMin,
  }) {
    final d = Ngay.parse(ngay);
    if (durationMin == null) {
      return DateTime(d.year, d.month, d.day, 23, 59);
    }
    return DateTime(d.year, d.month, d.day, 0, 0)
        .add(Duration(minutes: gioPhut + durationMin));
  }

  static bool quaHan({
    required bool done,
    required String ngay,
    required int gioPhut,
    required int? durationMin,
    required DateTime now,
  }) {
    if (done) return false;
    return now.isAfter(
      hetHan(ngay: ngay, gioPhut: gioPhut, durationMin: durationMin),
    );
  }
}
