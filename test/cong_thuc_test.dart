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

  test('BMI mốc Á 23 / 27,5', () {
    final bmi = CongThuc.bmi(65, 170)!;
    expect(bmi, closeTo(65 / (1.7 * 1.7), 0.01));
    expect(bmi < CongThuc.mocA275, isTrue);
    expect(CongThuc.mocA23, 23);
    expect(CongThuc.mocA275, 27.5);
  });

  test('he so dau phay Viet', () {
    expect(So.heSo(1.2), '1,2');
    expect(So.heSo(1.375), '1,375');
    expect(So.heSo(1.9), '1,9');
  });
}
