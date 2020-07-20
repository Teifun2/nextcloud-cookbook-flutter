import 'package:equatable/equatable.dart';

class Recipe extends Equatable {
  final int _id;
  final String _name;
  final String _imageUrl;
  final String _recipeCategory;
  final List<String> _recipeIngredient;

  int get id => _id;
  String get name => _name;
  String get imageUrl => _imageUrl;
  String get recipeCategory => _recipeCategory;
  List<String> get recipeIngredient => _recipeIngredient;

  Recipe.fromJson(Map<String, dynamic> json) :
    _id = json["id"],
    _name = json["name"],
    _imageUrl = json["imageUrl"],
    _recipeCategory = json["recipeCategory"],
    _recipeIngredient = json["recipeIngredient"].cast<String>().toList();

  @override
  List<Object> get props => [_id];
}