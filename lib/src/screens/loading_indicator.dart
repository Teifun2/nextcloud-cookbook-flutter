import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
    child: SpinKitWave(
      color: Colors.black,
      size: 50.0,
    ),
  );
}