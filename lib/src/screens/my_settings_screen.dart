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
  Widget build(BuildContext context) {
    return SettingsScreen(
      title: translate("settings.title"),
      children: [
        SwitchSettingsTile(
          title: translate("settings.stay_awake.title"),
          settingKey: SettingKeys.stay_awake.name,
          subtitle: translate("settings.stay_awake.subtitle"),
        ),
        SliderSettingsTile(
          title: translate("settings.recipe_font_size.title"),
          settingKey: SettingKeys.recipe_font_size.name,
          defaultValue: Theme.of(context).textTheme.bodyMedium!.fontSize!,
          min: 10,
          max: 25,
          eagerUpdate: false,
          subtitle: translate("settings.recipe_font_size.subtitle"),
        ),
        SliderSettingsTile(
          title: translate("settings.category_font_size.title"),
          settingKey: SettingKeys.category_font_size.name,
          defaultValue: 16,
          min: 10,
          max: 25,
          eagerUpdate: false,
          subtitle: translate("settings.category_font_size.subtitle"),
        ),
        DropDownSettingsTile<String>(
          title: translate("settings.dark_mode.title"),
          settingKey: SettingKeys.dark_mode.name,
          values: <String, String>{
            ThemeMode.system.toString(): translate("settings.dark_mode.system"),
            ThemeMode.dark.toString(): translate("settings.dark_mode.dark"),
            ThemeMode.light.toString(): translate("settings.dark_mode.light"),
          },
          selected: ThemeModeHandler.of(context)!.themeMode.toString(),
          onChange: (value) {
            final theme = ThemeMode.values.firstWhere(
              (v) => v.toString() == value,
              orElse: () => ThemeMode.system,
            );
            ThemeModeHandler.of(context)?.saveThemeMode(theme);
          },
        ),
        DropDownSettingsTile(
          title: translate("settings.language.title"),
          settingKey: SettingKeys.language.name,
          selected: Settings.getValue<String>(
            SettingKeys.language.name,
            defaultValue: 'default',
          ),
          values: Map.from(
            <String, String>{
              'default': translate("settings.dark_mode.system"),
            },
          )..addAll(SupportedLocales.locales),
          onChange: (dynamic value) {
            if (value == 'default') {
              changeLocale(context, Platform.localeName);
            } else {
              changeLocale(context, value as String?);
            }
          },
        )
      ],
    );
  }
}
