import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nc_cookbook_api/nc_cookbook_api.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/timer.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe_edit_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/services/services.dart';
import 'package:nextcloud_cookbook_flutter/src/util/wakelock.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/animated_time_progress_bar.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/recipe/recipe_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/recipe_image.dart';

class RecipeScreen extends StatelessWidget {
  final String recipeId;

  const RecipeScreen({
    required this.recipeId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RecipeBloc>(
      create: (context) => RecipeBloc()..add(RecipeLoaded(recipeId)),
      child: BlocBuilder<RecipeBloc, RecipeState>(
        builder: builder,
      ),
    );
  }

  Widget builder(BuildContext context, RecipeState state) {
    switch (state.status) {
      case RecipeStatus.loadSuccess:
        return RecipeScreenBody(recipe: state.recipe!);
      case RecipeStatus.loadFailure:
      case RecipeStatus.createFailure:
      case RecipeStatus.updateFailure:
      case RecipeStatus.importFailure:
        return Scaffold(
          body: Center(
            child: Text(state.error!),
          ),
        );
      default:
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
    }
  }
}

class RecipeScreenBody extends StatefulWidget {
  const RecipeScreenBody({
    required this.recipe,
    super.key,
  });

  final Recipe recipe;

  @override
  State<RecipeScreenBody> createState() => _RecipeScreenBodyState();
}

class _RecipeScreenBodyState extends State<RecipeScreenBody> {
  late Recipe recipe;

  Future<void> _onEdit() async {
    disableWakelock();

    final recipeBloc = BlocProvider.of<RecipeBloc>(context);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: recipeBloc,
          child: RecipeEditScreen(recipe),
        ),
      ),
    );
    enableWakelock();
  }

  @override
  void initState() {
    super.initState();

    recipe = widget.recipe;
    enableWakelock();
  }

  @override
  Widget build(BuildContext context) {
    final list = [
      if (recipe.nutritionList.isNotEmpty) NutritionList(recipe.nutritionList),
      if (recipe.recipeIngredient.isNotEmpty) IngredientList(recipe),
      InstructionList(recipe),
    ];

    final header = SliverList(
      delegate: SliverChildListDelegate.fixed([
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: MarkdownBody(data: recipe.description),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: RecipeYield(recipe: recipe),
        ),
        DurationList(recipe: recipe),
      ]),
    );

    final timerList = SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final timer = TimerList().timers[index];

          return TimerListItem(
            timer: timer,
            onPressed: () => setState(() => TimerList().remove(timer)),
          );
        },
        childCount: TimerList().timers.length,
      ),
    );

    final bottom = SliverList(
      delegate: SliverChildListDelegate.fixed([
        if (recipe.tool.isNotEmpty) ToolList(recipe: recipe),
        if (MediaQuery.of(context).size.width > 600)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: list.map((e) => Expanded(flex: 5, child: e)).toList(),
          )
        else
          ...list,
      ]),
    );

    final body = WillPopScope(
      onWillPop: disableWakelock,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: RecipeImage(
                id: recipe.id,
                size: const Size(double.infinity, 350),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: header,
            ),
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 16.0),
              sliver: timerList,
            ),
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 75.0),
              sliver: bottom,
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: translate("recipe_create.title").toLowerCase(),
            onPressed: _onEdit,
          ),
        ],
        title: Text(recipe.name),
        centerTitle: true,
      ),
      body: body,
      floatingActionButton: RecipeScreenFab(
        enabled: recipe.cookTime != null,
        onPressed: () => setState(() => TimerList().add(Timer(recipe))),
      ),
    );
  }
}

class TimerListItem extends StatelessWidget {
  const TimerListItem({
    required this.timer,
    this.onPressed,
    super.key,
  });

  final Timer timer;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: UniqueKey(),
      title: AnimatedTimeProgressBar(timer: timer),
      trailing: IconButton(
        icon: const Icon(Icons.cancel_outlined),
        tooltip: translate("timer.button.cancel"),
        onPressed: onPressed,
      ),
    );
  }
}

class RecipeScreenFab extends StatelessWidget {
  const RecipeScreenFab({
    required this.onPressed,
    required this.enabled,
    super.key,
  });

  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final color = enabled
        ? Theme.of(context).colorScheme.secondary
        : Theme.of(context).disabledColor;

    void callback() {
      final SnackBar snackBar;
      if (enabled) {
        onPressed();
        snackBar = SnackBar(content: Text(translate('timer.started')));
      } else {
        snackBar = SnackBar(content: Text(translate('timer.missing')));
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return FloatingActionButton(
      onPressed: callback,
      tooltip: translate("timer.button.start"),
      backgroundColor: color,
      child: const Icon(Icons.access_alarm_outlined),
    );
  }
}
