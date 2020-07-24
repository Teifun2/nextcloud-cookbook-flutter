import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nextcloud_cookbook_flutter/src/models/category.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object> get props => [];
}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoadSuccess extends CategoriesState {
  final List<Category> categories;

  const CategoriesLoadSuccess({@required this.categories});

  @override
  List<Object> get props => [categories];
}

class CategoriesLoadFailure extends CategoriesState {}

class CategoriesLoadInProgress extends CategoriesState {}
