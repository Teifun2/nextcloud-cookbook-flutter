import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../blocs/authentication/authentication_bloc.dart';
import '../blocs/login/login_bloc.dart';
import 'form/login_form.dart';

class LoginScreen extends StatelessWidget {
  final bool invalidCredentials;
  LoginScreen({this.invalidCredentials = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('login.title')),
      ),
      body: BlocProvider<LoginBloc>(
        create: (context) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            notifyIfInvalidCredentials(context);
          });
          return LoginBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
          );
        },
        child: LoginForm(),
      ),
    );
  }

  void notifyIfInvalidCredentials(context) {
    if (invalidCredentials) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(translate('login.errors.credentials_invalid')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
