part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginFlowStart extends LoginEvent {
  const LoginFlowStart(this.serverURL);

  final String serverURL;
}
