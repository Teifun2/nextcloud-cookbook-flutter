import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/categories/categories.dart';
import 'package:nextcloud_cookbook_flutter/src/models/category.dart';

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
    return Column(
      children: <Widget>[
        TextField(
          readOnly: true,
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            semanticChildCount: categories.length,
            children: categories
                .map((category) => Text(category.name +
                    (category.imageUrl != null ? "Yes" : "nope")))
                .toList(),
          ),
        ),
//        Wrap(
//          direction: Axis.horizontal,
//          children: categories.map((category) => Text(category.name)).toList(),
//        ),
      ],
    );
  }
}
