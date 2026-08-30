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

  test('kcal tap 0.0175 MET kg phut, thieu can thi khong tinh', () {
    expect(CongThuc.kcalTap(met: 5.5, kg: 65, phut: 30), closeTo(0.0175 * 5.5 * 65 * 30, 0.01));
    expect(CongThuc.kcalTap(met: 5.5, kg: null, phut: 30), isNull);
  });

  test('nhip 0,25-0,5 kg/tuan', () {
    expect(CongThuc.nhip(70, 70), 'Đã đạt cân đích.');
    expect(CongThuc.nhip(72, 70), contains('giảm 0,25–0,5'));
    expect(CongThuc.nhip(null, 70), isNull);
  });

  test('he so dau phay Viet', () {
    expect(So.heSo(1.2), '1,2');
    expect(So.heSo(1.375), '1,375');
    expect(So.heSo(1.9), '1,9');
  });
}
