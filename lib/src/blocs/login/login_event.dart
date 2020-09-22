import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final String serverURL;

  const LoginButtonPressed({
    @required this.serverURL,
  });

  @override
  List<Object> get props => [serverURL];

  @override
  String toString() => 'LoginButtonPressed {serverURL: $serverURL}';
}
