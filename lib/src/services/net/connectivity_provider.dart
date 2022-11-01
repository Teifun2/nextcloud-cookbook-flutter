import 'package:flutter_offline/flutter_offline.dart';

class ConnectivityProvider {
  bool connected() => connectivity != ConnectivityResult.none;
  ConnectivityResult connectivity = ConnectivityResult.wifi;

  ConnectivityProvider._();
  static final instance = ConnectivityProvider._();
}
