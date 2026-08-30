import 'package:flutter/material.dart';

import '../mau.dart';

class ChipCan extends StatelessWidget {
  const ChipCan({super.key, required this.chu, required this.onTap});

  final String chu;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: Mau.beMat,
        shape: const StadiumBorder(
          side: BorderSide(color: Mau.vien),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                chu,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Mau.muc,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
