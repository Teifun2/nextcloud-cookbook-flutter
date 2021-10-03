import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/timer.dart';

const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
  '1',
  'Cookbook',
  'Timer for the Cookbook',
  importance: Importance.high,
  priority: Priority.high,
  showWhen: false,
);

const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();
  int curId = 0;

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notification_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, iOS: null, macOS: null);

    // Notification was triggered and the user clicked on it
    Future selectNotification(String payload) async {
      // Map<String, dynamic> data = jsonDecode(payload);
      // We could e.g. show the recipe
    }
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    // Loading pending notifications an rebuild timers
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    pendingNotificationRequests.forEach((PendingNotificationRequest element) {
      Map<String, dynamic> data = jsonDecode(element.payload);
      Timer timer = Timer.fromJson(data, element.id);
      if (timer.id > this.curId) this.curId = timer.id;
    });

    // initialize Timezone Database
    tz.initializeTimeZones();
    tz.setLocalLocation(
        tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()));
  }

  int start(Timer timer) {
    this.curId++;
    timer.id = this.curId;
    flutterLocalNotificationsPlugin.zonedSchedule(this.curId, timer.title,
        timer.body, timer.done, platformChannelSpecifics,
        payload: jsonEncode(timer.toJson()),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: null);
    return this.curId;
  }

  cancel(Timer timer) {
    flutterLocalNotificationsPlugin.cancel(timer.id);
  }

  cancelAll() {
    flutterLocalNotificationsPlugin.cancelAll();
  }
}
