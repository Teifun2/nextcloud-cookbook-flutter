import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;
  final String serverURL;

  const LoginButtonPressed({
    @required this.username,
    @required this.password,
    @required this.serverURL,
  });

  @override
  List<Object> get props => [username, password,serverURL];

  @override
  String toString() =>
      'LoginButtonPressed { username: $username, password: $password,serverURL: $serverURL  }';
}