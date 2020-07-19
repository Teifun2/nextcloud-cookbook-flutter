import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object> get props => [];
}

class RecipeLoaded extends RecipeEvent {
  final int recipeId;

  const RecipeLoaded({@required this.recipeId});

  @override
  List<Object> get props => [recipeId];
}