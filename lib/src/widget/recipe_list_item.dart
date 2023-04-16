import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nc_cookbook_api/nc_cookbook_api.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/recipe_image.dart';

class RecipeListItem extends StatelessWidget {
  final RecipeStub recipe;

  const RecipeListItem({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: RecipeImage(
          id: recipe.recipeId,
          size: const Size.square(80),
        ),
      ),
      title: Text(recipe.name),
      subtitle: Row(
        children: [
          _RecipeListDate(
            Icons.edit_calendar_outlined,
            recipe.dateCreated,
          ),
          if (recipe.dateModified != null &&
              recipe.dateModified != recipe.dateCreated) ...[
            _RecipeListDate(
              Icons.edit_outlined,
              recipe.dateModified!,
            ),
          ],
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeScreen(recipeId: recipe.recipeId),
          ),
        );
      },
    );
  }
}

class _RecipeListDate extends StatelessWidget {
  const _RecipeListDate(
    this.icon,
    this.data,
  );

  final DateTime data;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall!;
    final colorScheme = Theme.of(context).colorScheme;
    final content = DateFormat(DateFormat.YEAR_NUM_MONTH_DAY).format(data);

    return Card(
      color: colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: textStyle.fontSize,
              color: colorScheme.onSecondaryContainer,
            ),
            const SizedBox(width: 4),
            Text(
              content,
              style: textStyle.copyWith(
                color: colorScheme.onSecondaryContainer,
              ),
              overflow: TextOverflow.fade,
            ),
          ],
        ),
      ),
    );
  }
}
