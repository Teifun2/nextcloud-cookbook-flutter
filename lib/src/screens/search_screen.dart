import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe_short.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/services/data_repository.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/authentication_cached_network_image.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen() {
    DataRepository().fetchSearchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SearchBar<RecipeShort>(
          minimumChars: 3,
          mainAxisSpacing: 5,
          onCancelled: () => Navigator.pop(context),
          onSearch: (text) => DataRepository().searchRecipes(text),
          onItemFound: (RecipeShort item, int index) {
            return ListTile(
              title: Text(item.name),
              trailing: Container(
                child:
                    AuthenticationCachedNetworkImage(imagePath: item.imageUrl),
              ),
              onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeScreen(recipeShort: item),
                  )),
            );
          },
          onError: (error) => Text(error.toString()),
          emptyWidget: Center(child: Text("No recipe found!")),
        ),
      ),
    );
  }
}
