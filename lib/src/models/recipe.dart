import 'package:nc_cookbook_api/nc_cookbook_api.dart';

extension RecipeExtension on Recipe {
  Map<String, String> get nutritionList {
    final items = <String, String>{};
    if (nutrition.calories != null) {
      items['calories'] = nutrition.calories!;
    }
    if (nutrition.carbohydrateContent != null) {
      items['carbohydrateContent'] = nutrition.carbohydrateContent!;
    }
    if (nutrition.cholesterolContent != null) {
      items['cholesterolContent'] = nutrition.cholesterolContent!;
    }
    if (nutrition.fatContent != null) {
      items['fatContent'] = nutrition.fatContent!;
    }
    if (nutrition.fiberContent != null) {
      items['fiberContent'] = nutrition.fiberContent!;
    }
    if (nutrition.proteinContent != null) {
      items['proteinContent'] = nutrition.proteinContent!;
    }
    if (nutrition.saturatedFatContent != null) {
      items['saturatedFatContent'] = nutrition.saturatedFatContent!;
    }
    if (nutrition.servingSize != null) {
      items['servingSize'] = nutrition.servingSize!;
    }
    if (nutrition.sodiumContent != null) {
      items['sodiumContent'] = nutrition.sodiumContent!;
    }
    if (nutrition.sugarContent != null) {
      items['sugarContent'] = nutrition.sugarContent!;
    }
    if (nutrition.transFatContent != null) {
      items['transFatContent'] = nutrition.transFatContent!;
    }
    if (nutrition.unsaturatedFatContent != null) {
      items['unsaturatedFatContent'] = nutrition.unsaturatedFatContent!;
    }

    return items;
  }
}
