import 'package:flutter_test/flutter_test.dart';
import 'package:thoi_quen/thu.dart';

void main() {
  test('thu hop ISO, rong = tat ca', () {
    expect(Thu.hop('1', DateTime(2026, 8, 24)), isTrue);
    expect(Thu.hop('1', DateTime(2026, 8, 30)), isFalse);
    expect(Thu.hop('', DateTime(2026, 8, 30)), isTrue);
    expect(Thu.goi({2, 4, 6}), '246');
  });

  test('hien tu createdOn, dung thu', () {
    final tao = DateTime(2026, 8, 31);
    const bit = '1234'; // T2–T5
    expect(Thu.hien(thuBit: bit, createdOn: tao, d: DateTime(2026, 8, 31)), isTrue);
    expect(Thu.hien(thuBit: bit, createdOn: tao, d: DateTime(2026, 9, 1)), isTrue);
    expect(Thu.hien(thuBit: bit, createdOn: tao, d: DateTime(2026, 9, 3)), isTrue);
    expect(Thu.hien(thuBit: bit, createdOn: tao, d: DateTime(2026, 8, 28)), isFalse);
    expect(Thu.hien(thuBit: bit, createdOn: tao, d: DateTime(2026, 8, 29)), isFalse);
    expect(Thu.hien(thuBit: bit, createdOn: tao, d: DateTime(2026, 9, 2)), isTrue);
    expect(Thu.hien(thuBit: bit, createdOn: tao, d: DateTime(2026, 9, 4)), isFalse);
  });
}
