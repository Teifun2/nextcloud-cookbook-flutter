import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/util/setting_keys.dart';
import 'package:nextcloud_cookbook_flutter/src/util/supported_locales.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';

class MySettingsScreen extends StatefulWidget {
  const MySettingsScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MySettingsScreenState();
}

class _MySettingsScreenState extends State<MySettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return SettingsScreen(
      title: translate("settings.title"),
      children: [
        SwitchSettingsTile(
          title: translate("settings.stay_awake.title"),
          settingKey: describeEnum(
            SettingKeys.stay_awake,
          ),
          subtitle: translate("settings.stay_awake.subtitle"),
        ),
        SliderSettingsTile(
          title: translate("settings.recipe_font_size.title"),
          settingKey: describeEnum(SettingKeys.recipe_font_size),
          defaultValue: Theme.of(context).textTheme.bodyText2.fontSize,
          min: 10,
          max: 20,
          eagerUpdate: false,
          subtitle: translate("settings.recipe_font_size.subtitle"),
        ),
        SliderSettingsTile(
          title: translate("settings.category_font_size.title"),
          settingKey: describeEnum(SettingKeys.category_font_size),
          defaultValue: 16,
          min: 10,
          max: 20,
          eagerUpdate: false,
          subtitle: translate("settings.category_font_size.subtitle"),
        ),
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
        DropDownSettingsTile(
          title: translate("settings.language.title"),
          settingKey: describeEnum(SettingKeys.language),
          selected: Settings.getValue<String>(
            describeEnum(SettingKeys.language),
            'default',
          ),
          values: Map.from(
            <String, String>{
              'default': translate("settings.dark_mode.system"),
            },
          )..addAll(SupportedLocales.locales),
          onChange: (value) {
            if (value == 'default') {
              changeLocale(context, Platform.localeName);
            } else {
              changeLocale(context, value);
            }
            setState(() {});
          },
        )
      ],
    );
  }
}
