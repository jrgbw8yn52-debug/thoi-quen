import 'package:flutter/services.dart';

/// Widget Android Cam 4×2 + Đêm 2×2. iOS / test: nuốt lỗi thiếu plugin.
abstract final class WidHome {
  static const _ch = MethodChannel('habis/widget');

  static Future<void> capNhat({
    required String ngay,
    required String habit,
    required String kcal,
    required int lua,
    required String habitNm,
    required String kcalNgan,
  }) async {
    try {
      await _ch.invokeMethod<void>('capNhat', {
        'ngay': ngay,
        'habit': habit,
        'kcal': kcal,
        'lua': lua,
        'habitNm': habitNm,
        'kcalNgan': kcalNgan,
      });
    } catch (_) {}
  }
}
