import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nc_cookbook_api/nc_cookbook_api.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/services/services.dart';

part 'authentication_event.dart';
part 'authentication_exception.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(const AuthenticationState()) {
    on<AppStarted>(_mapAppStartedEventToState);
    on<LoggedIn>(_mapLoggedInEventToState);
    on<LoggedOut>(_mapLoggedOutEventToState);
  }
  final UserRepository userRepository = UserRepository();

  Future<void> _mapAppStartedEventToState(
    AppStarted event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (userRepository.hasAuthentidation) {
      try {
        await userRepository.loadAppAuthentication();

        final validCredentials = await userRepository.checkAppAuthentication();

        if (validCredentials) {
          final apiVersion = await UserRepository().fetchApiVersion();
          emit(
            AuthenticationState(
              status: AuthenticationStatus.authenticated,
              apiVersion: apiVersion,
            ),
          );
        } else {
          await userRepository.deleteAppAuthentication();
          emit(const AuthenticationState(status: AuthenticationStatus.invalid));
        }
      } on LoadAuthException {
        emit(
          const AuthenticationState(status: AuthenticationStatus.authenticated),
        );
      } catch (e) {
        emit(
          AuthenticationState(
            status: AuthenticationStatus.error,
            error: e.toString(),
          ),
        );
      }
    } else {
      emit(
        const AuthenticationState(
          status: AuthenticationStatus.unauthenticated,
        ),
      );
    }
  }

  Future<void> _mapLoggedInEventToState(
    LoggedIn event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationState());
    try {
      await userRepository.persistAppAuthentication(event.appAuthentication);

      final apiVersion = await UserRepository().fetchApiVersion();
      emit(
        AuthenticationState(
          status: AuthenticationStatus.authenticated,
          apiVersion: apiVersion,
        ),
      );
    } catch (e) {
      emit(
        AuthenticationState(
          status: AuthenticationStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _mapLoggedOutEventToState(
    LoggedOut event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationState());
    try {
      await userRepository.deleteAppAuthentication();
    } finally {
      emit(
        const AuthenticationState(status: AuthenticationStatus.unauthenticated),
      );
    }
  }
}
