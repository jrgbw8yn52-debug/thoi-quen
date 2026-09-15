import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../db/database.dart';
import '../kho.dart';
import '../mau.dart';
import '../ngay.dart';
import '../nhac.dart';
import '../ten.dart';
import '../widget/o_ten.dart';

const _luong = [30, 60, 120, 180];

class ManThemFocus extends StatefulWidget {
  const ManThemFocus({super.key, required this.kho, this.viec});

  final Kho kho;
  final FocusTask? viec;

  @override
  State<ManThemFocus> createState() => _ManThemFocusState();
}

class _ManThemFocusState extends State<ManThemFocus> {
  late final TextEditingController _ten;
  late final TextEditingController _tu;
  late DateTime _ngay;
  late int _gio;
  int? _luongChon;
  bool _tuDat = false;

  bool get _sua => widget.viec != null;

  @override
  void initState() {
    super.initState();
    final v = widget.viec;
    _ten = TextEditingController(text: v?.title ?? '');
    _ngay = v == null ? widget.kho.homNay : Ngay.parse(v.ngay);
    _gio = v?.gioPhut ?? 8 * 60;
    final d = v?.durationMin;
    if (d != null && !_luong.contains(d)) {
      _tuDat = true;
      _tu = TextEditingController(text: '$d');
      _luongChon = null;
    } else {
      _luongChon = d ?? 30;
      _tu = TextEditingController();
    }
  }

  @override
  void dispose() {
    _ten.dispose();
    _tu.dispose();
    super.dispose();
  }

  int? _duration() {
    if (_tuDat) {
      final n = int.tryParse(_tu.text.trim());
      if (n == null || n < 1 || n > 720) return null;
      return n;
    }
    return _luongChon;
  }

  Future<void> _luu() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await Future<void>.delayed(Duration.zero);
    if (!mounted) return;
    if (Ten.sach(_ten.text).isEmpty) return;
    if (!Ngay.ghiDuoc(_ngay, widget.kho.homNay)) return;
    if (_tuDat && _duration() == null) return;
    await Nhac.xinQuyen();
    if (!mounted) return;
    final duration = _duration();
    final bool ok;
    if (_sua) {
      ok = await widget.kho.suaFocus(
        id: widget.viec!.id,
        title: _ten.text,
        ngay: _ngay,
        gioPhut: _gio,
        durationMin: duration,
      );
    } else {
      final id = await widget.kho.themFocus(
        title: _ten.text,
        ngay: _ngay,
        gioPhut: _gio,
        durationMin: duration,
      );
      ok = id > 0;
    }
    if (!mounted) return;
    if (!ok) return;
    await _hoiUuTien(duration);
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  Future<void> _hoiUuTien(int? duration) async {
    final trung = widget.kho.habitTrungChuaXuLy(
      ngay: _ngay,
      gioPhut: _gio,
      durationMin: duration,
    );
    if (trung.isEmpty) return;
    final uu = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(Chuoi.uuTienFocus),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(Chuoi.khong),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(Chuoi.co),
          ),
        ],
      ),
    );
    if (uu == true) await widget.kho.ghiOverride(_ngay, trung);
  }

  Future<void> _moGio() async {
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

  Future<void> _moNgay() async {
    final chon = await showDatePicker(
      context: context,
      initialDate: _ngay,
      firstDate: widget.kho.homNay.subtract(const Duration(days: Ngay.cuaSoLui)),
      lastDate: widget.kho.homNay.add(const Duration(days: 730)),
    );
    if (chon != null && mounted) setState(() => _ngay = Ngay.cat(chon));
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
                _sua ? Chuoi.sua : Chuoi.viecQuanTrong,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.4,
                  color: Mau.muc,
                ),
              ),
              const SizedBox(height: 20),
              OTen(
                key: const Key('ten-focus'),
                controller: _ten,
                autofocus: !_sua,
                hint: Chuoi.tenViec,
              ),
              const SizedBox(height: 16),
              InkWell(
                key: const Key('ngay-focus'),
                onTap: _moNgay,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.event, color: Mau.mo, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          Chuoi.dongNgay(_ngay),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16, color: Mau.muc),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                key: const Key('gio-focus'),
                onTap: _moGio,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.schedule, color: Mau.mo, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          Chuoi.gioNhacChu(_gio),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16, color: Mau.muc),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                Chuoi.thoiLuong,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Mau.mo,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final n in _luong)
                    _Chip(
                      chu: '$n',
                      bat: !_tuDat && _luongChon == n,
                      onTap: () => setState(() {
                        _tuDat = false;
                        _luongChon = n;
                      }),
                    ),
                  _Chip(
                    chu: Chuoi.tuDat,
                    bat: _tuDat,
                    onTap: () => setState(() {
                      _tuDat = true;
                      _luongChon = null;
                    }),
                  ),
                ],
              ),
              if (_tuDat) ...[
                const SizedBox(height: 12),
                TextField(
                  key: const Key('luong-tu'),
                  controller: _tu,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: Chuoi.phut),
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

class _Chip extends StatelessWidget {
  const _Chip({required this.chu, required this.bat, required this.onTap});

  final String chu;
  final bool bat;
  final VoidCallback onTap;

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
