import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../chuoi.dart';
import '../kho.dart';
import '../mau.dart';
import '../so.dart';

class ManGhiNap extends StatefulWidget {
  const ManGhiNap({super.key, required this.kho});

  final Kho kho;

  @override
  State<ManGhiNap> createState() => _ManGhiNapState();
}

class _ManGhiNapState extends State<ManGhiNap> {
  late final TextEditingController _so;

  @override
  void initState() {
    super.initState();
    final n = widget.kho.napCua(widget.kho.selected);
    _so = TextEditingController(text: n == null ? '' : '${n.kcal}');
  }

  @override
  void dispose() {
    _so.dispose();
    super.dispose();
  }

  Future<void> _luu() async {
    if (widget.kho.khoaGhi) return;
    final v = So.parseKcal(_so.text);
    if (v == null) return;
    await widget.kho.ghiNap(v);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final kho = widget.kho;
    return Scaffold(
      backgroundColor: Mau.giay,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Mau.muc),
                    ),
                  ),
                  const Text(
                    Chuoi.nhatKy,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Mau.muc),
                  ),
                ],
              ),
              Text(kho.dongNgay, style: const TextStyle(color: Mau.mo)),
              if (kho.khoaGhi)
                const Text(Chuoi.chiXem, style: TextStyle(color: Mau.mo, fontSize: 13)),
              const SizedBox(height: 24),
              const Text(
                Chuoi.kcalNapHomNay,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo),
              ),
              const SizedBox(height: 8),
              TextField(
                key: const Key('kcal-nap'),
                controller: _so,
                enabled: !kho.khoaGhi,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Mau.muc),
                decoration: const InputDecoration(
                  hintText: '0',
                  hintStyle: TextStyle(color: Mau.vien),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 44,
                child: FilledButton(
                  onPressed: kho.khoaGhi ? null : _luu,
                  child: const Text(Chuoi.luu),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
