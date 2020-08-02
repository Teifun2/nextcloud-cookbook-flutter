import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe_short.dart';
import 'package:nextcloud_cookbook_flutter/src/services/data_repository.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SearchBar<RecipeShort>(
          onCancelled: () => Navigator.pop(context),
          onSearch: (text) =>
              DataRepository().fetchRecipesShort(category: text),
          onItemFound: (RecipeShort item, int index) {
            return ListTile(
              title: Text(item.name),
            );
          },
        ),
      ),
    );
  }
}
