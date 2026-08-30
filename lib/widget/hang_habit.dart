import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../chuoi.dart';
import '../kho.dart';
import '../mau.dart';

class HangHabit extends StatelessWidget {
  const HangHabit({
    super.key,
    required this.hang,
    required this.onTap,
    required this.onChiTiet,
    this.khoaGhi = false,
  });

  final HangHabitView hang;
  final VoidCallback onTap;
  final VoidCallback onChiTiet;
  final bool khoaGhi;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Mau.beMat,
      child: InkWell(
        onTap: khoaGhi
            ? null
            : () {
                HapticFeedback.selectionClick();
                onTap();
              },
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                _NutTick(bat: hang.ticked, mo: khoaGhi),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    hang.habit.ten,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      color: Mau.muc,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  Chuoi.xTrenNThangNay(hang.xThang, hang.habit.mucTieuThang),
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.2,
                    color: Mau.mo,
                  ),
                ),
                SizedBox(
                  width: 44,
                  height: 56,
                  child: IconButton(
                    key: Key('chi-tiet-${hang.habit.id}'),
                    padding: EdgeInsets.zero,
                    tooltip: Chuoi.thoiQuen,
                    onPressed: onChiTiet,
                    icon: const Icon(Icons.chevron_right, color: Mau.mo),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NutTick extends StatelessWidget {
  const _NutTick({required this.bat, this.mo = false});

  final bool bat;
  final bool mo;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bat ? (mo ? Mau.reu.withValues(alpha: 0.45) : Mau.reu) : Colors.transparent,
        border: Border.all(
          color: bat ? Mau.reu : (mo ? Mau.vien : Mau.muc),
          width: 1.6,
        ),
      ),
      child: bat
          ? const Icon(Icons.check, size: 14, color: Mau.giay)
          : null,
    );
  }
}
