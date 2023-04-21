part of '../recipe_screen.dart';

class NutritionList extends StatelessWidget {
  const NutritionList(
    this.nutrition, {
    super.key,
  });
  final Map<String, String> nutrition;

  @override
  Widget build(BuildContext context) => ExpansionTile(
        title: Text(translate('recipe.fields.nutrition.title')),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final entry in nutrition.entries)
                  RoundedBoxItem(
                    name: translate(
                      'recipe.fields.nutrition.items.${entry.key}',
                    ),
                    value: entry.value,
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
              ],
            ),
          ),
        ],
      );
}
