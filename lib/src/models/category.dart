import 'dart:convert';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

part 'category.g.dart';

@CopyWith(constructor: "_")
class Category extends Equatable {
  @CopyWithField(immutable: true)
  final String name;
  @CopyWithField(immutable: true)
  final int recipeCount;
  final int firstRecipeId;

  const Category(this.name, this.recipeCount) : firstRecipeId = 0;

  const Category._({
    required this.name,
    required this.recipeCount,
    required this.firstRecipeId,
  });

  Category.fromJson(Map<String, dynamic> json)
      : name = json["name"] as String,
        recipeCount = json["recipe_count"] is int
            ? json["recipe_count"] as int
            : int.parse(json["recipe_count"] as String),
        firstRecipeId = 0;

  @override
  List<String> get props => [name];

  static List<Category> parseCategories(String responseBody) {
    final parsed = json.decode(responseBody) as List;

    return parsed
        .map<Category>(
          (json) => Category.fromJson(json as Map<String, dynamic>),
        )
        .where((Category c) => c.recipeCount > 0)
        .toList();
  }
}
