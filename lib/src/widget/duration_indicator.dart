import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class DurationIndicator extends StatelessWidget {
  final Duration duration;
  final String name;
  final bool timer;

  const DurationIndicator({@required this.duration, @required this.name, this.timer = false});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        children: <Widget>[
          Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 13, right: 13),
                child: Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            height: 35,
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(3),
                topRight: Radius.circular(3),
              ),
              border: Border.all(
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
          Container(
            child: Center(
              child: Text(
                "${duration.inHours}:${duration.inMinutes % 60 < 10 ? "0" : ""}${duration.inMinutes % 60}",
                style: TextStyle(fontSize: 16),
              ),
            ),
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(3),
                bottomRight: Radius.circular(3),
              ),
              border: Border.all(
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
