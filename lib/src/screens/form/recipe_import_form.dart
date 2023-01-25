import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe_bloc.dart';

class RecipeImportForm extends StatefulWidget {
  final String importUrl;

  const RecipeImportForm([this.importUrl = '']);

  @override
  _RecipeImportFormState createState() => _RecipeImportFormState();
}

class _RecipeImportFormState extends State<RecipeImportForm> {
  late TextEditingController _importUrlController;

  @override
  void initState() {
    super.initState();

    _importUrlController = TextEditingController(text: widget.importUrl);
    if (widget.importUrl.isNotEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        BlocProvider.of<RecipeBloc>(context)
            .add(RecipeImported(widget.importUrl));
      });
    }
  }

  @override
  void dispose() {
    _importUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(
      builder: (BuildContext context, RecipeState state) {
        final enabled = state.status != RecipeStatus.updateInProgress;
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              child: Column(
                children: [
                  TextField(
                    enabled: enabled,
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
                        icon: const Icon(Icons.content_copy_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: enabled
                        ? OutlinedButton.icon(
                            onPressed: () {
                              if (enabled) {
                                BlocProvider.of<RecipeBloc>(context).add(
                                  RecipeImported(_importUrlController.text),
                                );
                              }
                            },
                            icon: const Icon(Icons.cloud_download_outlined),
                            label: Text(translate("recipe_import.button")),
                            style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          )
                        : SpinKitWave(
                            color: Theme.of(context).colorScheme.primary,
                            size: 30.0,
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
