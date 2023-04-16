import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/authentication/authentication_bloc.dart';

class LoadingErrorScreen extends StatelessWidget {
  const LoadingErrorScreen({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(message),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(const AppStarted());
                },
                child: Text(translate("login.retry")),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(const LoggedOut());
                },
                child: Text(translate("login.reset")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
