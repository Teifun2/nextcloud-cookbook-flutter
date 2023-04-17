part of 'services.dart';

class TimerList {
  factory TimerList() => _instance;

  TimerList._() : _timers = <Timer>[];
  static final TimerList _instance = TimerList._();
  final List<Timer> _timers;

  List<Timer> get timers => _timers;

  void add(Timer timer) {
    unawaited(NotificationService().start(timer));
    _timers.add(timer);
  }

  void remove(Timer timer) {
    unawaited(NotificationService().cancel(timer));
    _timers.remove(timer);
  }
}
