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

  static double? parseEo(String raw) {
    final t = raw.trim().replaceAll(' ', '').replaceAll(',', '.');
    if (t.isEmpty) return null;
    final v = double.tryParse(t);
    if (v == null || v < 40 || v > 200) return null;
    return v;
  }

  static double? parseMo(String raw) {
    final t = raw.trim().replaceAll(' ', '').replaceAll(',', '.');
    if (t.isEmpty) return null;
    final v = double.tryParse(t);
    if (v == null || v < 1 || v > 70) return null;
    return v;
  }

  static int? parseKcal(String raw) {
    final t = raw.trim().replaceAll(' ', '');
    if (t.isEmpty) return null;
    final v = int.tryParse(t);
    if (v == null || v < 1 || v > 20000) return null;
    return v;
  }

  static double? parseG(String raw) {
    final t = raw.trim().replaceAll(' ', '').replaceAll(',', '.');
    if (t.isEmpty) return null;
    final v = double.tryParse(t);
    if (v == null || v <= 0 || v > 5000) return null;
    return v;
  }

  static String heSo(double v) {
    final s = v.toString();
    return s.replaceAll('.', ',');
  }
}
