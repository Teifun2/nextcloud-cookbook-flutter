import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/util/setting_keys.dart';
import 'package:nextcloud_cookbook_flutter/src/util/supported_locales.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';

class MySettingsScreen extends StatelessWidget {
  const MySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => SettingsScreen(
        title: translate('settings.title'),
        children: [
          SwitchSettingsTile(
            title: translate('settings.stay_awake.title'),
            settingKey: SettingKeys.stay_awake.name,
            subtitle: translate('settings.stay_awake.subtitle'),
          ),
          DropDownSettingsTile<String>(
            title: translate('settings.dark_mode.title'),
            settingKey: SettingKeys.dark_mode.name,
            values: <String, String>{
              ThemeMode.system.toString():
                  translate('settings.dark_mode.system'),
              ThemeMode.dark.toString(): translate('settings.dark_mode.dark'),
              ThemeMode.light.toString(): translate('settings.dark_mode.light'),
            },
            selected: ThemeModeHandler.of(context)!.themeMode.toString(),
            onChange: (value) async {
              final theme = ThemeMode.values.firstWhere(
                (v) => v.toString() == value,
                orElse: () => ThemeMode.system,
              );
              await ThemeModeHandler.of(context)?.saveThemeMode(theme);
            },
          ),
          DropDownSettingsTile<String>(
            title: translate('settings.language.title'),
            settingKey: SettingKeys.language.name,
            selected: Settings.getValue<String>(
              SettingKeys.language.name,
              defaultValue: 'default',
            )!,
            values: Map.from(
              <String, String>{
                'default': translate('settings.dark_mode.system'),
              },
            )..addAll(SupportedLocales.locales),
            onChange: (value) async {
              if (value == 'default') {
                await changeLocale(context, Platform.localeName);
              } else {
                await changeLocale(context, value);
              }
            },
          )
        ],
      );
}
