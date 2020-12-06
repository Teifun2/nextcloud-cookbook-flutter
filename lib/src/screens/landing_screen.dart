import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/authentication/authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/categories/categories.dart';
import 'package:nextcloud_cookbook_flutter/src/models/category.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipes_list_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/search_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/category_card.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, categoriesState) {
        return Scaffold(
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
              IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  semanticLabel: translate('app_bar.logout'),
                ),
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
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
              return Center(child: CircularProgressIndicator());
            } else if (categoriesState is CategoriesLoadFailure) {
              return Text(translate('categories.errors.load_failed',
                  args: {'error_msg': categoriesState.errorMsg}));
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
