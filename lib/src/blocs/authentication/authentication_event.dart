import 'package:equatable/equatable.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final AppAuthentication appAuthentication;

  const LoggedIn({required this.appAuthentication});

  @override
  List<Object> get props => [appAuthentication];

  @override
  String toString() => appAuthentication.toString();
}

class LoggedOut extends AuthenticationEvent {}
