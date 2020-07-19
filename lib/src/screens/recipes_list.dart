import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/authentication/authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipes_short/recipes_short.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe_short.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/services/recipes_short_provider.dart';

class RecipesListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RecipesListScreenState();
}

class RecipesListScreenState extends State<RecipesListScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipesShortBloc, RecipesShortState> (
      builder: (context, recipesShortState) {
        return Scaffold(
          appBar: AppBar(
              title: Text('Cookbook App'),
              actions: <Widget>[
                // action button
                IconButton(
                  icon: Icon(Icons.refresh, semanticLabel: 'Refresh',),
                  onPressed: () {
                    AuthenticationAuthenticated authenticationState = BlocProvider.of<AuthenticationBloc>(context).state;
                    BlocProvider.of<RecipesShortBloc>(context).add(RecipesShortLoaded(appAuthentication: authenticationState.appAuthentication));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.exit_to_app, semanticLabel: 'LogOut',),
                  onPressed: () {
                    BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                  },
                ),
              ]
          ),
          body: (() {
            if (recipesShortState is RecipesShortLoadSuccess) {
              AuthenticationAuthenticated authenticationState = BlocProvider.of<AuthenticationBloc>(context).state;
              return _buildRecipesShortScreen(authenticationState.appAuthentication, recipesShortState.recipesShort);
            } else if (recipesShortState is RecipesShortLoadInProgress) {
              return Center(child: CircularProgressIndicator());
            } else {
              //TODO Retry screen
              return Center(

                child: RaisedButton(
                  onPressed: () {
                    AuthenticationAuthenticated authenticationState = BlocProvider.of<AuthenticationBloc>(context).state;
                    BlocProvider.of<RecipesShortBloc>(context).add(RecipesShortLoaded(appAuthentication: authenticationState.appAuthentication));
                  },
                  child: Text("Welcome"),
                ),
              );
            }
          }()),
        );
      },
    );
  }


  ListView _buildRecipesShortScreen(AppAuthentication appAuthentication, List<RecipeShort> data) {
    return ListView.separated(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _buildRecipeShortScreen(appAuthentication, data[index]);
      },
      separatorBuilder: (context, index) => Divider(
        color: Colors.black,
      ),
    );
  }

  ListTile _buildRecipeShortScreen(AppAuthentication appAuthentication, RecipeShort recipeShort) {
    return ListTile(
      title: Text(recipeShort.name),
      trailing: RecipesShortProvider().fetchRecipeThumb(appAuthentication, recipeShort.imageUrl),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeScreen(recipeShort: recipeShort),
          )
        );
      },
    );
  }
}
