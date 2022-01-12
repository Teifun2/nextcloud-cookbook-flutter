import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/form/recipe_form.dart';

import 'recipe/recipe_screen.dart';

class RecipeCreateScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeCreateScreen(this.recipe);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RecipeBloc>(
      create: (context) => RecipeBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: BlocListener<RecipeBloc, RecipeState>(
              listener: (BuildContext context, RecipeState state) {
                if (state is RecipeCreateFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(translate(
                          'recipe_create.errors.update_failed',
                          args: {"error_msg": state.errorMsg})),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is RecipeCreateSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RecipeScreen(recipeId: state.recipeId),
                    ),
                  );
                }
              },
              child: Text(translate('recipe_create.title'))),
        ),
        body: RecipeForm(
          recipe,
          translate('recipe_create.button'),
          (mutableRecipe, context) => {
            BlocProvider.of<RecipeBloc>(context)
                .add(RecipeCreated(mutableRecipe.toRecipe()))
          },
        ),
      ),
    );
  }
}
