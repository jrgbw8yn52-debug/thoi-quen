import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../cong_thuc.dart';
import '../db/database.dart';
import '../kho.dart';
import '../mau.dart';
import '../ngay.dart';
import '../so.dart';

Future<void> _unfocusRoi() async {
  FocusManager.instance.primaryFocus?.unfocus();
  await Future<void>.delayed(Duration.zero);
}

Future<void> moToTaoCongThuc(BuildContext context, Kho kho, {DateTime? ngay}) async {
  await _unfocusRoi();
  if (!context.mounted) return;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Mau.beMat,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
        child: ToTaoCongThuc(kho: kho, ngay: ngay),
      );
    },
  );
}

Future<void> moToMonDaLuu(BuildContext context, Kho kho, {DateTime? ngay}) async {
  await _unfocusRoi();
  if (!context.mounted) return;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Mau.beMat,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
        child: ToMonDaLuu(kho: kho, ngay: ngay),
      );
    },
  );
}

Future<void> moChonThemMon(BuildContext context, Kho kho, {DateTime? ngay}) async {
  await _unfocusRoi();
  if (!context.mounted) return;
  final chon = await showModalBottomSheet<String>(
    context: context,
    useRootNavigator: true,
    backgroundColor: Mau.beMat,
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 44,
                child: FilledButton(
                  key: const Key('them-tao-cong-thuc'),
                  onPressed: () => Navigator.pop(ctx, 'tao'),
                  child: const Text(Chuoi.taoCongThuc),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 44,
                child: OutlinedButton(
                  key: const Key('them-mon-da-luu'),
                  onPressed: () => Navigator.pop(ctx, 'kho'),
                  child: const Text(Chuoi.monDaLuu),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
  if (!context.mounted || chon == null) return;
  await Future<void>.delayed(Duration.zero);
  if (!context.mounted) return;
  if (chon == 'tao') {
    await moToTaoCongThuc(context, kho, ngay: ngay);
  } else {
    await moToMonDaLuu(context, kho, ngay: ngay);
  }
}

class SuaLogKq {
  const SuaLogKq({required this.kcal, this.gram, this.dam, this.bot, this.beo});

  final int kcal;
  final double? gram;
  final double? dam;
  final double? bot;
  final double? beo;
}

class SuaMonKq {
  const SuaMonKq({
    required this.ten,
    required this.kcal,
    this.gram,
    this.dam,
    this.bot,
    this.beo,
  });

  final String ten;
  final int kcal;
  final double? gram;
  final double? dam;
  final double? bot;
  final double? beo;
}

Future<SuaLogKq?> moDlgSuaLog(BuildContext context, FoodLog log) async {
  await _unfocusRoi();
  if (!context.mounted) return null;
  return showDialog<SuaLogKq>(
    context: context,
    useRootNavigator: true,
    builder: (ctx) => _DlgSuaLog(log: log),
  );
}

Future<SuaMonKq?> moDlgSuaMon(BuildContext context, Food mon) async {
  await _unfocusRoi();
  if (!context.mounted) return null;
  return showDialog<SuaMonKq>(
    context: context,
    useRootNavigator: true,
    builder: (ctx) => _DlgSuaMon(mon: mon),
  );
}

class _DlgSuaLog extends StatefulWidget {
  const _DlgSuaLog({required this.log});

  final FoodLog log;

  @override
  State<_DlgSuaLog> createState() => _DlgSuaLogState();
}

class _DlgSuaLogState extends State<_DlgSuaLog> {
  late final TextEditingController _kcal;
  late final TextEditingController _gram;
  late final TextEditingController _dam;
  late final TextEditingController _bot;
  late final TextEditingController _beo;

  @override
  void initState() {
    super.initState();
    final l = widget.log;
    _kcal = TextEditingController(text: '${l.kcal}');
    _gram = TextEditingController(text: l.gram == null ? '' : So.kg(l.gram!));
    _dam = TextEditingController(text: l.dam == null ? '' : So.kg(l.dam!));
    _bot = TextEditingController(text: l.bot == null ? '' : So.kg(l.bot!));
    _beo = TextEditingController(text: l.beo == null ? '' : So.kg(l.beo!));
  }

  @override
  void dispose() {
    _kcal.dispose();
    _gram.dispose();
    _dam.dispose();
    _bot.dispose();
    _beo.dispose();
    super.dispose();
  }

  void _luu() {
    FocusManager.instance.primaryFocus?.unfocus();
    final kcal = So.parseKcal(_kcal.text);
    if (kcal == null) return;
    Navigator.of(context, rootNavigator: true).pop(
      SuaLogKq(
        kcal: kcal,
        gram: So.parseG(_gram.text),
        dam: So.parseMacro(_dam.text),
        bot: So.parseMacro(_bot.text),
        beo: So.parseMacro(_beo.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Mau.beMat,
      scrollable: true,
      title: Text(widget.log.ten, style: const TextStyle(color: Mau.muc)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            key: const Key('sua-kcal'),
            controller: _kcal,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(suffixText: 'kcal'),
          ),
          const SizedBox(height: 8),
          TextField(
            key: const Key('sua-gram'),
            controller: _gram,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: Chuoi.khoiLuongG, suffixText: 'g'),
          ),
          const SizedBox(height: 8),
          TextField(
            key: const Key('sua-dam'),
            controller: _dam,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: Chuoi.dam, suffixText: 'g'),
          ),
          const SizedBox(height: 8),
          TextField(
            key: const Key('sua-bot'),
            controller: _bot,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: Chuoi.bot, suffixText: 'g'),
          ),
          const SizedBox(height: 8),
          TextField(
            key: const Key('sua-beo'),
            controller: _beo,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: Chuoi.beo, suffixText: 'g'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: const Text(Chuoi.huy),
        ),
        TextButton(
          key: const Key('sua-log-luu'),
          onPressed: _luu,
          child: const Text(Chuoi.luu),
        ),
      ],
    );
  }
}

class _DlgSuaMon extends StatefulWidget {
  const _DlgSuaMon({required this.mon});

  final Food mon;

  @override
  State<_DlgSuaMon> createState() => _DlgSuaMonState();
}

class _DlgSuaMonState extends State<_DlgSuaMon> {
  late final TextEditingController _ten;
  late final TextEditingController _kcal;
  late final TextEditingController _gram;
  late final TextEditingController _dam;
  late final TextEditingController _bot;
  late final TextEditingController _beo;

  @override
  void initState() {
    super.initState();
    final m = widget.mon;
    _ten = TextEditingController(text: m.ten);
    _kcal = TextEditingController(text: '${m.kcal}');
    _gram = TextEditingController(text: m.gram == null ? '' : So.kg(m.gram!));
    _dam = TextEditingController(text: m.dam == null ? '' : So.kg(m.dam!));
    _bot = TextEditingController(text: m.bot == null ? '' : So.kg(m.bot!));
    _beo = TextEditingController(text: m.beo == null ? '' : So.kg(m.beo!));
  }

  @override
  void dispose() {
    _ten.dispose();
    _kcal.dispose();
    _gram.dispose();
    _dam.dispose();
    _bot.dispose();
    _beo.dispose();
    super.dispose();
  }

  void _luu() {
    FocusManager.instance.primaryFocus?.unfocus();
    final ten = _ten.text.trim();
    final kcal = So.parseKcal(_kcal.text);
    if (ten.isEmpty || kcal == null) return;
    Navigator.of(context, rootNavigator: true).pop(
      SuaMonKq(
        ten: ten,
        kcal: kcal,
        gram: So.parseG(_gram.text),
        dam: So.parseMacro(_dam.text),
        bot: So.parseMacro(_bot.text),
        beo: So.parseMacro(_beo.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Mau.beMat,
      scrollable: true,
      title: const Text(Chuoi.sua, style: TextStyle(color: Mau.muc)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            key: const Key('sua-ten-mon'),
            controller: _ten,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(hintText: Chuoi.taoCongThuc),
          ),
          const SizedBox(height: 8),
          TextField(
            key: const Key('sua-kcal-mon'),
            controller: _kcal,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(suffixText: 'kcal'),
          ),
          const SizedBox(height: 8),
          TextField(
            key: const Key('sua-gram-mon'),
            controller: _gram,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: Chuoi.khoiLuongG, suffixText: 'g'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _dam,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: Chuoi.dam, suffixText: 'g'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _bot,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: Chuoi.bot, suffixText: 'g'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _beo,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: Chuoi.beo, suffixText: 'g'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: const Text(Chuoi.huy),
        ),
        TextButton(
          key: const Key('sua-mon-luu'),
          onPressed: _luu,
          child: const Text(Chuoi.luu),
        ),
      ],
    );
  }
}

class ToTaoCongThuc extends StatefulWidget {
  const ToTaoCongThuc({super.key, required this.kho, this.ngay});

  final Kho kho;
  final DateTime? ngay;

  @override
  State<ToTaoCongThuc> createState() => _ToTaoCongThucState();
}

class _ToTaoCongThucState extends State<ToTaoCongThuc> {
  final _ten = TextEditingController();
  final _dan = TextEditingController();
  final _kcal = TextEditingController();
  final _gram = TextEditingController();
  final _dam = TextEditingController();
  final _bot = TextEditingController();
  final _beo = TextEditingController();
  bool _suaTay = false;

  Kho get kho => widget.kho;

  DateTime get _ngay => widget.ngay ?? kho.selected;

  bool get _khoa => !Ngay.ghiDuoc(_ngay, kho.homNay);

  @override
  void initState() {
    super.initState();
    _dan.addListener(_docDan);
  }

  void _ve() {
    if (mounted) setState(() {});
  }

  void _gan(TextEditingController c, String v) {
    if (c.text == v) return;
    c.value = TextEditingValue(
      text: v,
      selection: TextSelection.collapsed(offset: v.length),
    );
  }

  void _docDan() {
    if (_suaTay) {
      _ve();
      return;
    }
    final d = CongThuc.docMon(_dan.text);
    if (d.kcal != null) _gan(_kcal, '${d.kcal}');
    if (d.gram != null) _gan(_gram, So.kg(d.gram!));
    if (d.dam != null) _gan(_dam, So.kg(d.dam!));
    if (d.bot != null) _gan(_bot, So.kg(d.bot!));
    if (d.beo != null) _gan(_beo, So.kg(d.beo!));
    if (d.ten != null) _gan(_ten, d.ten!);
    _ve();
  }

  @override
  void dispose() {
    _dan.removeListener(_docDan);
    _ten.dispose();
    _dan.dispose();
    _kcal.dispose();
    _gram.dispose();
    _dam.dispose();
    _bot.dispose();
    _beo.dispose();
    super.dispose();
  }

  Future<void> _luu({required bool vaoNgay}) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final doc = CongThuc.docMon(_dan.text);
    final ten = (doc.ten ?? _ten.text).trim();
    final kcal = So.parseKcal(_kcal.text);
    if (ten.isEmpty || kcal == null) return;
    final gram = So.parseG(_gram.text);
    final dam = So.parseMacro(_dam.text);
    final bot = So.parseMacro(_bot.text);
    final beo = So.parseMacro(_beo.text);
    final van = _dan.text.trim();
    final ngay = _ngay;
    Navigator.pop(context);
    await kho.luuMon(
      ten: ten,
      kcal: kcal,
      gram: gram,
      vanBan: van.isEmpty ? null : van,
      dam: dam,
      bot: bot,
      beo: beo,
      vaoNgay: vaoNgay,
      ngay: ngay,
    );
  }

  @override
  Widget build(BuildContext context) {
    final doc = CongThuc.docMon(_dan.text);
    final coMon = doc.ten != null;
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.9,
        ),
        child: ListView(
          key: const Key('to-tao-cong-thuc'),
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            const Text(
              Chuoi.taoCongThuc,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Mau.muc),
            ),
            const SizedBox(height: 12),
            if (!coMon) ...[
              TextField(
                key: const Key('ten-mon'),
                controller: _ten,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(hintText: Chuoi.taoCongThuc),
              ),
              const SizedBox(height: 8),
            ],
            TextField(
              key: const Key('dan-chu'),
              controller: _dan,
              minLines: 4,
              maxLines: 8,
              decoration: const InputDecoration(hintText: Chuoi.danChuGrok),
            ),
            if (doc.kcal != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(Chuoi.docNKcal(doc.kcal!), style: const TextStyle(fontSize: 13, color: Mau.mo)),
              ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('doc-kcal'),
              controller: _kcal,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(suffixText: 'kcal'),
              onTap: () => _suaTay = true,
            ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('gram-mon'),
              controller: _gram,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(hintText: Chuoi.khoiLuongG, suffixText: 'g'),
              onTap: () => _suaTay = true,
            ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('dam-mon'),
              controller: _dam,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(hintText: Chuoi.dam, suffixText: 'g'),
              onTap: () => _suaTay = true,
            ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('bot-mon'),
              controller: _bot,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(hintText: Chuoi.bot, suffixText: 'g'),
              onTap: () => _suaTay = true,
            ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('beo-mon'),
              controller: _beo,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(hintText: Chuoi.beo, suffixText: 'g'),
              onTap: () => _suaTay = true,
            ),
            const SizedBox(height: 12),
            if (!_khoa)
              SizedBox(
                height: 44,
                child: FilledButton(
                  key: const Key('tinh-vao-ngay'),
                  onPressed: () => _luu(vaoNgay: true),
                  child: const Text(Chuoi.tinhVaoThucDon),
                ),
              ),
            if (!_khoa) const SizedBox(height: 8),
            SizedBox(
              height: 44,
              child: OutlinedButton(
                key: const Key('chi-luu-kho'),
                onPressed: () => _luu(vaoNgay: false),
                child: const Text(Chuoi.chiLuuKho),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ToMonDaLuu extends StatelessWidget {
  const ToMonDaLuu({super.key, required this.kho, this.ngay});

  final Kho kho;
  final DateTime? ngay;

  DateTime get _ngay => ngay ?? kho.selected;

  bool get _khoa => !Ngay.ghiDuoc(_ngay, kho.homNay);

  Future<void> _sua(BuildContext context, Food f) async {
    final kq = await moDlgSuaMon(context, f);
    if (kq == null) return;
    await Future<void>.delayed(Duration.zero);
    await kho.suaMon(
      id: f.id,
      ten: kq.ten,
      kcal: kq.kcal,
      gram: kq.gram,
      dam: kq.dam,
      bot: kq.bot,
      beo: kq.beo,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: kho,
      builder: (context, _) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.7,
            ),
            child: ListView(
              key: const Key('mon-da-luu'),
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                const Text(
                  Chuoi.monDaLuu,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Mau.muc),
                ),
                const SizedBox(height: 12),
                if (kho.dsMon.isEmpty)
                  const Text('—', style: TextStyle(color: Mau.mo))
                else
                  for (final f in kho.dsMon)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Material(
                        color: Mau.giay,
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                key: Key('mon-kho-${f.id}'),
                                onTap: _khoa ? null : () => kho.chonMon(f.id, ngay: _ngay),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(minHeight: 44),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        Chuoi.dongMon(f.ten, f.kcal, g: f.gram),
                                        style: const TextStyle(fontSize: 15, color: Mau.muc),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 44,
                              child: TextButton(
                                key: Key('sua-mon-kho-${f.id}'),
                                onPressed: () => _sua(context, f),
                                child: const Text(Chuoi.sua),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
          ),
        );
      },
    );
  }
}
