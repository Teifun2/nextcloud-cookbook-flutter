import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/login_nextcloud_bloc.dart';
import '../../services/login_event.dart';
import '../../services/login_state.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _serverUrl = TextEditingController();
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    _onLoginButtonPressed() {
      if (_formKey.currentState.validate()) {
        BlocProvider.of<LoginBloc>(context).add(
          LoginButtonPressed(
            serverURL: _serverUrl.text,
          ),
        );
      }
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Form(
            // Build a Form widget using the _formKey created above.
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Server URL'),
                  controller: _serverUrl,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a Nextcloud URL';
                    }
                    bool _validURL = Uri.parse(value).isAbsolute;
                    //TODO user input better, accept without https
                    if ( ! _validURL){
                      return 'Please enter a valid URL';
                    }
                    return null;
                  },
                ),
                RaisedButton(
                  onPressed:
                    state is! LoginLoading ? _onLoginButtonPressed : null,
                    child: Text('Login'),
                ),
                Container(
                  child: state is LoginLoading
                      ? CircularProgressIndicator()
                      : null,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
