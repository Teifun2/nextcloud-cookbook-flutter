import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:nextcloud_cookbook_flutter/src/util/setting_keys.dart';
import 'package:theme_mode_handler/theme_mode_manager_interface.dart';

class MyThemeModeManager implements IThemeModeManager {
  @override
  Future<String> loadThemeMode() {
    return Future.value(
      Settings.getValue<String>(
        describeEnum(SettingKeys.dark_mode),
        ThemeMode.system.toString(),
      ),
    );
  }

  @override
  Future<bool> saveThemeMode(String value) async {
    return Future.value(true);
  }
}
