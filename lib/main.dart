import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/authentication/authentication_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/categories/categories_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipes_short/recipes_short_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/simple_bloc_delegatae.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/category/category_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/loading_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/login_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/splash_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/services/intent_repository.dart';
import 'package:nextcloud_cookbook_flutter/src/services/notification_provider.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';
import 'package:nextcloud_cookbook_flutter/src/util/lifecycle_event_handler.dart';
import 'package:nextcloud_cookbook_flutter/src/util/setting_keys.dart';
import 'package:nextcloud_cookbook_flutter/src/util/supported_locales.dart';
import 'package:nextcloud_cookbook_flutter/src/util/theme_mode_manager.dart';
import 'package:nextcloud_cookbook_flutter/src/util/translate_preferences.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';

void main() async {
  Bloc.observer = SimpleBlocDelegate();
  final delegate = await LocalizationDelegate.create(
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
              return AuthenticationBloc()..add(const AppStarted());
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
        child: const App(),
      ),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final UserRepository userRepository = UserRepository();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        resumeCallBack: () async => setState(() {
          IntentRepository().handleIntent();
        }),
      ),
    );

    // Update Localization if Settings are set!
    final savedLocalization = Settings.getValue<String>(
      SettingKeys.language.name,
    );
    changeLocale(context, savedLocalization);
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
            switch (state.status) {
              case AuthenticationStatus.loading:
                return const SplashPage();
              case AuthenticationStatus.authenticated:
                IntentRepository().handleIntent();
                final categoryBloc = BlocProvider.of<CategoriesBloc>(context);
                if (categoryBloc.state.status ==
                    CategoriesStatus.loadInProgress) {
                  categoryBloc.add(const CategoriesLoaded());
                }
                return const CategoryScreen();
              case AuthenticationStatus.unauthenticated:
                return const LoginScreen();
              case AuthenticationStatus.invalid:
                return const LoginScreen(
                  invalidCredentials: true,
                );
              case AuthenticationStatus.error:
                return const LoadingErrorScreen();
            }
          },
        ),
      ),
    );
  }
}
