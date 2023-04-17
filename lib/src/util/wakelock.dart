import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:nextcloud_cookbook_flutter/src/util/setting_keys.dart';
import 'package:wakelock/wakelock.dart';

Future<void> disableWakelock() async {
  await Wakelock.disable();
}

Future<void> enableWakelock() async {
  final enable = Settings.getValue<bool>(
    SettingKeys.stay_awake.name,
    defaultValue: false,
  )!;

  if (enable) {
    await Wakelock.enable();
  }
}
