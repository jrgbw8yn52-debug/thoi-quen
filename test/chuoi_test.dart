import 'package:flutter_test/flutter_test.dart';
import 'package:thoi_quen/chuoi.dart';
import 'package:thoi_quen/so.dart';

void main() {
  test('chuoi UI dung tieng Viet', () {
    expect(Chuoi.homNay, 'Hôm nay');
    expect(Chuoi.xong, 'Xong');
    expect(Chuoi.caiDat, 'Cài đặt');
    expect(Chuoi.thoiQuen, 'Thói quen');
    expect(Chuoi.mucTieu, 'Mục tiêu');
    expect(Chuoi.chuoiNgay, 'Chuỗi');
    expect(Chuoi.nTrenMHomNay(1, 3), '1/3 hôm nay');
    expect(Chuoi.xTrenNThangNay(4, 25), '4/25 tháng này');
    expect(Chuoi.themCan, 'Thêm cân');
    expect(Chuoi.uocTinh, contains('không thay lời bác sĩ'));
    expect(Chuoi.saiSo, 'sai số ±200–400');
    expect(Chuoi.mocA, 'Mốc Á 18,5 / 23 / 27,5');
  });

  test('so kg dau phay Viet, khong bia', () {
    expect(So.kg(70), '70');
    expect(So.kg(70.5), '70,5');
    expect(So.parseKg('70,5'), 70.5);
    expect(So.parseKg(''), isNull);
    expect(So.parseKg('abc'), isNull);
    expect(So.parseKg('0'), isNull);
  });
}
