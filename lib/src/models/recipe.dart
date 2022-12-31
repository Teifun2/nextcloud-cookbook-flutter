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

  factory Recipe(String jsonString) {
    final Map<String, dynamic> data = json.decode(jsonString);

    final int id = data["id"] ?? 0;
    final String name = data["name"] ?? '';
    final String imageUrl = data["imageUrl"] ?? '';
    final String recipeCategory = data["recipeCategory"] ?? '';
    final String description = data["description"] ?? '';

    Map<String, String> recipeNutrition = {};

    if (data["nutrition"] is Map<String, dynamic>) {
      recipeNutrition = (data["nutrition"] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, value.toString()))
        ..removeWhere((key, value) =>
            !NutritionUtility.nutritionProperties.contains(key),);
      data["nutrition"] = (data["nutrition"] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, value?.toString()))
        ..removeWhere(
            (key, value) => NutritionUtility.nutritionProperties.contains(key),);
    }

    List<String> recipeIngredient = [];
    if (data["recipeIngredient"] is Map) {
      data["recipeIngredient"]
          .forEach((k, v) => recipeIngredient.add(v as String));
    } else if (data["recipeIngredient"] != null) {
      recipeIngredient = data["recipeIngredient"].cast<String>().toList();
    }

    List<String> recipeInstructions = [];
    if (data["recipeInstructions"] is Map) {
      data["recipeInstructions"]
          .forEach((k, v) => recipeInstructions.add(v as String));
    } else if (data["recipeInstructions"] != null) {
      recipeInstructions = data["recipeInstructions"].cast<String>().toList();
    }

    List<String> tool = [];
    if (data["tool"] is Map) {
      data["tool"].forEach((k, v) => tool.add(v as String));
    } else if (data["tool"] != null) {
      tool = data["tool"].cast<String>().toList();
    }

    final int recipeYield = data["recipeYield"] ?? 1;
    final Duration prepTime = data.containsKey("prepTime") &&
            data["prepTime"] != "" &&
            data["prepTime"] != null
        ? IsoTimeFormat.toDuration(data["prepTime"])
        : Duration.zero;
    final Duration cookTime = data.containsKey("cookTime") &&
            data["cookTime"] != "" &&
            data["cookTime"] != null
        ? IsoTimeFormat.toDuration(data["cookTime"])
        : Duration.zero;
    final Duration totalTime = data.containsKey("totalTime") &&
            data["totalTime"] != "" &&
            data["totalTime"] != null
        ? IsoTimeFormat.toDuration(data["totalTime"])
        : Duration.zero;
    final String keywords = data["keywords"] ?? '';
    final String image = data["image"] ?? '';
    final String url = data["url"] ?? '';

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
    this.remainingData,
  );

  factory Recipe.empty() {
    return Recipe._(
      0,
      '',
      '',
      '',
      '',
      const <String, String>{},
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
      const <String, dynamic>{},
    );
  }

  String toJson() {
    final Map<String, dynamic> updatedData = {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'recipeCategory': recipeCategory,
      'description': description,
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

    if (remainingData['nutrition'] is Map) {
      (remainingData['nutrition'] as Map).addAll(nutrition);
    } else {
      remainingData['nutrition'] = nutrition;
    }

    return jsonEncode(remainingData);
  }

  MutableRecipe toMutableRecipe() {
    final MutableRecipe mutableRecipe = MutableRecipe();

    mutableRecipe.id = id;
    mutableRecipe.name = name;
    mutableRecipe.imageUrl = imageUrl;
    mutableRecipe.recipeCategory = recipeCategory;
    mutableRecipe.description = description;
    mutableRecipe.nutrition = nutrition;
    mutableRecipe.recipeIngredient = recipeIngredient;
    mutableRecipe.recipeInstructions = recipeInstructions;
    mutableRecipe.tool = tool;
    mutableRecipe.recipeYield = recipeYield;
    mutableRecipe.prepTime = prepTime;
    mutableRecipe.cookTime = cookTime;
    mutableRecipe.totalTime = totalTime;
    mutableRecipe.keywords = keywords;
    mutableRecipe.image = image;
    mutableRecipe.url = url;
    mutableRecipe.remainingData = remainingData;

    return mutableRecipe;
  }

  @override
  List<int> get props => [id];

  String _durationToIso(Duration? duration) {
    if (duration != null && duration.inMinutes != 0) {
      return "PT${duration.inHours}H${duration.inMinutes % 60}M";
    } else {
      return "";
    }
  }
}

class MutableRecipe {
  int id = 0;
  String name = '';
  String imageUrl = '';
  String recipeCategory = '';
  String description = '';
  Map<String, String> nutrition = {};
  List<String> recipeIngredient = [];
  List<String> recipeInstructions = [];
  List<String> tool = [];
  int recipeYield = 0;
  Duration prepTime = Duration.zero;
  Duration cookTime = Duration.zero;
  Duration totalTime = Duration.zero;
  String keywords = '';
  String image = '';
  String url = '';
  Map<String, dynamic> remainingData = {};

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
