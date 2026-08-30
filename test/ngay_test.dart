import 'package:flutter_test/flutter_test.dart';
import 'package:thoi_quen/chuoi.dart';
import 'package:thoi_quen/ngay.dart';
import 'package:thoi_quen/ten.dart';

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

  test('ghiDuoc: hom nay va 7 ngay truoc, khoa ngay thu 8', () {
    final hom = DateTime(2026, 8, 30);
    expect(Ngay.ghiDuoc(hom, hom), isTrue);
    expect(Ngay.ghiDuoc(DateTime(2026, 8, 23), hom), isTrue);
    expect(Ngay.ghiDuoc(DateTime(2026, 8, 22), hom), isFalse);
    expect(Ngay.ghiDuoc(DateTime(2026, 8, 31), hom), isFalse);
    expect(Ngay.ghiDuoc(DateTime(2026, 7, 15), hom), isFalse);
  });

  test('so ngay thang', () {
    expect(Ngay.soNgayThang(2026, 8), 31);
    expect(Ngay.soNgayThang(2026, 2), 28);
    expect(Ngay.cacNgayThang(DateTime(2026, 8, 15)).length, 31);
  });

  test('chuoi lien tiep: hom nay chua tick thi dem tu hom qua', () {
    final ticks = {'2026-08-28', '2026-08-29'};
    expect(Ngay.chuoiLienTiep(ticks, DateTime(2026, 8, 30)), 2);
    expect(Ngay.chuoiLienTiep({...ticks, '2026-08-30'}, DateTime(2026, 8, 30)), 3);
    expect(Ngay.chuoiLienTiep({'2026-08-27'}, DateTime(2026, 8, 30)), 0);
  });

  test('ten khoa: mot ten = mot hang', () {
    expect(Ten.trung('Dậy 6 giờ', ' dậy 6 giờ '), isTrue);
    expect(Ten.trung('Dậy 6 giờ', 'Vận động'), isFalse);
  });

  test('con k dat N tieng Viet', () {
    expect(Chuoi.chuoiNNgay(4), 'Chuỗi 4 ngày');
    expect(Chuoi.conKDatN(13, 25), 'Còn 13 ngày nữa là đạt 25');
    expect(Chuoi.conKDatN(0, 25), 'Đã đạt 25');
    expect(Chuoi.nNgayTrongThang(25), '25 ngày trong tháng này');
    expect(Chuoi.xoaKhoiMay, 'Xoá khỏi máy này? Không lấy lại được.');
  });
}
