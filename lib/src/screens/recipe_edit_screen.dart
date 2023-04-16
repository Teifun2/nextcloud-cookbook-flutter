import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:nc_cookbook_api/nc_cookbook_api.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/categories/categories_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/services/services.dart';
import 'package:nextcloud_cookbook_flutter/src/util/theme_data.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/alerts/recipe_delete_alert.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/alerts/recipe_edit_alert.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/input/duration_form_field.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/input/integer_text_form_field.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/input/reorderable_list_form_field.dart';

class RecipeEditScreen extends StatefulWidget {
  final Recipe? recipe;

  const RecipeEditScreen({
    this.recipe,
    super.key,
  });

  @override
  State<RecipeEditScreen> createState() => _RecipeEditScreenState();
}

class _RecipeEditScreenState extends State<RecipeEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late RecipeBuilder _mutableRecipe;
  late TextEditingController categoryController;

  @override
  void initState() {
    super.initState();

    _mutableRecipe = RecipeBuilder();

    if (widget.recipe != null) {
      _mutableRecipe.replace(widget.recipe!);
    }
    categoryController =
        TextEditingController(text: _mutableRecipe.recipeCategory);
  }

  @override
  void dispose() {
    categoryController.dispose();

    super.dispose();
  }

  String get translationKey =>
      widget.recipe != null ? 'recipe_edit' : 'recipe_create';

  Future<void> onDelete() async {
    final decision = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteRecipeAlert(recipe: widget.recipe!),
    );

    if (decision ?? false) {
      FocusManager.instance.primaryFocus?.unfocus();
      // ignore: use_build_context_synchronously
      BlocProvider.of<RecipeBloc>(context).add(RecipeDeleted(widget.recipe!));
    }
  }

  void onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      if (widget.recipe == null) {
        _mutableRecipe.dateCreated = DateTime.now().toUtc();
        BlocProvider.of<RecipeBloc>(context)
            .add(RecipeCreated(_mutableRecipe.build()));
      } else {
        _mutableRecipe.dateModified = DateTime.now().toUtc();
        BlocProvider.of<RecipeBloc>(context)
            .add(RecipeUpdated(_mutableRecipe.build()));
      }
    }
  }

  Future<bool> onWillPop() async {
    if (widget.recipe != null) {
      final RecipeBloc recipeBloc = BlocProvider.of<RecipeBloc>(context);
      if (recipeBloc.state.status == RecipeStatus.updateFailure) {
        recipeBloc.add(RecipeLoaded(widget.recipe!.id!));
      }
    }

    final decision = await showDialog<bool>(
      context: context,
      builder: (context) => CancelEditAlert(recipe: widget.recipe),
    );

    if (decision == true) {
      FocusManager.instance.primaryFocus?.unfocus();
    }

    return decision ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('$translationKey.title')),
        actions: [
          if (widget.recipe != null) ...[
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: translate("recipe_edit.delete.title").toLowerCase(),
              color: Theme.of(context).colorScheme.error,
              onPressed: onDelete,
            ),
          ],
        ],
      ),
      body: BlocConsumer<RecipeBloc, RecipeState>(
        builder: builder,
        listener: listener,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: translate('$translationKey.button'),
        onPressed: onSubmit,
        child: const Icon(Icons.check_outlined),
      ),
    );
  }

  Widget builder(BuildContext context, RecipeState state) {
    final theme = Theme.of(context);
    final headerStile = theme.textTheme.titleMedium!.copyWith(
      color: theme.colorScheme.secondary,
    );

    final enabled = state.status != RecipeStatus.updateInProgress;

    final children = [
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          translate('recipe.fields.general'),
          style: headerStile,
        ),
      ),
      TextFormField(
        enabled: enabled,
        initialValue: _mutableRecipe.name,
        textInputAction: TextInputAction.next,
        onChanged: (value) => _mutableRecipe.name = value,
        autofocus: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return translate("form.validators.required");
          }

          return null;
        },
        decoration: InputDecoration(
          labelText: translate('recipe.fields.name'),
        ),
      ),
      TextFormField(
        enabled: enabled,
        maxLines: 100,
        minLines: 1,
        textInputAction: TextInputAction.newline,
        initialValue: _mutableRecipe.description,
        onChanged: (value) => _mutableRecipe.description = value,
        decoration: InputDecoration(
          labelText: translate('recipe.fields.description'),
        ),
      ),
      TypeAheadFormField(
        getImmediateSuggestions: true,
        textFieldConfiguration: TextFieldConfiguration(
          controller: categoryController,
          decoration: InputDecoration(
            labelText: translate('recipe.fields.category'),
          ),
          textInputAction: TextInputAction.next,
        ),
        suggestionsCallback: DataRepository().getMatchingCategoryNames,
        itemBuilder: (context, String suggestion) {
          return ListTile(
            title: Text(suggestion),
          );
        },
        onSuggestionSelected: (String? suggestion) {
          if (suggestion == null) return;
          categoryController.text = suggestion;
        },
        onSaved: (value) => _mutableRecipe.recipeCategory = value,
      ),
      TextFormField(
        enabled: enabled,
        textInputAction: TextInputAction.next,
        initialValue: _mutableRecipe.keywords,
        onSaved: (value) => _mutableRecipe.keywords = value,
        decoration: InputDecoration(
          labelText: translate('recipe.fields.keywords'),
        ),
      ),
      TextFormField(
        enabled: enabled,
        keyboardType: TextInputType.url,
        textInputAction: TextInputAction.next,
        initialValue: _mutableRecipe.url,
        onSaved: (value) => _mutableRecipe.url = value,
        decoration: InputDecoration(
          labelText: translate('recipe.fields.source'),
        ),
      ),
      if (widget.recipe != null)
        TextFormField(
          enabled: false,
          style: const TextStyle(color: Colors.grey),
          textInputAction: TextInputAction.next,
          initialValue: _mutableRecipe.imageUrl,
          onSaved: (value) => _mutableRecipe.imageUrl = value,
          decoration: InputDecoration(
            labelText: translate('recipe.fields.image'),
          ),
        ),
      IntegerTextFormField(
        enabled: enabled,
        minValue: 1,
        textInputAction: TextInputAction.next,
        initialValue: _mutableRecipe.recipeYield,
        onSaved: (value) => _mutableRecipe.recipeYield = value,
        onChanged: (value) => setState(() {
          _mutableRecipe.recipeYield = value;
        }),
        decoration: InputDecoration(
          labelText: translate('recipe.fields.servings.else'),
          suffixText: translatePlural(
            'recipe.fields.servings',
            _mutableRecipe.recipeYield!,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          translate('recipe.fields.times'),
          style: headerStile,
        ),
      ),
      DurationFormField(
        enabled: enabled,
        initialValue: _mutableRecipe.prepTime,
        onSaved: (value) => _mutableRecipe.prepTime = value,
        decoration: InputDecoration(
          labelText: translate('recipe.fields.time.prep'),
        ),
      ),
      DurationFormField(
        enabled: enabled,
        initialValue: _mutableRecipe.cookTime,
        onSaved: (value) => _mutableRecipe.cookTime = value,
        decoration: InputDecoration(
          labelText: translate('recipe.fields.time.cook'),
        ),
      ),
      DurationFormField(
        enabled: enabled,
        initialValue: _mutableRecipe.totalTime,
        onSaved: (value) => _mutableRecipe.totalTime = value,
        decoration: InputDecoration(
          labelText: translate('recipe.fields.time.total'),
        ),
      ),
      if (state.status == RecipeStatus.updateInProgress)
        SpinKitWave(
          color: Theme.of(context).colorScheme.onSecondary,
          size: 30.0,
        ),
    ];

    return Form(
      key: _formKey,
      onWillPop: onWillPop,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: children[index],
                ),
                childCount: children.length,
              ),
            ),
            ReordarableListFormField(
              title: translate('recipe.fields.tools'),
              initialValues: _mutableRecipe.tool,
              enabled: enabled,
              onSaved: (value) => _mutableRecipe.tool = value,
              decoration: InputDecoration(
                labelText: translate('recipe.fields.time.total'),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            ReordarableListFormField(
              title: translate('recipe.fields.ingredients'),
              initialValues: _mutableRecipe.recipeIngredient,
              enabled: enabled,
              onSaved: (value) => _mutableRecipe.recipeIngredient = value,
            ),
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 75),
              sliver: ReordarableListFormField(
                title: translate('recipe.fields.instructions'),
                initialValues: _mutableRecipe.recipeInstructions,
                enabled: enabled,
                onSaved: (value) => _mutableRecipe.recipeInstructions = value,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void listener(BuildContext context, RecipeState state) {
    final theme = Theme.of(context).extension<SnackBarThemes>()!.errorSnackBar;

    switch (state.status) {
      case RecipeStatus.createFailure:
      case RecipeStatus.updateFailure:
      case RecipeStatus.deleteFailure:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              translate(
                '$translationKey.errors.update_failed',
                args: {"error_msg": state.error},
              ),
              style: theme.contentTextStyle,
            ),
            backgroundColor: theme.backgroundColor,
          ),
        );
        break;
      case RecipeStatus.updateSuccess:
        BlocProvider.of<RecipeBloc>(context).add(RecipeLoaded(state.recipeId!));
        Navigator.pop(context);
        break;
      case RecipeStatus.delteSuccess:
        BlocProvider.of<CategoriesBloc>(context).add(const CategoriesLoaded());
        Navigator.pop(context);
        Navigator.pop(context);
        break;
      case RecipeStatus.createSuccess:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeScreen(recipeId: state.recipeId!),
          ),
        );
        break;
      default:
    }
  }
}
