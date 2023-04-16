import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/form/recipe_form.dart';

import 'package:nextcloud_cookbook_flutter/src/screens/recipe_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/util/theme_data.dart';

class RecipeCreateScreen extends StatelessWidget {
  const RecipeCreateScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RecipeBloc>(
      create: (context) => RecipeBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: BlocListener<RecipeBloc, RecipeState>(
            listener: (BuildContext context, RecipeState state) {
              if (state.status == RecipeStatus.createFailure) {
                final theme = Theme.of(context)
                    .extension<SnackBarThemes>()!
                    .errorSnackBar;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      translate(
                        'recipe_create.errors.update_failed',
                        args: {"error_msg": state.error},
                      ),
                      style: theme.contentTextStyle,
                    ),
                    backgroundColor: theme.backgroundColor,
                  ),
                );
              } else if (state.status == RecipeStatus.createSuccess) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RecipeScreen(recipeId: state.recipeId!),
                  ),
                );
              }
            },
            child: Text(translate('recipe_create.title')),
          ),
        ),
        body: const RecipeForm(),
      ),
    );
  }
}
