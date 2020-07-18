import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipes_short/recipes_short.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/loading_indicator.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipes_list.dart';

import 'package:nextcloud_cookbook_flutter/src/blocs/authentication/authentication_events.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/authentication/authentication_state.dart';
import 'package:nextcloud_cookbook_flutter/src/services/repository.dart';
import './src/services/user_repository.dart';

import 'src/blocs/authentication/authentication_bloc.dart';
import './src/screens/splash_screen.dart';

import './src/screens/login_page.dart';



class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final userRepository = UserRepository();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) {
            return AuthenticationBloc(userRepository: userRepository)..add(AppStarted());},
        ),
        BlocProvider<RecipesShortBloc>(
          create: (context) {
            return RecipesShortBloc(repository: Repository());
          },
        ),
      ],
      child: App(userRepository: userRepository),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository userRepository;

  App({Key key, @required this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationUninitialized) {
            return SplashPage();
          }
          else if (state is AuthenticationAuthenticated) {
            BlocProvider.of<RecipesShortBloc>(context).add(RecipesShortLoaded(appAuthentication: state.appAuthentication));
            return RecipesListScreen();
          }
          else if (state is AuthenticationUnauthenticated) {
            print("LoginPage");
            return LoginPage(userRepository: userRepository);
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