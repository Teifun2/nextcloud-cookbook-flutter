import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final String serverURL;
  final String username;
  final String originalBasicAuth;

  const LoginButtonPressed(
      {@required this.serverURL,
      @required this.username,
      @required this.originalBasicAuth});

  @override
  List<Object> get props => [serverURL, username];

  @override
  String toString() =>
      'LoginButtonPressed {serverURL: $serverURL, username: $username}';
}
