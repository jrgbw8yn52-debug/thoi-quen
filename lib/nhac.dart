import 'dart:ui' show Color;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'db/database.dart';
import 'ngay.dart';
import 'thu.dart';

@pragma('vm:entry-point')
void nhacNen(NotificationResponse r) {
  // UI isolate xử lý Xong qua onDidReceiveNotificationResponse.
}

/// Nhắc local: chuông + màn khóa. Không AlarmKit, không server, không full-screen.
abstract final class Nhac {
  static const kenhId = 'habit_remind';
  static const kenhTen = 'Nhắc thói quen';
  static const kenhMoTa = 'Nhắc thói quen đúng giờ đã lưu.';
  static const prefixFocus = 'f|';
  static const idFocusGoc = 500000;

  static String payloadFocus(int id) => '$prefixFocus$id';

  static int? idFocusTu(String p) {
    if (!p.startsWith(prefixFocus)) return null;
    return int.tryParse(p.substring(prefixFocus.length));
  }

  static int notiIdFocus(int id) => idFocusGoc + id;

  static final _p = FlutterLocalNotificationsPlugin();
  static bool _ok = false;
  static void Function(String payload)? onBam;
  static void Function(String payload)? onXong;

  static Future<void> khoiTao({
    void Function(String payload)? bam,
    void Function(String payload)? xong,
  }) async {
    onBam = bam ?? onBam;
    onXong = xong ?? onXong;
    try {
      tzdata.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
      const android = AndroidInitializationSettings('@drawable/ic_nhac');
      const ios = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestSoundPermission: false,
        requestBadgePermission: false,
        defaultPresentAlert: true,
        defaultPresentSound: true,
        defaultPresentBanner: true,
        defaultPresentList: true,
      );
      await _p.initialize(
        const InitializationSettings(android: android, iOS: ios),
        onDidReceiveNotificationResponse: _nhanBam,
        onDidReceiveBackgroundNotificationResponse: nhacNen,
      );
      final a = _p.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await a?.createNotificationChannel(
        const AndroidNotificationChannel(
          kenhId,
          kenhTen,
          description: kenhMoTa,
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
          showBadge: true,
        ),
      );
      _ok = true;
    } catch (_) {
      _ok = false;
    }
  }

  static void _nhanBam(NotificationResponse r) {
    final p = r.payload;
    if (p == null || p.isEmpty) return;
    if (r.actionId == 'xong') {
      onXong?.call(p);
      return;
    }
    onBam?.call(p);
  }

  static Future<void> xuLyLanMo() async {
    try {
      final d = await _p.getNotificationAppLaunchDetails();
      if (d?.didNotificationLaunchApp != true) return;
      final r = d?.notificationResponse;
      final p = r?.payload;
      if (p == null || p.isEmpty) return;
      if (r?.actionId == 'xong') {
        onXong?.call(p);
      } else {
        onBam?.call(p);
      }
    } catch (_) {}
  }

  /// First-run / lần đầu bật giờ habit. Tắt thông báo hệ thống thì OS không đánh thức.
  static Future<bool> xinQuyen() async {
    try {
      final a = _p.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final androidOk = await a?.requestNotificationsPermission() ?? true;
      try {
        await a?.requestExactAlarmsPermission();
      } catch (_) {}
      final i = _p.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      final iosOk = await i?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          true;
      return androidOk && iosOk;
    } catch (_) {
      return false;
    }
  }

  static Future<void> dongBo(
    List<Habit> ds, {
    Set<int> boHomNay = const {},
    List<FocusTask> focus = const [],
  }) async {
    if (!_ok) return;
    try {
      await _p.cancelAll();
      final thuHom = tz.TZDateTime.now(tz.local).weekday;
      for (final h in ds) {
        final g = h.gioNhac;
        if (g == null) continue;
        for (final thu in Thu.tach(h.thuBit)) {
          await _dat(
            h,
            thu,
            g,
            boHomNay: boHomNay.contains(h.id) && thu == thuHom,
          );
        }
      }
      for (final t in focus) {
        await _datFocus(t);
      }
    } catch (_) {}
  }

  static Future<void> _dat(
    Habit h,
    int thu,
    int phut, {
    bool boHomNay = false,
  }) async {
    const android = AndroidNotificationDetails(
      kenhId,
      kenhTen,
      channelDescription: kenhMoTa,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      visibility: NotificationVisibility.public,
      category: AndroidNotificationCategory.reminder,
      icon: '@drawable/ic_nhac',
      color: Color(0xFFFF7A00),
      fullScreenIntent: false,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'xong',
          'Xong',
          showsUserInterface: true,
          cancelNotification: true,
        ),
      ],
    );
    const ios = DarwinNotificationDetails(
      presentAlert: true,
      presentBanner: true,
      presentList: true,
      presentSound: true,
      sound: 'default',
      interruptionLevel: InterruptionLevel.active,
    );
    const details = NotificationDetails(android: android, iOS: ios);
    final khi = _lanSau(thu, phut, boHomNay: boHomNay);
    final id = h.id * 10 + thu;
    final payload = '${h.id}|$thu';
    try {
      await _p.zonedSchedule(
        id,
        h.ten,
        '',
        khi,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: payload,
      );
    } catch (_) {
      await _p.zonedSchedule(
        id,
        h.ten,
        '',
        khi,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: payload,
      );
    }
  }

  static Future<void> _datFocus(FocusTask t) async {
    if (t.done) return;
    final d = Ngay.parse(t.ngay);
    final khi = tz.TZDateTime(
      tz.local,
      d.year,
      d.month,
      d.day,
      t.gioPhut ~/ 60,
      t.gioPhut % 60,
    );
    if (!khi.isAfter(tz.TZDateTime.now(tz.local))) return;
    const android = AndroidNotificationDetails(
      kenhId,
      kenhTen,
      channelDescription: kenhMoTa,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      visibility: NotificationVisibility.public,
      category: AndroidNotificationCategory.reminder,
      icon: '@drawable/ic_nhac',
      color: Color(0xFFFF7A00),
      fullScreenIntent: false,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'xong',
          'Xong',
          showsUserInterface: true,
          cancelNotification: true,
        ),
      ],
    );
    const ios = DarwinNotificationDetails(
      presentAlert: true,
      presentBanner: true,
      presentList: true,
      presentSound: true,
      sound: 'default',
      interruptionLevel: InterruptionLevel.active,
    );
    const details = NotificationDetails(android: android, iOS: ios);
    final payload = payloadFocus(t.id);
    try {
      await _p.zonedSchedule(
        notiIdFocus(t.id),
        t.title,
        '',
        khi,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
    } catch (_) {
      await _p.zonedSchedule(
        notiIdFocus(t.id),
        t.title,
        '',
        khi,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: payload,
      );
    }
  }

  static tz.TZDateTime _lanSau(
    int weekday,
    int phut, {
    bool boHomNay = false,
  }) {
    final now = tz.TZDateTime.now(tz.local);
    var d = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      phut ~/ 60,
      phut % 60,
    );
    final hom = tz.TZDateTime(tz.local, now.year, now.month, now.day);
    while (d.weekday != weekday ||
        !d.isAfter(now) ||
        (boHomNay &&
            d.year == hom.year &&
            d.month == hom.month &&
            d.day == hom.day)) {
      d = d.add(const Duration(days: 1));
    }
    return d;
  }
}
