import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/authentication/authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe_short.dart';
import 'package:nextcloud_cookbook_flutter/src/services/data_repository.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';


class RecipeScreen extends StatefulWidget {
  final RecipeShort recipeShort;

  const RecipeScreen({Key key, @required this.recipeShort}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RecipeScreenState();
}

class RecipeScreenState extends State<RecipeScreen> {
  RecipeShort recipeShort;

  @override
  void initState() {
    recipeShort = widget.recipeShort;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    UserRepository userRepository = BlocProvider.of<AuthenticationBloc>(context).userRepository;

    RecipeBloc recipeBloc = RecipeBloc(dataRepository: DataRepository(), userRepository: userRepository);
    recipeBloc.add(RecipeLoaded(recipeId: recipeShort.recipeId));

    return Scaffold(
      appBar: AppBar (
        title: Text("Recipe"),
      ),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        bloc: recipeBloc,
        builder: (BuildContext context, RecipeState state) {
          if (state is RecipeLoadSuccess) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(recipeShort.name),
            );
          } else if (state is RecipeLoadInProgress) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Text("FAILED"),
            );
          }
        },)
    );
  }
}


