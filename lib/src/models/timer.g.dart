// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Timer _$TimerFromJson(Map<String, dynamic> json) => Timer.restore(
      Recipe.fromJson(json['recipe'] as Map<String, dynamic>),
      DateTime.parse(json['done'] as String),
      json['id'] as int?,
    );

Map<String, dynamic> _$TimerToJson(Timer instance) => <String, dynamic>{
      'recipe': instance.recipe,
      'done': instance.done.toIso8601String(),
      'id': instance.id,
    };
