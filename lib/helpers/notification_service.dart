import 'dart:async';
import 'dart:convert';
import 'dart:io';
// ignore: unnecessary_import
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as image;
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../providers/tasks.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

const String portName = 'notification_send_port';

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

String? selectedNotificationPayload;

/// A notification action which triggers a url launch event
const String urlLaunchActionId = 'id_1';

/// A notification action which triggers a App navigation event
const String navigationActionId = 'id_3';

/// Defines a iOS/MacOS notification category for text input actions.
const String darwinNotificationCategoryText = 'textCategory';

/// Defines a iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

int notificationId = 0;

Future<void> configureLocalTimeZone() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}

Future<void> cancelPendingNotificationRequestsWithTaskPayload() async {
  final List<PendingNotificationRequest> pendingNotificationRequests =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  print('cancelPendingNotificationRequestsWithTaskPayload');
  for (final PendingNotificationRequest pendingNotificationRequest
      in pendingNotificationRequests) {
    if (isTask(pendingNotificationRequest.payload ?? '')) {
      print('delete 1 ne');
      await flutterLocalNotificationsPlugin
          .cancel(pendingNotificationRequest.id);
    } else {
      print(pendingNotificationRequest.payload);
    }
  }
}

// cancel pending notifications request with payload equal to task
Future<bool> cancelPendingNotificationRequestsWithTag(Task task) async {
  print('cancelPendingNotificationRequestsWithTag');
  //checkPendingNotificationRequests();
  // print(task.description);
  await flutterLocalNotificationsPlugin
      .pendingNotificationRequests()
      .then((pendingNotificationRequests) async {
    for (final PendingNotificationRequest pendingNotificationRequest
        in pendingNotificationRequests) {
      Task currentTask = taskFromString(pendingNotificationRequest.payload!);
      print(currentTask.startTime);

      if (currentTask.field == task.field &&
          currentTask.course == task.course &&
          currentTask.stage == task.stage &&
          currentTask.startTime == task.startTime &&
          currentTask.endTime == task.endTime) {
        print('delete 1 ne');
        await flutterLocalNotificationsPlugin
            .cancel(pendingNotificationRequest.id);
        return true;
      }
    }
  });
  return false;
}

Future<void> zonedScheduleNotification(
    {int id = 0,
    String title = '',
    String body = '',
    required Task payload,
    required DateTime scheduledDate}) async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      payload: jsonEncode(payload.toJson()),
      const NotificationDetails(
          android: AndroidNotificationDetails(
              'your channel id', 'your channel name',
              channelDescription: 'your channel description')),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);
}

Future<void> checkPendingNotificationRequests() async {
  final List<PendingNotificationRequest> pendingNotificationRequests =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  pendingNotificationRequests.forEach((PendingNotificationRequest p) async {
    // ignore: avoid_print
    print(p.payload);

    //await flutterLocalNotificationsPlugin.cancel(p.id);
  });
  notificationId = pendingNotificationRequests.length;
  print('notificationId: $notificationId');
}

Future<void> _showNotification() async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails('your channel id', 'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      notificationId++, 'plain title', 'plain body', notificationDetails,
      payload: 'item x');
}

Future<void> _cancelNotificationWithTag() async {
  await flutterLocalNotificationsPlugin.cancel(--notificationId, tag: 'tag');
}

Future<void> _zonedScheduleAlarmClockNotification() async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      123,
      'scheduled alarm clock title',
      'scheduled alarm clock body',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      const NotificationDetails(
          android: AndroidNotificationDetails(
              'alarm_clock_channel', 'Alarm Clock Channel',
              channelDescription: 'Alarm Clock Notification')),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);
}

Future<void> _cancelAllNotifications() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

Future<void> _showOngoingNotification() async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails('your channel id', 'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ongoing: true,
          autoCancel: false);
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      notificationId++,
      'ongoing notification title',
      'ongoing notification body',
      notificationDetails);
}

Future<void> _repeatNotification() async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
          'repeating channel id', 'repeating channel name',
          channelDescription: 'repeating description');
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.periodicallyShow(
    notificationId++,
    'repeating title',
    'repeating body',
    RepeatInterval.everyMinute,
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  );
}

Future<void> _scheduleDailyTenAMNotification() async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'daily scheduled notification title',
      'daily scheduled notification body',
      _nextInstanceOfTenAM(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'daily notification channel id', 'daily notification channel name',
            channelDescription: 'daily notification description'),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time);
}

/// To test we don't validate past dates when using `matchDateTimeComponents`
Future<void> _scheduleDailyTenAMLastYearNotification() async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'daily scheduled notification title',
      'daily scheduled notification body',
      _nextInstanceOfTenAMLastYear(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'daily notification channel id', 'daily notification channel name',
            channelDescription: 'daily notification description'),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time);
}

Future<void> _scheduleWeeklyTenAMNotification() async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'weekly scheduled notification title',
      'weekly scheduled notification body',
      _nextInstanceOfTenAM(),
      const NotificationDetails(
        android: AndroidNotificationDetails('weekly notification channel id',
            'weekly notification channel name',
            channelDescription: 'weekly notificationdescription'),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
}

Future<void> _scheduleWeeklyMondayTenAMNotification() async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'weekly scheduled notification title',
      'weekly scheduled notification body',
      _nextInstanceOfMondayTenAM(),
      const NotificationDetails(
        android: AndroidNotificationDetails('weekly notification channel id',
            'weekly notification channel name',
            channelDescription: 'weekly notificationdescription'),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
}

Future<void> _scheduleMonthlyMondayTenAMNotification() async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'monthly scheduled notification title',
      'monthly scheduled notification body',
      _nextInstanceOfMondayTenAM(),
      const NotificationDetails(
        android: AndroidNotificationDetails('monthly notification channel id',
            'monthly notification channel name',
            channelDescription: 'monthly notificationdescription'),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime);
}

tz.TZDateTime _nextInstanceOfTenAM() {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

tz.TZDateTime _nextInstanceOfTenAMLastYear() {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  return tz.TZDateTime(tz.local, now.year - 1, now.month, now.day, 10);
}

tz.TZDateTime _nextInstanceOfMondayTenAM() {
  tz.TZDateTime scheduledDate = _nextInstanceOfTenAM();
  while (scheduledDate.weekday != DateTime.monday) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

Future<void> _showNotificationWithSubtitle() async {
  const DarwinNotificationDetails darwinNotificationDetails =
      DarwinNotificationDetails(
    subtitle: 'the subtitle',
  );
  const NotificationDetails notificationDetails = NotificationDetails(
      iOS: darwinNotificationDetails, macOS: darwinNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      notificationId++,
      'title of notification with a subtitle',
      'body of notification with a subtitle',
      notificationDetails,
      payload: 'item x');
}
