import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nc_cookbook_api/nc_cookbook_api.dart';

class CancelEditAlert extends StatelessWidget {
  const CancelEditAlert({
    this.recipe,
    super.key,
  });

  final Recipe? recipe;

  @override
  Widget build(BuildContext context) {
    final key = recipe == null ? 'dismiss_create' : 'dismiss_edit';
    return AlertDialog(
      title: Text(translate('recipe_form.dismiss_create.title')),
      content: Text(
        translate(
          'recipe_form.$key.dialog',
          args: {"recipe": recipe?.name},
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(translate('alert.discard')),
        ),
      ],
    );
  }
}
