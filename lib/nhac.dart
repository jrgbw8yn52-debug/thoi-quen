import 'dart:ui' show Color;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'db/database.dart';
import 'thu.dart';

/// Nhắc local, không server. Android 13+ xin POST_NOTIFICATIONS + tạo channel.
abstract final class Nhac {
  static const kenhId = 'nhac';
  static const kenhTen = 'Nhắc';
  static const kenhMoTa = 'Nhắc thói quen trên máy này.';

  static final _p = FlutterLocalNotificationsPlugin();
  static bool _ok = false;

  static Future<void> khoiTao() async {
    try {
      tzdata.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
      const android = AndroidInitializationSettings('@drawable/ic_nhac');
      const ios = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestSoundPermission: true,
        requestBadgePermission: true,
      );
      await _p.initialize(
        const InitializationSettings(android: android, iOS: ios),
      );
      final a = _p.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await a?.createNotificationChannel(
        const AndroidNotificationChannel(
          kenhId,
          kenhTen,
          description: kenhMoTa,
          importance: Importance.defaultImportance,
        ),
      );
      await xinQuyen();
      _ok = true;
    } catch (_) {
      _ok = false;
    }
  }

  static Future<bool> xinQuyen() async {
    try {
      final a = _p.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final androidOk = await a?.requestNotificationsPermission() ?? true;
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
          await _p.zonedSchedule(
            h.id * 10 + thu,
            h.ten,
            '',
            _lanSau(thu, g),
            const NotificationDetails(
              android: AndroidNotificationDetails(
                kenhId,
                kenhTen,
                channelDescription: kenhMoTa,
                importance: Importance.defaultImportance,
                icon: '@drawable/ic_nhac',
                color: Color(0xFFE85D04),
              ),
              iOS: DarwinNotificationDetails(),
            ),
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          );
        }
      }
    } catch (_) {}
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
