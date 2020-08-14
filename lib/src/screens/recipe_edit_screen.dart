import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/form/recipe_form.dart';

class RecipeEditScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeEditScreen(this.recipe);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocListener<RecipeBloc, RecipeState>(
            listener: (BuildContext context, RecipeState state) {
              if (state is RecipeUpdateFailure) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Update Failed: ${state.errorMsg}"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text("Edit Recipe")),
      ),
      body: RecipeForm(recipe),
    );
  }
}
