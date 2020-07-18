import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';

abstract class RecipesShortEvent extends Equatable {
  const RecipesShortEvent();

  @override
  List<Object> get props => [];
}

class RecipesShortLoaded extends RecipesShortEvent {
  final AppAuthentication appAuthentication;

  const RecipesShortLoaded({@required this.appAuthentication});

  @override
  List<Object> get props => [appAuthentication];
}

// TODO: Implement Recipe Deletion
class RecipesShortDeleted extends RecipesShortEvent {}

// TODO: Implement Recipe Update (maybe to favorite / un-favorite?)
class RecipesShortUpdated extends RecipesShortEvent {}