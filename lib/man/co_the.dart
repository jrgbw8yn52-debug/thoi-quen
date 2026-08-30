import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../kho.dart';
import '../mau.dart';
import '../ngay.dart';
import '../so.dart';

class ManCoThe extends StatefulWidget {
  const ManCoThe({super.key, required this.kho});

  final Kho kho;

  @override
  State<ManCoThe> createState() => _ManCoTheState();
}

class _ManCoTheState extends State<ManCoThe> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _luu() async {
    final ok = await widget.kho.ghiCan(_ctrl.text);
    if (ok) _ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final kho = widget.kho;
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          const Text(
            Chuoi.coThe,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.4,
              color: Mau.muc,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            Chuoi.canHomNay,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Mau.mo,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    hintText: Chuoi.kg,
                    suffixText: Chuoi.kg,
                  ),
                  onSubmitted: (_) => _luu(),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 44,
                child: FilledButton(
                  onPressed: _luu,
                  child: const Text(Chuoi.luu),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (kho.dsCan.isEmpty)
            const Text(
              Chuoi.chuaCoCan,
              style: TextStyle(color: Mau.mo, fontSize: 15),
            )
          else
            for (final c in kho.dsCan)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Text(
                      Chuoi.dongNgay(Ngay.parse(c.ngay)),
                      style: const TextStyle(fontSize: 15, color: Mau.muc),
                    ),
                    const Spacer(),
                    Text(
                      '${So.kg(c.kg)} ${Chuoi.kg}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Mau.muc,
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
