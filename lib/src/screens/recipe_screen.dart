import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe_short.dart';


class RecipeScreen extends StatefulWidget {
  final RecipeShort recipeShort;

  const RecipeScreen({Key key, @required this.recipeShort}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RecipeScreenState();
}

class RecipeScreenState extends State<RecipeScreen> {
  RecipeShort recipeShort;

  @override
  void initState() {
    recipeShort = widget.recipeShort;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (
        title: Text("Recipe"),
      ),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        bloc: RecipeBloc()..add(RecipeLoaded(recipeId: recipeShort.recipeId)),
        builder: (BuildContext context, RecipeState state) {
          if (state is RecipeLoadSuccess) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(state.recipe.recipeCategory),
            );
          } else if (state is RecipeLoadInProgress) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Text("FAILED"),
            );
          }
        },)
    );
  }
}


