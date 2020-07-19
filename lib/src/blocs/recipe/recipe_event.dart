import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object> get props => [];
}

class RecipeLoaded extends RecipeEvent {
  final AppAuthentication appAuthentication;
  final int recipeId;

  const RecipeLoaded({@required this.appAuthentication, @required this.recipeId});

  @override
  List<Object> get props => [appAuthentication];
}