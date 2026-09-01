import 'package:flutter/material.dart';

/// Mark Habis từ ảnh đính (assets/habis_mark.png). Không vẽ lại.
class NhanHabis extends StatelessWidget {
  const NhanHabis({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/habis_mark.png',
      width: size,
      height: size,
      filterQuality: FilterQuality.high,
      gaplessPlayback: true,
    );
  }
}
