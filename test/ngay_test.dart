import 'package:flutter_test/flutter_test.dart';
import 'package:thoi_quen/chuoi.dart';
import 'package:thoi_quen/ngay.dart';

void main() {
  test('iso cat gio', () {
    final d = DateTime(2026, 8, 30, 19, 7, 12);
    expect(Ngay.iso(d), '2026-08-30');
    expect(Ngay.cat(d), DateTime(2026, 8, 30));
  });

  test('tuan bat dau thu hai — chu nhat 30/8/2026', () {
    final cn = DateTime(2026, 8, 30);
    expect(Ngay.thuHai(cn), DateTime(2026, 8, 24));
    final t = Ngay.tuan(cn);
    expect(t.length, 7);
    expect(t.first, DateTime(2026, 8, 24));
    expect(t.last, DateTime(2026, 8, 30));
  });

  test('dong ngay tieng Viet, khong phu thuoc locale may', () {
    expect(Chuoi.dongNgay(DateTime(2026, 8, 30)), 'Chủ Nhật, 30 tháng 8');
    expect(Chuoi.dongNgay(DateTime(2026, 8, 24)), 'Thứ Hai, 24 tháng 8');
  });
}
