import 'dart:ui' show Color;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'db/database.dart';
import 'thu.dart';

/// Nhắc local: chuông + màn khóa. Không AlarmKit, không server, không full-screen.
abstract final class Nhac {
  static const kenhId = 'habit_remind';
  static const kenhTen = 'Nhắc thói quen';
  static const kenhMoTa = 'Nhắc thói quen đúng giờ đã lưu.';

  static final _p = FlutterLocalNotificationsPlugin();
  static bool _ok = false;
  static void Function(String payload)? onBam;

  static Future<void> khoiTao({void Function(String payload)? bam}) async {
    onBam = bam ?? onBam;
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
    onBam?.call(p);
  }

  static Future<void> xuLyLanMo() async {
    try {
      final d = await _p.getNotificationAppLaunchDetails();
      if (d?.didNotificationLaunchApp == true) {
        final p = d?.notificationResponse?.payload;
        if (p != null && p.isNotEmpty) onBam?.call(p);
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

  static Future<void> dongBo(List<Habit> ds) async {
    if (!_ok) return;
    try {
      await _p.cancelAll();
      for (final h in ds) {
        final g = h.gioNhac;
        if (g == null) continue;
        for (final thu in Thu.tach(h.thuBit)) {
          await _dat(h, thu, g);
        }
      }
    } catch (_) {}
  }

  static Future<void> _dat(Habit h, int thu, int phut) async {
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
      color: Color(0xFFE85D04),
      fullScreenIntent: false,
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
    final khi = _lanSau(thu, phut);
    final id = h.id * 10 + thu;
    final payload = '$thu';
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

  static tz.TZDateTime _lanSau(int weekday, int phut) {
    final now = tz.TZDateTime.now(tz.local);
    var d = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      phut ~/ 60,
      phut % 60,
    );
    while (d.weekday != weekday || !d.isAfter(now)) {
      d = d.add(const Duration(days: 1));
    }
    return d;
  }
}
