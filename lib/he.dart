import 'dart:math';

/// Công thức Hệ. Tính lúc đọc. Không persist sức tạm.
abstract final class He {
  static const napNgay = 200;
  static const expTick = 10;
  static const expCan = 10;
  static const kindHabit = 'habit';
  static const kindTap = 'tap';
  static const kindCan = 'can';
  static const kindLua = 'lua';

  static int canCap(int level) => 80 + level * 40;

  static int expTap(int kcal) {
    final k = kcal < 0 ? 0 : kcal;
    return 20 + k ~/ 25;
  }

  static int sucTam({
    required int luc,
    required int ben,
    required bool coKy,
  }) =>
      10 + luc * 2 + ben + (coKy ? 5 : 0);

  static ({int level, int exp, int unspent, int lan}) lenCap({
    required int level,
    required int exp,
    required int unspent,
  }) {
    var lv = level;
    var e = exp;
    var u = unspent;
    var n = 0;
    while (e >= canCap(lv)) {
      e -= canCap(lv);
      lv++;
      u += 3;
      n++;
    }
    return (level: lv, exp: e, unspent: u, lan: n);
  }

  static String xoay(List<String> pool, String? cuoi, Random r) {
    if (pool.isEmpty) return '';
    if (pool.length == 1) return pool.first;
    var i = r.nextInt(pool.length);
    var s = pool[i];
    if (s == cuoi) s = pool[(i + 1) % pool.length];
    return s;
  }

  static const cauLenCap = [
    'Cấp mới. Cơ thể nhớ.',
    'Bạn vừa vượt chính mình.',
    'Nặng hơn một bậc. Đứng vững.',
    'Sức không đến từ lời. Đến từ hôm nay.',
    'Cấp lên. Không quay lại.',
    'Một bước thật. Giữ lấy.',
    'Thân này vừa chắc hơn.',
    'Im. Rồi đi tiếp.',
    'Bạn đã chứng minh.',
    'Lửa còn. Đi tiếp.',
  ];

  static const cauKhichLe = [
    'Xong một việc. Còn hơi.',
    'Đúng nhịp. Giữ.',
    'Nhỏ nhưng thật.',
    'Hôm nay đang thành hình.',
    'Một lần. Một lần thắng.',
    'Không cần lớn. Cần đều.',
    'Cơ thể ghi nhận.',
    'Sạch. Gọn. Xong.',
    'Bạn đang xây Hệ.',
    'Ổn. Tiếp.',
    'Việc này thuộc về bạn.',
    'Không ồn. Chỉ làm.',
    'Đủ để đi tiếp.',
    'Nặng nhẹ không quan trọng. Đã làm.',
  ];

  static const cauLuaTang = 'Lửa vừa nối. Đừng để tắt.';

  static const manhPool = [
    'Có thứ đang lắng trong người. Chưa có tên.',
    'Hôm nay để lại một mảnh. Nhặt sau.',
    'Nhịp thở vừa đổi. Nhẹ thôi.',
    'Một góc tối vừa sáng hơn một tấc.',
    'Cơ thể biết. Đầu chưa kịp.',
    'Im lặng cũng là dấu. Giữ.',
    'Mảnh này không lớn. Nhưng thật.',
  ];
}

class HeTrangThai {
  const HeTrangThai({
    required this.level,
    required this.exp,
    required this.unspent,
    required this.luc,
    required this.ben,
    required this.chi,
    required this.tinh,
  });

  final int level;
  final int exp;
  final int unspent;
  final int luc;
  final int ben;
  final int chi;
  final int tinh;

  int get can => He.canCap(level);

  HeTrangThai copyWith({
    int? level,
    int? exp,
    int? unspent,
    int? luc,
    int? ben,
    int? chi,
    int? tinh,
  }) {
    return HeTrangThai(
      level: level ?? this.level,
      exp: exp ?? this.exp,
      unspent: unspent ?? this.unspent,
      luc: luc ?? this.luc,
      ben: ben ?? this.ben,
      chi: chi ?? this.chi,
      tinh: tinh ?? this.tinh,
    );
  }

  static const goc = HeTrangThai(
    level: 1,
    exp: 0,
    unspent: 0,
    luc: 0,
    ben: 0,
    chi: 0,
    tinh: 0,
  );
}

class HeQuest {
  const HeQuest({
    required this.kind,
    required this.refId,
    required this.ten,
    required this.xong,
  });

  final String kind;
  final int refId;
  final String ten;
  final bool xong;
}

class HeKy {
  const HeKy({
    required this.ten,
    required this.moTa,
    required this.hieuLuc,
  });

  final String ten;
  final String moTa;
  final bool hieuLuc;
}

class HeManh {
  const HeManh({required this.cau, required this.ngay});

  final String cau;
  final String ngay;
}
