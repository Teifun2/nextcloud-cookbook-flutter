part of 'services.dart';

class TimerList {
  static final TimerList _instance = TimerList._();
  final List<Timer> _timers;

  factory TimerList() => _instance;

  TimerList._() : _timers = <Timer>[];

  List<Timer> get timers => _timers;

  void add(Timer timer) {
    NotificationService().start(timer);
    _timers.add(timer);
  }

  void remove(Timer timer) {
    NotificationService().cancel(timer);
    _timers.remove(timer);
  }
}
