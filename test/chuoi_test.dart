import 'package:flutter_test/flutter_test.dart';
import 'package:thoi_quen/chuoi.dart';
import 'package:thoi_quen/so.dart';

void main() {
  test('chuoi UI dung tieng Viet', () {
    expect(Chuoi.homNay, 'Hôm nay');
    expect(Chuoi.xong, 'Xong');
    expect(Chuoi.caiDat, 'Cài đặt');
    expect(Chuoi.thoiQuen, 'Thói quen');
    expect(Chuoi.tenApp, 'Habis');
    expect(Chuoi.habisNhan, 'HABIS');
    expect(Chuoi.chaoSang, 'Chào buổi sáng!');
    expect(Chuoi.chaoChieu, 'Chào buổi chiều!');
    expect(Chuoi.chaoToi, 'Chào buổi tối!');
    expect(Chuoi.chaoDem, 'Chào đêm muộn!');
    expect(Chuoi.totHonHomQua, 'Hôm nay, bạn sẽ tốt hơn hôm qua.');
    expect(Chuoi.chuoiHienTai, 'STREAK HIỆN TẠI');
    expect(Chuoi.ngayDonVi, 'ngày');
    expect(Chuoi.chaoTheoGio(DateTime(2026, 8, 30, 5)), Chuoi.chaoSang);
    expect(Chuoi.chaoTheoGio(DateTime(2026, 8, 30, 10, 59)), Chuoi.chaoSang);
    expect(Chuoi.chaoTheoGio(DateTime(2026, 8, 30, 11)), Chuoi.chaoChieu);
    expect(Chuoi.chaoTheoGio(DateTime(2026, 8, 30, 13)), Chuoi.chaoChieu);
    expect(Chuoi.chaoTheoGio(DateTime(2026, 8, 30, 17)), Chuoi.chaoToi);
    expect(Chuoi.chaoTheoGio(DateTime(2026, 8, 30, 20, 59)), Chuoi.chaoToi);
    expect(Chuoi.chaoTheoGio(DateTime(2026, 8, 30, 21)), Chuoi.chaoDem);
    expect(Chuoi.chaoTheoGio(DateTime(2026, 8, 30, 4, 59)), Chuoi.chaoDem);
    expect(Chuoi.timMon, 'Tìm món');
    expect(Chuoi.kcalConLai, 'kcal còn lại');
    expect(Chuoi.kcalVuot, 'kcal vượt');
    expect(Chuoi.thieuChieuCao, 'Thiếu chiều cao');
    expect(Chuoi.tatPinNhac, 'Tắt tiết kiệm pin cho Habis nếu nhắc không kêu');
    expect(Chuoi.mucTieu, 'Mục tiêu');
    expect(Chuoi.chuoiNgay, 'Chuỗi');
    expect(Chuoi.nTrenMHomNay(1, 3), '1/3 hôm nay');
    expect(Chuoi.xTrenNThangNay(4, 25), '4/25 tháng này');
    expect(Chuoi.themCan, 'Thêm cân');
    expect(Chuoi.uocTinh, contains('không thay lời bác sĩ'));
    expect(Chuoi.saiSo, 'sai số ±200–400');
    expect(Chuoi.mocA, 'Mốc Á 18,5 / 23 / 27,5');
    expect(Chuoi.widNgay(DateTime(2026, 9, 2)), 'Thứ Tư 2/9');
    expect(Chuoi.widHabit(3, 5), '3/5 thói quen');
    expect(Chuoi.widKcal(969, 2920), '969 / 2920 kcal');
  });

  test('so kg dau phay Viet, khong bia', () {
    expect(So.kg(70), '70');
    expect(So.kg(70.5), '70,5');
    expect(So.parseKg('70,5'), 70.5);
    expect(So.parseKg(''), isNull);
    expect(So.parseKg('abc'), isNull);
    expect(So.parseKg('0'), isNull);
  });

  test('danh gia nguong khoa', () {
    expect(Chuoi.danhGia(12, 30), Chuoi.te);
    expect(Chuoi.danhGia(55, 67), Chuoi.tot);
    expect(Chuoi.danhGia(9, 10), Chuoi.xuatSac);
    expect(Chuoi.danhGia(5, 10), Chuoi.kha);
    expect(Chuoi.danhGia(4, 10), Chuoi.te);
    expect(Chuoi.hoanThanhThoiQuen(1, 3), 'Hoàn thành 1/3 thói quen');
    expect(Chuoi.thayToanBo, 'Thay toàn bộ dữ liệu trên máy này. Không gộp.');
    expect(Chuoi.xoaHetMay, 'Xoá hết dữ liệu trên máy này? Không lấy lại được.');
  });
}
