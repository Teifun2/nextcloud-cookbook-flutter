part of '../recipe_screen.dart';

class RecipeYield extends StatelessWidget {
  const RecipeYield({
    required this.recipe,
    super.key,
  });
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final style =
        Theme.of(context).textTheme.bodyMedium!.apply(fontWeightDelta: 3);

    return Row(
      children: <Widget>[
        Text(
          "${translate('recipe.fields.servings.else')}: ${recipe.recipeYield}",
          style: style,
        ),
        if (recipe.url.isNotEmpty) ...[
          const Spacer(),
          ElevatedButton(
            onPressed: () async => launchUrlString(recipe.url),
            child: Text(translate('recipe.fields.source_button')),
          ),
        ],
      ],
    );
  }
}
