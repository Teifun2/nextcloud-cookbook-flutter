import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:nextcloud_cookbook_flutter/src/util/iso_time_format.dart';
import 'package:nextcloud_cookbook_flutter/src/util/nutrition_utilty.dart';

class Recipe extends Equatable {
  final int id;
  final String name;
  final String imageUrl;
  final String recipeCategory;
  final String description;
  final Map<String, String> nutrition;
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
  final Map<String, dynamic> remainingData;

  const Recipe._(
      this.id,
      this.name,
      this.imageUrl,
      this.recipeCategory,
      this.description,
      this.nutrition,
      this.recipeIngredient,
      this.recipeInstructions,
      this.tool,
      this.recipeYield,
      this.prepTime,
      this.cookTime,
      this.totalTime,
      this.keywords,
      this.image,
      this.url,
      this.remainingData);

  factory Recipe.empty() {
    return Recipe._(
      0,
      '',
      '',
      '',
      '',
      Map<String, String>(),
      List<String>.empty(),
      List<String>.empty(),
      List<String>.empty(),
      1,
      Duration.zero,
      Duration.zero,
      Duration.zero,
      '',
      '',
      '',
      Map<String, dynamic>(),
    );
  }

  factory Recipe(String jsonString) {
    Map<String, dynamic> data = json.decode(jsonString);

    int id = data["id"];
    String name = data["name"];
    String imageUrl = data["imageUrl"];
    String recipeCategory = data["recipeCategory"];
    String description = data["description"];

    Map<String, String> recipeNutrition = {};

    if (data["nutrition"] is Map) {
      recipeNutrition = Map<String, String>.from(data["nutrition"])
        ..removeWhere((key, value) =>
            !NutritionUtility.nutritionProperties.contains(key));
      data["nutrition"] = Map.from(data["nutrition"])
        ..removeWhere(
            (key, value) => NutritionUtility.nutritionProperties.contains(key));
    }

    List<String> recipeIngredient = [];
    if (data["recipeIngredient"] is Map) {
      data["recipeIngredient"]
          .forEach((k, v) => recipeIngredient.add(v as String));
    } else {
      recipeIngredient = data["recipeIngredient"].cast<String>().toList();
    }

    List<String> recipeInstructions = [];
    if (data["recipeInstructions"] is Map) {
      data["recipeInstructions"]
          .forEach((k, v) => recipeInstructions.add(v as String));
    } else {
      recipeInstructions = data["recipeInstructions"].cast<String>().toList();
    }

    List<String> tool = [];
    if (data["tool"] is Map) {
      data["tool"].forEach((k, v) => tool.add(v as String));
    } else {
      tool = data["tool"].cast<String>().toList();
    }

    int recipeYield = data["recipeYield"];
    Duration prepTime = data.containsKey("prepTime") &&
            data["prepTime"] != "" &&
            data["prepTime"] != null
        ? IsoTimeFormat.toDuration(data["prepTime"])
        : null;
    Duration cookTime = data.containsKey("cookTime") &&
            data["cookTime"] != "" &&
            data["cookTime"] != null
        ? IsoTimeFormat.toDuration(data["cookTime"])
        : null;
    Duration totalTime = data.containsKey("totalTime") &&
            data["totalTime"] != "" &&
            data["totalTime"] != null
        ? IsoTimeFormat.toDuration(data["totalTime"])
        : null;
    String keywords = data["keywords"];
    String image = data["image"];
    String url = data["url"];

    data.remove("id");
    data.remove("name");
    data.remove("imageUrl");
    data.remove("recipeCategory");
    data.remove("description");
    // Nutrition items are filtered at the point of parsing
    data.remove("recipeIngredient");
    data.remove("recipeInstructions");
    data.remove("tool");
    data.remove("recipeYield");
    data.remove("prepTime");
    data.remove("cookTime");
    data.remove("totalTime");
    data.remove("keywords");
    data.remove("image");
    data.remove("url");

    data.remove("dateModified");

    return Recipe._(
      id,
      name,
      imageUrl,
      recipeCategory,
      description,
      recipeNutrition,
      recipeIngredient,
      recipeInstructions,
      tool,
      recipeYield,
      prepTime,
      cookTime,
      totalTime,
      keywords,
      image,
      url,
      data,
    );
  }

  String toJson() {
    Map<String, dynamic> updatedData = {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'recipeCategory': recipeCategory,
      'description': description,
      'nutrition': nutrition,
      'recipeIngredient': recipeIngredient,
      'recipeInstructions': recipeInstructions,
      'tool': tool,
      'recipeYield': recipeYield,
      'prepTime': _durationToIso(prepTime),
      'cookTime': _durationToIso(cookTime),
      'totalTime': _durationToIso(totalTime),
      'keywords': keywords,
      'image': image,
      'url': url,
      'dateModified': DateTime.now().toIso8601String()
    };

    // Add all the data points that are not handled by the app!
    remainingData.addAll(updatedData);

    return jsonEncode(remainingData);
  }

  MutableRecipe toMutableRecipe() {
    MutableRecipe mutableRecipe = MutableRecipe();

    mutableRecipe.id = this.id;
    mutableRecipe.name = this.name;
    mutableRecipe.imageUrl = this.imageUrl;
    mutableRecipe.recipeCategory = this.recipeCategory;
    mutableRecipe.description = this.description;
    mutableRecipe.nutrition = this.nutrition;
    mutableRecipe.recipeIngredient = this.recipeIngredient;
    mutableRecipe.recipeInstructions = this.recipeInstructions;
    mutableRecipe.tool = this.tool;
    mutableRecipe.recipeYield = this.recipeYield;
    mutableRecipe.prepTime = this.prepTime;
    mutableRecipe.cookTime = this.cookTime;
    mutableRecipe.totalTime = this.totalTime;
    mutableRecipe.keywords = this.keywords;
    mutableRecipe.image = this.image;
    mutableRecipe.url = this.url;
    mutableRecipe.remainingData = this.remainingData;

    return mutableRecipe;
  }

  @override
  List<Object> get props => [id];

  String _durationToIso(Duration duration) {
    if (duration != null && duration.inMinutes != 0) {
      return "PT${duration.inHours}H${duration.inMinutes % 60}M";
    } else {
      return "";
    }
  }
}

class MutableRecipe {
  int id;
  String name;
  String imageUrl;
  String recipeCategory;
  String description;
  Map<String, String> nutrition;
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
  Map<String, dynamic> remainingData;

  Recipe toRecipe() {
    return Recipe._(
      id,
      name,
      imageUrl,
      recipeCategory,
      description,
      nutrition,
      recipeIngredient,
      recipeInstructions,
      tool,
      recipeYield,
      prepTime,
      cookTime,
      totalTime,
      keywords,
      image,
      url,
      remainingData,
    );
  }
}
