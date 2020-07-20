import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipes_short/recipes_short.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/loading_indicator.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipes_list.dart';

import './src/services/user_repository.dart';

import 'src/blocs/authentication/authentication.dart';
import './src/screens/splash_screen.dart';

import './src/screens/login_page.dart';
import 'src/blocs/simple_bloc_delegatae.dart';


void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) {
            return AuthenticationBloc()..add(AppStarted());},
        ),
        BlocProvider<RecipesShortBloc>(
          create: (context) {
            return RecipesShortBloc();
          },
        ),
      ],
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationUninitialized) {
            return SplashPage();
          }
          else if (state is AuthenticationAuthenticated) {
            BlocProvider.of<RecipesShortBloc>(context).add(RecipesShortLoaded());
            return RecipesListScreen();
          }
          else if (state is AuthenticationUnauthenticated) {
            return LoginPage();
          }
          else if (state is AuthenticationLoading) {
            return LoadingIndicator();
          }
          else {
            return LoadingIndicator();
          }
        },
      ),
    );
  }
}