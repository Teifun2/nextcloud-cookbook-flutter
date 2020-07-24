import 'package:equatable/equatable.dart';

abstract class RecipesShortEvent extends Equatable {
  const RecipesShortEvent();

  @override
  List<Object> get props => [];
}

class RecipesShortLoaded extends RecipesShortEvent {
  final String category;

  const RecipesShortLoaded({this.category = 'all'});

  @override
  List<Object> get props => [category];
}

// TODO: Implement Recipe Deletion
class RecipesShortDeleted extends RecipesShortEvent {}

// TODO: Implement Recipe Update (maybe to favorite / un-favorite?)
class RecipesShortUpdated extends RecipesShortEvent {}
