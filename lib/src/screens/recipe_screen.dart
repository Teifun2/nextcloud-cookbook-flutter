import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe_edit_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/util/setting_keys.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/authentication_cached_network_image.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/duration_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock/wakelock.dart';

class RecipeScreen extends StatefulWidget {
  final int recipeId;

  const RecipeScreen({Key key, @required this.recipeId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RecipeScreenState();
}

class RecipeScreenState extends State<RecipeScreen> {
  int recipeId;

  Future<bool> _disableWakelock() async {
    bool wakelockEnabled = await Wakelock.enabled;
    if (wakelockEnabled) {
      Wakelock.disable();
    }
    return Future.value(true);
  }

  void _enableWakelock() {
    if (Settings.getValue<bool>(describeEnum(SettingKeys.stay_awake), false)) {
      Wakelock.enable();
    }
  }

  @override
  void initState() {
    _enableWakelock();
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
        return WillPopScope(
          onWillPop: () => _disableWakelock(),
          child: Scaffold(
            appBar: AppBar(
              title: Text(translate('recipe.title')),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                if (state is RecipeLoadSuccess) {
                  _disableWakelock();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return BlocProvider.value(
                            value: recipeBloc,
                            child: RecipeEditScreen(state.recipe));
                      },
                    ),
                  );
                  _enableWakelock();
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
          ),
        );
      }),
    );
  }

  Widget _buildRecipeScreen(Recipe recipe) {
    List<bool> instructionsDone =
        List.filled(recipe.recipeInstructions.length, false);

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        TextStyle settingsBasedTextStyle = TextStyle(
          fontSize: Settings.getValue<double>(
            describeEnum(SettingKeys.recipe_font_size),
            Theme.of(context).textTheme.bodyText2.fontSize,
          ),
        );

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
                              child: Text(
                                recipe.tool.fold(
                                  "",
                                  (p, e) => p + "-  " + e.trim() + "\n",
                                ),
                                style: settingsBasedTextStyle,
                              ),
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
                        initiallyExpanded: true,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text(
                                recipe.recipeIngredient.fold(
                                  "",
                                  (p, e) => p + "-  " + e.trim() + "\n",
                                ),
                                style: settingsBasedTextStyle,
                              ),
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
                                        recipe.recipeInstructions[index],
                                        style: settingsBasedTextStyle,
                                      ),
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
