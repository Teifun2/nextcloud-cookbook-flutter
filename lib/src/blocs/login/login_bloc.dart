import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/authentication/authentication_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/services/services.dart';
import 'package:nextcloud_cookbook_flutter/src/util/nextcloud_login_qr_util.dart';
import 'package:nextcloud_cookbook_flutter/src/util/url_validator.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required this.authenticationBloc,
  }) : super(const LoginState()) {
    on<LoginFlowStart>(_mapLoginFlowStartEventToState);
    on<LoginQRScenned>(_mapLoginQRScannedEventToState);
  }
  final UserRepository userRepository = UserRepository();
  final AuthenticationBloc authenticationBloc;

  Future<void> _mapLoginFlowStartEventToState(
    LoginFlowStart event,
    Emitter<LoginState> emit,
  ) async {
    assert(URLUtils.isSanitized(event.serverURL));
    try {
      final client = NextcloudClient(event.serverURL);
      final init = await client.core.initLoginFlow();
      emit(LoginState(status: LoginStatus.loading, url: init.login));
      Timer.periodic(const Duration(seconds: 2), (timer) async {
        try {
          final result =
              await client.core.getLoginFlowResult(token: init.poll.token);
          timer.cancel();

          authenticationBloc.add(
            LoggedIn(
              appAuthentication: AppAuthentication(
                server: result.server,
                loginName: result.loginName,
                appPassword: result.appPassword,
                isSelfSignedCertificate: false,
              ),
            ),
          );
        } catch (e) {
          debugPrint(e.toString());
        }
      });
    } catch (e) {
      emit(LoginState(status: LoginStatus.failure, error: e.toString()));
    }
  }

  Future<void> _mapLoginQRScannedEventToState(
    LoginQRScenned event,
    Emitter<LoginState> emit,
  ) async {
    assert(event.uri.isScheme('nc'));
    try {
      final auth = parseNCLoginQR(event.uri);

      authenticationBloc.add(
        LoggedIn(
          appAuthentication: AppAuthentication(
            server: auth['server']!,
            loginName: auth['user']!,
            appPassword: auth['password']!,
            isSelfSignedCertificate: false,
          ),
        ),
      );
    } catch (e) {
      emit(LoginState(status: LoginStatus.failure, error: e.toString()));
    }
  }
}
