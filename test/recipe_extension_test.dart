import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nc_cookbook_api/nc_cookbook_api.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/timer.dart';
import 'package:nextcloud_cookbook_flutter/src/services/services.dart';

class NotificationServiceMock extends Mock implements NotificationService {}

// ignore: avoid_implementing_value_types
class FakeTimer extends Fake implements Timer {}

void main() {
  const calories = 'Test calories';
  const carbohydrateContent = 'Testcarbohydrat eContent';
  const cholesterolContent = 'Testcholestero lContent';
  const fatContent = 'Testfa tContent';
  const fiberContent = 'Testfibe rContent';
  const proteinContent = 'Testprotei nContent';
  const saturatedFatContent = 'TestsaturatedFa tContent';
  const servingSize = 'Testser vingSize';
  const sodiumContent = 'Testsodiu mContent';
  const sugarContent = 'Testsuga rContent';
  const transFatContent = 'TesttransFa tContent';
  const unsaturatedFatContent = 'TestunsaturatedFa tContent';

  final nutritionMap = Nutrition(
    (b) => b
      ..calories = calories
      ..carbohydrateContent = carbohydrateContent
      ..cholesterolContent = cholesterolContent
      ..fatContent = fatContent
      ..fiberContent = fiberContent
      ..proteinContent = proteinContent
      ..saturatedFatContent = saturatedFatContent
      ..servingSize = servingSize
      ..sodiumContent = sodiumContent
      ..sugarContent = sugarContent
      ..transFatContent = transFatContent
      ..unsaturatedFatContent = unsaturatedFatContent,
  ).asMap;

  test('NutritionExtension', () {
    expect(nutritionMap['calories'], calories);
    expect(nutritionMap['carbohydrateContent'], carbohydrateContent);
    expect(nutritionMap['cholesterolContent'], cholesterolContent);
    expect(nutritionMap['fatContent'], fatContent);
    expect(nutritionMap['fiberContent'], fiberContent);
    expect(nutritionMap['proteinContent'], proteinContent);
    expect(nutritionMap['saturatedFatContent'], saturatedFatContent);
    expect(nutritionMap['servingSize'], servingSize);
    expect(nutritionMap['sodiumContent'], sodiumContent);
    expect(nutritionMap['sugarContent'], sugarContent);
    expect(nutritionMap['transFatContent'], transFatContent);
    expect(nutritionMap['unsaturatedFatContent'], unsaturatedFatContent);
  });
}
