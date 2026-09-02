import 'package:flutter/services.dart';

/// Widget 4×2 Android. iOS / test: nuốt lỗi thiếu plugin.
abstract final class WidHome {
  static const _ch = MethodChannel('habis/widget');

  static Future<void> capNhat({
    required String ngay,
    required String habit,
    required String kcal,
    required int lua,
  }) async {
    try {
      await _ch.invokeMethod<void>('capNhat', {
        'ngay': ngay,
        'habit': habit,
        'kcal': kcal,
        'lua': lua,
      });
    } catch (_) {}
  }
}
