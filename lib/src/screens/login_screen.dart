import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/authentication/authentication_bloc.dart';

import 'package:nextcloud_cookbook_flutter/src/blocs/login/login_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/util/url_validator.dart';
import 'package:vector_graphics/vector_graphics.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();
  late final LoginBloc _loginBloc;

  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..enableZoom(false)
    ..setUserAgent('CookbookFlutter');

  @override
  void didChangeDependencies() {
    unawaited(
      controller.setBackgroundColor(Theme.of(context).scaffoldBackgroundColor),
    );

    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loginBloc = LoginBloc(authenticationBloc: authBloc);
    super.didChangeDependencies();
  }

  void onSubmit([String? value]) {
    _formKey.currentState!.save();
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<LoginBloc, LoginState>(
        bloc: _loginBloc,
        listener: listener,
        builder: builder,
      );

  Widget builder(BuildContext context, LoginState state) {
    final theme = Theme.of(context);

    final webview = WebViewWidget(controller: controller);
    final form = Center(
      child: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 40,
          horizontal: 20,
        ),
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: theme.colorScheme.primaryContainer,
            ),
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    translate('categories.title'),
                    style: theme.textTheme.headlineLarge,
                  ),
                ),
                const SvgPicture(
                  AssetBytesLoader('assets/icon.svg.vec'),
                  height: 100,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: TextFormField(
              focusNode: _focusNode,
              decoration: InputDecoration(
                labelText: translate('login.server_url.field'),
                suffixIcon: InkWell(
                  onTap: onSubmit,
                  child: const Icon(Icons.arrow_forward),
                ),
              ),
              keyboardType: TextInputType.url,
              validator: validateUrl,
              onFieldSubmitted: onSubmit,
              onSaved: submit,
            ),
          ),
          const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.qr_code_scanner,
              size: 40,
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(translate('login.title')),
        actions: [
          if (state.status == LoginStatus.loading) ...[],
        ],
        leading:
            state.status == LoginStatus.loading ? const BackButton() : null,
      ),
      body: state.status == LoginStatus.loading ? webview : form,
    );
  }

  void submit(String? value) {
    if (_formKey.currentState!.validate()) {
      _loginBloc.add(
        LoginFlowStart(URLUtils.sanitizeUrl(value!)),
      );
    } else {
      _focusNode.requestFocus();
    }
  }

  String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return translate(
        'login.server_url.validator.empty',
      );
    }

    if (!URLUtils.isValid(value)) {
      return translate(
        'login.server_url.validator.pattern',
      );
    }
    return null;
  }

  Future<void> listener(BuildContext context, LoginState state) async {
    if (state.status == LoginStatus.loading) {
      await controller.loadRequest(Uri.parse(state.url!));
    }
  }
}
