import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/util/setting_keys.dart';

class TranslatePreferences implements ITranslatePreferences {
  @override
  Future<Locale> getPreferredLocale() {
    var locale = Settings.getValue<String>(
      describeEnum(SettingKeys.language),
      defaultValue: Platform.localeName,
    );
    if (locale == 'default') {
      return Future.value(Locale(Platform.localeName));
    }
    return Future.value(Locale(locale!));
  }

  @override
  Future savePreferredLocale(Locale locale) {
    return Future.value(true);
  }
}
