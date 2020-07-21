import 'package:equatable/equatable.dart';
import 'package:nextcloud_cookbook_flutter/src/util/iso_time_format.dart';

class Recipe extends Equatable {
  final int _id;
  final String _name;
  final String _imageUrl;
  final String _recipeCategory;
  final String _description;
  final List<String> _recipeIngredient;
  final List<String> _recipeInstructions;
  final int _recipeYield;
  final Duration _prepTime;
  final Duration _cookTime;
  final Duration _totalTime;

  int get id => _id;
  String get name => _name;
  String get imageUrl => _imageUrl;
  String get recipeCategory => _recipeCategory;
  String get description => _description;
  List<String> get recipeIngredient => _recipeIngredient;
  List<String> get recipeInstructions => _recipeInstructions;
  int get recipeYield => _recipeYield;
  Duration get prepTime => _prepTime;
  Duration get cookTime => _cookTime;
  Duration get totalTime => _totalTime;

  Recipe.fromJson(Map<String, dynamic> json)
      : _id = json["id"],
        _name = json["name"],
        _imageUrl = json["imageUrl"],
        _recipeCategory = json["recipeCategory"],
        _description = json["description"],
        _recipeIngredient = json["recipeIngredient"].cast<String>().toList(),
        _recipeInstructions =
            json["recipeInstructions"].cast<String>().toList(),
        _recipeYield = json["recipeYield"],
        _prepTime = IsoTimeFormat.toDuration(json["prepTime"]),
        _cookTime = IsoTimeFormat.toDuration(json["cookTime"]),
        _totalTime = IsoTimeFormat.toDuration(json["totalTime"]);

  @override
  List<Object> get props => [_id];
}
