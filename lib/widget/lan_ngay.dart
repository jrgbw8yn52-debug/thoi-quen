import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../kho.dart';
import '../mau.dart';
import '../ngay.dart';

Future<DateTime?> moChonNgay({
  required BuildContext context,
  required DateTime goc,
}) {
  var tam = Ngay.cat(goc);
  return showModalBottomSheet<DateTime>(
    context: context,
    backgroundColor: Mau.beMat,
    builder: (ctx) {
      return SafeArea(
        child: SizedBox(
          height: 280,
          child: Column(
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text(Chuoi.huy),
                  ),
                  const Expanded(
                    child: Text(
                      Chuoi.tuNgay,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Mau.muc,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, tam),
                    child: const Text(Chuoi.xong),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: tam,
                  minimumYear: tam.year - 5,
                  maximumYear: tam.year + 3,
                  onDateTimeChanged: (d) => tam = Ngay.cat(d),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> moLanNgay(BuildContext context, Kho kho) async {
  final goc = kho.selected;
  final ok = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Mau.beMat,
    builder: (ctx) => _LanNgay(kho: kho),
  );
  if (ok != true) kho.chonNgay(goc);
}

Future<DateTime?> moLanSinh({
  required BuildContext context,
  required DateTime goc,
  required DateTime homNay,
}) {
  return showModalBottomSheet<DateTime>(
    context: context,
    backgroundColor: Mau.beMat,
    builder: (ctx) => _LanSinh(goc: goc, homNay: homNay),
  );
}

class _LanNgay extends StatefulWidget {
  const _LanNgay({required this.kho});

  final Kho kho;

  @override
  State<_LanNgay> createState() => _LanNgayState();
}

class _LanNgayState extends State<_LanNgay> {
  static const _namLui = 5;
  static const _namToi = 3;

  late int _nam;
  late int _thang;
  late int _ngay;
  late int _namMin;
  late FixedExtentScrollController _cNam;
  late FixedExtentScrollController _cThang;
  late FixedExtentScrollController _cNgay;

  DateTime get _hom => widget.kho.homNay;

  int get _soNam => _namLui + 1 + _namToi;

  @override
  void initState() {
    super.initState();
    final s = widget.kho.selected;
    _nam = s.year;
    _thang = s.month;
    _ngay = s.day;
    _namMin = _hom.year - _namLui;
    _cNam = FixedExtentScrollController(initialItem: _nam - _namMin);
    _cThang = FixedExtentScrollController(initialItem: _thang - 1);
    _cNgay = FixedExtentScrollController(initialItem: _ngay - 1);
  }

  @override
  void dispose() {
    _cNam.dispose();
    _cThang.dispose();
    _cNgay.dispose();
    super.dispose();
  }

  DateTime _hopLe(int nam, int thang, int ngay) {
    final maxD = Ngay.soNgayThang(nam, thang);
    return DateTime(nam, thang, ngay.clamp(1, maxD));
  }

  void _apDung() {
    final d = _hopLe(_nam, _thang, _ngay);
    _nam = d.year;
    _thang = d.month;
    _ngay = d.day;
    widget.kho.chonNgay(d);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 320,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text(Chuoi.huy),
                  ),
                  const Expanded(
                    child: Text(
                      Chuoi.chonNgay,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Mau.muc,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(Chuoi.xong),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: _cNgay,
                      itemExtent: 36,
                      onSelectedItemChanged: (i) {
                        _ngay = i + 1;
                        _apDung();
                      },
                      children: [
                        for (var d = 1; d <= 31; d++)
                          Center(child: Text('$d')),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: CupertinoPicker(
                      scrollController: _cThang,
                      itemExtent: 36,
                      onSelectedItemChanged: (i) {
                        _thang = i + 1;
                        _apDung();
                      },
                      children: [
                        for (var m = 1; m <= 12; m++)
                          Center(child: Text(Chuoi.thang(m))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: _cNam,
                      itemExtent: 36,
                      onSelectedItemChanged: (i) {
                        _nam = _namMin + i;
                        _apDung();
                      },
                      children: [
                        for (var i = 0; i < _soNam; i++)
                          Center(child: Text('${_namMin + i}')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanSinh extends StatefulWidget {
  const _LanSinh({required this.goc, required this.homNay});

  final DateTime goc;
  final DateTime homNay;

  @override
  State<_LanSinh> createState() => _LanSinhState();
}

class _LanSinhState extends State<_LanSinh> {
  static const _namLui = 100;

  late int _nam;
  late int _thang;
  late int _ngay;
  late int _namMin;
  late FixedExtentScrollController _cNam;
  late FixedExtentScrollController _cThang;
  late FixedExtentScrollController _cNgay;

  int get _soNam => widget.homNay.year - _namMin + 1;

  @override
  void initState() {
    super.initState();
    final s = widget.goc;
    _nam = s.year;
    _thang = s.month;
    _ngay = s.day;
    _namMin = widget.homNay.year - _namLui;
    _cNam = FixedExtentScrollController(initialItem: (_nam - _namMin).clamp(0, _soNam - 1));
    _cThang = FixedExtentScrollController(initialItem: _thang - 1);
    _cNgay = FixedExtentScrollController(initialItem: _ngay - 1);
  }

  @override
  void dispose() {
    _cNam.dispose();
    _cThang.dispose();
    _cNgay.dispose();
    super.dispose();
  }

  DateTime _hopLe() {
    final maxD = Ngay.soNgayThang(_nam, _thang);
    var d = DateTime(_nam, _thang, _ngay.clamp(1, maxD));
    if (Ngay.sau(d, widget.homNay)) d = widget.homNay;
    return d;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 320,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(Chuoi.huy),
                  ),
                  const Expanded(
                    child: Text(
                      Chuoi.ngaySinh,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Mau.muc,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, _hopLe()),
                    child: const Text(Chuoi.xong),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: _cNgay,
                      itemExtent: 36,
                      onSelectedItemChanged: (i) => _ngay = i + 1,
                      children: [
                        for (var d = 1; d <= 31; d++)
                          Center(child: Text('$d')),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: CupertinoPicker(
                      scrollController: _cThang,
                      itemExtent: 36,
                      onSelectedItemChanged: (i) => _thang = i + 1,
                      children: [
                        for (var m = 1; m <= 12; m++)
                          Center(child: Text(Chuoi.thang(m))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: _cNam,
                      itemExtent: 36,
                      onSelectedItemChanged: (i) => _nam = _namMin + i,
                      children: [
                        for (var i = 0; i < _soNam; i++)
                          Center(child: Text('${_namMin + i}')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
