import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/authentication/authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository = UserRepository();

  AuthenticationBloc() : super(AuthenticationUninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event,) async* {
    if (event is AppStarted) {
      final bool hasToken = await userRepository.hasAppAuthentication();

      if (hasToken) {
        yield AuthenticationLoading();
        await userRepository.loadAppAuthentication();
        bool validCredentials = false;
        try {
          validCredentials = await userRepository.checkAppAuthentication();
        } catch (e) {
          yield AuthenticationError(e.toString());
          return;
        }
        if (validCredentials) {
          await userRepository.fetchApiVersion();
          yield AuthenticationAuthenticated();
        } else {
          await userRepository.deleteAppAuthentication();
          yield AuthenticationInvalid();
        }
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      await userRepository.persistAppAuthentication(event.appAuthentication);
      await userRepository.fetchApiVersion();
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await userRepository.deleteAppAuthentication();
      yield AuthenticationUnauthenticated();
    }
  }
}
