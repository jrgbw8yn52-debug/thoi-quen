import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../kho.dart';
import '../mau.dart';
import '../so.dart';

class ManGhiCan extends StatefulWidget {
  const ManGhiCan({super.key, required this.kho});

  final Kho kho;

  @override
  State<ManGhiCan> createState() => _ManGhiCanState();
}

class _ManGhiCanState extends State<ManGhiCan> {
  late double _kg;
  late final TextEditingController _so;
  bool _banPhim = false;

  @override
  void initState() {
    super.initState();
    final c = widget.kho.canCua(widget.kho.selected) ?? widget.kho.canMoi;
    _kg = c?.kg ?? 0;
    _so = TextEditingController(text: _kg > 0 ? So.kg(_kg) : '');
  }

  @override
  void dispose() {
    _so.dispose();
    super.dispose();
  }

  void _tuSo() {
    final v = So.parseKg(_so.text);
    if (v != null) _kg = v;
  }

  void _buoc(double d) {
    _tuSo();
    setState(() {
      _kg = ((_kg + d) * 10).round() / 10;
      if (_kg < 0) _kg = 0;
      if (_kg > 400) _kg = 400;
      _banPhim = false;
      _so.text = _kg > 0 ? So.kg(_kg) : '';
    });
  }

  Future<void> _luu() async {
    if (widget.kho.khoaGhi) return;
    _tuSo();
    if (_kg <= 0) return;
    await widget.kho.ghiCanKg(_kg);
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
                    Chuoi.canNang,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Mau.muc,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(kho.dongNgay, style: const TextStyle(color: Mau.mo)),
              if (kho.khoaGhi)
                const Text(Chuoi.chiXem, style: TextStyle(color: Mau.mo, fontSize: 13)),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Buoc(chu: '−', onTap: kho.khoaGhi ? null : () => _buoc(-0.1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: _banPhim
                        ? SizedBox(
                            width: 140,
                            child: TextField(
                              key: const Key('so-kg'),
                              controller: _so,
                              autofocus: true,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w600,
                                color: Mau.muc,
                              ),
                              decoration: const InputDecoration(
                                suffixText: Chuoi.kg,
                                border: InputBorder.none,
                              ),
                              onSubmitted: (_) => _luu(),
                            ),
                          )
                        : InkWell(
                            key: const Key('so-kg-nhan'),
                            onTap: kho.khoaGhi
                                ? null
                                : () => setState(() {
                                      _banPhim = true;
                                      _so.text = _kg > 0 ? So.kg(_kg) : '';
                                    }),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              child: Text(
                                '${So.kg(_kg)} ${Chuoi.kg}',
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w600,
                                  color: Mau.muc,
                                ),
                              ),
                            ),
                          ),
                  ),
                  _Buoc(chu: '+', onTap: kho.khoaGhi ? null : () => _buoc(0.1)),
                ],
              ),
              const Spacer(),
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

class _Buoc extends StatelessWidget {
  const _Buoc({required this.chu, required this.onTap});

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
