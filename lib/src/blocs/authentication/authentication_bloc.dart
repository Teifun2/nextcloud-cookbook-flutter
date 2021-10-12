import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../services/user_repository.dart';
import 'authentication.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository = UserRepository();

  AuthenticationBloc() : super(AuthenticationUninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppStarted) {
      final bool hasToken = await userRepository.hasAppAuthentication();

      if (hasToken) {
        yield AuthenticationLoading();
        await userRepository.loadAppAuthentication();
        bool validCredentials = await userRepository.checkAppAuthentication();
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
