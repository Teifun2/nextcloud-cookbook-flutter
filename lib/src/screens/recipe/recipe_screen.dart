import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/timer.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe/widget/instruction_list.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe/widget/nutrition_list.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe_edit_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/util/setting_keys.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/animated_time_progress_bar.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/authentication_cached_network_recipe_image.dart';
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
  bool isLargeScreen = false;

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

  Future<void> _refresh() async {
    DefaultCacheManager().emptyCache();
    this.setState(() {});
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle settingsBasedTextStyle = TextStyle(
      fontSize: Settings.getValue<double>(
        describeEnum(SettingKeys.recipe_font_size),
        Theme.of(context).textTheme.bodyText2.fontSize,
      ),
    );

    if (MediaQuery.of(context).size.width > 600) {
      this.isLargeScreen = true;
    }
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
              actions: <Widget>[
                // action button
                IconButton(
                  icon: Icon(
                    Icons.edit,
                  ),
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
                ),
              ],
            ),
            floatingActionButton: state is RecipeLoadSuccess
                ? _buildFabButton(state.recipe)
                : null,
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

  FloatingActionButton _buildFabButton(Recipe recipe) {
    var enabled = recipe.cookTime != null && recipe.cookTime > Duration.zero;
    return FloatingActionButton(
      onPressed: () {
        {
          if (enabled) {
            Timer timer = new Timer(
                recipe.id,
                recipe.name,
                recipe.name + " " + translate('timer.finished'),
                recipe.cookTime);
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
                child: AuthenticationCachedNetworkRecipeImage(
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
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
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
                    ),
                  if (this.isLargeScreen && recipe.recipeIngredient.isNotEmpty)
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: NutritionList(recipe.nutrition),
                              ),
                              Expanded(
                                flex: 5,
                                child: this._buildRecipeIngredient(
                                    recipe, settingsBasedTextStyle),
                              ),
                              Expanded(
                                flex: 5,
                                child: InstructionList(
                                    recipe, settingsBasedTextStyle),
                              )
                            ]))
                  else
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Column(children: <Widget>[
                          if (recipe.nutrition.isNotEmpty)
                            NutritionList(recipe.nutrition),
                          if (recipe.recipeIngredient.isNotEmpty)
                            this._buildRecipeIngredient(
                                recipe, settingsBasedTextStyle),
                          InstructionList(recipe, settingsBasedTextStyle)
                        ]))
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRecipeIngredient(
      Recipe recipe, TextStyle settingsBasedTextStyle) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(translate('recipe.fields.ingredients')),
            initiallyExpanded: true,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    recipe.recipeIngredient
                        .fold("", (p, e) => p + "-  " + e.trim() + "\n"),
                    style: settingsBasedTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ));
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
