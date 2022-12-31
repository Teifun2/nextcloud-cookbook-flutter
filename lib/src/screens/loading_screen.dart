import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/authentication/authentication.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, authenticationState) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (authenticationState is! AuthenticationError)
                  SpinKitWave(
                    color: Theme.of(context).primaryColor,
                  ),
                if (authenticationState is AuthenticationError)
                  Text(authenticationState.errorMsg),
                const SizedBox(height: 10),
                if (authenticationState is AuthenticationError)
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<AuthenticationBloc>(context)
                          .add(AppStarted());
                    },
                    child: Text(translate("login.retry")),
                  ),
                const SizedBox(height: 10),
                if (authenticationState is AuthenticationError)
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<AuthenticationBloc>(context)
                          .add(LoggedOut());
                    },
                    child: Text(translate("login.reset")),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
