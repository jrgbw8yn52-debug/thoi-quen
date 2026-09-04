import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../chuoi.dart';
import '../he.dart';
import '../kho.dart';
import '../mau.dart';

class ManHe extends StatefulWidget {
  const ManHe({super.key, required this.kho});

  final Kho kho;

  @override
  State<ManHe> createState() => _ManHeState();
}

class _ManHeState extends State<ManHe> {
  Kho get kho => widget.kho;

  @override
  void initState() {
    super.initState();
    kho.heBan.addListener(_ve);
    kho.homeBan.addListener(_ve);
  }

  void _ve() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    kho.heBan.removeListener(_ve);
    kho.homeBan.removeListener(_ve);
    super.dispose();
  }

  Future<void> _cong(String ma) async {
    HapticFeedback.selectionClick();
    await kho.congChiSo(ma);
  }

  @override
  Widget build(BuildContext context) {
    final st = kho.he;
    final vien = kho.heVienCam;
    return SafeArea(
      bottom: false,
      child: ListView(
        key: const Key('he-man'),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          const Text(
            Chuoi.he,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.4,
              color: Mau.muc,
            ),
          ),
          const SizedBox(height: 16),
          _TheTrang(
            st: st,
            suc: kho.sucTam,
            vienCam: vien,
            onCong: st.unspent > 0 ? _cong : null,
          ),
          if (kho.heLuaCau != null) ...[
            const SizedBox(height: 12),
            Text(
              kho.heLuaCau!,
              key: const Key('he-lua-cau'),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Mau.reu,
                height: 1.35,
              ),
            ),
          ],
          if (kho.heKhichLe != null) ...[
            const SizedBox(height: 8),
            Text(
              kho.heKhichLe!,
              key: const Key('he-khich-le'),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Mau.reu,
                height: 1.35,
              ),
            ),
          ],
          const SizedBox(height: 22),
          const Text(
            Chuoi.questHomNay,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
              color: Mau.mo,
            ),
          ),
          const SizedBox(height: 8),
          for (final q in kho.heQuest) _HangQuest(quest: q),
          const SizedBox(height: 22),
          const Text(
            Chuoi.kyNhan,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
              color: Mau.mo,
            ),
          ),
          const SizedBox(height: 8),
          for (final k in kho.heKy) _TheKy(ky: k),
          if (kho.heManh.isNotEmpty) ...[
            const SizedBox(height: 22),
            const Text(
              Chuoi.manhNhan,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
                color: Mau.mo,
              ),
            ),
            const SizedBox(height: 8),
            for (final m in kho.heManh) _TheManh(manh: m),
          ],
        ],
      ),
    );
  }
}

class _TheTrang extends StatelessWidget {
  const _TheTrang({
    required this.st,
    required this.suc,
    required this.vienCam,
    required this.onCong,
  });

  final HeTrangThai st;
  final int suc;
  final bool vienCam;
  final Future<void> Function(String ma)? onCong;

  @override
  Widget build(BuildContext context) {
    final p = st.can == 0 ? 0.0 : (st.exp / st.can).clamp(0.0, 1.0);
    return Container(
      key: const Key('he-status'),
      decoration: BoxDecoration(
        color: Mau.beMat,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: vienCam ? Mau.reu : Mau.vien,
          width: vienCam ? 1.6 : 1,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Chuoi.capSo(st.level),
            key: const Key('he-cap'),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Mau.muc,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${Chuoi.expNhan} ${Chuoi.expThanh(st.exp, st.can)}',
            key: const Key('he-exp'),
            style: const TextStyle(fontSize: 14, color: Mau.mo),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const ColoredBox(color: Mau.vien),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: p,
                    child: const ColoredBox(color: Mau.reu),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            Chuoi.sucTamSo(suc),
            key: const Key('he-suc'),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Mau.muc,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            Chuoi.diemChuaCongSo(st.unspent),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: st.unspent > 0 ? Mau.reu : Mau.mo,
            ),
          ),
          const SizedBox(height: 8),
          _HangChi(ten: Chuoi.luc, so: st.luc, ma: 'luc', onCong: onCong),
          _HangChi(ten: Chuoi.ben, so: st.ben, ma: 'ben', onCong: onCong),
          _HangChi(ten: Chuoi.chiNhan, so: st.chi, ma: 'chi', onCong: onCong),
          _HangChi(ten: Chuoi.tinh, so: st.tinh, ma: 'tinh', onCong: onCong),
        ],
      ),
    );
  }
}

class _HangChi extends StatelessWidget {
  const _HangChi({
    required this.ten,
    required this.so,
    required this.ma,
    required this.onCong,
  });

  final String ten;
  final int so;
  final String ma;
  final Future<void> Function(String ma)? onCong;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          Expanded(
            child: Text(
              ten,
              style: const TextStyle(fontSize: 16, color: Mau.muc),
            ),
          ),
          Text(
            '$so',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Mau.muc,
            ),
          ),
          if (onCong != null) ...[
            const SizedBox(width: 8),
            IconButton(
              key: Key('he-cong-$ma'),
              onPressed: () => onCong!(ma),
              icon: const Icon(Icons.add, color: Mau.reu),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            ),
          ],
        ],
      ),
    );
  }
}

class _HangQuest extends StatelessWidget {
  const _HangQuest({required this.quest});

  final HeQuest quest;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 44),
        child: Row(
          children: [
            Icon(
              quest.xong ? Icons.check_circle : Icons.circle_outlined,
              color: quest.xong ? Mau.reu : Mau.mo,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                quest.ten,
                style: TextStyle(
                  fontSize: 16,
                  color: quest.xong ? Mau.mo : Mau.muc,
                  decoration: quest.xong ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TheKy extends StatelessWidget {
  const _TheKy({required this.ky});

  final HeKy ky;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: Mau.beMat,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ky.hieuLuc ? Mau.reu : Mau.vien),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    ky.ten,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Mau.muc,
                    ),
                  ),
                ),
                Text(
                  Chuoi.kyDong(ky.hieuLuc),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: ky.hieuLuc ? Mau.reu : Mau.mo,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              ky.moTa,
              style: const TextStyle(fontSize: 14, color: Mau.mo, height: 1.3),
            ),
          ],
        ),
      ),
    );
  }
}

class _TheManh extends StatelessWidget {
  const _TheManh({required this.manh});

  final HeManh manh;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        manh.cau,
        style: const TextStyle(
          fontSize: 15,
          height: 1.4,
          color: Mau.muc,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
