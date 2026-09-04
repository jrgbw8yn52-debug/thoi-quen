import 'package:flutter/services.dart';

/// Widget Android Cam 4×2 + Đêm 2×2. iOS / test: nuốt lỗi thiếu plugin.
abstract final class WidHome {
  static const _ch = MethodChannel('habis/widget');
  static const maxO = 3;

  static void langNghe(Future<void> Function(int id) tick) {
    _ch.setMethodCallHandler((c) async {
      if (c.method != 'tickWid') return;
      final a = c.arguments;
      final id = a is int ? a : (a is num ? a.toInt() : int.tryParse('$a'));
      if (id != null) await tick(id);
    });
  }

  static Future<void> capNhat({
    required String ngay,
    required String habit,
    required String kcal,
    required int lua,
    required String habitNm,
    required String kcalNgan,
    required int n,
    required int m,
    required List<Map<String, Object?>> hang,
  }) async {
    try {
      await _ch.invokeMethod<void>('capNhat', {
        'ngay': ngay,
        'habit': habit,
        'kcal': kcal,
        'lua': lua,
        'habitNm': habitNm,
        'kcalNgan': kcalNgan,
        'n': n,
        'm': m,
        'hang': hang,
      });
    } catch (_) {}
  }
}
