import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/categories/categories.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipes_short/recipes_short.dart';
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
          appBar: AppBar(title: Text("Cookbook")),
          body: (() {
            if (categoriesState is CategoriesLoadSuccess) {
              return _buildCategoriesScreen(categoriesState.categories);
            } else if (categoriesState is CategoriesImageLoadSuccess) {
              return _buildCategoriesScreen(categoriesState.categories);
            } else {
              return Center(child: CircularProgressIndicator());
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
                            BlocProvider.of<RecipesShortBloc>(context).add(
                                RecipesShortLoaded(category: category.name));
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
