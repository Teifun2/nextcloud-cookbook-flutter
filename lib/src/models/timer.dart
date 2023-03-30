import 'package:nextcloud_cookbook_flutter/src/services/services.dart';
import 'package:timezone/timezone.dart' as tz;

class TimerList {
  static final TimerList _instance = TimerList._();
  final List<Timer> timers;

  factory TimerList() => _instance;

  TimerList._() : timers = <Timer>[];

  List<Timer> get(String recipeId) {
    final List<Timer> l = <Timer>[];
    for (final value in timers) {
      if (value.recipeId == recipeId) l.add(value);
    }
    return l;
  }

  void clear() {
    timers.clear();
    NotificationService().cancelAll();
  }
}

class Timer {
  final String? title;
  final String body;
  final Duration duration;
  int id = 0;
  final tz.TZDateTime done;
  final String recipeId;

  Timer(
    this.recipeId,
    this.title,
    this.body,
    this.duration,
  ) : done = tz.TZDateTime.now(tz.local).add(duration);

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
    final Timer timer = Timer._restore(
      json['recipeId'] is String
          ? json['recipeId'] as String
          : json['recipeId'].toString(),
      json['title'] as String,
      json['body'] as String,
      Duration(minutes: json['duration'] as int),
      tz.TZDateTime.fromMicrosecondsSinceEpoch(tz.local, json['done'] as int),
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

  void start() {
    NotificationService().start(this);
  }

  // cancel the timer
  void cancel() {
    NotificationService().cancel(this);
    TimerList().timers.remove(this);
  }

  Duration remaining() {
    if (done.difference(tz.TZDateTime.now(tz.local)).isNegative) {
      return Duration.zero;
    } else {
      return done.difference(tz.TZDateTime.now(tz.local));
    }
  }

  double progress() {
    final Duration remainingTime = remaining();
    return remainingTime.inSeconds > 0
        ? 1 - (remainingTime.inSeconds / duration.inSeconds)
        : 1.0;
  }
}
