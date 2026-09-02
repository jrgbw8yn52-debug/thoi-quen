import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../kho.dart';
import '../mau.dart';
import '../ngay.dart';
import '../widget/duong_thong_ke.dart';
import '../widget/lan_ngay.dart';
import '../widget/xem_them.dart';

class ManThoiKhoa extends StatefulWidget {
  const ManThoiKhoa({super.key, required this.kho});

  final Kho kho;

  @override
  State<ManThoiKhoa> createState() => _ManThoiKhoaState();
}

class _ManThoiKhoaState extends State<ManThoiKhoa> {
  int _phin = 0;
  late DateTime _tu;

  Kho get kho => widget.kho;

  @override
  void initState() {
    super.initState();
    _tu = kho.homNay;
  }

  DateTime get _den => Ngay.cuoiKhoang(_tu, _phin);

  Future<void> _chonTu() async {
    final d = await moChonNgay(context: context, goc: _tu);
    if (d != null) setState(() => _tu = Ngay.cat(d));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mau.giay,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: kho,
          builder: (context, _) {
            final nm = kho.nTrenMThongKe(_phin, tu: _tu);
            final dg = Chuoi.danhGia(nm.$1, nm.$2);
            final diem = kho.diemThongKe(_phin, tu: _tu);
            final chua = kho.chuaTick(phin: _phin, tu: _tu);
            final maxChua = chua.isEmpty ? 1 : chua.first.so;
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Expanded(
                      child: Text(
                        Chuoi.thongKe,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Mau.muc,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _Phin(chu: Chuoi.tuanNhan, bat: _phin == 0, onTap: () => setState(() => _phin = 0)),
                    _Phin(chu: Chuoi.thangNhan, bat: _phin == 1, onTap: () => setState(() => _phin = 1)),
                    _Phin(chu: Chuoi.sauThang, bat: _phin == 2, onTap: () => setState(() => _phin = 2)),
                    _Phin(chu: Chuoi.muoiHaiThang, bat: _phin == 3, onTap: () => setState(() => _phin = 3)),
                  ],
                ),
                const SizedBox(height: 12),
                InkWell(
                  key: const Key('tu-ngay'),
                  onTap: _chonTu,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 44),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${Chuoi.tuNgay} ${_tu.day}/${_tu.month}/${_tu.year}',
                          style: const TextStyle(fontSize: 15, color: Mau.muc),
                        ),
                        Text(
                          Chuoi.denNgay(_den),
                          style: const TextStyle(fontSize: 13, color: Mau.mo),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                DuongThongKe(
                  diem: diem,
                  onChon: (d) {
                    kho.chonNgay(d);
                    setState(() {});
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  Chuoi.hoanThanhDanhGia(nm.$1, nm.$2, dg),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Mau.muc,
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  Chuoi.chuaTick,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Mau.mo),
                ),
                const SizedBox(height: 8),
                if (chua.isEmpty)
                  const Text('—', style: TextStyle(color: Mau.mo))
                else
                  XemThem(
                    hang: [
                      for (final c in chua)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 88,
                                child: Text(
                                  c.ten,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13, color: Mau.muc),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 10,
                                  child: FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: c.so / maxChua,
                                    child: const DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Mau.canhBao,
                                        borderRadius: BorderRadius.all(Radius.circular(2)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${c.so}',
                                style: const TextStyle(fontSize: 13, color: Mau.canhBao),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Phin extends StatelessWidget {
  const _Phin({required this.chu, required this.bat, required this.onTap});

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
