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

    this._controller.forward().whenCompleteOrCancel(() {
      print("Completed Animation Controller???");
    });

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
      builder: (context, child){
        if(_controller.isCompleted){
          return Container(child: Text(translate('timer.done')));
        }

        return Column(
          children: [
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${_timer.remaining().inHours.toString().padLeft(2, '0')}:${_timer.remaining().inMinutes.remainder(60).toString().padLeft(2, '0')}:${(_timer.remaining().inSeconds.remainder(60)).toString().padLeft(2, '0')}"),
                  Text("${_timer.duration.inHours.toString().padLeft(2, '0')}:${_timer.duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(_timer.duration.inSeconds.remainder(60)).toString().padLeft(2, '0')}"),
                ],
              ),

            LinearProgressIndicator(
              value: this._timerTween.evaluate(this._controller),
              semanticsLabel: _timer.title,
            )
          ],
        );
      }

    );
  }
}
