import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/authentication/authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/categories/categories.dart';
import 'package:nextcloud_cookbook_flutter/src/models/category.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipes_list_screen.dart';
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
            title: Text("Cookbook"),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  semanticLabel: 'Refresh',
                ),
                onPressed: () {
                  BlocProvider.of<CategoriesBloc>(context)
                      .add(CategoriesLoaded());
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  semanticLabel: 'LogOut',
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
              return Text("Category Load Failed: ${categoriesState.errorMsg}");
            } else {
              return Text("Category unknown State!");
            }
          }()),
        );
      },
    );
  }

  Widget _buildCategoriesScreen(List<Category> categories) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          TextField(
            readOnly: true,
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
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
          ),
        ],
      ),
    );
  }
}
