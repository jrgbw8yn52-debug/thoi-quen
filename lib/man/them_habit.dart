import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../db/database.dart';
import '../kho.dart';
import '../mau.dart';
import '../ten.dart';

class ManThemHabit extends StatefulWidget {
  const ManThemHabit({super.key, required this.kho, this.habit});

  final Kho kho;
  final Habit? habit;

  @override
  State<ManThemHabit> createState() => _ManThemHabitState();
}

class _ManThemHabitState extends State<ManThemHabit> {
  late final TextEditingController _ten;
  late int _n;
  String? _loi;

  bool get _sua => widget.habit != null;

  @override
  void initState() {
    super.initState();
    final h = widget.habit;
    _ten = TextEditingController(text: h?.ten ?? '');
    _n = h?.mucTieuThang ?? 25;
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
    final bool ok;
    if (_sua) {
      ok = await widget.kho.suaHabit(
        id: widget.habit!.id,
        ten: ten,
        mucTieuThang: _n,
      );
    } else {
      ok = await widget.kho.themPreset(ten: ten, mucTieuThang: _n);
    }
    if (!mounted) return;
    if (!ok) {
      setState(() => _loi = Chuoi.daCoThoiQuen);
      return;
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
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
              TextField(
                controller: _ten,
                autofocus: !_sua,
                maxLength: 40,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: Chuoi.tenThoiQuen,
                  counterText: '',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                Chuoi.mucTieu,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Mau.mo,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _NutBuoc(
                    chu: '−',
                    onTap: () {
                      if (_n <= 1) return;
                      setState(() => _n--);
                    },
                  ),
                  Expanded(
                    child: Text(
                      '$_n',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Mau.muc,
                      ),
                    ),
                  ),
                  _NutBuoc(
                    chu: '+',
                    onTap: () {
                      if (_n >= 31) return;
                      setState(() => _n++);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                Chuoi.nNgayTrongThang(_n),
                style: const TextStyle(fontSize: 14, color: Mau.mo),
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

class _NutBuoc extends StatelessWidget {
  const _NutBuoc({required this.chu, required this.onTap});

  final String chu;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: Material(
        color: Mau.beMat,
        shape: const CircleBorder(side: BorderSide(color: Mau.vien)),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Center(
            child: Text(
              chu,
              style: const TextStyle(fontSize: 22, color: Mau.muc, height: 1),
            ),
          ),
        ),
      ),
    );
  }
}
