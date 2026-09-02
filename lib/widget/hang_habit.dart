import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../chuoi.dart';
import '../kho.dart';
import '../mau.dart';

class HangHabit extends StatefulWidget {
  const HangHabit({
    super.key,
    required this.hang,
    required this.onTap,
    required this.onSua,
    required this.onXoa,
    this.khoaGhi = false,
    this.choVuot = true,
  });

  final HangHabitView hang;
  final VoidCallback onTap;
  final VoidCallback onSua;
  final VoidCallback onXoa;
  final bool khoaGhi;
  final bool choVuot;

  @override
  State<HangHabit> createState() => _HangHabitState();
}

class _HangHabitState extends State<HangHabit> {
  late bool _bat;

  @override
  void initState() {
    super.initState();
    _bat = widget.hang.ticked;
  }

  @override
  void didUpdateWidget(covariant HangHabit old) {
    super.didUpdateWidget(old);
    if (old.hang.ticked != widget.hang.ticked) {
      _bat = widget.hang.ticked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return HangVuot(
      choVuot: widget.choVuot && !widget.khoaGhi,
      onSua: widget.onSua,
      onXoa: widget.onXoa,
      child: Material(
        color: Mau.beMat,
        child: InkWell(
          onTap: widget.khoaGhi
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  setState(() => _bat = !_bat);
                  widget.onTap();
                },
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _NutTick(bat: _bat, mo: widget.khoaGhi),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Expanded(
                          child: Text(
                            widget.hang.habit.ten,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                              color: Mau.muc,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Text(
                            widget.hang.habit.gioNhac == null
                                ? ''
                                : Chuoi.gioNhacChu(widget.hang.habit.gioNhac!),
                            maxLines: 1,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                              color: Mau.muc,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HangVuot extends StatefulWidget {
  const HangVuot({
    super.key,
    required this.child,
    this.onSua,
    required this.onXoa,
    this.choVuot = true,
  });

  final Widget child;
  final VoidCallback? onSua;
  final VoidCallback onXoa;
  final bool choVuot;

  @override
  State<HangVuot> createState() => _HangVuotState();
}

class _HangVuotState extends State<HangVuot> {
  double _x = 0;

  double get _rong => widget.onSua == null ? 88.0 : 176.0;

  @override
  Widget build(BuildContext context) {
    if (!widget.choVuot) return widget.child;
    return ClipRect(
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.onSua != null)
                  _Nut(
                    chu: Chuoi.sua,
                    mau: Mau.mo,
                    onTap: widget.onSua!,
                  ),
                _Nut(
                  chu: Chuoi.xoa,
                  mau: Mau.canhBao,
                  onTap: widget.onXoa,
                ),
              ],
            ),
          ),
          GestureDetector(
            onHorizontalDragUpdate: (d) {
              setState(() {
                _x = (_x + d.delta.dx).clamp(-_rong, 0);
              });
            },
            onHorizontalDragEnd: (_) {
              setState(() {
                _x = _x < -_rong / 2 ? -_rong : 0;
              });
            },
            child: Transform.translate(
              offset: Offset(_x, 0),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}

class _Nut extends StatelessWidget {
  const _Nut({required this.chu, required this.mau, required this.onTap});

  final String chu;
  final Color mau;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: mau,
      child: InkWell(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          onTap();
        },
        child: SizedBox(
          width: 88,
          child: Center(
            child: Text(
              chu,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Mau.giay,
              ),
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
