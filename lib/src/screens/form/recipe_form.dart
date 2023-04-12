import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:nc_cookbook_api/nc_cookbook_api.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/services/services.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/input/duration_form_field.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/input/integer_text_form_field.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/input/reorderable_list_form_field.dart';

class RecipeForm extends StatefulWidget {
  final Recipe? recipe;

  const RecipeForm({
    super.key,
    this.recipe,
  });

  @override
  _RecipeFormState createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  final _formKey = GlobalKey<FormState>();
  late RecipeBuilder _mutableRecipe;
  late TextEditingController categoryController;

  @override
  void initState() {
    _mutableRecipe = RecipeBuilder();

    if (widget.recipe != null) {
      _mutableRecipe.replace(widget.recipe!);
    }
    categoryController =
        TextEditingController(text: _mutableRecipe.recipeCategory);

    super.initState();
  }

  @override
  void dispose() {
    categoryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(
      builder: (context, state) {
        final enabled = state.status != RecipeStatus.updateInProgress;
        return Form(
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
                        enabled: enabled,
                        initialValue: _mutableRecipe.name,
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
                        enabled: enabled,
                        initialValue: _mutableRecipe.description,
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
                        itemBuilder: (context, String suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        onSuggestionSelected: (String suggestion) {
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
                        enabled: enabled,
                        initialValue: _mutableRecipe.keywords,
                        onSaved: (value) {
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
                        enabled: enabled,
                        initialValue: _mutableRecipe.url,
                        onSaved: (value) {
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
                        initialValue: _mutableRecipe.imageUrl,
                        onSaved: (value) {
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
                        enabled: enabled,
                        initialValue: _mutableRecipe.recipeYield,
                        onSaved: (value) => _mutableRecipe.recipeYield = value,
                      ),
                    ],
                  ), // Servings
                  DurationFormField(
                    title: translate('recipe.fields.time.prep'),
                    state: state,
                    duration: _mutableRecipe.prepTime,
                    onChanged: (value) => {_mutableRecipe.prepTime = value},
                  ),
                  DurationFormField(
                    title: translate('recipe.fields.time.cook'),
                    state: state,
                    duration: _mutableRecipe.cookTime,
                    onChanged: (value) => {_mutableRecipe.cookTime = value},
                  ),
                  DurationFormField(
                    title: translate('recipe.fields.time.total'),
                    state: state,
                    duration: _mutableRecipe.totalTime,
                    onChanged: (value) => {_mutableRecipe.totalTime = value},
                  ),
                  ReorderableListFormField(
                    title: translate('recipe.fields.tools'),
                    items: _mutableRecipe.tool,
                    state: state,
                    onSave: (value) => {_mutableRecipe.tool = value},
                  ),
                  ReorderableListFormField(
                    title: translate('recipe.fields.ingredients'),
                    items: _mutableRecipe.recipeIngredient,
                    state: state,
                    onSave: (value) =>
                        {_mutableRecipe.recipeIngredient = value},
                  ),
                  ReorderableListFormField(
                    title: translate('recipe.fields.instructions'),
                    items: _mutableRecipe.recipeInstructions,
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
                          if (widget.recipe == null) {
                            _mutableRecipe.dateCreated = DateTime.now().toUtc();
                            BlocProvider.of<RecipeBloc>(context)
                                .add(RecipeCreated(_mutableRecipe.build()));
                          } else {
                            _mutableRecipe.dateModified =
                                DateTime.now().toUtc();
                            BlocProvider.of<RecipeBloc>(context)
                                .add(RecipeUpdated(_mutableRecipe.build()));
                          }
                        }
                      },
                      child: () {
                        switch (state.status) {
                          case RecipeStatus.updateInProgress:
                            return const SpinKitWave(
                              color: Colors.white,
                              size: 30.0,
                            );
                          case RecipeStatus.updateFailure:
                          case RecipeStatus.updateSuccess:
                          case RecipeStatus.loadSuccess:
                          case RecipeStatus.createSuccess:
                          case RecipeStatus.createFailure:
                          default:
                            return Text(
                              widget.recipe == null
                                  ? translate('recipe_create.button')
                                  : translate('recipe_edit.button'),
                            );
                        }
                      }(),
                    ),
                  ), // Update Button
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
