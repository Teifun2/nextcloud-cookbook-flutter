import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/input/duration_form_field.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/input/integer_text_form_field.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/input/reorderable_list_form_field.dart';

class RecipeForm extends StatefulWidget {
  final Recipe recipe;

  const RecipeForm(this.recipe);

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
                      "Name",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextFormField(
                      enabled: !(state is RecipeUpdateInProgress),
                      initialValue: recipe.name,
                      decoration: InputDecoration(hintText: "Recipe Name"),
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
                      "Description",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextFormField(
                      enabled: !(state is RecipeUpdateInProgress),
                      initialValue: recipe.description,
                      maxLines: 100,
                      minLines: 1,
                      decoration:
                          InputDecoration(hintText: "Recipe Description"),
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
                      "Category",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextFormField(
                      enabled: !(state is RecipeUpdateInProgress),
                      initialValue: recipe.recipeCategory,
                      decoration: InputDecoration(hintText: "Recipe Category"),
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
                      "Keywords",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextFormField(
                      enabled: !(state is RecipeUpdateInProgress),
                      initialValue: recipe.keywords,
                      decoration: InputDecoration(hintText: "Recipe Keywords"),
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
                      "URL",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextFormField(
                      enabled: !(state is RecipeUpdateInProgress),
                      initialValue: recipe.url,
                      decoration: InputDecoration(hintText: "Source URL"),
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
                      "Image",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextFormField(
                      enabled: false,
                      style: TextStyle(color: Colors.grey),
                      initialValue: recipe.imageUrl,
                      decoration: InputDecoration(hintText: "Image Location"),
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
                      "Servings",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    IntegerTextFormField(
                      enabled: !(state is RecipeUpdateInProgress),
                      initialValue: recipe.recipeYield,
                      decoration: InputDecoration(hintText: "Servings"),
                      onChanged: (value) => _mutableRecipe.recipeYield = value,
                      onSaved: (value) => _mutableRecipe.recipeYield = value,
                    ),
                  ],
                ), // Servings
                DurationFormField(
                  title: "Preparation Time",
                  state: state,
                  duration: recipe.prepTime,
                  onChanged: (value) => {_mutableRecipe.prepTime = value},
                ),
                DurationFormField(
                  title: "Cooking Time",
                  state: state,
                  duration: recipe.cookTime,
                  onChanged: (value) => {_mutableRecipe.cookTime = value},
                ),
                DurationFormField(
                  title: "Total Time",
                  state: state,
                  duration: recipe.totalTime,
                  onChanged: (value) => {_mutableRecipe.totalTime = value},
                ),
                // ListFormField(
                //   state: state,
                //   list: recipe.tool,
                //   title: "Tools",
                //   onChanged: (value) => {_mutableRecipe.tool = value},
                // ),
                // ListFormField(
                //   state: state,
                //   list: recipe.recipeIngredient,
                //   title: "Ingredients",
                //   onChanged: (value) =>
                //       {_mutableRecipe.recipeIngredient = value},
                // ),
                // ListFormField(
                //   state: state,
                //   list: recipe.recipeInstructions,
                //   title: "Instructions",
                //   onChanged: (value) =>
                //       {_mutableRecipe.recipeInstructions = value},
                // ),
                ReorderableListFormField(
                  title: "Recipe Instructions",
                  items: recipe.recipeInstructions,
                  state: state,
                ),
                Container(
                  width: 150,
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        BlocProvider.of<RecipeBloc>(context)
                            .add(RecipeUpdated(_mutableRecipe.toRecipe()));
                      }
                    },
                    child: () {
                      if (state is RecipeUpdateInProgress) {
                        return SpinKitWave(color: Colors.blue, size: 30.0);
                      } else if (state is RecipeUpdateFailure ||
                          state is RecipeUpdateSuccess ||
                          state is RecipeLoadSuccess) {
                        return Text("Update");
                      } else {
                        return Text("");
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
