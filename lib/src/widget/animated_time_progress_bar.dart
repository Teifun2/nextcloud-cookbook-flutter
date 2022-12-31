import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/models/timer.dart';

class AnimatedTimeProgressBar extends StatefulWidget {
  final Timer timer;

  const AnimatedTimeProgressBar({
    super.key,
    required this.timer,
  });

  @override
  _AnimatedTimeProgressBarState createState() =>
      _AnimatedTimeProgressBarState(timer);
}

class _AnimatedTimeProgressBarState extends State<AnimatedTimeProgressBar>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final Timer _timer;
  late Tween<num> _timerTween;

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

    this._controller.forward().whenCompleteOrCancel(() {});
  }

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: this._controller,
        child: Container(),
        builder: (context, child) {
          if (_controller.isCompleted) {
            return Container(child: Text(translate('timer.done')));
          }

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      "${_timer.remaining().inHours.toString().padLeft(2, '0')}:${_timer.remaining().inMinutes.remainder(60).toString().padLeft(2, '0')}:${(_timer.remaining().inSeconds.remainder(60)).toString().padLeft(2, '0')}"),
                  Text(
                      "${_timer.duration.inHours.toString().padLeft(2, '0')}:${_timer.duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(_timer.duration.inSeconds.remainder(60)).toString().padLeft(2, '0')}"),
                ],
              ),
              LinearProgressIndicator(
                value: this._timerTween.evaluate(this._controller) as double?,
                semanticsLabel: _timer.title,
              )
            ],
          );
        });
  }
}
