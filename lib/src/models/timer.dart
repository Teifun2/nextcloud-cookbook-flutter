import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../util/notification_service.dart';

class TimerList {
  static final TimerList _timerList =
  TimerList._internal();
  List<Timer> timers = <Timer>[];

  factory TimerList() {
    return _timerList;
  }

  TimerList._internal();

  List<Timer> get(int recipeId) {
    List<Timer> l = <Timer>[];
    for (var value in this.timers) {
      if (value.recipeId == recipeId)
        l.add(value);
    }
    return l;
  }

  clear() {
    this.timers.clear();
    NotificationService().cancelAll();
  }
}

class Timer {
  final String title;
  final String body;
  final Duration duration;
  int id;
  tz.TZDateTime done;
  final int recipeId;

  Timer(this.recipeId, this.title, this.body, this.duration, [tz.TZDateTime done]) {
    tz.initializeTimeZones();
    this.done = tz.TZDateTime.now(tz.local).add(this.duration);
    TimerList().timers.add(this);
  }

  // Restore Timer fom pending notification
  Timer.restore(this.recipeId, this.title, this.body, this.duration, this.done, this.id) {
    TimerList().timers.add(this);
  }
  factory Timer.fromJson(Map<String, dynamic> json, int id) {
    tz.initializeTimeZones();
    return Timer.restore(
        json['recipeId'],
        json['title'],
        json['body'],
        new Duration(minutes: json['duration']),
        tz.TZDateTime.fromMicrosecondsSinceEpoch(tz.local, json['done']),
        id
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'body': body,
    'duration': duration.inMinutes,
    'done': done.microsecondsSinceEpoch,
    'id': id,
    'recipeId': recipeId,
  };

  show() async {
    NotificationService().start(this);
  }

  // cancel the timer
  cancel() {
    NotificationService().cancel(this);
    TimerList().timers.remove(this);
  }

  // calculate progress
  double progress() {
    Duration left = this.done.difference(tz.TZDateTime.now(tz.local));
    return left.inMinutes > 0 ? 1 - (left.inMinutes / this.duration.inMinutes) : 0.0;
  }

  String remaining() {
    Duration left = this.done.difference(tz.TZDateTime.now(tz.local));
    return "${left.inHours}:${left.inMinutes % 60 < 10 ? "0" : ""}${left.inMinutes % 60} h";
  }

  String endingTime() {
    return done.hour.toString() + ":" + done.minute.toString().padLeft(2, "0");
  }
}