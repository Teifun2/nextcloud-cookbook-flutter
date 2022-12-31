import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe/widget/nutrition_list_item.dart';

class NutritionList extends StatelessWidget {
  final Map<String, String> _nutrition;

  const NutritionList(
    this._nutrition, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(translate('recipe.fields.nutrition.title')),
          children: [
            Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _nutrition.entries
                    .map((e) => NutritionListItem(
                        translate('recipe.fields.nutrition.items.${e.key}'),
                        e.value,),)
                    .toList(),),
          ],
        ),
      ),
    );
  }
}
