import 'dart:convert';

import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String name;
  final int recipeCount;
  String imageUrl;

  Category.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        recipeCount = int.parse(json["recipe_count"]);

  @override
  List<Object> get props => [name];

  static List<Category> parseCategories(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Category>((json) => Category.fromJson(json)).toList();
  }
}
