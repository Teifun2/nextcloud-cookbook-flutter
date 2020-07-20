import 'package:equatable/equatable.dart';

class Recipe extends Equatable {
  final int _id;
  final String _name;
  final String _imageUrl;
  final String _recipeCategory;
  final String _description;
  final List<String> _recipeIngredient;
  final List<String> _recipeInstructions;

  int get id => _id;
  String get name => _name;
  String get imageUrl => _imageUrl;
  String get recipeCategory => _recipeCategory;
  String get description => _description;
  List<String> get recipeIngredient => _recipeIngredient;
  List<String> get recipeInstructions => _recipeInstructions;

  Recipe.fromJson(Map<String, dynamic> json)
      : _id = json["id"],
        _name = json["name"],
        _imageUrl = json["imageUrl"],
        _recipeCategory = json["recipeCategory"],
        _description = json["description"],
        _recipeIngredient = json["recipeIngredient"].cast<String>().toList(),
        _recipeInstructions =
            json["recipeInstructions"].cast<String>().toList();

  @override
  List<Object> get props => [_id];
}
