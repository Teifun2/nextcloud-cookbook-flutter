part of '../recipe_screen.dart';

class IngredientList extends StatelessWidget {
  final Recipe recipe;
  final TextStyle textStyle;

  const IngredientList(
    this.recipe,
    this.textStyle,
  );

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      childrenPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      title: Text(translate('recipe.fields.ingredients')),
      initiallyExpanded: true,
      children: <Widget>[
        for (final ingredient in recipe.recipeIngredient)
          _IngredientListItem(ingredient, textStyle)
      ],
    );
  }
}

class _IngredientListItem extends StatefulWidget {
  final String ingredient;
  final TextStyle textStyle;

  const _IngredientListItem(this.ingredient, this.textStyle);

  @override
  State<_IngredientListItem> createState() => __IngredientListItemState();
}

class __IngredientListItemState extends State<_IngredientListItem> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    if (widget.ingredient.startsWith('##')) {
      return Text(
        widget.ingredient.replaceFirst(RegExp(r'##\s*'), '').trim(),
        style: widget.textStyle.copyWith(
          fontFeatures: [const FontFeature.enable('smcp')],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: GestureDetector(
        onTap: () => setState(() {
          selected = !selected;
        }),
        child: Row(
          children: <Widget>[
            Container(
              width: widget.textStyle.fontSize,
              height: widget.textStyle.fontSize,
              decoration: ShapeDecoration(
                shape: const CircleBorder(
                  side: BorderSide(color: Colors.grey),
                ),
                color: selected
                    ? Colors.green
                    : Theme.of(context).colorScheme.onBackground,
              ),
              child: selected
                  ? Icon(
                      Icons.check_outlined,
                      size: widget.textStyle.fontSize! * 0.75,
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.ingredient,
                style: widget.textStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
