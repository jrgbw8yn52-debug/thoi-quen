enum HabitTrang { done, doneOverride, lockedOverdue, open }

extension HabitTrangX on HabitTrang {
  /// Tick thật hoặc override — tính vào n/m.
  bool get daLam => this == HabitTrang.done || this == HabitTrang.doneOverride;

  /// Chỉ tick tay — chuỗi lửa.
  bool get tickThat => this == HabitTrang.done;

  bool get choTick => this == HabitTrang.open || this == HabitTrang.done;

  bool get gach =>
      this == HabitTrang.doneOverride || this == HabitTrang.lockedOverdue;

  bool get quaGio => this == HabitTrang.lockedOverdue;

  bool get khoa =>
      this == HabitTrang.lockedOverdue || this == HabitTrang.doneOverride;
}

/// Widget Việc: now ∈ [giờ − 2 giờ, giờ + 1 giờ].
bool trongCuaSoWid({
  required int gioPhut,
  required DateTime ngay,
  required DateTime now,
}) {
  final moc = DateTime(ngay.year, ngay.month, ngay.day)
      .add(Duration(minutes: gioPhut));
  final a = moc.subtract(const Duration(hours: 2));
  final b = moc.add(const Duration(hours: 1));
  return !now.isBefore(a) && !now.isAfter(b);
}

/// Một hàm: done | done_override | locked_overdue | open.
/// Có giờ: khóa «Quá giờ» sau 0h ngày hôm sau. Cùng ngày vẫn tick.
HabitTrang habitState({
  required int? gioNhac,
  required bool ticked,
  required bool override,
  required DateTime ngay,
  required DateTime now,
}) {
  if (ticked) return HabitTrang.done;
  if (override) return HabitTrang.doneOverride;
  if (gioNhac != null) {
    final hetNgay = DateTime(ngay.year, ngay.month, ngay.day + 1);
    if (!now.isBefore(hetNgay)) return HabitTrang.lockedOverdue;
  }
  return HabitTrang.open;
}
