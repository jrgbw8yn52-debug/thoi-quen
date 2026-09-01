/// Buổi ăn: Sáng | Trưa | Chiều | Tối.
abstract final class Khung {
  static const sang = 'sang';
  static const trua = 'trua';
  static const chieu = 'chieu';
  static const toi = 'toi';
  static const ds = [sang, trua, chieu, toi];

  static String theoGio(DateTime t) {
    final h = t.hour;
    if (h < 11) return sang;
    if (h < 14) return trua;
    if (h < 17) return chieu;
    return toi;
  }

  static String chuan(String? k) {
    if (k == sang || k == trua || k == chieu || k == toi) return k!;
    return sang;
  }
}
