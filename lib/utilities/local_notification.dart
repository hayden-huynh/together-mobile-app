import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class LocalNotification {
  static final FlutterLocalNotificationsPlugin localNotiPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> setLocalTimeZone() async {
    initializeTimeZones();
    final String localZone = await FlutterNativeTimezone.getLocalTimezone();
    setLocalLocation(getLocation(localZone));
  }

  static Future<void> initializeLocalNotificationPlugin(
      BuildContext context) async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@drawable/notification_icon');
    final IOSInitializationSettings iOSSettings = IOSInitializationSettings(
      onDidReceiveLocalNotification: (
        int id,
        String title,
        String body,
        String payload,
      ) async {
        showDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('OK'),
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  await Navigator.of(context).pushReplacementNamed("/");
                },
              )
            ],
          ),
        );
      },
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );
    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );
    await localNotiPlugin.initialize(
      initSettings,
      onSelectNotification: (_) async {
        await Navigator.of(context).pushReplacementNamed("/");
      },
    );
  }

  /// Immediately show a notification with the given title and body
  static Future<void> showNotification(String title, String body) async {
    await localNotiPlugin.show(
      9,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'immediate-notification',
          'Immediate Notification',
          'Show a notification immediately',
          importance: Importance.max,
          priority: Priority.max,
          enableVibration: true,
          playSound: true,
        ),
        iOS: IOSNotificationDetails(
          presentAlert: true,
          presentSound: true,
          subtitle: body,
          presentBadge: null,
        ),
      ),
    );
  }

  /// Create the TZDateTime object to schedule a notification
  /// The scheduled time is set to this year, this month, this day, at the hour passed in
  /// If the hour is already in the past, add 1 day to schedule for the day following
  static TZDateTime _setScheduledTime(int hour) {
    final TZDateTime now = TZDateTime.now(local);
    TZDateTime scheduledTime =
        TZDateTime(local, now.year, now.month, now.day, hour);
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }
    return scheduledTime;
  }

  /// Schedule a notification at the hour "atHour" during the day
  static Future<void> scheduleNotification({int id, int atHour}) async {
    await localNotiPlugin.zonedSchedule(
      id,
      'Check-in: Questionnaire Time',
      'It is time to take your $atHour:00 questionnaire!',
      _setScheduledTime(atHour),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'checkin-questionnaire',
          'Check-in Notifications',
          'Notifications daily, at specific points throughout the day, each with two hours in between',
          importance: Importance.max,
          priority: Priority.max,
          enableVibration: true,
          playSound: true,
        ),
        iOS: IOSNotificationDetails(
          presentAlert: true,
          presentSound: true,
          subtitle: "It is time to take your next questionnaire!",
          presentBadge: null,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
