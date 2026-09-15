/// Ngày local, không giờ. Lưu TEXT yyyy-MM-dd.
abstract final class Ngay {
  static DateTime cat(DateTime d) => DateTime(d.year, d.month, d.day);

  static String iso(DateTime d) {
    final x = cat(d);
    final mm = x.month.toString().padLeft(2, '0');
    final dd = x.day.toString().padLeft(2, '0');
    return '${x.year}-$mm-$dd';
  }

  static DateTime parse(String s) {
    final p = s.split('-');
    return DateTime(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
  }

  static DateTime thuHai(DateTime d) {
    final x = cat(d);
    return x.subtract(Duration(days: x.weekday - 1));
  }

  static List<DateTime> tuan(DateTime d) {
    final m = thuHai(d);
    return List<DateTime>.generate(7, (i) => m.add(Duration(days: i)));
  }

  static String prefixThang(DateTime d) {
    final mm = d.month.toString().padLeft(2, '0');
    return '${d.year}-$mm';
  }

  static bool cungNgay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static bool cungThang(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  static bool truoc(DateTime a, DateTime b) => cat(a).isBefore(cat(b));

  static bool sau(DateTime a, DateTime b) => cat(a).isAfter(cat(b));

  /// Sửa / tick / xóa lịch khi selectedDate ∈ [hôm nay − 6, +∞).
  static const cuaSoLui = 6;

  static bool ghiDuoc(DateTime ngay, DateTime homNay) {
    final d = cat(ngay);
    final h = cat(homNay);
    return !d.isBefore(h.subtract(const Duration(days: cuaSoLui)));
  }

  static int soNgayThang(int nam, int thang) =>
      DateTime(nam, thang + 1, 0).day;

  static DateTime dauThang(DateTime d) => DateTime(d.year, d.month, 1);

  static DateTime luiThang(DateTime d) => DateTime(d.year, d.month - 1, 1);

  static DateTime toiThang(DateTime d) => DateTime(d.year, d.month + 1, 1);

  /// Cộng tháng lịch, kẹp ngày cuối tháng (31/1 → 28/29/2, 31/3 → 30/4).
  static DateTime congThang(DateTime d, int n) {
    final x = cat(d);
    var y = x.year;
    var m = x.month + n;
    while (m > 12) {
      m -= 12;
      y++;
    }
    while (m < 1) {
      m += 12;
      y--;
    }
    final last = soNgayThang(y, m);
    final day = x.day > last ? last : x.day;
    return DateTime(y, m, day);
  }

  /// End inclusive. 0 tuần +6, 1 tháng +1, 2 +6 tháng, 3 +12 tháng.
  static DateTime cuoiKhoang(DateTime tu, int phin) {
    final a = cat(tu);
    switch (phin) {
      case 1:
        return congThang(a, 1);
      case 2:
        return congThang(a, 6);
      case 3:
        return congThang(a, 12);
      default:
        return a.add(const Duration(days: 6));
    }
  }

  /// Cuối kỳ inclusive theo lịch thật (tháng 28–31).
  /// 0 ngày; 1 tuần = tu+6; 2 tháng = cuối tháng; 3 = cuối tháng+5; 4 = cuối tháng+11.
  static DateTime cuoiKy(DateTime tu, int phin) {
    final a = cat(tu);
    switch (phin) {
      case 0:
        return a;
      case 1:
        return a.add(const Duration(days: 6));
      case 2:
        return DateTime(a.year, a.month, soNgayThang(a.year, a.month));
      case 3:
        final c = congThang(dauThang(a), 5);
        return DateTime(c.year, c.month, soNgayThang(c.year, c.month));
      case 4:
        final c = congThang(dauThang(a), 11);
        return DateTime(c.year, c.month, soNgayThang(c.year, c.month));
      default:
        return a.add(const Duration(days: 6));
    }
  }

  static DateTime dauKyHomNay(DateTime hom, int phin) {
    final h = cat(hom);
    switch (phin) {
      case 0:
        return h;
      case 1:
        return thuHai(h);
      case 2:
        return dauThang(h);
      case 3:
        return dauThang(congThang(h, -5));
      case 4:
        return DateTime(h.year, 1, 1);
      default:
        return thuHai(h);
    }
  }

  static DateTime snapTu(DateTime d, int phin) {
    if (phin <= 1) return cat(d);
    return dauThang(d);
  }

  /// Mốc trục: ngày/tuần = ngày; tháng = thứ Hai tuần; 6 tháng/năm = mùng 1.
  static List<DateTime> mocKy(DateTime tu, DateTime den, int phin) {
    final a = cat(tu);
    final b = cat(den);
    if (phin <= 1) return cacNgayKhoang(a, b);
    if (phin == 2) {
      var t = thuHai(a);
      final out = <DateTime>[];
      while (!t.isAfter(b)) {
        out.add(t);
        t = t.add(const Duration(days: 7));
      }
      return out;
    }
    var m = dauThang(a);
    final out = <DateTime>[];
    while (!m.isAfter(b)) {
      out.add(m);
      m = congThang(m, 1);
    }
    return out;
  }

  static (DateTime, DateTime) bienMoc(
    DateTime moc,
    int phin,
    DateTime tu,
    DateTime den,
  ) {
    final a0 = cat(tu);
    final b0 = cat(den);
    final m = cat(moc);
    if (phin <= 1) {
      final x = m.isBefore(a0) ? a0 : (m.isAfter(b0) ? b0 : m);
      return (x, x);
    }
    if (phin == 2) {
      final a = m.isBefore(a0) ? a0 : m;
      final cuoi = m.add(const Duration(days: 6));
      return (a, cuoi.isAfter(b0) ? b0 : cuoi);
    }
    final a = m.isBefore(a0) ? a0 : m;
    final last = DateTime(m.year, m.month, soNgayThang(m.year, m.month));
    return (a, last.isAfter(b0) ? b0 : last);
  }

  static List<DateTime> cacNgayKhoang(DateTime a, DateTime b) {
    final out = <DateTime>[];
    var d = cat(a);
    final end = cat(b);
    while (!d.isAfter(end)) {
      out.add(d);
      d = d.add(const Duration(days: 1));
    }
    return out;
  }

  static List<DateTime> cacNgayThang(DateTime d) {
    final n = soNgayThang(d.year, d.month);
    return List<DateTime>.generate(n, (i) => DateTime(d.year, d.month, i + 1));
  }

  /// Liên tiếp, kết thúc hôm nay nếu đã tick hôm nay, không thì hôm qua.
  static int chuoiLienTiep(Set<String> ticks, DateTime homNay) {
    var d = cat(homNay);
    if (!ticks.contains(iso(d))) {
      d = d.subtract(const Duration(days: 1));
    }
    if (!ticks.contains(iso(d))) return 0;
    var n = 0;
    while (ticks.contains(iso(d))) {
      n++;
      d = d.subtract(const Duration(days: 1));
    }
    return n;
  }
}
