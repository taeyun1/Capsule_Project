import 'dart:developer';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final notification = FlutterLocalNotificationsPlugin();

class CapsuleNotificationService {
  Future<void> initializeTimeZone() async {
    tz.initializeTimeZones();
    final timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<void> initializeNotification() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await notification.initialize(
      initializationSettings,
    );
  }

  // medicineId값이 1이고 + 알람시간이 8시면 -> 1 + 0800 => 10800
  String alarmId(int medicineId, String alarmTime) {
    return medicineId.toString() + alarmTime.replaceAll(':', '');
  }

  // addNotifcication를 호출하면 permissionNotification가 있는지 물음
  Future<bool> addNotifcication({
    required int medicineId,
    required String alarmTimeStr,
    required String title, // HH:mm 약 먹을 시간이예요!
    required String body, // {약이름} 복약했다고 알려주세요!
  }) async {
    if (!await permissionNotification) {
      // permissionNotification이 false경우에는 다음 코드 읽지 않고 나가게 처리 (show native setting page)
      return false;
    }

    /// exception (예외처리)
    final now = tz.TZDateTime.now(tz.local);
    final alarmTime = DateFormat('HH:mm').parse(alarmTimeStr);

    // ex) 현제 29일 1:10분인데, 29일 1:09분 알림을 예약 할려고 하면 안되니까. 내 date값이 현재 시간(hour) 값보다 작거나 분(minute) 값이 작다면,
    //     now.day + 1 을 해줘서 오늘이 아닌 내일 30일 1:09분을 예약할 수 있도록 예외처리 설정
    final day = (alarmTime.hour < now.hour ||
            alarmTime.hour == now.hour && alarmTime.minute <= now.minute)
        ? now.day + 1
        : now.day;

    /// id
    // medicineId값이 1이고 + 알람시간이 8시면 -> 1 + 0800 => 10800
    String alarmTimeId = alarmId(medicineId, alarmTimeStr);

    /// add schedule notification
    final details = _notificationDetails(
      alarmTimeId, // unique
      title: title,
      body: body,
    );

    await notification.zonedSchedule(
      int.parse(alarmTimeId), // unique  (10)08:00 -> (10)800  ()안은 유니크한 id값
      title,
      body,
      tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        day,
        alarmTime.hour,
        alarmTime.minute,
      ),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: alarmTimeId,
    );
    // pendingNotificationIds를 반환
    log('[notification list] ${await pendingNotificationIds}');

    return true;
  }

  NotificationDetails _notificationDetails(
    String id, {
    required String title,
    required String body,
  }) {
    final android = AndroidNotificationDetails(
      id,
      title,
      channelDescription: body,
      importance: Importance.max,
      priority: Priority.max,
    );
    const ios = IOSNotificationDetails();

    return NotificationDetails(
      android: android,
      iOS: ios,
    );
  }

  // permissionNotification이 있는지 확인 (알림 권한)
  Future<bool> get permissionNotification async {
    // 안드로이드 일 때는 알림권한 기본값이 허용 이기때문에 true를 반환
    if (Platform.isAndroid) {
      return true;
      // IOS일 경우에는 권한이 있는지 묻고 없을 경우에는 false를 반환
    } else if (Platform.isIOS) {
      return await notification
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(alert: true, badge: true, sound: true) ??
          false;
      // 안드로이드와 IOS가 아닐경우는 false반환
    } else {
      return false;
    }
  }

  // 다중 알림 삭제
  Future<void> deleteMultipleAlarm(List<String> alarmIds) async {
    log('[before delete notification list] ${await pendingNotificationIds}'); // 삭제 전 리스트
    for (final alarmId in alarmIds) {
      final id = int.parse(alarmId);
      await notification.cancel(id);
    }
    log('[after delete notification list] ${await pendingNotificationIds}'); // 삭제 후 리스트
  }

  Future<List<int>> get pendingNotificationIds {
    final list = notification
        .pendingNotificationRequests()
        .then((value) => value.map((e) => e.id).toList());
    return list;
  }
}
