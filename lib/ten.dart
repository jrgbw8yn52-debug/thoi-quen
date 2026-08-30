abstract final class Ten {
  static String sach(String raw) =>
      raw.trim().replaceAll(RegExp(r'\s+'), ' ');

  static String khoa(String raw) => sach(raw).toLowerCase();

  static bool trung(String a, String b) => khoa(a) == khoa(b);
}
