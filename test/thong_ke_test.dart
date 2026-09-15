import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thoi_quen/cong_thuc.dart';
import 'package:thoi_quen/db/database.dart';
import 'package:thoi_quen/kho.dart';
import 'package:thoi_quen/ngay.dart';

void main() {
  test('cuoiKy ngay tuan thang 28-31, 6 thang, nam', () {
    expect(Ngay.cuoiKy(DateTime(2026, 8, 24), 0), DateTime(2026, 8, 24));
    expect(Ngay.cuoiKy(DateTime(2026, 8, 24), 1), DateTime(2026, 8, 30));
    expect(Ngay.cuoiKy(DateTime(2026, 2, 1), 2), DateTime(2026, 2, 28));
    expect(Ngay.cuoiKy(DateTime(2026, 9, 1), 2), DateTime(2026, 9, 30));
    expect(Ngay.cuoiKy(DateTime(2026, 1, 1), 2), DateTime(2026, 1, 31));
    expect(Ngay.cuoiKy(DateTime(2026, 4, 1), 3), DateTime(2026, 9, 30));
    expect(Ngay.cuoiKy(DateTime(2026, 1, 1), 4), DateTime(2026, 12, 31));
  });

  test('Hôm nay = kỳ chứa hôm nay', () {
    final hom = DateTime(2026, 8, 30);
    expect(Ngay.dauKyHomNay(hom, 0), DateTime(2026, 8, 30));
    expect(Ngay.dauKyHomNay(hom, 1), DateTime(2026, 8, 24));
    expect(Ngay.dauKyHomNay(hom, 2), DateTime(2026, 8, 1));
    expect(Ngay.dauKyHomNay(hom, 3), DateTime(2026, 3, 1));
    expect(Ngay.dauKyHomNay(hom, 4), DateTime(2026, 1, 1));
  });

  test('bangKy: TB nạp chỉ ngày có log, Δ cân, không bịa', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final kho = Kho(db, bayGio: DateTime(2026, 8, 30, 13));
    await kho.tai();
    await kho.ghiCanKg(70, ngay: DateTime(2026, 8, 24));
    await kho.ghiCanKg(69, ngay: DateTime(2026, 8, 30));
    await kho.luuMon(ten: 'Phở', kcal: 400, vaoNgay: true);
    kho.chonNgay(DateTime(2026, 8, 25));
    await kho.luuMon(ten: 'Cơm', kcal: 600, vaoNgay: true);
    await kho.ghiTap(CongThuc.loaiDiBo, 30, ngay: DateTime(2026, 8, 24));

    final ky = kho.bangKy(1, DateTime(2026, 8, 24));
    expect(ky.den, DateTime(2026, 8, 30));
    expect(ky.tbNap, 500);
    expect(ky.tbDot, isNotNull);
    expect(ky.deltaCan, closeTo(-1, 0.01));
    expect(ky.thieuCanKy, isFalse);

    final trong = kho.diemCanKy(1, DateTime(2026, 8, 24));
    expect(trong.length, 2);
    expect(kho.diemCanKy(1, DateTime(2026, 8, 10)).isEmpty, isTrue);

    final ngay = kho.bangKy(0, DateTime(2026, 8, 30));
    expect(ngay.den, DateTime(2026, 8, 30));
    expect(ngay.tu, DateTime(2026, 8, 30));
  });
}
