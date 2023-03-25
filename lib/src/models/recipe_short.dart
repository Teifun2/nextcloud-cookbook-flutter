import 'dart:convert';

import 'package:equatable/equatable.dart';

class RecipeShort extends Equatable {
  final String _recipeId;
  final String _name;
  final String _imageUrl;

  String get recipeId => _recipeId;
  String get name => _name;
  String get imageUrl => _imageUrl;

  RecipeShort.fromJson(Map<String, dynamic> json)
      : _recipeId = json["recipe_id"] is int
            ? json["recipe_id"]!.toString()
            : json["recipe_id"] as String,
        _name = json["name"] as String,
        _imageUrl = json["imageUrl"] as String;

  static List<RecipeShort> parseRecipesShort(String responseBody) {
    final parsed = json.decode(responseBody) as List;

    return parsed
        .map<RecipeShort>(
          (json) => RecipeShort.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  List<String> get props => [_recipeId];
}
