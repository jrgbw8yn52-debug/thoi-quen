import 'package:flutter_test/flutter_test.dart';
import 'package:thoi_quen/thu.dart';

void main() {
  test('thu hop ISO, rong = tat ca', () {
    expect(Thu.hop('1', DateTime(2026, 8, 24)), isTrue);
    expect(Thu.hop('1', DateTime(2026, 8, 30)), isFalse);
    expect(Thu.hop('', DateTime(2026, 8, 30)), isTrue);
    expect(Thu.goi({2, 4, 6}), '246');
  });
}
