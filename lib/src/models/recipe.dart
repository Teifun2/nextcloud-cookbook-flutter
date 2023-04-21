import 'package:nc_cookbook_api/nc_cookbook_api.dart';

extension NutritionExtension on Nutrition {
  Map<String, String> get asMap {
    final items = <String, String>{};
    if (calories != null) {
      items['calories'] = calories!;
    }
    if (carbohydrateContent != null) {
      items['carbohydrateContent'] = carbohydrateContent!;
    }
    if (cholesterolContent != null) {
      items['cholesterolContent'] = cholesterolContent!;
    }
    if (fatContent != null) {
      items['fatContent'] = fatContent!;
    }
    if (fiberContent != null) {
      items['fiberContent'] = fiberContent!;
    }
    if (proteinContent != null) {
      items['proteinContent'] = proteinContent!;
    }
    if (saturatedFatContent != null) {
      items['saturatedFatContent'] = saturatedFatContent!;
    }
    if (servingSize != null) {
      items['servingSize'] = servingSize!;
    }
    if (sodiumContent != null) {
      items['sodiumContent'] = sodiumContent!;
    }
    if (sugarContent != null) {
      items['sugarContent'] = sugarContent!;
    }
    if (transFatContent != null) {
      items['transFatContent'] = transFatContent!;
    }
    if (unsaturatedFatContent != null) {
      items['unsaturatedFatContent'] = unsaturatedFatContent!;
    }

    return items;
  }
}
