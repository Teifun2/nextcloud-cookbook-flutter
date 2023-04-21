import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/authentication/authentication_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/categories/categories_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipes_short/recipes_short_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/simple_bloc_delegatae.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/category_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/loading_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/login_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/splash_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/services/services.dart';
import 'package:nextcloud_cookbook_flutter/src/util/lifecycle_event_handler.dart';
import 'package:nextcloud_cookbook_flutter/src/util/setting_keys.dart';
import 'package:nextcloud_cookbook_flutter/src/util/supported_locales.dart';
import 'package:nextcloud_cookbook_flutter/src/util/theme_data.dart';
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
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(
    LocalizedApp(
      delegate,
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc()..add(const AppStarted()),
          ),
          BlocProvider<RecipesShortBloc>(
            create: (context) => RecipesShortBloc(),
          ),
          BlocProvider<CategoriesBloc>(
            create: (context) => CategoriesBloc(),
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
    unawaited(changeLocale(context, savedLocalization));
  }

  @override
  Widget build(BuildContext context) => ThemeModeHandler(
        manager: ThemeModeManager(),
        builder: (themeMode) => MaterialApp(
          navigatorKey: IntentRepository().getNavigationKey(),
          themeMode: themeMode,
          theme: AppTheme.lightThemeData,
          darkTheme: AppTheme.darkThemeData,
          home: BlocConsumer<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle(
                  systemNavigationBarColor:
                      Theme.of(context).scaffoldBackgroundColor,
                ),
              );

              switch (state.status) {
                case AuthenticationStatus.loading:
                  return const SplashPage();
                case AuthenticationStatus.authenticated:
                  return const CategoryScreen();
                case AuthenticationStatus.unauthenticated:
                  return const LoginScreen();
                case AuthenticationStatus.invalid:
                  return const LoginScreen(
                    invalidCredentials: true,
                  );
                case AuthenticationStatus.error:
                  return LoadingErrorScreen(message: state.error!);
              }
            },
            listener: (context, state) async {
              if (state.status != AuthenticationStatus.loading) {
                FlutterNativeSplash.remove();
              } else if (state.status == AuthenticationStatus.authenticated) {
                await IntentRepository().handleIntent();
              }
            },
          ),
        ),
      );
}
