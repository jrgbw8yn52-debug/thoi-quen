import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thoi_quen/db/database.dart';
import 'package:thoi_quen/kho.dart';
import 'package:thoi_quen/ngay.dart';
import 'package:thoi_quen/nhac.dart';

void main() {
  setUp(() {
    Nhac.huyTest.clear();
    Nhac.lichTest.clear();
  });

  test('payload habit va focus, mo coi', () {
    expect(Nhac.idHabitPayload('12|3'), 12);
    expect(Nhac.idHabitPayload('f|4'), isNull);
    expect(Nhac.idHabitPayload(null), isNull);
    expect(
      Nhac.notiIdsHabit(12).take(7).toList(),
      [121, 122, 123, 124, 125, 126, 127],
    );
    final moi = Nhac.notiIdsHabit(1).skip(7).toSet();
    final cu = {
      for (var id = 1; id <= 40; id++) ...Nhac.notiIdsHabit(id).take(7),
    };
    expect(moi.intersection(cu), isEmpty);
    expect(Nhac.idLan(1, 0, 1), greaterThan(Nhac.idFocusGoc));
    expect(Nhac.idLan(1, 0, 1) < Nhac.idLan(2, 0, 1), isTrue);
    expect(
      Nhac.idCanHuy(
        [
          (id: 121, payload: '12|1'),
          (id: 500004, payload: 'f|4'),
          (id: 91, payload: '9|1'),
        ],
        {12},
      ),
      [91],
    );
  });

  test('lan nhac bo ngay loai tru', () {
    final now = DateTime(2026, 9, 7, 5);
    expect(
      Nhac.lanNhac(now: now, weekday: DateTime.monday, phut: 6 * 60),
      DateTime(2026, 9, 7, 6),
    );
    expect(
      Nhac.lanNhac(
        now: now,
        weekday: DateTime.monday,
        phut: 6 * 60,
        boNgay: {'2026-09-07'},
      ),
      DateTime(2026, 9, 14, 6),
    );
  });

  test('khong lap tuan: thang bi xoa khong co moc', () {
    final now = DateTime(2026, 9, 7, 8);
    final bo = <String>{};
    for (var d = DateTime(2026, 10, 1);
        d.month == 10;
        d = d.add(const Duration(days: 1))) {
      if (d.weekday == DateTime.monday) bo.add(Ngay.iso(d));
    }
    final ds = Nhac.keHoach(
      ds: [(id: 1, ten: 'Đi', gioNhac: 6 * 60, thuBit: '1')],
      now: now,
      boNgay: {1: bo},
    );
    final iso = ds.map((e) => Ngay.iso(e.khi)).toList();
    expect(iso.any((s) => s.startsWith('2026-10')), isFalse);
    expect(iso, contains('2026-09-14'));
    expect(iso.length, Nhac.soTuan);
    expect(ds.every((e) => e.tuan >= 0 && e.tuan < Nhac.soTuan), isTrue);
  });

  test('tao habit co gio roi xoa moi pham vi: khong con noti', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final kho = Kho(db, bayGio: DateTime(2026, 9, 7, 8));
    addTearDown(kho.dispose);
    addTearDown(db.close);
    await kho.tai();
    await kho.themPreset(ten: 'Đi bộ', gioNhac: 5 * 60);
    final h = kho.dsHien.single;

    await kho.xoaKhoiNgay(h, DateTime(2026, 9, 8));
    expect(Nhac.huyTest, containsAll(Nhac.notiIdsHabit(h.id)));
    expect(Nhac.lichTest.any((e) => e.ngay == '2026-09-08'), isFalse);
    expect(Nhac.lichTest.any((e) => e.habitId == h.id), isTrue);

    Nhac.huyTest.clear();
    await kho.xoaKhoiTuanSau(h);
    expect(Nhac.huyTest, containsAll(Nhac.notiIdsHabit(h.id)));

    Nhac.huyTest.clear();
    await kho.xoaKhoiThangSau(h);
    expect(Nhac.huyTest, containsAll(Nhac.notiIdsHabit(h.id)));

    Nhac.huyTest.clear();
    await kho.anKhoiDs(h.id);
    expect(Nhac.huyTest, containsAll(Nhac.notiIdsHabit(h.id)));
    final moi = kho.dsHien.firstWhere((x) => x.id == h.id);
    expect(kho.hienO(moi, kho.homNay), isFalse);
    expect(Nhac.lichTest.where((e) => e.habitId == h.id), isEmpty);
    expect(kho.quetNotiMoCoi(), completes);
  });
}