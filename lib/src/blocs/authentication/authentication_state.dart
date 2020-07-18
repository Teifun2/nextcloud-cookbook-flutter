import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationUninitialized extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  final AppAuthentication appAuthentication;

  const AuthenticationAuthenticated({@required this.appAuthentication});

  @override
  List<Object> get props => [appAuthentication];

  @override
  String toString() => appAuthentication.toString();
}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}
