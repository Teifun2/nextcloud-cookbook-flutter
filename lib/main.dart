import 'package:flutter/material.dart';

import 'src/screens/welcome_screen.dart';

void main() => runApp(NextcloudCookbook());

class NextcloudCookbook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Nextcloud Cookbook",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(),
    );
  }
}
