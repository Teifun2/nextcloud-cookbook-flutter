import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';

class RecipeImportForm extends StatefulWidget {
  @override
  _RecipeImportFormState createState() => _RecipeImportFormState();
}

class _RecipeImportFormState extends State<RecipeImportForm> {
  var _importUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          child: Column(
            children: [
              TextField(
                controller: _importUrlController,
                decoration: InputDecoration(
                  hintText: translate("recipe_import.field"),
                  suffixIcon: IconButton(
                    tooltip: translate("recipe_import.clipboard"),
                    onPressed: () async => {
                      _importUrlController.text =
                          (await Clipboard.getData('text/plain')).text
                    },
                    icon: Icon(Icons.content_copy),
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () => {},
                  child: Row(
                    children: [
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 9.0),
                        child: Text(translate("recipe_import.button")),
                      ),
                      Icon(Icons.cloud_download_outlined),
                      Spacer(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
