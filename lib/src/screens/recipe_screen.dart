import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe_short.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/authentication_cached_network_image.dart';

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
        appBar: AppBar(
          title: Text("Recipe"),
        ),
        body: BlocBuilder<RecipeBloc, RecipeState>(
          bloc: RecipeBloc()..add(RecipeLoaded(recipeId: recipeShort.recipeId)),
          builder: (BuildContext context, RecipeState state) {
            if (state is RecipeLoadSuccess) {
              return _buildRecipeScreen(state.recipe);
            } else if (state is RecipeLoadInProgress) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Center(
                child: Text("FAILED"),
              );
            }
          },
        ));
  }

  Widget _buildRecipeScreen(Recipe recipe) {
    return ListView(
      children: <Widget>[
        Container(
          child: AuthenticationCachedNetworkImage(
            imagePath: recipe.imageUrl,
            width: double.infinity,
            height: 200,
            boxFit: BoxFit.cover,
          ),
          width: double.infinity,
          height: 200,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Text(
                  recipe.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "Ingredients:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text(recipe.recipeIngredient.fold("", (p, e) => p + e + "\n")),
            ],
          ),
        ),
      ],
    );
  }
}
