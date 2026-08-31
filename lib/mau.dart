import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Cam–đen. Không neon, không tím, không vàng gold, không AEGIS.
/// Lửa #ffb020 — không dùng cam nút cho lửa.
abstract final class Mau {
  static const giay = Color(0xFF100E0C);
  static const beMat = Color(0xFF1C1713);
  static const muc = Color(0xFFF3ECE4);
  static const mo = Color(0xFFC4B6A8);
  static const reu = Color(0xFFE85D04);
  static const today = Color(0xFFFF7A2F);
  static const lua = Color(0xFFFFB020);
  static const canhBao = Color(0xFFD94A38);
  static const vien = Color(0xFF3A322C);
  static const chipBat = Color(0xFF2A1C14);

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
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: muc,
          side: const BorderSide(color: vien),
          minimumSize: const Size(44, 44),
        ),
      ),
      dialogTheme: const DialogThemeData(backgroundColor: beMat),
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: beMat),
    );
  }
}
