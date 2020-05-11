import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipes_short_screen.dart';

class WelcomeScreen  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RecipesShortScreen()),
            );
          },
          child: Text("Welcome"),
        ),
      ),
    );
  }
}