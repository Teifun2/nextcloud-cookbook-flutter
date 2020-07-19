import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe_short.dart';


class RecipeScreen extends StatefulWidget {
  final RecipeShort recipeShort;

  const RecipeScreen({Key key, @required this.recipeShort}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RecipeScreenState();
}

class RecipeScreenState extends State<RecipeScreen> {
  RecipeShort recipeShort;

  @override
  void initState() {
    recipeShort = widget.recipeShort;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (
        title: Text("Recipe"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(recipeShort.name),
      ),
    );
  }
}