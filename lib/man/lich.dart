import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../chuoi.dart';
import '../kho.dart';
import '../mau.dart';
import '../ngay.dart';
import 'them_habit.dart';
import 'xoa_habit.dart';
import '../widget/hang_habit.dart';

class ManLich extends StatefulWidget {
  const ManLich({super.key, required this.kho});

  final Kho kho;

  @override
  State<ManLich> createState() => _ManLichState();
}

class _ManLichState extends State<ManLich> {
  bool _nam = false;
  late DateTime _thang;
  late DateTime _selGan;

  Kho get kho => widget.kho;

  @override
  void initState() {
    super.initState();
    _thang = DateTime(kho.selected.year, kho.selected.month, 1);
    _selGan = kho.selected;
  }

  @override
  void didUpdateWidget(covariant ManLich old) {
    super.didUpdateWidget(old);
    if (kho.selected.year != _selGan.year ||
        kho.selected.month != _selGan.month) {
      _thang = DateTime(kho.selected.year, kho.selected.month, 1);
    }
    _selGan = kho.selected;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => setState(() => _nam = !_nam),
                borderRadius: BorderRadius.circular(12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 44),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _nam
                                ? '${_thang.year}'
                                : '${Chuoi.thang(_thang.month)} ${_thang.year}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.4,
                              color: Mau.muc,
                            ),
                          ),
                        ),
                        Icon(
                          _nam ? Icons.expand_less : Icons.expand_more,
                          color: Mau.mo,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (kho.khoaGhi)
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Text(Chuoi.chiXem, style: TextStyle(fontSize: 13, color: Mau.mo)),
            ),
          Expanded(
            child: _nam
                ? _LuoiNam(
                    thang: _thang.month,
                    onThang: (m) {
                      setState(() {
                        _thang = DateTime(_thang.year, m, 1);
                        _nam = false;
                      });
                    },
                  )
                : _LuoiThang(kho: kho, thang: _thang),
          ),
          if (!_nam)
            SizedBox(
              height: 220,
              child: kho.hang.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                      child: Text('', style: TextStyle(color: Mau.mo)),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                      itemCount: kho.hang.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 6),
                      itemBuilder: (context, i) {
                        final h = kho.hang[i];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: HangHabit(
                            hang: h,
                            khoaGhi: kho.khoaGhi,
                            onTap: () => kho.toggle(h),
                            onSua: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => ManThemHabit(kho: kho, habit: h.habit),
                                ),
                              );
                            },
                            onXoa: () => moXoaHabit(context, kho, h.habit),
                          ),
                        );
                      },
                    ),
            ),
        ],
      ),
    );
  }
}

class _LuoiThang extends StatelessWidget {
  const _LuoiThang({required this.kho, required this.thang});

  final Kho kho;
  final DateTime thang;

  @override
  Widget build(BuildContext context) {
    final y = thang.year;
    final m = thang.month;
    final dau = DateTime(y, m, 1);
    final skip = dau.weekday - 1;
    final so = Ngay.soNgayThang(y, m);
    final o = skip + so;
    final hang = (o / 7).ceil();
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Column(
        children: [
          Row(
            children: [
              for (final t in Chuoi.thuNgan)
                Expanded(
                  child: Text(
                    t,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11, color: Mau.mo),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemCount: hang * 7,
              itemBuilder: (context, i) {
                final ngay = i - skip + 1;
                if (ngay < 1 || ngay > so) return const SizedBox.shrink();
                final d = DateTime(y, m, ngay);
                final hom = Ngay.cungNgay(d, kho.homNay);
                final xem = Ngay.cungNgay(d, kho.selected);
                final tuongLai = Ngay.sau(d, kho.homNay);
                return InkWell(
                  onTap: tuongLai
                      ? null
                      : () {
                          HapticFeedback.selectionClick();
                          kho.chonNgay(d);
                        },
                  child: Center(
                    child: Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: xem ? Mau.chipBat : Colors.transparent,
                        border: hom
                            ? Border.all(color: Mau.reu, width: 2)
                            : (xem ? Border.all(color: Mau.muc) : null),
                      ),
                      child: Text(
                        '$ngay',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: hom ? FontWeight.w700 : FontWeight.w500,
                          color: tuongLai ? Mau.vien : Mau.muc,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LuoiNam extends StatelessWidget {
  const _LuoiNam({
    required this.thang,
    required this.onThang,
  });

  final int thang;
  final ValueChanged<int> onThang;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.6,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: [
          for (var m = 1; m <= 12; m++)
            Material(
              color: thang == m ? Mau.chipBat : Mau.beMat,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () => onThang(m),
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  child: Text(
                    Chuoi.thang(m),
                    style: const TextStyle(fontSize: 16, color: Mau.muc),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
