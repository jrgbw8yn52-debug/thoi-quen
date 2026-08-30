import 'ngay.dart';

/// ISO weekday 1=T2 … 7=CN. Lưu TEXT «1234567».
abstract final class Thu {
  static const tatCa = '1234567';

  static Set<int> tach(String? raw) {
    if (raw == null || raw.isEmpty) return {1, 2, 3, 4, 5, 6, 7};
    final s = <int>{};
    for (final c in raw.split('')) {
      final n = int.tryParse(c);
      if (n != null && n >= 1 && n <= 7) s.add(n);
    }
    return s.isEmpty ? {1, 2, 3, 4, 5, 6, 7} : s;
  }

  static String goi(Set<int> s) {
    final b = StringBuffer();
    for (var i = 1; i <= 7; i++) {
      if (s.contains(i)) b.write(i);
    }
    return b.isEmpty ? tatCa : b.toString();
  }

  static bool hop(String? raw, DateTime d) => tach(raw).contains(d.weekday);

  static bool hopIso(String? raw, int weekday) => tach(raw).contains(weekday);

  static List<DateTime> ngayTrongTuan(String? raw, DateTime chon) {
    return [
      for (final d in Ngay.tuan(chon))
        if (hop(raw, d)) d,
    ];
  }

  static List<DateTime> ngayTrongThang(String? raw, DateTime chon) {
    return [
      for (final d in Ngay.cacNgayThang(chon))
        if (hop(raw, d)) d,
    ];
  }
}
