import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';

abstract class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object> get props => [];
}

class RecipeInitial extends RecipeState {}

class RecipeLoadSuccess extends RecipeState {
  final Recipe recipe;

  RecipeLoadSuccess({@required this.recipe});

  @override
  List<Object> get props => [recipe];
}

class RecipeLoadFailure extends RecipeState {}

class RecipeLoadInProgress extends RecipeState {}