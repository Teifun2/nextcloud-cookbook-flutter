import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import '../../services/user_repository.dart';

import 'authentication_events.dart';
import 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({@required this.userRepository})
      : assert(userRepository != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AppStarted) {
      final bool hasToken = await userRepository.hasAppAuthentication();

      if (hasToken) {
        final AppAuthentication appAuthentication = await userRepository.getAppAuthentication();
        yield AuthenticationAuthenticated(appAuthentication: appAuthentication);
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      await userRepository.persistAppAuthentication(event.appAuthentication);
      yield AuthenticationAuthenticated(appAuthentication: event.appAuthentication);
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await userRepository.deleteAppAuthentication();
      yield AuthenticationUnauthenticated();
    }
  }
}