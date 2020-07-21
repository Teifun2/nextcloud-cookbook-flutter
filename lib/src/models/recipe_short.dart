import 'dart:convert';

import 'package:equatable/equatable.dart';

class RecipeShort extends Equatable {
  final int _recipeId;
  final String _name;
  final String _userId;
  final String _imageUrl;

  int get recipeId => _recipeId;
  String get name => _name;
  String get userId => _userId;
  String get imageUrl => _imageUrl;

  RecipeShort.fromJson(Map<String, dynamic> json) :
    _recipeId = int.parse(json["recipe_id"]),
    _name = json["name"],
    _userId = json["user_id"],
    _imageUrl = json["imageUrl"];


  static List<RecipeShort> parseRecipesShort(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<RecipeShort>((json) => RecipeShort.fromJson(json))
        .toList();
  }

  @override
  List<Object> get props => [_recipeId];
}
