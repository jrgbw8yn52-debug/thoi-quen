import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thoi_quen/chuoi.dart';
import 'package:thoi_quen/db/database.dart';
import 'package:thoi_quen/kho.dart';
import 'package:thoi_quen/ngay.dart';

void main() {
  late AppDatabase db;
  final goc = DateTime(2026, 8, 30);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('onCreate: 4 bang + profile id=1', () async {
    final bang = await db
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name",
        )
        .get();
    final ten = bang.map((r) => r.read<String>('name')).toSet();
    expect(ten.contains('habits'), isTrue);
    expect(ten.contains('ticks'), isTrue);
    expect(ten.contains('profile'), isTrue);
    expect(ten.contains('weigh_ins'), isTrue);
    expect(ten.contains('moc_can'), isTrue);
    expect(ten.contains('nap_ins'), isTrue);
    expect(ten.contains('foods'), isTrue);
    expect(ten.contains('food_log'), isTrue);

    final p = await db.docProfile();
    expect(p.id, 1);
    expect(p.activity, 1.2);
    expect(p.targetKg, isNull);
    expect(await db.canMoiNhat(), isNull);
  });

  test('schemaVersion = 12', () {
    expect(db.schemaVersion, 12);
  });

  test('ticks UNIQUE (habit_id, ngay)', () async {
    final id = await db.themHabit(ten: 'Dậy 6 giờ', createdOn: goc);
    await db.into(db.ticks).insert(
          TicksCompanion.insert(habitId: id!, ngay: '2026-08-30'),
        );
    await expectLater(
      db.into(db.ticks).insert(
            TicksCompanion.insert(habitId: id, ngay: '2026-08-30'),
          ),
      throwsA(isA<Exception>()),
    );
  });

  test('toggle tick roi hoan tac, ghi phut mac dinh', () async {
    final id = await db.themHabit(
      ten: 'Vận động',
      met: AppDatabase.metVanDong,
      phutMacDinh: AppDatabase.phutVanDong,
      createdOn: goc,
    );
    final h = (await db.dsHabit()).single;
    expect(h.met, 5.5);
    expect(h.phutMacDinh, 30);

    final ngay = DateTime(2026, 8, 30);
    await db.toggleTick(h, ngay);
    var ticks = await db.ticksNgay(ngay);
    expect(ticks.length, 1);
    expect(ticks.single.phut, 30);

    await db.toggleTick(h, ngay);
    ticks = await db.ticksNgay(ngay);
    expect(ticks, isEmpty);
    expect(id, isNotNull);
  });

  test('x/N thang nay khong dem thang khac', () async {
    await db.themHabit(ten: 'Đọc 20 trang', createdOn: goc);
    final h = (await db.dsHabit()).single;
    await db.toggleTick(h, DateTime(2026, 8, 1));
    await db.toggleTick(h, DateTime(2026, 8, 30));
    await db.toggleTick(h, DateTime(2026, 7, 31));
    final thang8 = await db.ticksThang(DateTime(2026, 8, 15));
    expect(thang8.length, 2);
  });

  test('toi da 8 habit', () async {
    for (var i = 0; i < 8; i++) {
      expect(await db.themHabit(ten: 'H$i', createdOn: goc), isNotNull);
    }
    expect(await db.themHabit(ten: 'H9', createdOn: goc), isNull);
    expect(await db.soHabit(), 8);
  });

  test('khong trung ten', () async {
    expect(await db.themHabit(ten: 'Dậy 6 giờ', createdOn: goc), isNotNull);
    expect(await db.themHabit(ten: ' dậy 6 giờ ', createdOn: goc), isNull);
    expect(await db.soHabit(), 1);
  });

  test('gop ten trung giu hang cu, gop tick', () async {
    final a = await db.themHabit(ten: 'A', createdOn: goc);
    await db.into(db.habits).insert(
          HabitsCompanion.insert(
            ten: 'A',
            taoLuc: goc,
          ),
        );
    expect(await db.soHabit(), 2);
    final ids = (await db.dsHabit()).map((h) => h.id).toList();
    final drop = ids.firstWhere((id) => id != a);
    await db.into(db.ticks).insert(
          TicksCompanion.insert(habitId: a!, ngay: '2026-08-30'),
        );
    await db.into(db.ticks).insert(
          TicksCompanion.insert(habitId: drop, ngay: '2026-08-29'),
        );
    await db.gopTenTrung();
    expect(await db.soHabit(), 1);
    final ticks = await db.ticksCuaHabit(a);
    expect(ticks.map((t) => t.ngay).toSet(), {'2026-08-29', '2026-08-30'});
  });

  test('khong bia 70 kg khi thieu can', () async {
    expect(await db.canMoiNhat(), isNull);
  });

  test('ghi can upsert theo ngay', () async {
    await db.ghiCan(DateTime(2026, 8, 30), 72.4);
    await db.ghiCan(DateTime(2026, 8, 30), 71.9);
    final ds = await db.dsCan();
    expect(ds.length, 1);
    expect(ds.single.kg, closeTo(71.9, 0.001));
  });

  test('watchHomeNgay chi ticks dung ngay, khong ca DB', () async {
    final id = await db.themHabit(ten: 'Dậy 6 giờ', createdOn: goc);
    final h = (await db.dsHabit()).single;
    await db.ghiTick(h, goc);
    await db.ghiTick(h, DateTime(2026, 8, 29));
    await db.ghiCan(goc, 70);
    final ev = await db.watchHomeNgay(Ngay.iso(goc)).first;
    expect(ev.$1.single.id, id);
    expect(ev.$2.map((t) => t.ngay).toSet(), {Ngay.iso(goc)});
  });

  test('tick chi ban home, khong lich tien do shell', () async {
    final kho = Kho(db, bayGio: DateTime(2026, 8, 30, 13));
    addTearDown(kho.dispose);
    await kho.tai();
    await kho.themPreset(ten: 'Dậy 6 giờ');
    var home = 0, lich = 0, tien = 0, shell = 0;
    kho.homeBan.addListener(() => home++);
    kho.lichBan.addListener(() => lich++);
    kho.tienDoBan.addListener(() => tien++);
    kho.shellBan.addListener(() => shell++);
    home = lich = tien = shell = 0;
    await kho.toggle(kho.hang.single);
    expect(home, greaterThan(0));
    expect(lich, 0);
    expect(tien, 0);
    expect(shell, 0);
    expect(kho.hang.single.ticked, isFalse);
  });

  test('xuat habit.sqlite, khoi phuc ticks, huy xoa giu data', () async {
    expect(AppDatabase.tenBanSao, 'habit.sqlite');
    final kho = Kho(db, bayGio: DateTime(2026, 8, 30, 13));
    addTearDown(kho.dispose);
    await kho.tai();
    await kho.themPreset(ten: 'Dậy 6 giờ');
    expect(kho.hang.single.ticked, isTrue);

    final dir = await Directory.systemTemp.createTemp('tq-xuat');
    addTearDown(() => dir.delete(recursive: true));
    final f = await kho.vietFileXuat(vao: dir);
    expect(f.uri.pathSegments.last, 'habit.sqlite');
    expect(await db.laSqlite(f.path), isTrue);

    final apk = AppDatabase(NativeDatabase.memory());
    addTearDown(apk.close);
    final k2 = Kho(apk, bayGio: DateTime(2026, 8, 30, 13));
    addTearDown(k2.dispose);
    await k2.tai();
    expect(k2.hang, isEmpty);
    expect(await k2.khoiPhucTuFile(f.path), isTrue);
    expect(k2.hang.single.habit.ten, 'Dậy 6 giờ');
    expect(k2.hang.single.ticked, isTrue);

    final n = k2.dsHien.length;
    // Huỷ = không gọi xoaDuLieu
    expect(k2.dsHien.length, n);
  });

  test('moTuNoti ve Home dung weekday noti', () async {
    final kho = Kho(db, bayGio: DateTime(2026, 8, 30, 13));
    addTearDown(kho.dispose);
    await kho.tai();
    kho.chonTab(2);
    kho.moTuNoti('7');
    expect(kho.tab, 0);
    expect(kho.selected, DateTime(2026, 8, 30));
    kho.moTuNoti('1');
    expect(kho.selected, DateTime(2026, 8, 24));
  });

  test('ho so du 4 field, can dich khong tinh; Pepsi 0 va banh bo 50 g', () async {
    final kho = Kho(db, bayGio: DateTime(2026, 8, 30, 13));
    addTearDown(kho.dispose);
    await kho.tai();
    expect(kho.dongTaiKhoan, contains(Chuoi.thieuChieuCao));
    expect(kho.dongTaiKhoan, contains(Chuoi.thieuGioi));
    expect(kho.dongTaiKhoan, isNot(equals(Chuoi.thieuDuLieu)));
    await kho.luuMucTieu(dich: '65', nhip: 0.5);
    expect(kho.dongTaiKhoan, contains(Chuoi.thieuChieuCao));
    await kho.luuHoSo(
      ten: 'A',
      cao: '170',
      sex: 'nam',
      dob: DateTime(1996, 1, 1),
      activity: 1.2,
      banDau: '70',
    );
    expect(kho.heightCm, 170);
    expect(kho.sex, 'nam');
    expect(kho.dob, '1996-01-01');
    expect(kho.startKg, 70);
    expect(kho.dongTaiKhoan, isNot(contains('Thiếu')));

    await kho.luuMon(ten: 'Pepsi', kcal: 0, gram: 330, vaoNgay: true);
    expect(kho.dsMon.single.kcal, 0);
    expect(kho.dsMon.single.gram, 330);
    expect(kho.logNgay(kho.selected).single.gram, 330);
    expect(kho.logNgay(kho.selected).single.kcal, 0);

    await kho.luuMon(ten: 'Bánh bò', kcal: 240, gram: 100, vaoNgay: false);
    final bb = kho.dsMon.firstWhere((f) => f.ten == 'Bánh bò');
    expect(bb.kcal, 240);
    expect(bb.gram, 100);
    await kho.chonMon(bb.id);
    final log100 = kho.logNgay(kho.selected).firstWhere((l) => l.ten == 'Bánh bò');
    expect(log100.kcal, 240);
    expect(await kho.suaLogGram(log100.id, 50), isTrue);
    final log50 = kho.logNgay(kho.selected).firstWhere((l) => l.ten == 'Bánh bò');
    expect(log50.kcal, 120);
    expect(log50.gram, 50);
    expect(kho.dsMon.firstWhere((f) => f.ten == 'Bánh bò').kcal, 240);
  });

  test('kho mon ABC va tim realtime chua ky tu', () async {
    final kho = Kho(db, bayGio: DateTime(2026, 8, 30, 13));
    addTearDown(kho.dispose);
    await kho.tai();
    await kho.luuMon(ten: 'Phở bò', kcal: 450);
    await kho.luuMon(ten: 'Cơm', kcal: 200);
    await kho.luuMon(ten: 'Bánh mì', kcal: 250);
    expect(kho.dsMon.map((f) => f.ten).toList(), ['Bánh mì', 'Cơm', 'Phở bò']);
    expect(kho.dsMonLoc('b').map((f) => f.ten).toList(), ['Bánh mì', 'Phở bò']);
    expect(kho.dsMonLoc('Cơ').map((f) => f.ten).toList(), ['Cơm']);
    expect(kho.dsMonLoc('xyz'), isEmpty);
  });

  test('apk trong khoi phuc file iOS: tick va mon con', () async {
    final tmp = await Directory.systemTemp.createTemp('tq-bs');
    addTearDown(() => tmp.delete(recursive: true));

    final iosFile = File('${tmp.path}/ios.sqlite');
    final ios = AppDatabase(NativeDatabase(iosFile));
    final hid = await ios.themHabit(ten: 'Dậy 6 giờ', createdOn: goc);
    await ios.into(ios.ticks).insert(
          TicksCompanion.insert(habitId: hid!, ngay: '2026-08-30'),
        );
    await ios.themMon(ten: 'Phở bò', kcal: 450, dam: 20, bot: 55, beo: 12);
    await ios.ghiLog(goc, ten: 'Phở bò', kcal: 450, dam: 20, bot: 55, beo: 12);
    final dump = '${tmp.path}/thoi-quen-ban-sao.sqlite';
    await ios.xuatVao(dump);
    await ios.close();

    expect(await db.dsHabit(), isEmpty);
    expect(await db.dsTick(), isEmpty);
    expect(await db.dsMon(), isEmpty);
    expect(await db.dsLog(), isEmpty);

    await db.khoiPhucTu(dump);

    expect((await db.dsHabit()).single.ten, 'Dậy 6 giờ');
    expect((await db.dsTick()).map((t) => t.ngay), ['2026-08-30']);
    expect((await db.dsMon()).single.ten, 'Phở bò');
    expect((await db.dsLog()).single.ten, 'Phở bò');
    expect((await db.dsLog()).single.kcal, 450);
  });

  test('khoi phuc thay het, khong gop', () async {
    final tmp = await Directory.systemTemp.createTemp('tq-thay');
    addTearDown(() => tmp.delete(recursive: true));

    await db.themHabit(ten: 'Cũ Android', createdOn: goc);
    await db.themMon(ten: 'Cơm', kcal: 200);

    final ios = AppDatabase(NativeDatabase(File('${tmp.path}/ios.sqlite')));
    final hid = await ios.themHabit(ten: 'Dậy 6 giờ', createdOn: goc);
    await ios.into(ios.ticks).insert(
          TicksCompanion.insert(habitId: hid!, ngay: '2026-08-29'),
        );
    await ios.themMon(ten: 'Phở', kcal: 450);
    final dump = '${tmp.path}/dump.sqlite';
    await ios.xuatVao(dump);
    await ios.close();

    await db.khoiPhucTu(dump);
    final tenH = (await db.dsHabit()).map((h) => h.ten).toList();
    expect(tenH, ['Dậy 6 giờ']);
    expect((await db.dsMon()).map((m) => m.ten), ['Phở']);
    expect(await db.dsTick(), isNotEmpty);
  });

  test('file khong sqlite khong xoa du lieu', () async {
    await db.themHabit(ten: 'Giữ', createdOn: goc);
    final tmp = await Directory.systemTemp.createTemp('tq-bad');
    addTearDown(() => tmp.delete(recursive: true));
    final bad = File('${tmp.path}/not.sqlite')..writeAsStringSync('hello');
    expect(await db.laSqlite(bad.path), isFalse);
    await expectLater(db.khoiPhucTu(bad.path), throwsA(isA<StateError>()));
    expect((await db.dsHabit()).single.ten, 'Giữ');
  });

  test('khoi phuc xong khong first-run rong', () async {
    final tmp = await Directory.systemTemp.createTemp('tq-fr');
    addTearDown(() => tmp.delete(recursive: true));
    final ios = AppDatabase(NativeDatabase(File('${tmp.path}/ios.sqlite')));
    final hid = await ios.themHabit(ten: 'Dậy 6 giờ', createdOn: goc);
    await ios.into(ios.ticks).insert(
          TicksCompanion.insert(habitId: hid!, ngay: '2026-08-30'),
        );
    await ios.themMon(ten: 'Phở', kcal: 450);
    final dump = '${tmp.path}/dump.sqlite';
    await ios.xuatVao(dump);
    await ios.close();

    final apk = AppDatabase(NativeDatabase.memory());
    addTearDown(apk.close);
    final kho = Kho(apk, bayGio: DateTime(2026, 8, 30, 13));
    await kho.tai();
    expect(kho.rong, isTrue);

    expect(await kho.khoiPhucTuFile(dump), isTrue);
    expect(kho.rong, isFalse);
    expect(kho.hang.single.ticked, isTrue);
    expect(kho.dsMon.single.ten, 'Phở');
  });
}
