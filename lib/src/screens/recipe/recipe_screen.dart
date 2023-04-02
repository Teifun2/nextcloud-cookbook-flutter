import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nc_cookbook_api/nc_cookbook_api.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/timer.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe/widget/ingredient_list.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe/widget/instruction_list.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe/widget/nutrition_list.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe_edit_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/services/services.dart';
import 'package:nextcloud_cookbook_flutter/src/util/setting_keys.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/animated_time_progress_bar.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/duration_indicator.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/recipe_image.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wakelock/wakelock.dart';

class RecipeScreen extends StatefulWidget {
  final String recipeId;

  const RecipeScreen({
    super.key,
    required this.recipeId,
  });

  @override
  State<StatefulWidget> createState() => RecipeScreenState();
}

class RecipeScreenState extends State<RecipeScreen> {
  late bool isLargeScreen;

  Future<bool> _disableWakelock() async {
    final bool wakelockEnabled = await Wakelock.enabled;
    if (wakelockEnabled) {
      Wakelock.disable();
    }
    return Future.value(true);
  }

  void _enableWakelock() {
    if (Settings.getValue<bool>(
      SettingKeys.stay_awake.name,
      defaultValue: false,
    )!) {
      Wakelock.enable();
    }
  }

  @override
  void initState() {
    super.initState();
    _enableWakelock();
  }

  @override
  void didChangeDependencies() {
    isLargeScreen = MediaQuery.of(context).size.width > 600;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RecipeBloc>(
      create: (context) => RecipeBloc()..add(RecipeLoaded(widget.recipeId)),
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
                    icon: const Icon(
                      Icons.edit,
                    ),
                    onPressed: () async {
                      if (state.status == RecipeStatus.loadSuccess) {
                        _disableWakelock();
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return BlocProvider.value(
                                value: recipeBloc,
                                child: RecipeEditScreen(state.recipe!),
                              );
                            },
                          ),
                        );
                        _enableWakelock();
                      }
                    },
                  ),
                ],
              ),
              floatingActionButton: state.status == RecipeStatus.loadSuccess
                  ? _buildFabButton(state.recipe!)
                  : null,
              body: () {
                switch (state.status) {
                  case RecipeStatus.loadSuccess:
                    return _buildRecipeScreen(state.recipe!);
                  case RecipeStatus.loadInProgress:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case RecipeStatus.failure:
                    return Center(
                      child: Text(state.error!),
                    );
                  default:
                    return const Center(
                      child: Text("FAILED"),
                    );
                }
              }(),
            ),
          );
        },
      ),
    );
  }

  FloatingActionButton _buildFabButton(Recipe recipe) {
    final enabled = recipe.cookTime != null;
    return FloatingActionButton(
      onPressed: () {
        {
          if (enabled) {
            TimerList().timers.add(Timer(recipe));
            setState(() {});
            final snackBar =
                SnackBar(content: Text(translate('timer.started')));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            final snackBar =
                SnackBar(content: Text(translate('timer.missing')));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
      },
      backgroundColor: enabled
          ? Theme.of(context).colorScheme.secondary
          : Theme.of(context).disabledColor,
      child: const Icon(Icons.access_alarm),
    );
  }

  Widget _buildRecipeScreen(Recipe recipe) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        final TextStyle settingsBasedTextStyle = TextStyle(
          fontSize: Settings.getValue<double>(
            SettingKeys.recipe_font_size.name,
            defaultValue: Theme.of(context).textTheme.bodyMedium?.fontSize,
          ),
        );

        return ListView(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              height: 200,
              child: Center(
                child: RecipeImage(
                  id: recipe.id,
                  size: const Size(double.infinity, 200),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      recipe.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: MarkdownBody(
                      data: recipe.description,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: translate('recipe.fields.servings'),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .apply(fontWeightDelta: 3),
                            children: <TextSpan>[
                              TextSpan(
                                text: " ${recipe.recipeYield}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .apply(fontWeightDelta: 3),
                              )
                            ],
                          ),
                        ),
                        const Spacer(),
                        if (recipe.url.isNotEmpty)
                          ElevatedButton(
                            style: const ButtonStyle(),
                            onPressed: () async {
                              if (await launchUrlString(recipe.url)) {
                                await launchUrlString(recipe.url);
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
                            duration: recipe.prepTime!,
                            name: translate('recipe.prep'),
                          ),
                        if (recipe.cookTime != null)
                          DurationIndicator(
                            duration: recipe.cookTime!,
                            name: translate('recipe.cook'),
                          ),
                        if (recipe.totalTime != null)
                          DurationIndicator(
                            duration: recipe.totalTime!,
                            name: translate('recipe.total'),
                          ),
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
                                    (p, e) => "$p-  ${e.trim()}\n",
                                  ),
                                  style: settingsBasedTextStyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (isLargeScreen &&
                      recipe.recipeIngredient.isNotEmpty &&
                      recipe.nutritionList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: NutritionList(recipe.nutritionList),
                          ),
                          Expanded(
                            flex: 5,
                            child: IngredientList(
                              recipe,
                              settingsBasedTextStyle,
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: InstructionList(
                              recipe,
                              settingsBasedTextStyle,
                            ),
                          )
                        ],
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        children: <Widget>[
                          if (recipe.nutritionList.isNotEmpty)
                            NutritionList(recipe.nutritionList),
                          if (recipe.recipeIngredient.isNotEmpty)
                            IngredientList(recipe, settingsBasedTextStyle),
                          InstructionList(recipe, settingsBasedTextStyle)
                        ],
                      ),
                    )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _showTimers(Recipe recipe) {
    final timers = TimerList().timers;
    if (timers.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: timers.length,
              itemBuilder: (context, index) {
                return _buildTimerListItem(timers[index]);
              },
            )
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  ListTile _buildTimerListItem(Timer timer) {
    return ListTile(
      key: UniqueKey(),
      title: AnimatedTimeProgressBar(
        timer: timer,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.cancel),
        onPressed: () {
          TimerList().remove(timer);
          setState(() {});
        },
      ),
    );
  }
}
