// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Timer _$TimerFromJson(Map<String, dynamic> json) => Timer.restore(
      _recipeFromJson(json['recipe'] as String),
      DateTime.parse(json['done'] as String),
      json['id'] as int?,
    );

Map<String, dynamic> _$TimerToJson(Timer instance) => <String, dynamic>{
      'recipe': _recipeToJson(instance.recipe),
      'done': instance.done.toIso8601String(),
      'id': instance.id,
    };
