part of 'login_bloc.dart';

enum LoginStatus {
  initial,
  loading,
  failure;
}

class LoginState extends Equatable {
  final LoginStatus status;
  final String? error;

  const LoginState({
    this.status = LoginStatus.initial,
    this.error,
  }) : assert(
          (status != LoginStatus.failure && error == null) ||
              (status == LoginStatus.failure && error != null),
        );

  @override
  List<Object?> get props => [status, error];

  @override
  String toString() => status == LoginStatus.failure
      ? 'LoginFailure { error: $error }'
      : 'Instance of LoginState';
}
