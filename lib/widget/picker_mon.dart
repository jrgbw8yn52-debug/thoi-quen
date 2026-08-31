import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../cong_thuc.dart';
import '../mau.dart';

Future<String?> moPickerMon(BuildContext context, String hien) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Mau.beMat,
    builder: (ctx) {
      return SafeArea(
        child: ListView(
          key: const Key('ds-mon-tap'),
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
          children: [
            for (final m in CongThuc.mon)
              Material(
                color: m.loai == hien ? Mau.chipBat : Colors.transparent,
                child: InkWell(
                  key: Key('chon-mon-${m.loai}'),
                  onTap: () => Navigator.pop(ctx, m.loai),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 44),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          Chuoi.tenMon(m.loai),
                          style: const TextStyle(fontSize: 16, color: Mau.muc),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}

class HangPickerMon extends StatelessWidget {
  const HangPickerMon({
    super.key,
    required this.loai,
    this.onChon,
  });

  final String loai;
  final ValueChanged<String>? onChon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Mau.beMat,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        key: const Key('mon-picker'),
        onTap: onChon == null
            ? null
            : () async {
                final v = await moPickerMon(context, loai);
                if (v != null) onChon!(v);
              },
        borderRadius: BorderRadius.circular(12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    Chuoi.tenMon(loai),
                    style: const TextStyle(fontSize: 16, color: Mau.muc),
                  ),
                ),
                const Icon(Icons.expand_more, color: Mau.mo),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NutBuocPhut extends StatelessWidget {
  const NutBuocPhut({super.key, required this.chu, this.onTap});

  final String chu;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: Mau.muc,
          side: const BorderSide(color: Mau.vien),
          padding: EdgeInsets.zero,
        ),
        child: Text(chu, style: const TextStyle(fontSize: 22)),
      ),
    );
  }
}
