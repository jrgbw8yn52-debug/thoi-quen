import 'package:flutter/material.dart';

import '../mau.dart';

/// Khối thu gọn: hàng tiêu đề + chevron. Mặc định đóng.
class KhoiGap extends StatefulWidget {
  const KhoiGap({
    super.key,
    required this.tieuDe,
    required this.phu,
    required this.children,
    this.mo = false,
  });

  final String tieuDe;
  final String phu;
  final List<Widget> children;
  final bool mo;

  @override
  State<KhoiGap> createState() => _KhoiGapState();
}

class _KhoiGapState extends State<KhoiGap> {
  late bool _mo;

  @override
  void initState() {
    super.initState();
    _mo = widget.mo;
  }

  @override
  void didUpdateWidget(covariant KhoiGap old) {
    super.didUpdateWidget(old);
    if (widget.mo && !old.mo) _mo = true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: Mau.beMat,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _mo = !_mo),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 44),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.tieuDe,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Mau.muc,
                        ),
                      ),
                    ),
                    Text(
                      widget.phu,
                      style: const TextStyle(fontSize: 13, color: Mau.mo),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      _mo ? Icons.expand_less : Icons.expand_more,
                      color: Mau.mo,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_mo) ...[
          const SizedBox(height: 8),
          ...widget.children,
        ],
      ],
    );
  }
}
