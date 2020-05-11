import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipes_short/recipes_short.dart';
import 'package:nextcloud_cookbook_flutter/src/services/repository.dart';

import 'src/screens/welcome_screen.dart';

void main() => runApp(
    BlocProvider(
      create: (context) {
        return RecipesShortBloc(repository: Repository());
      },
      child: NextcloudCookbook()
    )
);

class NextcloudCookbook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Nextcloud Cookbook",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(),
    );
  }
}
