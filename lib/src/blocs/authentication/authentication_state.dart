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
  const AuthenticationState({
    this.status = AuthenticationStatus.loading,
    this.error,
    this.apiVersion,
  })  : assert(error == null || status == AuthenticationStatus.error),
        assert(
          apiVersion == null || status == AuthenticationStatus.authenticated,
        );
  final AuthenticationStatus status;
  final String? error;

  /// The [APIVersion] authenticated against
  final APIVersion? apiVersion;

  @override
  List<Object?> get props => [status, error, apiVersion];
}
