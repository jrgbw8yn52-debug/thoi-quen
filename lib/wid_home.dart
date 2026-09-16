import 'package:flutter/services.dart';

/// Widget Android: Cam · Đêm · Lịch. iOS / test: nuốt lỗi thiếu plugin.
abstract final class WidHome {
  static const _ch = MethodChannel('habis/widget');
  static const maxO = 2;
  static const maxFocus = 2;

  static void langNghe({
    required Future<void> Function(int id) tick,
    required Future<void> Function(int id) tickFocus,
    void Function(int tab)? moTab,
  }) {
    _ch.setMethodCallHandler((c) async {
      if (c.method == 'moTab') {
        final a = c.arguments;
        final tab = a is int ? a : (a is num ? a.toInt() : int.tryParse('$a'));
        if (tab != null) moTab?.call(tab);
        return;
      }
      final a = c.arguments;
      final id = a is int ? a : (a is num ? a.toInt() : int.tryParse('$a'));
      if (id == null) return;
      if (c.method == 'tickWid') await tick(id);
      if (c.method == 'tickFocus') await tickFocus(id);
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
    required List<Map<String, Object?>> focus,
    String? hetViec,
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
        'focus': focus,
        'hetViec': ?hetViec,
      });
    } catch (_) {}
  }
}
