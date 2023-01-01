import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipes_short/recipes_short.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe_short.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe/recipe_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/authentication_cached_network_recipe_image.dart';

class RecipesListScreen extends StatefulWidget {
  final String category;

  const RecipesListScreen({
    super.key,
    required this.category,
  });

  @override
  State<StatefulWidget> createState() => RecipesListScreenState();
}

class RecipesListScreenState extends State<RecipesListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<RecipesShortBloc>(context)
        .add(RecipesShortLoaded(category: widget.category));

    return BlocBuilder<RecipesShortBloc, RecipesShortState>(
      builder: (context, recipesShortState) {
        return Scaffold(
          appBar: AppBar(
            title: Text(translate(
              'recipe_list.title_category',
              args: {'category': widget.category},
            )),
            actions: <Widget>[
              // action button
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  semanticLabel: translate('app_bar.refresh'),
                ),
                onPressed: () {
                  DefaultCacheManager().emptyCache();
                  BlocProvider.of<RecipesShortBloc>(context)
                      .add(RecipesShortLoaded(category: widget.category));
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () {
              DefaultCacheManager().emptyCache();
              BlocProvider.of<RecipesShortBloc>(context)
                  .add(RecipesShortLoaded(category: widget.category));
              return Future.value(true);
            },
            child: (() {
              if (recipesShortState is RecipesShortLoadSuccess) {
                return _buildRecipesShortScreen(recipesShortState.recipesShort);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }()),
          ),
        );
      },
    );
  }

  Widget _buildRecipesShortScreen(List<RecipeShort> data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _buildRecipeShortScreen(data[index]);
        },
        separatorBuilder: (context, index) => Divider(
          color: Colors.black,
        ),
      ),
    );
  }

  ListTile _buildRecipeShortScreen(RecipeShort recipeShort) {
    return ListTile(
      title: Text(recipeShort.name),
      trailing: Container(
        child: AuthenticationCachedNetworkRecipeImage(
          recipeId: recipeShort.recipeId,
          full: false,
          width: 60,
          height: 60,
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RecipeScreen(recipeId: recipeShort.recipeId),
            ));
      },
    );
  }
}
