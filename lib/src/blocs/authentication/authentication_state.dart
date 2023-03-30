part of 'authentication_bloc.dart';

enum AuthenticationStatus {
  unauthenticated,
  uninitialized,
  authenticated,
  invalid,
  loading,
  error;
}

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final String? error;

  const AuthenticationState({
    this.status = AuthenticationStatus.uninitialized,
    this.error,
  }) : assert(
          (status != AuthenticationStatus.error && error == null) ||
              (status == AuthenticationStatus.error && error != null),
        );

  @override
  List<Object?> get props => [status, error];
}
