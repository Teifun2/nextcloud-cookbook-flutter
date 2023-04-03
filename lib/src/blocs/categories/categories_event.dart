part of 'categories_bloc.dart';

abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object> get props => [];
}

class CategoriesLoaded extends CategoriesEvent {
  const CategoriesLoaded();
}
