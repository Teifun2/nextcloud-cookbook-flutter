import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/categories/categories.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipes_short/recipes_short.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/category_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/loading_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/services/intent_repository.dart';
import 'package:nextcloud_cookbook_flutter/src/util/lifecycle_event_handler.dart';
import 'package:nextcloud_cookbook_flutter/src/util/supported_locales.dart';
import 'package:nextcloud_cookbook_flutter/src/util/theme_mode_manager.dart';
import 'package:nextcloud_cookbook_flutter/src/util/translate_preferences.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';

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
    supportedLocales: SupportedLocales.locales.keys.toList(),
    preferences: TranslatePreferences(),
  );
  // Wait for Settings to be ready
  await Settings.init();
  // Wait for Notifications to be ready
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

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final UserRepository userRepository = UserRepository();

  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        resumeCallBack: () async => setState(() {
          IntentRepository().handleIntent();
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeModeHandler(
      manager: ThemeModeManager(),
      builder: (ThemeMode themeMode) => MaterialApp(
        navigatorKey: IntentRepository().getNavigationKey(),
        themeMode: themeMode,
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
              IntentRepository().handleIntent();
              if (BlocProvider.of<CategoriesBloc>(context).state
                  is CategoriesInitial) {
                BlocProvider.of<CategoriesBloc>(context)
                    .add(CategoriesLoaded());
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
      ),
    );
  }
}
