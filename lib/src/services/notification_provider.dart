import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/timer.dart';

const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
  '1',
  'Cookbook',
  channelDescription: 'Timer for the Cookbook',
  importance: Importance.high,
  priority: Priority.high,
  showWhen: false,
);

const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

final FlutterLocalNotificationsPlugin _localNotifications =
    FlutterLocalNotificationsPlugin();

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._();
  int curId = 0;

  factory NotificationService() => _notificationService;

  NotificationService._();

  Future<void> init() async {
    // initialize Timezone Database
    tz.initializeTimeZones();
    tz.setLocalLocation(
        tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()));

    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notification_icon');

    Future onDidReceiveLocalNotification(
        int id, String? title, String? body, String? payload) async {
      // display a dialog with the notification details, tap ok to go to another page
      /* showDialog(
        // context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title!),
          content: Text(body!),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
              },
            )
          ],
        ),
      ); */
    }

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    // Notification was triggered and the user clicked on it
    Future selectNotification(NotificationResponse payload) async {
      // Map<String, dynamic> data = jsonDecode(payload);
      // We could e.g. show the recipe
    }
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: selectNotification,
    );

    // Loading pending notifications an rebuild timers
    final pendingNotificationRequests =
        await _localNotifications.pendingNotificationRequests();
    pendingNotificationRequests.forEach((PendingNotificationRequest element) {
      if (element.payload != null) {
        Map<String, dynamic> data = jsonDecode(element.payload!);
        Timer timer = Timer.fromJson(data, element.id);
        if (timer.id > this.curId) this.curId = timer.id;
      }
    });
  }

  int start(Timer timer) {
    this.curId++;
    timer.id = this.curId;
    _localNotifications.zonedSchedule(this.curId, timer.title, timer.body,
        timer.done, platformChannelSpecifics,
        payload: jsonEncode(timer.toJson()),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime);
    return this.curId;
  }

  cancel(Timer timer) {
    _localNotifications.cancel(timer.id);
  }

  cancelAll() {
    _localNotifications.cancelAll();
  }
}
