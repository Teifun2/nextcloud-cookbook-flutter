import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_translate/global.dart';
import 'package:nextcloud_cookbook_flutter/src/util/setting_keys.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';

class MySettingsScreen extends StatelessWidget {
  const MySettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsScreen(
      title: translate("settings.title"),
      children: [
        DropDownSettingsTile<String>(
          title: translate("settings.dark_mode.title"),
          settingKey: describeEnum(SettingKeys.dark_mode),
          values: <String, String>{
            ThemeMode.system.toString(): translate("settings.dark_mode.system"),
            ThemeMode.dark.toString(): translate("settings.dark_mode.dark"),
            ThemeMode.light.toString(): translate("settings.dark_mode.light"),
          },
          selected: ThemeModeHandler.of(context).themeMode.toString(),
          onChange: (value) {
            final theme = ThemeMode.values.firstWhere(
              (v) => v.toString() == value,
              orElse: () => ThemeMode.system,
            );
            ThemeModeHandler.of(context).saveThemeMode(theme);
          },
        ),
      ],
    );
  }
}
