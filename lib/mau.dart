import 'package:flutter/material.dart';

/// Giấy + mực + rêu. Không neon, không tím, không vàng, không AEGIS.
abstract final class Mau {
  static const giay = Color(0xFFF3EFE7);
  static const beMat = Color(0xFFFAF7F1);
  static const muc = Color(0xFF1A1714);
  static const mo = Color(0xFF6F6A63);
  static const reu = Color(0xFF2F6F56);
  static const vien = Color(0xFFD9D2C6);

  static ThemeData theme() {
    const scheme = ColorScheme.light(
      surface: giay,
      onSurface: muc,
      primary: reu,
      onPrimary: giay,
      secondary: muc,
      onSecondary: giay,
      outline: vien,
      error: Color(0xFF8A4B3B),
    );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: giay,
      splashFactory: InkSparkle.splashFactory,
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: muc,
        displayColor: muc,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: beMat,
        indicatorColor: Color(0xFFDCE8E2),
        elevation: 0,
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }
}
