import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/categories/categories.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipes_short/recipes_short.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/category_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/loading_screen.dart';

import './src/screens/login_screen.dart';
import './src/screens/splash_screen.dart';
import './src/services/notification_provider.dart';
import './src/services/user_repository.dart';
import 'src/blocs/authentication/authentication.dart';
import 'src/blocs/simple_bloc_delegatae.dart';

void main() async {
  Bloc.observer = SimpleBlocDelegate();
  var delegate = await LocalizationDelegate.create(
    basePath: 'assets/i18n/',
    fallbackLocale: 'en',
    supportedLocales: [
      'cs_CZ',
      'de',
      'de_DE',
      'en',
      'es',
      'eu',
      'fi_FI',
      'fr',
      'gl',
      'he',
      'hr',
      'hu_HU',
      'it',
      'nl',
      'pl',
      'pt_BR',
      'ru',
      'sc',
      'sk_SK',
      'sl',
      'tr',
      'zh_CN',
      'zh_HK'
    ],
  );
  await NotificationService().init();
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
      theme: ThemeData(
        brightness: Brightness.light,
        hintColor: Colors.grey,
        backgroundColor: Colors.grey[400],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        hintColor: Colors.grey,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationUninitialized) {
            return SplashPage();
          } else if (state is AuthenticationAuthenticated) {
            if (BlocProvider.of<CategoriesBloc>(context).state
                is CategoriesInitial) {
              BlocProvider.of<CategoriesBloc>(context).add(CategoriesLoaded());
            }
            return CategoryScreen();
          } else if (state is AuthenticationUnauthenticated) {
            return LoginScreen();
          } else if (state is AuthenticationInvalid) {
            return LoginScreen(
              invalidCredentials: true,
            );
          } else if (state is AuthenticationLoading) {
            return LoadingScreen();
          } else {
            return LoadingScreen();
          }
        },
      ),
    );
  }
}
