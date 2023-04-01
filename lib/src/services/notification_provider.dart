part of 'services.dart';

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
      tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()),
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notification_icon');

    Future onDidReceiveLocalNotification(
      int id,
      String? title,
      String? body,
      String? payload,
    ) async {
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
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

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
    for (final element in pendingNotificationRequests) {
      if (element.payload != null) {
        final data = jsonDecode(element.payload!) as Map<String, dynamic>;
        final timer = Timer.fromJson(data)..id = element.id;
        TimerList()._timers.add(timer);
        if (timer.id! > curId) curId = timer.id!;
      }
    }
  }

  void start(Timer timer) {
    timer.id = curId;

    _localNotifications.zonedSchedule(
      curId++,
      timer.title,
      timer.body,
      tz.TZDateTime.from(timer.done, tz.local),
      platformChannelSpecifics,
      payload: jsonEncode(timer.toJson()),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
    );
  }

  void cancel(Timer timer) {
    assert(
      timer.id != null,
      "The timer should have an ID. If not it probably wasn't started",
    );
    _localNotifications.cancel(timer.id!);
  }

  void cancelAll() {
    _localNotifications.cancelAll();
  }
}
