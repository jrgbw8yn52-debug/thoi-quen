enum HabitTrang { done, doneOverride, lockedOverdue, open }

/// done | done_override | locked_overdue | open
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
