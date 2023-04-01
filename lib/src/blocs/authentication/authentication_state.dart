part of 'authentication_bloc.dart';

enum AuthenticationStatus {
  /// The user has not been authenticated
  unauthenticated,

  /// The user has been authenticated
  authenticated,

  /// The provided authentication is invalid
  invalid,

  /// Loading
  ///
  /// Can either:
  ///  - retrive saved authentication
  ///  - log in witht he provided authentication
  loading,

  /// An error accured while authenticating
  error;
}

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final String? error;

  const AuthenticationState({
    this.status = AuthenticationStatus.loading,
    this.error,
  }) : assert(
          (status != AuthenticationStatus.error && error == null) ||
              (status == AuthenticationStatus.error && error != null),
        );

  @override
  List<Object?> get props => [status, error];
}
