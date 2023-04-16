import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nc_cookbook_api/nc_cookbook_api.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipes_short/recipes_short_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/recipe_image.dart';

class RecipesListScreen extends StatelessWidget {
  final String category;

  const RecipesListScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<RecipesShortBloc>(context)
        .add(RecipesShortLoaded(category: category));

    return BlocBuilder<RecipesShortBloc, RecipesShortState>(
      builder: (context, recipesShortState) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              translate(
                'recipe_list.title_category',
                args: {'category': category},
              ),
            ),
            actions: <Widget>[
              // action button
              IconButton(
                icon: const Icon(Icons.refresh_outlined),
                tooltip: translate('app_bar.refresh'),
                onPressed: () {
                  DefaultCacheManager().emptyCache();
                  BlocProvider.of<RecipesShortBloc>(context)
                      .add(RecipesShortLoaded(category: category));
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () {
              DefaultCacheManager().emptyCache();
              BlocProvider.of<RecipesShortBloc>(context)
                  .add(RecipesShortLoaded(category: category));
              return Future.value();
            },
            child: () {
              if (recipesShortState.status == RecipesShortStatus.loadSuccess) {
                return _buildRecipesShortScreen(
                  recipesShortState.recipesShort!,
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }(),
          ),
        );
      },
    );
  }

  Widget _buildRecipesShortScreen(Iterable<RecipeStub> data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _buildRecipeShortScreen(context, data.elementAt(index));
        },
        separatorBuilder: (context, index) => const Divider(
          color: Colors.black,
        ),
      ),
    );
  }

  ListTile _buildRecipeShortScreen(
    BuildContext context,
    RecipeStub recipe,
  ) {
    return ListTile(
      title: Text(recipe.name),
      trailing: RecipeImage(
        id: recipe.recipeId,
        size: const Size.square(60),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeScreen(recipeId: recipe.recipeId),
          ),
        );
      },
    );
  }
}
