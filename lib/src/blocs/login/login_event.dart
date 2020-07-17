import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final String serverURL;

  const LoginButtonPressed({
    @required this.serverURL,
  });

  @override
  List<Object> get props => [serverURL];

  @override
  String toString() =>
      'LoginButtonPressed {serverURL: $serverURL}';
}