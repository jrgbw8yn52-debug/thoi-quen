import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../db/database.dart';
import '../kho.dart';
import '../mau.dart';
import '../nhac.dart';
import '../ten.dart';
import '../thu.dart';
import '../widget/o_ten.dart';

class ManThemHabit extends StatefulWidget {
  const ManThemHabit({super.key, required this.kho, this.habit});

  final Kho kho;
  final Habit? habit;

  @override
  State<ManThemHabit> createState() => _ManThemHabitState();
}

class _ManThemHabitState extends State<ManThemHabit> {
  late final TextEditingController _ten;
  late Set<int> _thu;
  bool _nhac = false;
  int _gio = 7 * 60;
  String? _loi;

  bool get _sua => widget.habit != null;

  @override
  void initState() {
    super.initState();
    final h = widget.habit;
    _ten = TextEditingController(text: h?.ten ?? '');
    _thu = h == null
        ? {widget.kho.selected.weekday}
        : Thu.tach(h.thuBit);
    final g = h?.gioNhac;
    if (g != null) {
      _nhac = true;
      _gio = g;
    }
  }

  @override
  void dispose() {
    _ten.dispose();
    super.dispose();
  }

  Future<void> _luu() async {
    setState(() => _loi = null);
    final ten = _ten.text;
    if (Ten.sach(ten).isEmpty) return;
    if (_thu.isEmpty) {
      setState(() => _loi = Chuoi.phaiChonThu);
      return;
    }
    final bit = Thu.goi(_thu);
    final gio = _nhac ? _gio : null;
    final bool ok;
    if (_sua) {
      ok = await widget.kho.suaHabit(
        id: widget.habit!.id,
        ten: ten,
        thuBit: bit,
        gioNhac: gio,
        xoaGioNhac: !_nhac,
      );
    } else {
      ok = await widget.kho.themPreset(
        ten: ten,
        thuBit: bit,
        gioNhac: gio,
      );
    }
    if (!mounted) return;
    if (!ok) {
      setState(() => _loi = Chuoi.daCoThoiQuen);
      return;
    }
    Navigator.pop(context, true);
  }

  Future<void> _moGio() async {
    if (widget.kho.khoaGhi && !_sua) return;
    var tam = _gio;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Mau.beMat,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 180,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: false,
                  initialDateTime: DateTime(2026, 1, 1, tam ~/ 60, tam % 60),
                  onDateTimeChanged: (d) => tam = d.hour * 60 + d.minute,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() => _gio = tam);
                  Navigator.pop(ctx);
                },
                child: const Text(Chuoi.xong),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final khoaNhac = widget.kho.khoaGhi;
    return Scaffold(
      backgroundColor: Mau.giay,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _sua ? Chuoi.sua : Chuoi.themThoiQuen,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.4,
                  color: Mau.muc,
                ),
              ),
              const SizedBox(height: 20),
              OTen(
                key: const Key('ten-habit'),
                controller: _ten,
                autofocus: !_sua,
                hint: Chuoi.tenThoiQuen,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var i = 1; i <= 7; i++)
                    _ChipThu(
                      chu: Chuoi.thuNgan[i - 1],
                      bat: _thu.contains(i),
                      onTap: () => setState(() {
                        if (_thu.contains(i)) {
                          _thu.remove(i);
                        } else {
                          _thu.add(i);
                        }
                      }),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                Chuoi.gioNhac,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Mau.mo,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _ChipThu(
                    chu: Chuoi.tat,
                    bat: !_nhac,
                    onTap: khoaNhac ? null : () => setState(() => _nhac = false),
                  ),
                  const SizedBox(width: 8),
                  _ChipThu(
                    chu: Chuoi.batNhac,
                    bat: _nhac,
                    onTap: khoaNhac
                        ? null
                        : () async {
                            await Nhac.xinQuyen();
                            if (!mounted) return;
                            setState(() => _nhac = true);
                          },
                  ),
                  if (_nhac) ...[
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: khoaNhac ? null : _moGio,
                      child: Text(Chuoi.gioNhacChu(_gio)),
                    ),
                  ],
                ],
              ),
              if (_loi != null) ...[
                const SizedBox(height: 12),
                Text(
                  _loi!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
              const Spacer(),
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(Chuoi.huy),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 44,
                    child: FilledButton(
                      onPressed: _luu,
                      child: const Text(Chuoi.luu),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChipThu extends StatelessWidget {
  const _ChipThu({required this.chu, required this.bat, required this.onTap});

  final String chu;
  final bool bat;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bat ? Mau.chipBat : Mau.beMat,
      shape: StadiumBorder(side: BorderSide(color: bat ? Mau.reu : Mau.vien)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Text(chu, style: const TextStyle(fontSize: 15, color: Mau.muc)),
          ),
        ),
      ),
    );
  }
}
