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

/// Một hàm: done | done_override | locked_overdue | open.
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
    final han = DateTime(ngay.year, ngay.month, ngay.day)
        .add(Duration(minutes: gioNhac + 30));
    if (now.isAfter(han)) return HabitTrang.lockedOverdue;
  }
  return HabitTrang.open;
}
