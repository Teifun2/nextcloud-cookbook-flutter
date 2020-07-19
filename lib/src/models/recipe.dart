import 'package:equatable/equatable.dart';

class Recipe extends Equatable {
  final int _recipeId;
  final String _name;
  final String _userId;
  final String _imageUrl;
  final String _recipeCategory;

  int get recipeId => _recipeId;
  String get name => _name;
  String get userId => _userId;
  String get imageUrl => _imageUrl;
  String get recipeCategory => _recipeCategory;

  Recipe.fromJson(Map<String, dynamic> json) :
    _recipeId = int.parse(json["recipe_id"]),
    _name = json["name"],
    _userId = json["user_id"],
    _imageUrl = json["imageUrl"],
    _recipeCategory = json["recipeCategory"];

  @override
  List<Object> get props => [_recipeId];
}