import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:validators/validators.dart';

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
    return BlocBuilder<RecipeBloc, RecipeState>(
      builder: (context, state) => Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                enabled: !(state is RecipeUpdateInProgress),
                initialValue: recipe.name,
                decoration: InputDecoration(hintText: "Recipe Name"),
                onSaved: (value) {
                  _mutableRecipe.name = value;
                },
              ),
              TextFormField(
                enabled: !(state is RecipeUpdateInProgress),
                initialValue: recipe.recipeYield.toString(),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "Recipe Yield"),
                validator: (value) =>
                    isNumeric(value) ? null : "Recipe Yield should be a number",
                onSaved: (value) =>
                    _mutableRecipe.recipeYield = int.parse(value),
              ),
              Container(
                width: 150,
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
