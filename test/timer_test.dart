import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nc_cookbook_api/nc_cookbook_api.dart';
import 'package:nextcloud_cookbook_flutter/src/models/timer.dart';

import 'helpers/translation_helpers.dart';

void main() {
  const recipeName = 'title';
  const duration = Duration(minutes: 5);
  final done = DateTime.now().add(duration);
  const recipeId = '12345678';
  const oldId = 0;

  const title = recipeName;
  const body = 'body';

  final recipe = Recipe(
    (b) => b
      ..name = recipeName
      ..id = recipeId
      ..dateCreated = DateTime.now().toUtc()
      ..cookTime = duration,
  );
  final oldTimer =
      Timer.restoreOld(done, oldId, title, body, duration, recipeId);
  final newTimer = Timer(recipe);

  final json =
      '{"title":"$title","body":"$body","duration":${duration.inMinutes},"done":${done.microsecondsSinceEpoch},"id":$oldId,"recipeId":"$recipeId"}';
  final orderedJson =
      '{"title":"$title","body":"$body","duration":${duration.inMinutes},"id":$oldId,"done":${done.microsecondsSinceEpoch},"recipeId":"$recipeId"}';
  final oldJson =
      '{"title":"$title","body":"$body","duration":${duration.inMinutes},"done":${done.microsecondsSinceEpoch},"id":$oldId,"recipeId":$recipeId}';
  final newJson =
      '{"recipe":${jsonEncode(recipeToJson(recipe))},"done":"${newTimer.done.toIso8601String()}","id":null}';

  setUpAll(setupL10n);

  group(Timer, () {
    test('toJson', () {
      expect(jsonEncode(newTimer.toJson()).trim(), equals(newJson));
    });

    test('fromJson', () {
      expect(
        Timer.fromJson(jsonDecode(json) as Map<String, dynamic>),
        equals(oldTimer),
      );
      expect(
        Timer.fromJson(jsonDecode(orderedJson) as Map<String, dynamic>),
        equals(oldTimer),
      );

      expect(
        Timer.fromJson(jsonDecode(oldJson) as Map<String, dynamic>),
        equals(oldTimer),
      );

      expect(
        Timer.fromJson(jsonDecode(newJson) as Map<String, dynamic>),
        equals(newTimer),
      );
    });

    test('timer progress', () {
      const duration = Duration(minutes: 5);
      final now = DateTime.now();
      final done = now.add(duration);

      var timer = Timer.restoreOld(
        now,
        oldId,
        title,
        body,
        Duration.zero,
        recipeId,
      );

      expect(timer.remaining, Duration.zero);
      expect(timer.progress, 1.0);

      timer = Timer.restoreOld(
        done,
        oldId,
        title,
        body,
        duration,
        recipeId,
      );

      expect(timer.progress, greaterThan(0));
      expect(timer.progress, lessThanOrEqualTo(1.0));
    });
  });
}
