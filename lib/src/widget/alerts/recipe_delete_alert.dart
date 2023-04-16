import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nc_cookbook_api/nc_cookbook_api.dart';

class DeleteRecipeAlert extends StatelessWidget {
  const DeleteRecipeAlert({
    required this.recipe,
    super.key,
  });

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.delete_forever),
      iconColor: Theme.of(context).colorScheme.error,
      title: Text(translate("recipe_edit.delete.title")),
      content: Text(
        translate(
          "recipe_edit.delete.dialog",
          args: {"recipe": recipe.name},
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(MaterialLocalizations.of(context).deleteButtonTooltip),
        ),
      ],
    );
  }
}
