import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe.dart';

class RecipeImportForm extends StatefulWidget {
  final String importUrl;

  const RecipeImportForm([this.importUrl = '']);

  @override
  _RecipeImportFormState createState() => _RecipeImportFormState();
}

class _RecipeImportFormState extends State<RecipeImportForm> {
  final _importUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _importUrlController.text = widget.importUrl;
    if (widget.importUrl.isNotEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        BlocProvider.of<RecipeBloc>(context)
            .add(RecipeImported(_importUrlController.text));
      });
    }
  }

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
                    enabled: state is! RecipeImportInProgress,
                    controller: _importUrlController,
                    decoration: InputDecoration(
                      hintText: translate("recipe_import.field"),
                      suffixIcon: IconButton(
                        tooltip: translate("recipe_import.clipboard"),
                        onPressed: () async {
                          final clipboard =
                              await Clipboard.getData('text/plain');
                          final text = clipboard?.text;
                          if (text != null) _importUrlController.text = text;
                        },
                        icon: const Icon(Icons.content_copy),
                      ),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () => {
                        if (state is! RecipeImportInProgress)
                          BlocProvider.of<RecipeBloc>(context)
                              .add(RecipeImported(_importUrlController.text))
                        else
                          null
                      },
                      child: () {
                        return state is RecipeImportInProgress
                            ? SpinKitWave(
                                color: Theme.of(context).primaryColor,
                                size: 30.0,
                              )
                            : Row(
                                children: [
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 9.0),
                                    child:
                                        Text(translate("recipe_import.button")),
                                  ),
                                  const Icon(Icons.cloud_download_outlined),
                                  const Spacer(),
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
      },
    );
  }
}
