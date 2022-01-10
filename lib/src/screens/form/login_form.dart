import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/checkbox_form_field.dart';
import 'package:punycode/punycode.dart';

import '../../blocs/login/login.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with WidgetsBindingObserver {
  final _serverUrl = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool advancedSettingsExpanded = false;
  bool advancedIsAppPassword = false;
  bool advancedIsSelfSignedCertificate = false;
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  Function authenticateInterruptCallback;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      authenticateInterruptCallback();
    }
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    authenticateInterruptCallback = () {
      UserRepository().stopAuthenticate();
    };

    _onLoginButtonPressed() {
      _formKey.currentState.save();

      if (_formKey.currentState.validate()) {
        String serverUrl = _punyEncodeUrl(_serverUrl.text);
        String username = _username.text.trim();
        String password = _password.text.trim();
        String originalBasicAuth = 'Basic ' +
            base64Encode(
              utf8.encode(
                '$username:$password',
              ),
            );
        BlocProvider.of<LoginBloc>(context).add(
          LoginButtonPressed(
            serverURL: serverUrl,
            username: username,
            originalBasicAuth: originalBasicAuth,
            isAppPassword: advancedIsAppPassword,
            isSelfSignedCertificate: advancedIsSelfSignedCertificate,
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
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                // Build a Form widget using the _formKey created above.
                key: _formKey,
                child: AutofillGroup(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: translate('login.server_url.field'),
                        ),
                        controller: _serverUrl,
                        keyboardType: TextInputType.url,
                        validator: (value) {
                          if (value.isEmpty) {
                            return translate(
                                'login.server_url.validator.empty');
                          }
                          var urlPattern =
                              r"^(?:http(s)?:\/\/)?[\w.-]+(?:(?:\.[\w\.-]+)|(?:\:\d+))+[\w\-\._~:/?#[\]@!\$&'\(\)\*\+,;=.]*$";
                          bool _match =
                              new RegExp(urlPattern, caseSensitive: false)
                                  .hasMatch(_punyEncodeUrl(value));
                          if (!_match) {
                            return translate(
                                'login.server_url.validator.pattern');
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: translate('login.username.field'),
                        ),
                        controller: _username,
                        textInputAction: TextInputAction.next,
                        autofillHints: [AutofillHints.username],
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: translate('login.password.field'),
                        ),
                        controller: _password,
                        obscureText: true,
                        onFieldSubmitted: (val) {
                          if (state is! LoginLoading) {
                            _onLoginButtonPressed();
                          }
                        },
                        textInputAction: TextInputAction.done,
                        autofillHints: [AutofillHints.password],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: ExpansionPanelList(
                          expandedHeaderPadding: const EdgeInsets.all(0),
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              advancedSettingsExpanded = !isExpanded;
                            });
                          },
                          children: [
                            ExpansionPanel(
                              isExpanded: advancedSettingsExpanded,
                              body: Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Column(
                                  children: [
                                    CheckboxFormField(
                                      initialValue: advancedIsAppPassword,
                                      onSaved: (bool checked) => {
                                        setState(() {
                                          advancedIsAppPassword = checked;
                                        })
                                      },
                                      title: Text(translate(
                                          'login.settings.app_password')),
                                    ),
                                    CheckboxFormField(
                                      initialValue:
                                          advancedIsSelfSignedCertificate,
                                      onSaved: (bool checked) => {
                                        setState(() {
                                          advancedIsSelfSignedCertificate =
                                              checked;
                                        })
                                      },
                                      title: Text(translate(
                                          'login.settings.self_signed_certificate')),
                                    ),
                                  ],
                                ),
                              ),
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) {
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child:
                                        Text(translate('login.settings.title')),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                      RaisedButton(
                        onPressed: state is! LoginLoading
                            ? _onLoginButtonPressed
                            : null,
                        child: Text(translate('login.button')),
                      ),
                      Container(
                        child: state is LoginLoading
                            ? SpinKitWave(
                                color: Theme.of(context).primaryColor,
                                size: 50.0)
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _punyEncodeUrl(String url) {
    String pattern = r"(?:\.|^)([^.]*?[^\x00-\x7F][^.]*?)(?:\.|$)";
    RegExp expression = new RegExp(pattern, caseSensitive: false);
    String prefix = "";
    if (url.startsWith("https://")) {
      url = url.replaceFirst("https://", "");
      prefix = "https://";
    } else if (url.startsWith("http://")) {
      url = url.replaceFirst("http://", "");
      prefix = "http://";
    }

    while (expression.hasMatch(url)) {
      String match = expression.firstMatch(url).group(1);
      url = url.replaceFirst(match, "xn--" + punycodeEncode(match));
    }

    return prefix + url;
  }
}
