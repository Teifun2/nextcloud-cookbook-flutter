import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/authentication/authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/categories/categories.dart';
import 'package:nextcloud_cookbook_flutter/src/models/category.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe_create_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe_import_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipes_list_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/search_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/api_version_warning.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/category_card.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, categoriesState) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return RecipeCreateScreen(Recipe.empty());
                  },
                ),
              );
            },
            child: Icon(Icons.add),
          ),
          drawer: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Column(
                    children: [
                      Text('Coming soon!'),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                ListTile(
                  trailing: Icon(
                    Icons.exit_to_app,
                    semanticLabel: translate('app_bar.logout'),
                  ),
                  title: Text(translate('app_bar.logout')),
                  onTap: () {
                    BlocProvider.of<AuthenticationBloc>(context)
                        .add(LoggedOut());
                  },
                ),
                ListTile(
                  trailing: Icon(
                    Icons.cloud_download_outlined,
                    semanticLabel: translate('categories.drawer.import'),
                  ),
                  title: Text(translate('categories.drawer.import')),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return RecipeImportScreen();
                      }),
                    );
                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
            title: Text(translate('categories.title')),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.search,
                  semanticLabel: translate('app_bar.search'),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SearchScreen();
                      },
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  semanticLabel: translate('app_bar.refresh'),
                ),
                onPressed: () {
                  BlocProvider.of<CategoriesBloc>(context)
                      .add(CategoriesLoaded());
                },
              ),
            ],
          ),
          body: (() {
            if (categoriesState is CategoriesLoadSuccess) {
              return _buildCategoriesScreen(categoriesState.categories);
            } else if (categoriesState is CategoriesImageLoadSuccess) {
              return _buildCategoriesScreen(categoriesState.categories);
            } else if (categoriesState is CategoriesLoadInProgress ||
                categoriesState is CategoriesInitial) {
              return Column(
                children: [
                  ApiVersionWarning(),
                  Center(child: CircularProgressIndicator()),
                ],
              );
            } else if (categoriesState is CategoriesLoadFailure) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      translate('categories.errors.plugin_missing'),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                    Text(translate('categories.errors.load_failed',
                        args: {'error_msg': categoriesState.errorMsg})),
                  ],
                ),
              );
            } else {
              return Text(translate('categories.errors.unknown'));
            }
          }()),
        );
      },
    );
  }

  Widget _buildCategoriesScreen(List<Category> categories) {
    double screenWidth = MediaQuery.of(context).size.width;
    int axisRatio = (screenWidth / 150).round();
    int axisCount = axisRatio < 1 ? 1 : axisRatio;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.count(
        crossAxisCount: axisCount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        padding: EdgeInsets.only(top: 10),
        semanticChildCount: categories.length,
        children: categories
            .map(
              (category) => GestureDetector(
                child: CategoryCard(category),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return RecipesListScreen(category: category.name);
                    },
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
