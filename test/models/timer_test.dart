import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nextcloud_cookbook_flutter/src/models/timer.dart';

void main() {
  const title = "title";
  const body = "body";
  const duration = Duration(minutes: 5);
  final done = DateTime.now().add(duration);
  const recipeId = "12345678";
  const id = 0;

  final timer = Timer.restoreOld(done, id, recipeId, title, duration, recipeId);

  final json =
      '{"title":"$title","body":"$body","duration":${duration.inMinutes},"done":${done.millisecondsSinceEpoch},"id":$id,"recipeId":"$recipeId"}';
  final orderedJson =
      '{"title":"$title","body":"$body","duration":${duration.inMinutes},"id":$id,"done":${done.millisecondsSinceEpoch},"recipeId":"$recipeId"}';
  final oldJson =
      '{"title":"$title","body":"$body","duration":${duration.inMinutes},"done":${done.millisecondsSinceEpoch},"id":$id,"recipeId":$recipeId}';

  final newJson = '{"recipe":null,"done":"${done.toIso8601String()}","id":$id}';

  group(Timer, () {
    test("toJson", () {
      expect(jsonEncode(timer.toJson()), equals(newJson));
    });

    test("fromJson", () {
      expect(
        Timer.fromJson(jsonDecode(json) as Map<String, dynamic>),
        isA<Timer>(),
      );
      expect(
        Timer.fromJson(jsonDecode(orderedJson) as Map<String, dynamic>),
        isA<Timer>(),
      );
      expect(
        Timer.fromJson(jsonDecode(oldJson) as Map<String, dynamic>),
        isA<Timer>(),
      );
    });
  });
}
