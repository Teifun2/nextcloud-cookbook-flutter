import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final String serverURL;
  final String username;
  final String originalBasicAuth;
  final bool isAppPassword;
  final bool isSelfSignedCertificate;

  const LoginButtonPressed({
    required this.serverURL,
    required this.username,
    required this.originalBasicAuth,
    required this.isAppPassword,
    required this.isSelfSignedCertificate,
  });

  @override
  List<Object> get props =>
      [serverURL, username, isAppPassword, isSelfSignedCertificate];

  @override
  String toString() =>
      'LoginButtonPressed {serverURL: $serverURL, username: $username, isAppPassword: $isAppPassword}, isSelfSignedCertificate: $isSelfSignedCertificate';
}
