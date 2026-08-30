import 'package:flutter_test/flutter_test.dart';
import 'package:thoi_quen/cong_thuc.dart';
import 'package:thoi_quen/so.dart';

void main() {
  test('Mifflin nam +5 nu -161, khong persist', () {
    const kg = 65.0;
    const cm = 170.0;
    const tuoi = 30;
    final nam = CongThuc.bmr(sex: 'nam', kg: kg, cm: cm, tuoi: tuoi)!;
    final nu = CongThuc.bmr(sex: 'nu', kg: kg, cm: cm, tuoi: tuoi)!;
    expect(nam, closeTo(10 * kg + 6.25 * cm - 5 * tuoi + 5, 0.01));
    expect(nu, closeTo(10 * kg + 6.25 * cm - 5 * tuoi - 161, 0.01));
    expect(CongThuc.tdee(nam, 1.2), closeTo(nam * 1.2, 0.01));
  });

  test('thieu du lieu khong bia 70 kg', () {
    expect(CongThuc.bmi(null, 170), isNull);
    expect(CongThuc.bmi(65, null), isNull);
    expect(CongThuc.bmr(sex: 'nam', kg: null, cm: 170, tuoi: 30), isNull);
    expect(CongThuc.bmr(sex: null, kg: 65, cm: 170, tuoi: 30), isNull);
    expect(CongThuc.bmr(sex: 'nam', kg: 65, cm: 170, tuoi: null), isNull);
  });

  test('BMI nhãn Á', () {
    expect(CongThuc.bmiNhan(18.4), 'thiếu');
    expect(CongThuc.bmiNhan(18.5), 'bình thường');
    expect(CongThuc.bmiNhan(22.9), 'bình thường');
    expect(CongThuc.bmiNhan(23), 'thừa');
    expect(CongThuc.bmiNhan(27.4), 'thừa');
    expect(CongThuc.bmiNhan(27.5), 'béo');
    expect(CongThuc.bmiNhan(null), isNull);
  });

  test('Deurenberg BMI tuoi gioi, khong persist', () {
    expect(
      CongThuc.moDeurenberg(bmi: 22, tuoi: 30, sex: 'nam'),
      closeTo(1.20 * 22 + 0.23 * 30 - 10.8 - 5.4, 0.01),
    );
    expect(
      CongThuc.moDeurenberg(bmi: 22, tuoi: 30, sex: 'nu'),
      closeTo(1.20 * 22 + 0.23 * 30 - 5.4, 0.01),
    );
    expect(CongThuc.moDeurenberg(bmi: null, tuoi: 30, sex: 'nam'), isNull);
  });

  test('MET 5 mon', () {
    expect(CongThuc.metCua(CongThuc.loaiDiBo), 3.5);
    expect(CongThuc.metCua(CongThuc.loaiChay), 8);
    expect(CongThuc.metCua(CongThuc.loaiDapXe), 6.8);
    expect(CongThuc.metCua(CongThuc.loaiKhangLuc), 5);
    expect(CongThuc.metCua(CongThuc.loaiYoga), 3);
  });

  test('nhip hop le 0-1 buoc 0,1', () {
    expect(CongThuc.nhipHopLe(0.5), isTrue);
    expect(CongThuc.nhipHopLe(0), isTrue);
    expect(CongThuc.nhipHopLe(1), isTrue);
    expect(CongThuc.nhipHopLe(0.3), isTrue);
    expect(CongThuc.nhipHopLe(1.1), isFalse);
  });

  test('nhip 0,25 hoac 0,5 kg/tuan', () {
    expect(CongThuc.nhipDong(70, 70, 0.5), 'Đã đạt cân đích.');
    expect(CongThuc.nhipDong(72, 70, 0.5), contains('giảm 0,5'));
    expect(CongThuc.nhipDong(null, 70, 0.5), isNull);
  });

  test('kcal goi y TDEE tru nhip, lam tron 10', () {
    expect(CongThuc.kcalGoiY(tdee: 2000, nhip: 0.5, kg: 72, target: 70), 1450);
    expect(CongThuc.kcalGoiY(tdee: null, nhip: 0.5), isNull);
  });

  test('he so dau phay Viet', () {
    expect(So.heSo(1.2), '1,2');
    expect(So.heSo(1.375), '1,375');
    expect(So.heSo(1.9), '1,9');
  });
}
