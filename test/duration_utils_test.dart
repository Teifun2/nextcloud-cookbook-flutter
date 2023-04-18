import 'package:flutter_test/flutter_test.dart';
import 'package:nextcloud_cookbook_flutter/src/util/duration_utils.dart';

import 'helpers/translation_helpers.dart';

void main() {
  const hours = 1;
  const minutes = 5;
  const seconds = 30;
  const duration = Duration(hours: hours, minutes: minutes, seconds: seconds);

  setUpAll(setupL10n);

  group('DurationExtension', () {
    test('translatedString', () {
      final translated = duration.translatedString;

      expect(translated, '$hours Hours : $minutes Minutes');
    });
    test('formatMinutes', () {
      final formatted = duration.formatMinutes();

      expect(formatted, '$hours:0$minutes');
    });

    test('formatSeconds', () {
      final formatted = duration.formatSeconds();

      expect(formatted, '0$hours:0$minutes:$seconds');
    });
  });
}
