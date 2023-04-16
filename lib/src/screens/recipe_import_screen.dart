import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/form/recipe_import_form.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/util/theme_data.dart';

class RecipeImportScreen extends StatelessWidget {
  final String importUrl;

  const RecipeImportScreen([this.importUrl = '']);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RecipeBloc>(
      create: (context) => RecipeBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: BlocListener<RecipeBloc, RecipeState>(
            child: Text(translate("recipe_import.title")),
            listener: (context, state) {
              if (state.status == RecipeStatus.importFailure) {
                final theme = Theme.of(context)
                    .extension<SnackBarThemes>()!
                    .errorSnackBar;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      translate(
                        'recipe_import.errors.import_failed',
                        args: {"error_msg": state.error},
                      ),
                      style: theme.contentTextStyle,
                    ),
                    backgroundColor: theme.backgroundColor,
                  ),
                );
              } else if (state.status == RecipeStatus.importSuccess) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return RecipeScreen(recipeId: state.recipe!.id!);
                    },
                  ),
                );
              }
            },
          ),
        ),
        body: RecipeImportForm(importUrl),
      ),
    );
  }
}
