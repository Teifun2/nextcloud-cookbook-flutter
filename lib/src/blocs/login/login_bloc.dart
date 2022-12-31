import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/authentication/authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/login/login.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository = UserRepository();
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    required this.authenticationBloc,
  }) : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        AppAuthentication appAuthentication;

        if (event.isAppPassword) {
          appAuthentication = await userRepository.authenticateAppPassword(
            event.serverURL,
            event.username,
            event.originalBasicAuth,
            event.isSelfSignedCertificate,
          );
        } else {
          appAuthentication = await userRepository.authenticate(
            event.serverURL,
            event.username,
            event.originalBasicAuth,
            event.isSelfSignedCertificate,
          );
        }

        authenticationBloc.add(LoggedIn(appAuthentication: appAuthentication));
        yield LoginInitial();
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
