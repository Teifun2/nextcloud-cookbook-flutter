import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/models/timer.dart';
import 'package:nextcloud_cookbook_flutter/src/util/duration_utils.dart';

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
    super.initState();

    _timer = widget.timer;

    _timerTween = Tween(
      begin: _timer.progress,
      end: 1.0,
    );

    _controller = AnimationController(
      duration: _timer.remaining,
      vsync: this,
    );

    _controller.forward().whenCompleteOrCancel(() {});
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
      builder: (context, _) {
        if (_controller.isCompleted) {
          return Text(translate('timer.done'));
        }

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_timer.remaining.formatSeconds()),
                Text(_timer.duration.formatSeconds()),
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _timerTween.evaluate(_controller) as double,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.75),
                semanticsLabel: _timer.title,
              ),
            ),
          ],
        );
      },
    );
  }
}
