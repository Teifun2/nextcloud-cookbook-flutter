import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/user_repository.dart';

import '../blocs/authentication/authentication_bloc.dart';
import '../blocs/login/login_bloc.dart';
import 'form/login_form.dart';



class LoginPage extends StatelessWidget {
  final UserRepository userRepository;

  LoginPage({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: BlocProvider(
        create: (context) {
          return LoginBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            userRepository: userRepository,
          );
        },
        child: LoginForm(),
      ),
    );
  }
}
