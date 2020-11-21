import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/categories/categories.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipes_short/recipes_short.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/landing_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/loading_indicator.dart';

import './src/screens/login_page.dart';
import './src/screens/splash_screen.dart';
import './src/services/user_repository.dart';
import 'src/blocs/authentication/authentication.dart';
import 'src/blocs/simple_bloc_delegatae.dart';

void main() async {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  var delegate = await LocalizationDelegate.create(
    basePath: 'assets/i18n/',
    fallbackLocale: 'en',
    supportedLocales: ['en', 'de'],
  );
  runApp(
    LocalizedApp(
      delegate,
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) {
              return AuthenticationBloc()..add(AppStarted());
            },
          ),
          BlocProvider<RecipesShortBloc>(
            create: (context) {
              return RecipesShortBloc();
            },
          ),
          BlocProvider<CategoriesBloc>(
            create: (context) {
              return CategoriesBloc();
            },
          )
        ],
        child: App(),
      ),
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
          } else if (state is AuthenticationAuthenticated) {
            if (BlocProvider.of<CategoriesBloc>(context).state
                is CategoriesInitial) {
              BlocProvider.of<CategoriesBloc>(context).add(CategoriesLoaded());
            }
            return LandingScreen();
          } else if (state is AuthenticationUnauthenticated) {
            return LoginPage();
          } else if (state is AuthenticationLoading) {
            return LoadingIndicator();
          } else {
            return LoadingIndicator();
          }
        },
      ),
    );
  }
}
