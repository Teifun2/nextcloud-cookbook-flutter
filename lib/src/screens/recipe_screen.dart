import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/timer.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe_edit_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/animated_time_progress_bar.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/authentication_cached_network_image.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/duration_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeScreen extends StatefulWidget {
  final int recipeId;

  const RecipeScreen({Key key, @required this.recipeId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RecipeScreenState();
}

class RecipeScreenState extends State<RecipeScreen> {
  int recipeId;
  bool isLargeScreen = false;

  @override
  void initState() {
    recipeId = widget.recipeId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width > 600) {
      this.isLargeScreen = true;
    }
    return BlocProvider<RecipeBloc>(
      create: (context) => RecipeBloc()..add(RecipeLoaded(recipeId: recipeId)),
      child: BlocBuilder<RecipeBloc, RecipeState>(
          builder: (BuildContext context, RecipeState state) {
        final recipeBloc = BlocProvider.of<RecipeBloc>(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(translate('recipe.title')),
            actions: <Widget>[
              // action button
              IconButton(
                icon: Icon(
                  Icons.edit,
                ),
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
              ),
            ],
          ),
          floatingActionButton:
              state is RecipeLoadSuccess ? _buildFabButton(state.recipe) : null,
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

  FloatingActionButton _buildFabButton(Recipe recipe) {
    var enabled = recipe.cookTime != null && recipe.cookTime > Duration.zero;
    return FloatingActionButton(
      onPressed: () {
        {
          if (enabled) {
            Timer timer = new Timer(recipe.id, recipe.name,
                recipe.name + translate('timer.finished'), recipe.cookTime);
            timer.start();
            TimerList().timers.add(timer);
            setState(() {});
            final snackBar =
                SnackBar(content: Text(translate('timer.started')));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            final snackBar = SnackBar(
                content:
                    Text("You need to set the cooking time to use a timer."));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
      },
      child: Icon(Icons.access_alarm),
      backgroundColor: enabled
          ? Theme.of(context).accentColor
          : Theme.of(context).disabledColor,
    );
  }

  Widget _buildRecipeScreen(Recipe recipe) {
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
                              name: translate('recipe.cook')),
                        if (recipe.totalTime != null)
                          DurationIndicator(
                              duration: recipe.totalTime,
                              name: translate('recipe.total')),
                      ],
                    ),
                  ),
                  _showTimers(recipe),
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
                  if (this.isLargeScreen && recipe.recipeIngredient.isNotEmpty)
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  flex: 5,
                                  child: this._buildRecipeIngredient(recipe)),
                              Expanded(
                                  flex: 5,
                                  child: this._buildRecipeInstructions(recipe)),
                            ]))
                  else
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Column(children: <Widget>[
                          if (recipe.recipeIngredient.isNotEmpty)
                            this._buildRecipeIngredient(recipe),
                          this._buildRecipeInstructions(recipe),
                        ]))
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRecipeIngredient(Recipe recipe) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: ExpansionTile(
          title: Text(translate('recipe.fields.ingredients')),
          initiallyExpanded: true,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(recipe.recipeIngredient
                    .fold("", (p, e) => p + "-  " + e.trim() + "\n")),
              ),
            ),
          ],
        ));
  }

  Widget _buildRecipeInstructions(Recipe recipe) {
    List<bool> instructionsDone =
        List.filled(recipe.recipeInstructions.length, false);

    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
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
                      instructionsDone[index] = !instructionsDone[index];
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
                          color: instructionsDone[index]
                              ? Colors.green
                              : Theme.of(context).backgroundColor,
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
          ),
        ],
      ),
    );
  }

  Widget _showTimers(Recipe recipe) {
    List<Timer> l = TimerList().get(recipe.id);
    if (l.length > 0) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Column(children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: l.length,
            itemBuilder: (context, index) {
              return _buildTimerListItem(l[index]);
            },
          )
        ]),
      );
    }
    return SizedBox.shrink();
  }

  ListTile _buildTimerListItem(Timer timer) {
    return ListTile(
      key: UniqueKey(),
      title: AnimatedTimeProgressBar(
        timer: timer,
      ),
      trailing: IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () {
            timer.cancel();
            setState(() {});
          }),
    );
  }
}
