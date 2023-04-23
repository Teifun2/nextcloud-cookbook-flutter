import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nc_cookbook_api/nc_cookbook_api.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/models/animated_list.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/timer.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe_edit_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/util/wakelock.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/recipe/recipe_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/recipe_image.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/timer_list_item.dart';

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({
    required this.recipeId,
    super.key,
  });
  final String recipeId;

  @override
  Widget build(BuildContext context) => BlocProvider<RecipeBloc>(
        create: (context) => RecipeBloc()..add(RecipeLoaded(recipeId)),
        child: BlocBuilder<RecipeBloc, RecipeState>(
          builder: builder,
        ),
      );

  Widget builder(BuildContext context, RecipeState state) {
    switch (state.status) {
      case RecipeStatus.loadSuccess:
        return RecipeScreenBody(recipe: state.recipe!);
      case RecipeStatus.loadFailure:
      case RecipeStatus.createFailure:
      case RecipeStatus.deleteFailure:
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
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();

  late Recipe recipe;
  late AnimatedTimerList _list;

  Future<void> _onEdit() async {
    unawaited(disableWakelock());

    final recipeBloc = BlocProvider.of<RecipeBloc>(context);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: recipeBloc,
          child: RecipeEditScreen(recipe: recipe),
        ),
      ),
    );
    unawaited(enableWakelock());
  }

  Widget _buildTimerItem(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) =>
      TimerListItem(
        animation: animation,
        item: _list[index],
        dense: true,
        onDismissed: () {
          _list.removeAt(index);
        },
      );

  Widget _buildRemovedTimerItem(
    Timer item,
    BuildContext context,
    Animation<double> animation,
  ) =>
      TimerListItem(
        animation: animation,
        item: item,
        dense: true,
        enabled: false,
      );

  @override
  void initState() {
    super.initState();

    recipe = widget.recipe;
    unawaited(enableWakelock());

    _list = AnimatedTimerList.forId(
      listKey: _listKey,
      removedItemBuilder: _buildRemovedTimerItem,
      recipeId: recipe.id!,
    );
  }

  @override
  Widget build(BuildContext context) {
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

    final timerList = SliverAnimatedList(
      key: _listKey,
      initialItemCount: _list.length,
      itemBuilder: _buildTimerItem,
    );

    final bottom = SliverList(
      delegate: SliverChildListDelegate.fixed([
        if (MediaQuery.of(context).size.width > 600)
          ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (recipe.tool.isNotEmpty)
                  Expanded(
                    flex: 5,
                    child: ToolList(recipe: recipe),
                  ),
                if (recipe.nutritionList.isNotEmpty)
                  Expanded(
                    flex: 5,
                    child: NutritionList(recipe.nutritionList),
                  ),
              ]
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (recipe.recipeIngredient.isNotEmpty)
                  Expanded(
                    flex: 5,
                    child: IngredientList(recipe),
                  ),
                Expanded(
                  flex: 10,
                  child: InstructionList(recipe),
                ),
              ]
            ),
          ]
        else
          ...[
            if (recipe.tool.isNotEmpty) ToolList(recipe: recipe),
            if (recipe.nutritionList.isNotEmpty) NutritionList(recipe.nutritionList),
            if (recipe.recipeIngredient.isNotEmpty) IngredientList(recipe),
            InstructionList(recipe),
          ]
      ]),
    );

    final body = WillPopScope(
      onWillPop: () async {
        unawaited(disableWakelock());
        return true;
      },
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
              padding: const EdgeInsets.all(16),
              sliver: header,
            ),
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 16),
              sliver: timerList,
            ),
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 75),
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
            tooltip: translate('recipe_create.title').toLowerCase(),
            onPressed: _onEdit,
          ),
        ],
        title: Text(recipe.name),
        centerTitle: true,
      ),
      body: body,
      floatingActionButton: RecipeScreenFab(
        enabled: recipe.cookTime != null,
        onPressed: () => _list.add(Timer(recipe)),
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
      tooltip: translate('timer.button.start'),
      backgroundColor: color,
      child: const Icon(Icons.access_alarm_outlined),
    );
  }
}
