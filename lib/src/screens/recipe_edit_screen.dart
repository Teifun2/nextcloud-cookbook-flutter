import 'package:flutter/material.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/form/recipe_form.dart';

class RecipeEditScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeEditScreen(this.recipe);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Recipe"),
      ),
      body: RecipeForm(recipe),
    );
  }
}
