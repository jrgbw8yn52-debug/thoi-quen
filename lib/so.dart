abstract final class So {
  /// 70 → "70", 70.5 → "70,5"
  static String kg(double v) {
    final r = (v * 10).round() / 10.0;
    if (r == r.roundToDouble()) return r.toInt().toString();
    return r.toStringAsFixed(1).replaceAll('.', ',');
  }

  /// Nhận "70,5" hoặc "70.5". Sai / ≤0 / >400 → null. Không bịa.
  static double? parseKg(String raw) {
    final t = raw.trim().replaceAll(' ', '').replaceAll(',', '.');
    if (t.isEmpty) return null;
    final v = double.tryParse(t);
    if (v == null || v <= 0 || v > 400) return null;
    return v;
  }

  static double? parseCm(String raw) {
    final t = raw.trim().replaceAll(' ', '').replaceAll(',', '.');
    if (t.isEmpty) return null;
    final v = double.tryParse(t);
    if (v == null || v < 50 || v > 250) return null;
    return v;
  }

  static String heSo(double v) {
    var s = v.toStringAsFixed(3).replaceAll('.', ',');
    while (s.endsWith('0')) {
      s = s.substring(0, s.length - 1);
    }
    if (s.endsWith(',')) s = s.substring(0, s.length - 1);
    return s;
  }
}
