part of '../recipe_screen.dart';

class DurationList extends StatelessWidget {
  const DurationList({
    required this.recipe,
    super.key,
  });
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    const height = 35.0;
    const padding = EdgeInsets.symmetric(horizontal: 13);

    return Wrap(
      alignment: WrapAlignment.center,
      runSpacing: 10,
      spacing: 10,
      children: <Widget>[
        if (recipe.prepTime != null)
          RoundedBoxItem(
            name: translate('recipe.prep'),
            value: recipe.prepTime!.formatMinutes(),
            height: height,
            padding: padding,
          ),
        if (recipe.cookTime != null)
          RoundedBoxItem(
            name: translate('recipe.cook'),
            value: recipe.cookTime!.formatMinutes(),
            height: height,
            padding: padding,
          ),
        if (recipe.totalTime != null)
          RoundedBoxItem(
            name: translate('recipe.total'),
            value: recipe.totalTime!.formatMinutes(),
            height: height,
            padding: padding,
          ),
      ],
    );
  }
}
