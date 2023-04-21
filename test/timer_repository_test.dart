// ignore_for_file: discarded_futures

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nextcloud_cookbook_flutter/src/models/timer.dart';
import 'package:nextcloud_cookbook_flutter/src/services/services.dart';

class NotificationServiceMock extends Mock implements NotificationService {}

// ignore: avoid_implementing_value_types
class FakeTimer extends Fake implements Timer {}

void main() {
  final notificationService = NotificationServiceMock();
  final timer = FakeTimer();

  setUpAll(() => NotificationService.mocked(notificationService));

  group(TimerList, () {
    test('add timer', () {
      when(() => notificationService.start(timer)).thenAnswer((_) async {});

      TimerList().add(timer);
      verify(() => notificationService.start(timer)).called(1);
      expect(TimerList().timers, contains(timer));
    });

    test('remove timer', () {
      when(() => notificationService.cancel(timer)).thenAnswer((_) async {});

      TimerList().remove(timer);
      verify(() => notificationService.cancel(timer)).called(1);
      expect(TimerList().timers, isNot(contains(timer)));
    });
  });
}
