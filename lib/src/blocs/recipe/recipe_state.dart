import 'package:equatable/equatable.dart';

abstract class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object> get props => [];
}

class RecipeInitial extends RecipeState {}

class RecipeLoadSuccess extends RecipeState {}

class RecipeLoadFailure extends RecipeState {}

class RecipeLoadInProgress extends RecipeState {}