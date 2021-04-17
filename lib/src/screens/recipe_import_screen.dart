import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/form/recipe_import_form.dart';

class RecipeImportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate("recipe_import.title")),
      ),
      body: RecipeImportForm(),
    );
  }
}
