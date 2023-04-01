import 'package:flutter/foundation.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:nc_cookbook_api/nc_cookbook_api.dart';

part 'timer.g.dart';

@JsonSerializable(constructor: "restore")
class Timer {
  @visibleForTesting
  @JsonKey(
    toJson: _recipeToJson,
    fromJson: _recipeFromJson,
  )
  final Recipe? recipe;
  final DateTime done;

  final String? _title;
  final String? _body;
  final Duration? _duration;
  final String? _recipeId;

  int? id;

  Timer(Recipe this.recipe)
      : _title = null,
        _body = null,
        _duration = null,
        _recipeId = null,
        done = DateTime.now().add(recipe.cookTime!);

  // Restore Timer fom pending notification
  @visibleForTesting
  Timer.restore(
    Recipe this.recipe,
    this.done,
    this.id,
  )   : _title = null,
        _body = null,
        _duration = null,
        _recipeId = null;

  @visibleForTesting
  Timer.restoreOld(
    this.done,
    this.id,
    this._title,
    this._body,
    this._duration,
    this._recipeId,
  ) : recipe = null;

  factory Timer.fromJson(Map<String, dynamic> json) {
    try {
      return _$TimerFromJson(json);
      // ignore: avoid_catching_errors
    } on TypeError {
      return Timer.restoreOld(
        DateTime.fromMicrosecondsSinceEpoch(json['done'] as int),
        json['id'] as int?,
        json['title'] as String,
        json['body'] as String,
        Duration(minutes: json['duration'] as int),
        json['recipeId'] is String
            ? json['recipeId'] as String
            : json['recipeId'].toString(),
      );
    }
  }

  Map<String, dynamic> toJson() => _$TimerToJson(this);

  String get body => _body ?? "$title ${translate('timer.finished')}";
  String get title => _title ?? recipe!.name;
  Duration get duration => _duration ?? recipe!.cookTime!;
  String get recipeId => _recipeId ?? recipe!.id!;

  /// The remaining time of the timer
  ///
  /// Returns [Duration.zero] when done.
  Duration get remaining {
    final difference = done.difference(DateTime.now());

    if (difference.isNegative) {
      return Duration.zero;
    }

    return difference;
  }

  /// Prgogrss of the timer in percent.
  double get progress {
    if (remaining == Duration.zero) {
      return 1.0;
    }

    return 1.0 - (remaining.inMicroseconds / duration.inMicroseconds);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Timer &&
          runtimeType == other.runtimeType &&
          hashCode == other.hashCode;

  @override
  int get hashCode => Object.hash(
        done,
        id,
        title,
        body,
        duration,
        recipeId,
      );
}

Recipe _recipeFromJson(String data) =>
    standardSerializers.fromJson<Recipe>(Recipe.serializer, data)!;

String? _recipeToJson(Object? data) =>
    data != null ? standardSerializers.toJson(Recipe.serializer, data) : null;
