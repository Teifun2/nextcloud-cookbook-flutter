// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CategoryCWProxy {
  Category firstRecipeId(int firstRecipeId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Category(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Category(...).copyWith(id: 12, name: "My name")
  /// ````
  Category call({
    int? firstRecipeId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCategory.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCategory.copyWith.fieldName(...)`
class _$CategoryCWProxyImpl implements _$CategoryCWProxy {
  const _$CategoryCWProxyImpl(this._value);

  final Category _value;

  @override
  Category firstRecipeId(int firstRecipeId) =>
      this(firstRecipeId: firstRecipeId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Category(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Category(...).copyWith(id: 12, name: "My name")
  /// ````
  Category call({
    Object? firstRecipeId = const $CopyWithPlaceholder(),
  }) {
    return Category._(
      name: _value.name,
      recipeCount: _value.recipeCount,
      firstRecipeId:
          firstRecipeId == const $CopyWithPlaceholder() || firstRecipeId == null
              // ignore: unnecessary_non_null_assertion
              ? _value.firstRecipeId!
              // ignore: cast_nullable_to_non_nullable
              : firstRecipeId as int,
    );
  }
}

extension $CategoryCopyWith on Category {
  /// Returns a callable class that can be used as follows: `instanceOfCategory.copyWith(...)` or like so:`instanceOfCategory.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CategoryCWProxy get copyWith => _$CategoryCWProxyImpl(this);
}
