import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager_dio/flutter_cache_manager_dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nc_cookbook_api/nc_cookbook_api.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/categories/categories_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipes_short/recipes_short_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe_edit_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/services/services.dart';
import 'package:nextcloud_cookbook_flutter/src/util/category_grid_delegate.dart';
import 'package:nextcloud_cookbook_flutter/src/util/theme_data.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/category_card.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/drawer.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/recipe_list_item.dart';
import 'package:search_page/search_page.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback(checkApiCallback);
  }

  Future<void> checkApiCallback(Duration _) async {
    final theme = Theme.of(context).extension<SnackBarThemes>()!;

    try {
      final apiVersion = await UserRepository().fetchApiVersion();

      if (!UserRepository().isVersionSupported(apiVersion)) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              translate(
                'categories.errors.api_version_above_confirmed',
                args: {
                  'version':
                      '${apiVersion.epoch}.${apiVersion.major}.${apiVersion.minor}'
                },
              ),
            ),
            backgroundColor: theme.warningSnackBar.backgroundColor,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            translate(
              'categories.errors.api_version_check_failed',
              args: {'error_msg': e},
            ),
            style: theme.errorSnackBar.contentTextStyle,
          ),
          backgroundColor: theme.errorSnackBar.backgroundColor,
        ),
      );
    }
  }

  Future<void> refresh() async {
    await DioCacheManager.instance.emptyCache();
    // ignore: use_build_context_synchronously
    BlocProvider.of<CategoriesBloc>(context).add(const CategoriesLoaded());
  }

  Widget bodyBuilder(BuildContext context, CategoriesState state) =>
      RefreshIndicator(
        onRefresh: refresh,
        child: Builder(
          builder: (context) {
            switch (state.status) {
              case CategoriesStatus.loadSuccess:
              case CategoriesStatus.imageLoadSuccess:
                final categories = state.categories!.toList();
                final recipe = state.recipes?.toList();

                final extent = CategoryCard.hightExtend(context);
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 75),
                  gridDelegate: CategoryGridDelegate(extent: extent),
                  semanticChildCount: categories.length,
                  itemCount: categories.length,
                  itemBuilder: (context, index) => CategoryCard(
                    categories[index],
                    recipe?[index]?.recipeId.oneOf.value.toString(),
                  ),
                );
              case CategoriesStatus.loadInProgress:
                BlocProvider.of<CategoriesBloc>(context)
                    .add(const CategoriesLoaded());

                return Center(
                  child: SpinKitWave(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              case CategoriesStatus.loadFailure:
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        translate('categories.errors.plugin_missing'),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Divider(),
                      Text(
                        translate(
                          'categories.errors.load_failed',
                          args: {'error_msg': state.error},
                        ),
                      ),
                    ],
                  ),
                );
              default:
                throw StateError('invalid CategoryState');
            }
          },
        ),
      );

  Widget iconBuilder(BuildContext context, RecipesShortState state) =>
      IconButton(
        icon: Builder(
          builder: (context) {
            switch (state.status) {
              case RecipesShortStatus.loadAllInProgress:
                return const Icon(Icons.downloading_outlined);
              case RecipesShortStatus.loadAllFailure:
                return const Icon(Icons.report_problem_outlined);
              default:
                return const Icon(Icons.search_outlined);
            }
          },
        ),
        tooltip: MaterialLocalizations.of(context).searchFieldLabel,
        onPressed: () async {
          BlocProvider.of<RecipesShortBloc>(context)
              .add(RecipesShortLoadedAll());
        },
      );

  Future<void> recipeListener(
    BuildContext context,
    RecipesShortState state,
  ) async {
    if (state.status == RecipesShortStatus.loadAllSuccess) {
      await showSearch(
        context: context,
        delegate: SearchPage<RecipeStub>(
          items: state.recipesShort!.toList(),
          searchLabel: translate('search.title'),
          suggestion: Center(
            child: Text(translate('search.description')),
          ),
          failure: Center(
            child: Text(translate('search.nothing_found')),
          ),
          filter: (recipe) => [
            recipe.name,
            recipe.keywords,
          ],
          builder: (recipe) => RecipeListItem(recipe: recipe),
        ),
      );
    } else if (state.status == RecipesShortStatus.loadAllFailure) {
      final theme =
          Theme.of(context).extension<SnackBarThemes>()!.errorSnackBar;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            translate(
              'search.errors.search_failed',
              args: {'error_msg': state.error},
            ),
            style: theme.contentTextStyle,
          ),
          backgroundColor: theme.backgroundColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(translate('categories.title')),
          actions: <Widget>[
            BlocConsumer<RecipesShortBloc, RecipesShortState>(
              builder: iconBuilder,
              listener: recipeListener,
            ),
            IconButton(
              icon: const Icon(Icons.refresh_outlined),
              tooltip: MaterialLocalizations.of(context)
                  .refreshIndicatorSemanticLabel,
              onPressed: refresh,
            ),
          ],
        ),
        drawer: const MainDrawer(),
        body: BlocBuilder<CategoriesBloc, CategoriesState>(
          builder: bodyBuilder,
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: translate('recipe_edit.title').toLowerCase(),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider<RecipeBloc>(
                  create: (context) => RecipeBloc(),
                  child: const RecipeEditScreen(),
                ),
              ),
            );
          },
          child: const Icon(Icons.add_outlined),
        ),
      );
}
