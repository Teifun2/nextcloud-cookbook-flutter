import 'package:flutter/material.dart';

class DurationIndicator extends StatelessWidget {
  final Duration duration;
  final String name;

  const DurationIndicator({@required this.duration, @required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Center(
              child: Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          width: 200,
          height: 35,
          decoration: BoxDecoration(
            color: Color(0xFFEDEDED),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(3),
              topRight: Radius.circular(3),
            ),
            border: Border.all(
              color: Color(0xFFDBDBDB),
            ),
          ),
        ),
        Container(
          child: Center(
            child: Text(
              "${duration.inHours}:${duration.inMinutes}",
              style: TextStyle(fontSize: 16),
            ),
          ),
          width: 200,
          height: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(3),
              bottomRight: Radius.circular(3),
            ),
            border: Border.all(
              color: Color(0xFFDBDBDB),
            ),
          ),
        ),
      ],
    );
  }
}
