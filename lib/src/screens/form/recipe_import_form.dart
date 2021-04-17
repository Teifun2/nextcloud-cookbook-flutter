import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe.dart';

class RecipeImportForm extends StatefulWidget {
  @override
  _RecipeImportFormState createState() => _RecipeImportFormState();
}

class _RecipeImportFormState extends State<RecipeImportForm> {
  var _importUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(
        builder: (BuildContext context, RecipeState state) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            child: Column(
              children: [
                TextField(
                  enabled: state is RecipeImportInProgress ? false : true,
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
                    onPressed: () => {
                      state is! RecipeImportInProgress
                          ? BlocProvider.of<RecipeBloc>(context)
                              .add(RecipeImported(_importUrlController.text))
                          : null
                    },
                    child: () {
                      return state is RecipeImportInProgress
                          ? SpinKitWave(color: Colors.blue, size: 30.0)
                          : Row(
                              children: [
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 9.0),
                                  child:
                                      Text(translate("recipe_import.button")),
                                ),
                                Icon(Icons.cloud_download_outlined),
                                Spacer(),
                              ],
                            );
                    }(),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
