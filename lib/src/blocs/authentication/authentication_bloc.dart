import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/services/services.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository = UserRepository();

  AuthenticationBloc() : super(AuthenticationState()) {
    on<AppStarted>(_mapAppStartedEventToState);
    on<LoggedIn>(_mapLoggedInEventToState);
    on<LoggedOut>(_mapLoggedOutEventToState);
  }

  Future<void> _mapAppStartedEventToState(
    AppStarted event,
    Emitter<AuthenticationState> emit,
  ) async {
    final bool hasToken = await userRepository.hasAppAuthentication();

    if (hasToken) {
      await userRepository.loadAppAuthentication();
      try {
        final validCredentials = await userRepository.checkAppAuthentication();

        if (validCredentials) {
          emit(AuthenticationState(status: AuthenticationStatus.authenticated));
        } else {
          await userRepository.deleteAppAuthentication();
          emit(AuthenticationState(status: AuthenticationStatus.invalid));
        }
      } catch (e) {
        emit(
          AuthenticationState(
            status: AuthenticationStatus.error,
            error: e.toString(),
          ),
        );
      }
    } else {
      emit(AuthenticationState(status: AuthenticationStatus.unauthenticated));
    }
  }

  Future<void> _mapLoggedInEventToState(
    LoggedIn event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationState());
    await userRepository.persistAppAuthentication(event.appAuthentication);
    emit(AuthenticationState(status: AuthenticationStatus.authenticated));
  }

  Future<void> _mapLoggedOutEventToState(
    LoggedOut event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationState());
    await userRepository.deleteAppAuthentication();
    emit(AuthenticationState(status: AuthenticationStatus.unauthenticated));
  }
}
