import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/authentication/authentication_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository = UserRepository();
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    required this.authenticationBloc,
  }) : super(LoginState()) {
    on<LoginButtonPressed>(_mapLoginButtonPressedEventToState);
  }

  Future<void> _mapLoginButtonPressedEventToState(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginState(status: LoginStatus.loading));

    try {
      AppAuthentication appAuthentication;

      if (!event.isAppPassword) {
        appAuthentication = await userRepository.authenticate(
          event.serverURL,
          event.username,
          event.originalBasicAuth,
          isSelfSignedCertificate: event.isSelfSignedCertificate,
        );
      } else {
        appAuthentication = await userRepository.authenticateAppPassword(
          event.serverURL,
          event.username,
          event.originalBasicAuth,
          isSelfSignedCertificate: event.isSelfSignedCertificate,
        );
      }

      authenticationBloc.add(LoggedIn(appAuthentication: appAuthentication));
      emit(LoginState());
    } catch (error) {
      emit(
        LoginState(
          status: LoginStatus.failure,
          error: error.toString(),
        ),
      );
    }
  }
}
