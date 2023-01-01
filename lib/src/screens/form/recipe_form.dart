import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/services/data_repository.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/input/duration_form_field.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/input/integer_text_form_field.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/input/reorderable_list_form_field.dart';

typedef RecipeFormSubmit = void Function(
  MutableRecipe mutableRecipe,
  BuildContext context,
);

class RecipeForm extends StatefulWidget {
  final Recipe recipe;
  final String buttonSubmitText;
  final RecipeFormSubmit recipeFormSubmit;

  const RecipeForm(
    this.recipe,
    this.buttonSubmitText,
    this.recipeFormSubmit, {
    super.key,
  });

  @override
  _RecipeFormState createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  final _formKey = GlobalKey<FormState>();
  late Recipe recipe;
  late MutableRecipe _mutableRecipe;
  late TextEditingController categoryController;

  @override
  void initState() {
    recipe = widget.recipe;
    _mutableRecipe = recipe.toMutableRecipe();
    categoryController = TextEditingController(text: recipe.recipeCategory);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(
      builder: (context, state) => Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Wrap(
              runSpacing: 20,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      translate('recipe.fields.name'),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextFormField(
                      enabled: state is! RecipeUpdateInProgress,
                      initialValue: recipe.name,
                      onChanged: (value) {
                        _mutableRecipe.name = value;
                      },
                    ),
                  ],
                ), // Name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      translate('recipe.fields.description'),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextFormField(
                      enabled: state is! RecipeUpdateInProgress,
                      initialValue: recipe.description,
                      maxLines: 100,
                      minLines: 1,
                      onChanged: (value) {
                        _mutableRecipe.description = value;
                      },
                    ),
                  ],
                ), // Description
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      translate('recipe.fields.category'),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TypeAheadFormField(
                      getImmediateSuggestions: true,
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: categoryController,
                      ),
                      suggestionsCallback:
                          DataRepository().getMatchingCategoryNames,
                      itemBuilder: (context, String? suggestion) {
                        if (suggestion != null) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        }
                        return const SizedBox();
                      },
                      onSuggestionSelected: (String? suggestion) {
                        if (suggestion == null) return;
                        categoryController.text = suggestion;
                      },
                      onSaved: (value) {
                        if (value == null) return;
                        _mutableRecipe.recipeCategory = value;
                      },
                    )
                  ],
                ), // Category
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      translate('recipe.fields.keywords'),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextFormField(
                      enabled: state is! RecipeUpdateInProgress,
                      initialValue: recipe.keywords,
                      onChanged: (value) {
                        _mutableRecipe.keywords = value;
                      },
                    ),
                  ],
                ), // Keywords
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      translate('recipe.fields.source'),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextFormField(
                      enabled: state is! RecipeUpdateInProgress,
                      initialValue: recipe.url,
                      onChanged: (value) {
                        _mutableRecipe.url = value;
                      },
                    ),
                  ],
                ), // URL
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      translate('recipe.fields.image'),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextFormField(
                      enabled: false,
                      style: const TextStyle(color: Colors.grey),
                      initialValue: recipe.imageUrl,
                      onChanged: (value) {
                        _mutableRecipe.imageUrl = value;
                      },
                    ),
                  ],
                ), // Image
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      translate('recipe.fields.servings'),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    IntegerTextFormField(
                      enabled: state is! RecipeUpdateInProgress,
                      initialValue: recipe.recipeYield,
                      onChanged: (value) => _mutableRecipe.recipeYield = value,
                      onSaved: (value) => _mutableRecipe.recipeYield = value,
                    ),
                  ],
                ), // Servings
                DurationFormField(
                  title: translate('recipe.fields.time.prep'),
                  state: state,
                  duration: recipe.prepTime,
                  onChanged: (value) => {_mutableRecipe.prepTime = value},
                ),
                DurationFormField(
                  title: translate('recipe.fields.time.cook'),
                  state: state,
                  duration: recipe.cookTime,
                  onChanged: (value) => {_mutableRecipe.cookTime = value},
                ),
                DurationFormField(
                  title: translate('recipe.fields.time.total'),
                  state: state,
                  duration: recipe.totalTime,
                  onChanged: (value) => {_mutableRecipe.totalTime = value},
                ),
                ReorderableListFormField(
                  title: translate('recipe.fields.tools'),
                  items: recipe.tool,
                  state: state,
                  onSave: (value) => {_mutableRecipe.tool = value},
                ),
                ReorderableListFormField(
                  title: translate('recipe.fields.ingredients'),
                  items: recipe.recipeIngredient,
                  state: state,
                  onSave: (value) => {_mutableRecipe.recipeIngredient = value},
                ),
                ReorderableListFormField(
                  title: translate('recipe.fields.instructions'),
                  items: recipe.recipeInstructions,
                  state: state,
                  onSave: (value) =>
                      {_mutableRecipe.recipeInstructions = value},
                ),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        widget.recipeFormSubmit(_mutableRecipe, context);
                      }
                    },
                    child: () {
                      switch (state.runtimeType) {
                        case RecipeUpdateInProgress:
                          return const SpinKitWave(
                            color: Colors.white,
                            size: 30.0,
                          );
                        case RecipeUpdateFailure:
                        case RecipeUpdateSuccess:
                        case RecipeLoadSuccess:
                        case RecipeCreateSuccess:
                        case RecipeCreateFailure:
                        case RecipeInitial:
                        default:
                          return Text(widget.buttonSubmitText);
                      }
                    }(),
                  ),
                ), // Update Button
              ],
            ),
          ),
        ),
      ),
    );
  }
}
