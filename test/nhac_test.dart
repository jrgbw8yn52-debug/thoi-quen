import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thoi_quen/db/database.dart';
import 'package:thoi_quen/kho.dart';
import 'package:thoi_quen/nhac.dart';

void main() {
  setUp(Nhac.huyTest.clear);

  test('payload habit va focus, mo coi', () {
    expect(Nhac.idHabitPayload('12|3'), 12);
    expect(Nhac.idHabitPayload('f|4'), isNull);
    expect(Nhac.idHabitPayload(null), isNull);
    expect(Nhac.notiIdsHabit(12), [121, 122, 123, 124, 125, 126, 127]);
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

  test('tao habit co gio roi xoa moi pham vi: khong con noti', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final kho = Kho(db, bayGio: DateTime(2026, 9, 7, 8));
    addTearDown(kho.dispose);
    addTearDown(db.close);
    await kho.tai();
    await kho.themPreset(ten: 'Đi bộ', gioNhac: 5 * 60);
    final h = kho.dsHien.single;

    await kho.xoaKhoiNgay(h, kho.homNay);
    expect(Nhac.huyTest, containsAll(Nhac.notiIdsHabit(h.id)));

    Nhac.huyTest.clear();
    await kho.xoaKhoiTuanSau(h);
    expect(Nhac.huyTest, containsAll(Nhac.notiIdsHabit(h.id)));

    Nhac.huyTest.clear();
    await kho.xoaKhoiThangSau(h);
    expect(Nhac.huyTest, containsAll(Nhac.notiIdsHabit(h.id)));

    Nhac.huyTest.clear();
    await kho.anKhoiDs(h.id);
    expect(Nhac.huyTest, containsAll(Nhac.notiIdsHabit(h.id)));
    expect(kho.hienO(h, kho.homNay), isFalse);
    expect(kho.quetNotiMoCoi(), completes);
  });
}
