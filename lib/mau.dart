import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Nền tối + thép + rêu. Không neon, không tím, không vàng gold, không AEGIS.
abstract final class Mau {
  static const giay = Color(0xFF0C0D0B);
  static const beMat = Color(0xFF161714);
  static const muc = Color(0xFFE7E4DC);
  static const mo = Color(0xFFB9C0B8);
  static const reu = Color(0xFF3D9A7A);
  static const canhBao = Color(0xFFC45C4A);
  static const vien = Color(0xFF2E322F);
  static const chipBat = Color(0xFF1E2C26);

  static ThemeData theme() {
    const scheme = ColorScheme.dark(
      surface: giay,
      onSurface: muc,
      primary: reu,
      onPrimary: giay,
      secondary: mo,
      onSecondary: giay,
      outline: vien,
      error: canhBao,
    );
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: giay,
      splashFactory: InkSparkle.splashFactory,
      cupertinoOverrideTheme: const CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: reu,
        scaffoldBackgroundColor: beMat,
      ),
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(bodyColor: muc, displayColor: muc),
      iconTheme: const IconThemeData(color: mo),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: beMat,
        indicatorColor: chipBat,
        elevation: 0,
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStatePropertyAll(IconThemeData(color: mo)),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: beMat,
        hintStyle: TextStyle(color: mo),
        suffixStyle: TextStyle(color: mo),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: vien),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: reu),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: reu,
          foregroundColor: giay,
          minimumSize: const Size(44, 44),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: reu,
          minimumSize: const Size(44, 44),
        ),
      ),
      dialogTheme: const DialogThemeData(backgroundColor: beMat),
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: beMat),
    );
  }
}
