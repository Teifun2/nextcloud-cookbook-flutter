import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
          child: Center(
            child: AuthenticationCachedNetworkImage(
              imagePath: recipe.imageUrl,
              width: double.infinity,
              height: 200,
              boxFit: BoxFit.cover,
            ),
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
                  recipe.description,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "Ingredients",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                    recipe.recipeIngredient.fold("", (p, e) => p + e + "\n")),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "Instructions",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListView.separated(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(15),
                            margin: EdgeInsets.only(right: 15),
                            child: Text("${index + 1}"),
                            decoration: ShapeDecoration(
                              shape: CircleBorder(
                                  side: BorderSide(color: Colors.grey)),
                              color: Colors.grey[300],
                            ),
                          ),
                          Expanded(
                            child: Text(recipe.recipeInstructions[index]),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (c, i) => SizedBox(height: 10),
                    itemCount: recipe.recipeInstructions.length,
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
