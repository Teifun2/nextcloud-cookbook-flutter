import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/models/timer.dart';
import 'package:nextcloud_cookbook_flutter/src/util/duration_utils.dart';

class AnimatedTimeProgressBar extends StatelessWidget {
  const AnimatedTimeProgressBar({
    required this.timer,
    super.key,
  });
  final Timer timer;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        duration: timer.remaining,
        tween: Tween(
          begin: timer.progress,
          end: 1,
        ),
        builder: (context, value, child) {
          if (value == 1.0) {
            return Text(translate('timer.done'));
          }

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(timer.remaining.formatSeconds()),
                  child!,
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: value,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  semanticsLabel: timer.title,
                ),
              ),
            ],
          );
        },
        child: Text(timer.duration.formatSeconds()),
      );
}
