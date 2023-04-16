import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nc_cookbook_api/nc_cookbook_api.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/form/recipe_form.dart';
import 'package:nextcloud_cookbook_flutter/src/util/theme_data.dart';

class RecipeEditScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeEditScreen(
    this.recipe, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<SnackBarThemes>()!.errorSnackBar;

    return WillPopScope(
      onWillPop: () {
        final RecipeBloc recipeBloc = BlocProvider.of<RecipeBloc>(context);
        if (recipeBloc.state.status == RecipeStatus.updateFailure) {
          recipeBloc.add(RecipeLoaded(recipe.id!));
        }
        return Future(() => true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: BlocListener<RecipeBloc, RecipeState>(
            listener: (BuildContext context, RecipeState state) {
              if (state.status == RecipeStatus.updateFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      translate(
                        'recipe_edit.errors.update_failed',
                        args: {"error_msg": state.error},
                      ),
                      style: theme.contentTextStyle,
                    ),
                    backgroundColor: theme.backgroundColor,
                  ),
                );
              } else if (state.status == RecipeStatus.updateSuccess) {
                BlocProvider.of<RecipeBloc>(context)
                    .add(RecipeLoaded(state.recipeId!));
                Navigator.pop(context);
              }
            },
            child: Text(translate('recipe_edit.title')),
          ),
        ),
        body: RecipeForm(recipe: recipe),
      ),
    );
  }
}
