import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipes_short_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe_short_model.dart';
import 'package:nextcloud_cookbook_flutter/src/services/recipes_short_provider.dart';

class RecipesShortScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RecipesShortScreenState();
}

class RecipesShortScreenState extends State<RecipesShortScreen> {
  @override
  Widget build(BuildContext context) {
    recipesShortBloc.fetchRecipesShort();
    return Scaffold(
      body: StreamBuilder(
        stream: recipesShortBloc.recipesShort,
        builder: (context, AsyncSnapshot<List<RecipeShort>> snapshot) {
          if (snapshot.hasData) {
            return _buildRecipesShortScreen(snapshot.data);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  ListView _buildRecipesShortScreen(List<RecipeShort> data) {
    return ListView.separated(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _buildRecipeShortScreen(data[index]);
      },
      separatorBuilder: (context, index) => Divider(
        color: Colors.black,
      ),
    );
  }

  ListTile _buildRecipeShortScreen(RecipeShort data) {
    return ListTile(
      title: Text(data.name),
      trailing: RecipesShortProvider().fetchRecipeThumb(data.imageUrl),
      onTap: () => print(data.name),
    );
  }
}
