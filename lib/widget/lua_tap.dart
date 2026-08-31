import 'package:flutter/material.dart';

import '../cong_thuc.dart';
import '../mau.dart';

class LuaTapHien extends StatelessWidget {
  const LuaTapHien({
    super.key,
    required this.lua,
    this.to = false,
    this.onTap,
  });

  final LuaTap lua;
  final bool to;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final mau = lua.sang ? Mau.lua : Mau.mo;
    final icon = to ? 28.0 : 22.0;
    final chu = to ? 20.0 : 16.0;
    final nut = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44, minWidth: 44),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.local_fire_department, color: mau, size: icon),
                const SizedBox(width: 4),
                Text(
                  '${lua.so}',
                  style: TextStyle(
                    fontSize: chu,
                    fontWeight: FontWeight.w700,
                    color: mau,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return nut;
  }
}
