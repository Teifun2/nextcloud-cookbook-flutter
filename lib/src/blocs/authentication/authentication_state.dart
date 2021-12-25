import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationUninitialized extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationInvalid extends AuthenticationState {}

class AuthenticationError extends AuthenticationState {
  final String errorMsg;

  const AuthenticationError(this.errorMsg);

  @override
  List<Object> get props => [errorMsg];
}

class AuthenticationLoading extends AuthenticationState {}
