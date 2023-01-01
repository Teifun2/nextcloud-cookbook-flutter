import 'package:timezone/timezone.dart' as tz;

import '../services/notification_provider.dart';

class TimerList {
  static const TimerList _instance = TimerList._();
  final List<Timer> timers;

  factory TimerList() => _instance;

  const TimerList._() : timers = const <Timer>[];

  List<Timer> get(int recipeId) {
    List<Timer> l = <Timer>[];
    for (var value in this.timers) {
      if (value.recipeId == recipeId) l.add(value);
    }
    return l;
  }

  clear() {
    this.timers.clear();
    NotificationService().cancelAll();
  }
}

class Timer {
  final String? title;
  final String body;
  final Duration duration;
  int id = 0;
  final tz.TZDateTime done;
  final int recipeId;

  Timer(
    this.recipeId,
    this.title,
    this.body,
    this.duration, [
    tz.TZDateTime? done,
  ]) : this.done = tz.TZDateTime.now(tz.local).add(duration);

  // Restore Timer fom pending notification
  Timer._restore(
    this.recipeId,
    this.title,
    this.body,
    this.duration,
    this.done,
    this.id,
  );

  factory Timer.fromJson(Map<String, dynamic> json, int id) {
    Timer timer = Timer._restore(
      json['recipeId'],
      json['title'],
      json['body'],
      new Duration(minutes: json['duration']),
      tz.TZDateTime.fromMicrosecondsSinceEpoch(tz.local, json['done']),
      id,
    );
    TimerList().timers.add(timer);
    return timer;
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
        'duration': duration.inMinutes,
        'done': done.microsecondsSinceEpoch,
        'id': id,
        'recipeId': recipeId,
      };

  start() async {
    NotificationService().start(this);
  }

  // cancel the timer
  cancel() {
    NotificationService().cancel(this);
    TimerList().timers.remove(this);
  }

  Duration remaining() {
    if (this.done.difference(tz.TZDateTime.now(tz.local)).isNegative) {
      return Duration.zero;
    } else {
      return this.done.difference(tz.TZDateTime.now(tz.local));
    }
  }

  double progress() {
    Duration remainingTime = remaining();
    return remainingTime.inSeconds > 0
        ? 1 - (remainingTime.inSeconds / this.duration.inSeconds)
        : 1.0;
  }
}
