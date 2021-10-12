import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/models/timer.dart';
import 'package:timer_builder/timer_builder.dart';

class AnimatedTimeProgressBar extends StatefulWidget {
  final Timer timer;

  const AnimatedTimeProgressBar({@required this.timer, Key key})
      : super(key: key);

  @override
  _AnimatedTimeProgressBarState createState() =>
      _AnimatedTimeProgressBarState(timer);
}

class _AnimatedTimeProgressBarState extends State<AnimatedTimeProgressBar>
    with TickerProviderStateMixin {
  AnimationController _controller;
  final Timer _timer;
  Tween<num> _timerTween;

  _AnimatedTimeProgressBarState(this._timer) {
    this._timerTween = Tween(
      begin: this._timer.progress(),
      end: 1.0,
    );
  }

  @override
  void initState() {
    super.initState();

    this._controller = AnimationController(
      duration: _timer.remaining(),
      vsync: this,
    );
    this._controller.forward();
  }

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_timer.progress() > 0) {
      return Container(
        child: Column(children: [
          TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "${_timer.remaining().inHours}:${(_timer.remaining().inMinutes + 1 % 60).toString().padLeft(2, "0")}"),
                Text(
                    "${_timer.done.hour.toString()}:${_timer.done.minute.toString().padLeft(2, "0")}"),
              ],
            );
          }),
          AnimatedBuilder(
            animation: this._controller,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: this._timerTween.evaluate(this._controller),
                semanticsLabel: _timer.title,
              );
            },
          ),
        ]),
      );
    } else {
      return Container(
        child: Text(translate('timer.done')),
      );
    }
  }
}
