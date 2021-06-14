import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/timer.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe_edit_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/authentication_cached_network_image.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/duration_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../util/notification_service.dart';

class RecipeScreen extends StatefulWidget {
  final int recipeId;

  const RecipeScreen({Key key, @required this.recipeId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RecipeScreenState();
}

class RecipeScreenState extends State<RecipeScreen> {
  int recipeId;

  @override
  void initState() {
    recipeId = widget.recipeId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RecipeBloc>(
      create: (context) => RecipeBloc()..add(RecipeLoaded(recipeId: recipeId)),
      child: BlocBuilder<RecipeBloc, RecipeState>(
          builder: (BuildContext context, RecipeState state) {
        final recipeBloc = BlocProvider.of<RecipeBloc>(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(translate('recipe.title')),
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
            } else if (state is RecipeFailure) {
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
                  recipeId: recipe.id,
                  full: true,
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
                    child: Row(
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: translate('recipe.fields.servings'),
                            style: TextStyle(fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                text: " " + recipe.recipeYield.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        if (recipe.url.isNotEmpty)
                          ElevatedButton(
                            style: ButtonStyle(),
                            onPressed: () async {
                              if (await canLaunch(recipe.url)) {
                                await launch(recipe.url);
                              }
                            },
                            child:
                                Text(translate('recipe.fields.source_button')),
                          )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      runSpacing: 10,
                      spacing: 10,
                      children: <Widget>[
                        if (recipe.prepTime != null)
                          DurationIndicator(
                              duration: recipe.prepTime,
                              name: translate('recipe.prep')),
                        if (recipe.cookTime != null)
                          DurationIndicator(
                              duration: recipe.cookTime,
                              name: translate('recipe.cook'),
                              timer: true
                          ),
                        if (recipe.cookTime != null && recipe.cookTime > Duration.zero)
                          IconButton(
                            icon: const Icon(Icons.access_alarm),
                            tooltip: 'Start timer',
                            onPressed: () {
                              var timer = new Timer(recipe.id, recipe.name, recipe.name + translate('timer.finished'), recipe.cookTime);
                              timer.show();
                              final snackBar = SnackBar(content: Text(translate('timer.started')));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            },
                          ),
                        if (recipe.totalTime != null)
                          DurationIndicator(
                              duration: recipe.totalTime,
                              name: translate('recipe.total')),
                      ],
                    ),
                  ),
                  if (recipe.tool.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: ExpansionTile(
                        title: Text(translate('recipe.fields.tools')),
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text(recipe.tool.fold(
                                  "", (p, e) => p + "-  " + e.trim() + "\n")),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (recipe.recipeIngredient.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: ExpansionTile(
                        title: Text(translate('recipe.fields.ingredients')),
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text(recipe.recipeIngredient.fold(
                                  "", (p, e) => p + "-  " + e.trim() + "\n")),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: ExpansionTile(
                      title: Text(translate('recipe.fields.instructions')),
                      initiallyExpanded: true,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListView.separated(
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
                                      margin:
                                          EdgeInsets.only(right: 15, top: 10),
                                      child: instructionsDone[index]
                                          ? Icon(Icons.check)
                                          : Center(child: Text("${index + 1}")),
                                      decoration: ShapeDecoration(
                                        shape: CircleBorder(
                                            side:
                                                BorderSide(color: Colors.grey)),
                                        color: instructionsDone[index]
                                            ? Colors.green
                                            : Theme.of(context).backgroundColor,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                          recipe.recipeInstructions[index]),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (c, i) => SizedBox(height: 10),
                            itemCount: recipe.recipeInstructions.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
