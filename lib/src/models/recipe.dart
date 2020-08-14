import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:nextcloud_cookbook_flutter/src/util/iso_time_format.dart';

class Recipe extends Equatable {
  final int id;
  final String name;
  final String imageUrl;
  final String recipeCategory;
  final String description;
  final List<String> recipeIngredient;
  final List<String> recipeInstructions;
  final int recipeYield;
  final Duration prepTime;
  final Duration cookTime;
  final Duration totalTime;

  const Recipe._(
      this.id,
      this.name,
      this.imageUrl,
      this.recipeCategory,
      this.description,
      this.recipeIngredient,
      this.recipeInstructions,
      this.recipeYield,
      this.prepTime,
      this.cookTime,
      this.totalTime);

  factory Recipe(String jsonString) {
    Map<String, dynamic> data = json.decode(jsonString);

    int id = data["id"];
    String name = data["name"];
    String imageUrl = data["imageUrl"];
    String recipeCategory = data["recipeCategory"];
    String description = data["description"];
    List<String> recipeIngredient =
        data["recipeIngredient"].cast<String>().toList();
    List<String> recipeInstructions =
        data["recipeInstructions"].cast<String>().toList();
    int recipeYield = data["recipeYield"];
    Duration prepTime = data.containsKey("prepTime") && data["prepTime"] != ""
        ? IsoTimeFormat.toDuration(data["prepTime"])
        : null;
    Duration cookTime = data.containsKey("cookTime") && data["cookTime"] != ""
        ? IsoTimeFormat.toDuration(data["cookTime"])
        : null;
    Duration totalTime =
        data.containsKey("totalTime") && data["totalTime"] != ""
            ? IsoTimeFormat.toDuration(data["totalTime"])
            : null;

    return Recipe._(
        id,
        name,
        imageUrl,
        recipeCategory,
        description,
        recipeIngredient,
        recipeInstructions,
        recipeYield,
        prepTime,
        cookTime,
        totalTime);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'recipeCategory': recipeCategory,
        'description': description,
        'recipeIngredient': recipeIngredient,
        'recipeInstructions': recipeInstructions,
        'recipeYield': recipeYield,
        'prepTime': prepTime,
        'cookTime': cookTime,
        'totalTime': totalTime
      };

  @override
  List<Object> get props => [id];
}

class MutableRecipe {
  int id;
  String name;
  String imageUrl;
  String recipeCategory;
  String description;
  List<String> recipeIngredient;
  List<String> recipeInstructions;
  int recipeYield;
  Duration prepTime;
  Duration cookTime;
  Duration totalTime;

  Recipe toRecipe() {
    return Recipe._(
        id,
        name,
        imageUrl,
        recipeCategory,
        description,
        recipeIngredient,
        recipeInstructions,
        recipeYield,
        prepTime,
        cookTime,
        totalTime);
  }
}
