import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/login/login_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/checkbox_form_field.dart';
import 'package:punycode/punycode.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

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

  late Function() authenticateInterruptCallback;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      authenticateInterruptCallback();
    }
  }

  @override
  void initState() {
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

    void onLoginButtonPressed() {
      _formKey.currentState?.save();

      if (_formKey.currentState?.validate() ?? false) {
        final String serverUrl = _punyEncodeUrl(_serverUrl.text);
        final String username = _username.text.trim();
        final String password = _password.text.trim();
        final String originalBasicAuth = 'Basic ${base64Encode(
          utf8.encode(
            '$username:$password',
          ),
        )}';
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
        if (state.status == LoginStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
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
                          if (value == null || value.isEmpty) {
                            return translate(
                              'login.server_url.validator.empty',
                            );
                          }
                          const urlPattern =
                              r"^(?:http(s)?:\/\/)?[\w.-]+(?:(?:\.[\w\.-]+)|(?:\:\d+))+[\w\-\._~:/?#[\]@!\$&'\(\)\*\+,;=.]*$";
                          final bool match =
                              RegExp(urlPattern, caseSensitive: false)
                                  .hasMatch(_punyEncodeUrl(value));
                          if (!match) {
                            return translate(
                              'login.server_url.validator.pattern',
                            );
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        autofillHints: const [
                          AutofillHints.url,
                          AutofillHints.name
                        ],
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: translate('login.username.field'),
                        ),
                        controller: _username,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.username],
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: translate('login.password.field'),
                        ),
                        controller: _password,
                        obscureText: true,
                        onFieldSubmitted: (val) {
                          if (state.status != LoginStatus.loading) {
                            onLoginButtonPressed();
                          }
                        },
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: ExpansionPanelList(
                          expandedHeaderPadding: EdgeInsets.zero,
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
                                      onSaved: (bool? checked) {
                                        if (checked == null) return;
                                        setState(() {
                                          advancedIsAppPassword = checked;
                                        });
                                      },
                                      title: Text(
                                        translate(
                                          'login.settings.app_password',
                                        ),
                                      ),
                                    ),
                                    CheckboxFormField(
                                      initialValue:
                                          advancedIsSelfSignedCertificate,
                                      onSaved: (bool? checked) {
                                        if (checked == null) return;

                                        setState(() {
                                          advancedIsSelfSignedCertificate =
                                              checked;
                                        });
                                      },
                                      title: Text(
                                        translate(
                                          'login.settings.self_signed_certificate',
                                        ),
                                      ),
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
                      ElevatedButton(
                        onPressed: state.status != LoginStatus.loading
                            ? onLoginButtonPressed
                            : null,
                        child: Text(translate('login.button')),
                      ),
                      if (state.status == LoginStatus.loading)
                        SpinKitWave(
                          color: Theme.of(context).primaryColor,
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

  String _punyEncodeUrl(String punycodeUrl) {
    const String pattern = r"(?:\.|^)([^.]*?[^\x00-\x7F][^.]*?)(?:\.|$)";
    final RegExp expression = RegExp(pattern, caseSensitive: false);
    String prefix = "";
    String url = punycodeUrl;
    if (punycodeUrl.startsWith("https://")) {
      url = punycodeUrl.replaceFirst("https://", "");
      prefix = "https://";
    } else if (punycodeUrl.startsWith("http://")) {
      url = punycodeUrl.replaceFirst("http://", "");
      prefix = "http://";
    }

    while (expression.hasMatch(url)) {
      final String match = expression.firstMatch(url)!.group(1)!;
      url = url.replaceFirst(match, "xn--${punycodeEncode(match)}");
    }

    return prefix + url;
  }
}
