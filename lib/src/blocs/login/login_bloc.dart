import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/authentication/authentication_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/services/services.dart';
import 'package:nextcloud_cookbook_flutter/src/util/url_validator.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required this.authenticationBloc,
  }) : super(LoginState()) {
    on<LoginButtonPressed>(_mapLoginButtonPressedEventToState);
  }
  final UserRepository userRepository = UserRepository();
  final AuthenticationBloc authenticationBloc;

  Future<void> _mapLoginButtonPressedEventToState(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginState(status: LoginStatus.loading));

    try {
      assert(URLUtils.isSanitized(event.serverURL));

      final appAuthentication = await userRepository.authenticateAppPassword(
        event.serverURL,
        event.username,
        event.appPassword,
        isSelfSignedCertificate: event.isSelfSignedCertificate,
      );

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
