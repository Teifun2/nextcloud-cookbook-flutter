import 'dart:convert';
import 'dart:io';

import 'package:flutter_translate/flutter_translate.dart';

void setupL10n() {
  final translations = jsonDecode(
    File('assets/i18n/en.json').readAsStringSync(),
  ) as Map<String, dynamic>;

  Localization.load(translations);
}
