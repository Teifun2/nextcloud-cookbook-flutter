part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  const LoginButtonPressed({
    required this.serverURL,
    required this.username,
    required this.appPassword,
    required this.isAppPassword,
    required this.isSelfSignedCertificate,
  });
  final String serverURL;
  final String username;
  final String appPassword;
  final bool isAppPassword;
  final bool isSelfSignedCertificate;

  @override
  List<Object> get props =>
      [serverURL, username, isAppPassword, isSelfSignedCertificate];

  @override
  String toString() =>
      'LoginButtonPressed {serverURL: $serverURL, username: $username, isAppPassword: $isAppPassword}, isSelfSignedCertificate: $isSelfSignedCertificate';
}
