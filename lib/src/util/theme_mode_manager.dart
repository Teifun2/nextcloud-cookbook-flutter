import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:nextcloud_cookbook_flutter/src/util/setting_keys.dart';
import 'package:theme_mode_handler/theme_mode_manager_interface.dart';

class ThemeModeManager implements IThemeModeManager {
  @override
  Future<String> loadThemeMode() => Future.value(
        Settings.getValue<String>(
          SettingKeys.dark_mode.name,
          defaultValue: ThemeMode.system.toString(),
        ),
      );

  @override
  Future<bool> saveThemeMode(String value) async => Future.value(true);
}
