import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipes_short/recipes_short.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipes_list.dart';

class WelcomeScreen  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () {
            BlocProvider.of<RecipesShortBloc>(context).add(RecipesShortLoaded());
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RecipesListScreen()),
            );
          },
          child: Text("Welcome"),
        ),
      ),
    );
  }
}