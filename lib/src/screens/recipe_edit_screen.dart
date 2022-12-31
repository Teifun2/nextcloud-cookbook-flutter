import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/form/recipe_form.dart';

class RecipeEditScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeEditScreen(
    this.recipe, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        RecipeBloc recipeBloc = BlocProvider.of<RecipeBloc>(context);
        if (recipeBloc.state is RecipeUpdateFailure) {
          recipeBloc.add(RecipeLoaded(recipe.id));
        }
        return Future(() => true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: BlocListener<RecipeBloc, RecipeState>(
              listener: (BuildContext context, RecipeState state) {
                if (state is RecipeUpdateFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(translate(
                          'recipe_edit.errors.update_failed',
                          args: {"error_msg": state.errorMsg})),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is RecipeUpdateSuccess) {
                  BlocProvider.of<RecipeBloc>(context)
                      .add(RecipeLoaded(state.recipeId));
                  Navigator.pop(context);
                }
              },
              child: Text(translate('recipe_edit.title'))),
        ),
        body: RecipeForm(
          recipe,
          translate('recipe_edit.button'),
          (mutableRecipe, context) => {
            BlocProvider.of<RecipeBloc>(context)
                .add(RecipeUpdated(mutableRecipe.toRecipe()))
          },
        ),
      ),
    );
  }
}
