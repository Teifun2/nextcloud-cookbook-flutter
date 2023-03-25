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
      _AnimatedTimeProgressBarState();
}

class _AnimatedTimeProgressBarState extends State<AnimatedTimeProgressBar>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Timer _timer;
  late Tween<num> _timerTween;

  _AnimatedTimeProgressBarState();

  @override
  void initState() {
    _timer = widget.timer;

    _timerTween = Tween(
      begin: _timer.progress(),
      end: 1.0,
    );

    _controller = AnimationController(
      duration: _timer.remaining(),
      vsync: this,
    );

    _controller.forward().whenCompleteOrCancel(() {});
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: Container(),
      builder: (context, child) {
        if (_controller.isCompleted) {
          return Text(translate('timer.done'));
        }

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${_timer.remaining().inHours.toString().padLeft(2, '0')}:${_timer.remaining().inMinutes.remainder(60).toString().padLeft(2, '0')}:${(_timer.remaining().inSeconds.remainder(60)).toString().padLeft(2, '0')}",
                ),
                Text(
                  "${_timer.duration.inHours.toString().padLeft(2, '0')}:${_timer.duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(_timer.duration.inSeconds.remainder(60)).toString().padLeft(2, '0')}",
                ),
              ],
            ),
            LinearProgressIndicator(
              value: _timerTween.evaluate(_controller) as double?,
              semanticsLabel: _timer.title,
            )
          ],
        );
      },
    );
  }
}
