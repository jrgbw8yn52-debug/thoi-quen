import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../db/database.dart';
import '../kho.dart';
import '../mau.dart';

Future<void> moXoaHabit(BuildContext context, Kho kho, Habit h) async {
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Mau.beMat,
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Hang(
                chu: Chuoi.boTickNgay,
                onTap: () async {
                  Navigator.pop(ctx);
                  await kho.boTickNgay(h, kho.selected);
                },
              ),
              _Hang(
                chu: Chuoi.boTickTuan,
                onTap: () async {
                  Navigator.pop(ctx);
                  await kho.boTickTuan(h);
                },
              ),
              _Hang(
                chu: Chuoi.boTickThang,
                onTap: () async {
                  Navigator.pop(ctx);
                  await kho.boTickThang(h);
                },
              ),
              _Hang(
                chu: Chuoi.xoaKhoiDs,
                onTap: () async {
                  Navigator.pop(ctx);
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (d) => AlertDialog(
                      title: const Text(Chuoi.xoaKhoiDs),
                      content: const Text(Chuoi.xoaKhoiMay),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(d, false),
                          child: const Text(Chuoi.huy),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(d, true),
                          child: const Text(Chuoi.xoa),
                        ),
                      ],
                    ),
                  );
                  if (ok == true) await kho.anKhoiDs(h.id);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _Hang extends StatelessWidget {
  const _Hang({required this.chu, required this.onTap});

  final String chu;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 44),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(chu, style: const TextStyle(fontSize: 16, color: Mau.muc)),
          ),
        ),
      ),
    );
  }
}
