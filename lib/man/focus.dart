import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../kho.dart';
import '../mau.dart';

class ManFocus extends StatelessWidget {
  const ManFocus({super.key, required this.kho});

  final Kho kho;

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text(
          Chuoi.focus,
          key: Key('man-focus'),
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.4,
            color: Mau.muc,
          ),
        ),
      ),
    );
  }
}
