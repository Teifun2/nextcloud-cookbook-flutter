import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager_dio/flutter_cache_manager_dio.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipes_short/recipes_short_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/recipe_list_item.dart';

class RecipesListScreen extends StatefulWidget {
  const RecipesListScreen({
    required this.category,
    super.key,
  });
  final String category;

  @override
  State<RecipesListScreen> createState() => _RecipesListScreenState();
}

class _RecipesListScreenState extends State<RecipesListScreen> {
  Future<void> refresh() async {
    await DioCacheManager.instance.emptyCache();
    // ignore: use_build_context_synchronously
    BlocProvider.of<RecipesShortBloc>(context)
        .add(RecipesShortLoaded(category: widget.category));
  }

  @override
  void initState() {
    super.initState();

    BlocProvider.of<RecipesShortBloc>(context)
        .add(RecipesShortLoaded(category: widget.category));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            translate(
              'recipe_list.title_category',
              args: {'category': widget.category},
            ),
          ),
          actions: <Widget>[
            // action button
            IconButton(
              icon: const Icon(Icons.refresh_outlined),
              tooltip: MaterialLocalizations.of(context)
                  .refreshIndicatorSemanticLabel,
              onPressed: refresh,
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: BlocBuilder<RecipesShortBloc, RecipesShortState>(
            builder: (context, recipesShortState) {
              if (recipesShortState.status == RecipesShortStatus.loadSuccess) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListView.separated(
                    itemCount: recipesShortState.recipesShort!.length,
                    itemBuilder: (context, index) => RecipeListItem(
                      recipe: recipesShortState.recipesShort!.elementAt(index),
                    ),
                    separatorBuilder: (context, index) => const Divider(),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      );
}
