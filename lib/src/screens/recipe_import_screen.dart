import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/util/theme_data.dart';
import 'package:nextcloud_cookbook_flutter/src/util/url_validator.dart';

class RecipeImportScreen extends StatefulWidget {
  const RecipeImportScreen({
    this.importUrl = '',
    super.key,
  });

  final String importUrl;

  @override
  State<RecipeImportScreen> createState() => _RecipeImportScreenState();
}

class _RecipeImportScreenState extends State<RecipeImportScreen> {
  late TextEditingController _importUrlController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _importUrlController = TextEditingController(text: widget.importUrl);
    if (widget.importUrl.isNotEmpty) {
      SchedulerBinding.instance
          .addPostFrameCallback((_) => import(widget.importUrl));
    }
  }

  @override
  void dispose() {
    _importUrlController.dispose();
    super.dispose();
  }

  void import(String? url) {
    if (url != null) {
      BlocProvider.of<RecipeBloc>(context).add(RecipeImported(url));
    }
  }

  void onSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
  }

  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return translate(
        'login.server_url.validator.pattern',
      );
    }

    if (!URLUtils.isValid(value)) {
      return translate(
        'login.server_url.validator.pattern',
      );
    }

    return null;
  }

  Future<void> pasteClipboard() async {
    final clipboard = await Clipboard.getData('text/plain');
    final text = clipboard?.text;
    if (text != null) {
      _importUrlController.text = text;
    }

    _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) => BlocProvider<RecipeBloc>(
        create: (context) => RecipeBloc(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(translate('recipe_import.title')),
          ),
          body: BlocConsumer<RecipeBloc, RecipeState>(
            builder: builder,
            listener: listener,
          ),
        ),
      );

  Future<void> listener(BuildContext context, RecipeState state) async {
    if (state.status == RecipeStatus.importFailure) {
      final theme =
          Theme.of(context).extension<SnackBarThemes>()!.errorSnackBar;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            translate(
              'recipe_import.errors.import_failed',
              args: {'error_msg': state.error},
            ),
            style: theme.contentTextStyle,
          ),
          backgroundColor: theme.backgroundColor,
        ),
      );
    } else if (state.status == RecipeStatus.importSuccess) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeScreen(recipeId: state.recipe!.id!),
        ),
      );
    }
  }

  Widget builder(BuildContext context, RecipeState state) {
    final enabled = state.status != RecipeStatus.updateInProgress;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                enabled: enabled,
                controller: _importUrlController,
                validator: enabled ? validate : null,
                onSaved: import,
                onEditingComplete: onSubmit,
                decoration: InputDecoration(
                  hintText: translate('recipe_import.field'),
                  suffixIcon: IconButton(
                    tooltip: MaterialLocalizations.of(context).pasteButtonLabel,
                    onPressed: pasteClipboard,
                    icon: const Icon(Icons.content_copy_outlined),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: enabled
                    ? OutlinedButton.icon(
                        onPressed: enabled ? onSubmit : null,
                        icon: const Icon(Icons.cloud_download_outlined),
                        label: Text(translate('recipe_import.button')),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      )
                    : SpinKitWave(
                        color: Theme.of(context).colorScheme.primary,
                        size: 30,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
