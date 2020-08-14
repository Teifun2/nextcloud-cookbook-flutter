import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe_short.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe_edit_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/authentication_cached_network_image.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/duration_indicator.dart';

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
    return BlocProvider<RecipeBloc>(
      create: (context) =>
          RecipeBloc()..add(RecipeLoaded(recipeId: recipeShort.recipeId)),
      child: BlocBuilder<RecipeBloc, RecipeState>(
          builder: (BuildContext context, RecipeState state) {
        final recipeBloc = BlocProvider.of<RecipeBloc>(context);
        return Scaffold(
          appBar: AppBar(
            title: Text("Recipe"),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (state is RecipeLoadSuccess) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return BlocProvider.value(
                          value: recipeBloc,
                          child: RecipeEditScreen(state.recipe));
                    },
                  ),
                );
              }
            },
            child: Icon(Icons.edit),
          ),
          body: () {
            if (state is RecipeLoadSuccess) {
              return _buildRecipeScreen(state.recipe);
            } else if (state is RecipeLoadInProgress) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is RecipeLoadFailure) {
              return Center(
                child: Text(state.errorMsg),
              );
            } else {
              return Center(
                child: Text("FAILED"),
              );
            }
          }(),
        );
      }),
    );
  }

  Widget _buildRecipeScreen(Recipe recipe) {
    List<bool> instructionsDone =
        List.filled(recipe.recipeInstructions.length, false);

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                    child: RichText(
                      text: TextSpan(
                        text: "Servings: ",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                            text: recipe.recipeYield.toString(),
                            style: TextStyle(
//                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      runSpacing: 10,
                      spacing: 10,
                      children: <Widget>[
                        (recipe.prepTime != null)
                            ? DurationIndicator(
                                duration: recipe.prepTime,
                                name: "Preparation time")
                            : SizedBox(height: 0),
                        (recipe.cookTime != null)
                            ? DurationIndicator(
                                duration: recipe.cookTime, name: "Cooking time")
                            : SizedBox(height: 0),
                        (recipe.totalTime != null)
                            ? DurationIndicator(
                                duration: recipe.totalTime, name: "Total time")
                            : SizedBox(height: 0),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      "Ingredients:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(recipe.recipeIngredient
                        .fold("", (p, e) => p + e + "\n")),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      "Instructions:",
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
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                instructionsDone[index] =
                                    !instructionsDone[index];
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 40,
                                  height: 40,
                                  margin: EdgeInsets.only(right: 15, top: 10),
                                  child: instructionsDone[index]
                                      ? Icon(Icons.check)
                                      : Center(child: Text("${index + 1}")),
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
                            ),
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
      },
    );
  }
}
