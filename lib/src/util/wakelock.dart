import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:nextcloud_cookbook_flutter/src/util/setting_keys.dart';
import 'package:wakelock/wakelock.dart';

Future<bool> disableWakelock() async {
  final bool wakelockEnabled = await Wakelock.enabled;
  if (wakelockEnabled) {
    Wakelock.disable();
  }
  return Future.value(true);
}

void enableWakelock() {
  if (Settings.getValue<bool>(
    SettingKeys.stay_awake.name,
    defaultValue: false,
  )!) {
    Wakelock.enable();
  }
}
