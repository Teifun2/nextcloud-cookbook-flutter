part of '../recipe_screen.dart';

class NutritionList extends StatelessWidget {
  final Map<String, String> nutrition;

  const NutritionList(
    this.nutrition,
  );

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(translate('recipe.fields.nutrition.title')),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
}
