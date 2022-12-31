import 'dart:convert';

import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String name;
  final int recipeCount;
  int firstRecipeId = 0;

  Category(this.name, this.recipeCount);

  Category.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        recipeCount = json["recipe_count"] is int
            ? json["recipe_count"]
            : int.parse(json["recipe_count"]);

  @override
  List<String> get props => [name];

  static List<Category> parseCategories(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<Category>((json) => Category.fromJson(json))
        .where((Category c) => c.recipeCount > 0)
        .toList();
  }
}
