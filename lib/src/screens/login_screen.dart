import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import 'package:nextcloud_cookbook_flutter/src/blocs/authentication/authentication_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/login/login_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/form/login_form.dart';

class LoginScreen extends StatelessWidget {
  final bool invalidCredentials;
  const LoginScreen({
    super.key,
    this.invalidCredentials = false,
  });

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
        child: const LoginForm(),
      ),
    );
  }

  void notifyIfInvalidCredentials(context) {
    if (invalidCredentials) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(translate('login.errors.credentials_invalid')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
