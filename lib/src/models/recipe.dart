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
  final List<String> tool;
  final int recipeYield;
  final Duration prepTime;
  final Duration cookTime;
  final Duration totalTime;
  final String keywords;
  final String image;
  final String url;

  const Recipe._(
      this.id,
      this.name,
      this.imageUrl,
      this.recipeCategory,
      this.description,
      this.recipeIngredient,
      this.recipeInstructions,
      this.tool,
      this.recipeYield,
      this.prepTime,
      this.cookTime,
      this.totalTime,
      this.keywords,
      this.image,
      this.url);

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
    List<String> tool = data["tool"].cast<String>().toList();
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
    String keywords = data["keywords"];
    String image = data["image"];
    String url = data["url"];

    return Recipe._(
        id,
        name,
        imageUrl,
        recipeCategory,
        description,
        recipeIngredient,
        recipeInstructions,
        tool,
        recipeYield,
        prepTime,
        cookTime,
        totalTime,
        keywords,
        image,
        url);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'recipeCategory': recipeCategory,
        'description': description,
        'recipeIngredient': recipeIngredient,
        'recipeInstructions': recipeInstructions,
        'tool': tool,
        'recipeYield': recipeYield,
        'prepTime': prepTime,
        'cookTime': cookTime,
        'totalTime': totalTime,
        'keywords': keywords,
        'image': image,
        'url': url
      };

  MutableRecipe toMutableRecipe() {
    MutableRecipe mutableRecipe = MutableRecipe();

    mutableRecipe.id = this.id;
    mutableRecipe.name = this.name;
    mutableRecipe.imageUrl = this.imageUrl;
    mutableRecipe.recipeCategory = this.recipeCategory;
    mutableRecipe.description = this.description;
    mutableRecipe.recipeIngredient = this.recipeIngredient;
    mutableRecipe.recipeInstructions = this.recipeInstructions;
    mutableRecipe.recipeYield = this.recipeYield;
    mutableRecipe.prepTime = this.prepTime;
    mutableRecipe.cookTime = this.cookTime;
    mutableRecipe.totalTime = this.totalTime;

    return mutableRecipe;
  }

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
  List<String> tool;
  int recipeYield;
  Duration prepTime;
  Duration cookTime;
  Duration totalTime;
  String keywords;
  String image;
  String url;

  Recipe toRecipe() {
    return Recipe._(
        id,
        name,
        imageUrl,
        recipeCategory,
        description,
        recipeIngredient,
        recipeInstructions,
        tool,
        recipeYield,
        prepTime,
        cookTime,
        totalTime,
        keywords,
        image,
        url);
  }
}
