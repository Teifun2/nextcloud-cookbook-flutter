part of 'login_bloc.dart';

enum LoginStatus {
  initial,
  loading,
  failure;
}

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.initial,
    this.error,
    this.url,
  }) : assert(error == null || status == LoginStatus.failure);
  final LoginStatus status;
  final String? error;
  final String? url;

  @override
  List<Object?> get props => [status, error];

  @override
  String toString() => status == LoginStatus.failure
      ? 'LoginFailure { error: $error }'
      : 'Instance of LoginState';
}
