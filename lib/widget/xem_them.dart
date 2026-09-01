import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../mau.dart';

/// List >3 hàng: mặc định 3 + «Xem thêm».
class XemThem extends StatefulWidget {
  const XemThem({super.key, required this.hang, this.toiDa = 3});

  final List<Widget> hang;
  final int toiDa;

  @override
  State<XemThem> createState() => _XemThemState();
}

class _XemThemState extends State<XemThem> {
  bool _het = false;

  @override
  Widget build(BuildContext context) {
    if (widget.hang.length <= widget.toiDa) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widget.hang,
      );
    }
    final ds = _het ? widget.hang : widget.hang.take(widget.toiDa).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...ds,
        TextButton(
          onPressed: () => setState(() => _het = !_het),
          child: Text(_het ? Chuoi.thuGon : Chuoi.xemThem),
        ),
      ],
    );
  }
}

class ChipKhung extends StatelessWidget {
  const ChipKhung({
    super.key,
    required this.ma,
    required this.chu,
    required this.bat,
    required this.onTap,
  });

  final String ma;
  final String chu;
  final bool bat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bat ? Mau.chipBat : Mau.beMat,
      shape: StadiumBorder(side: BorderSide(color: bat ? Mau.reu : Mau.vien)),
      child: InkWell(
        key: Key('khung-$ma'),
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 36),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(chu, style: const TextStyle(fontSize: 14, color: Mau.muc)),
          ),
        ),
      ),
    );
  }
}
