import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/input/duration_form_field.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/input/integer_text_form_field.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/input/reorderable_list_form_field.dart';

import '../../../main.dart';

typedef RecipeFormSubmit = void Function(
    MutableRecipe mutableRecipe, BuildContext context);

class RecipeForm extends StatefulWidget {
  final Recipe recipe;
  final String buttonSubmitText;
  final RecipeFormSubmit recipeFormSubmit;

  const RecipeForm(this.recipe, this.buttonSubmitText, this.recipeFormSubmit);

  @override
  _RecipeFormState createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  final _formKey = GlobalKey<FormState>();
  Recipe recipe;
  MutableRecipe _mutableRecipe;

  @override
  void initState() {
    recipe = widget.recipe;
    _mutableRecipe = recipe.toMutableRecipe();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController servingsController =
        TextEditingController(text: recipe.recipeYield.toString());

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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextFormField(
                      enabled: !(state is RecipeUpdateInProgress),
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextFormField(
                      enabled: !(state is RecipeUpdateInProgress),
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextFormField(
                      enabled: !(state is RecipeUpdateInProgress),
                      initialValue: recipe.recipeCategory,
                      onChanged: (value) {
                        _mutableRecipe.recipeCategory = value;
                      },
                    ),
                  ],
                ), // Category
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      translate('recipe.fields.keywords'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextFormField(
                      enabled: !(state is RecipeUpdateInProgress),
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextFormField(
                      enabled: !(state is RecipeUpdateInProgress),
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextFormField(
                      enabled: false,
                      style: TextStyle(color: Colors.grey),
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    IntegerTextFormField(
                      enabled: !(state is RecipeUpdateInProgress),
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
                Container(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        widget.recipeFormSubmit(_mutableRecipe, context);
                      }
                    },
                    child: () {
                      if (state is RecipeUpdateInProgress) {
                        return SpinKitWave(color: PRIMARY_COLOR, size: 30.0);
                      } else if (state is RecipeUpdateFailure ||
                          state is RecipeUpdateSuccess ||
                          state is RecipeLoadSuccess ||
                          state is RecipeCreateSuccess ||
                          state is RecipeCreateFailure ||
                          state is RecipeInitial) {
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
