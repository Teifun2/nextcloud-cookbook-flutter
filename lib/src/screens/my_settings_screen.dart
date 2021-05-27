import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class MySettingsScreen extends StatelessWidget {
  const MySettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsScreen(
      title: "Application Settings",
      children: [
        CheckboxSettingsTile(
          settingKey: 'key-of-your-setting',
          title: 'This is a simple Checkbox',
        ),
      ],
    );
  }
}
