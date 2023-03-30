import 'package:flutter/material.dart';

class DurationIndicator extends StatelessWidget {
  final Duration duration;
  final String name;

  const DurationIndicator({
    super.key,
    required this.duration,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        children: <Widget>[
          Container(
            height: 35,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(3),
                topRight: Radius.circular(3),
              ),
              border: Border.all(
                color: Theme.of(context).hintColor,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 13, right: 13),
                child: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Container(
            height: 35,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(3),
                bottomRight: Radius.circular(3),
              ),
              border: Border.all(
                color: Theme.of(context).hintColor,
              ),
            ),
            child: Center(
              child: Text(
                "${duration.inHours}:${duration.inMinutes % 60 < 10 ? "0" : ""}${duration.inMinutes % 60}",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
