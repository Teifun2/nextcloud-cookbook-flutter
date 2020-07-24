import 'dart:convert';

import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String _name;
  final int _recipeCount;

  get name => _name;
  get recipeCount => _recipeCount;

  Category.fromJson(Map<String, dynamic> json)
      : _name = json["name"],
        _recipeCount = int.parse(json["recipe_count"]);

  @override
  List<Object> get props => [_name];

  static List<Category> parseCategories(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Category>((json) => Category.fromJson(json)).toList();
  }
}
