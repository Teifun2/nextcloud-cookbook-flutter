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
  }) : assert(
          (status != LoginStatus.failure && error == null) ||
              (status == LoginStatus.failure && error != null),
        );
  final LoginStatus status;
  final String? error;

  @override
  List<Object?> get props => [status, error];

  @override
  String toString() => status == LoginStatus.failure
      ? 'LoginFailure { error: $error }'
      : 'Instance of LoginState';
}
