import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nc_cookbook_api/nc_cookbook_api.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipes_list_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/recipe_image.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final String? imageID;

  const CategoryCard(
    this.category,
    this.imageID, {
    super.key,
  });

  static const double _spacer = 8;
  static const _labelPadding = EdgeInsets.symmetric(horizontal: 8.0);

  static TextStyle _nameStyle(BuildContext context) =>
      Theme.of(context).textTheme.labelSmall!;

  static TextStyle _itemStyle(BuildContext context) =>
      Theme.of(context).textTheme.labelSmall!;

  static double hightExtend(BuildContext context) {
    return _spacer +
        _itemStyle(context).fontSize! +
        _itemStyle(context).fontSize! +
        2 * _labelPadding.horizontal;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth;

        final String itemsText = translatePlural(
          'categories.items',
          category.recipeCount,
        );

        return GestureDetector(
          child: Card(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: RecipeImage(
                    id: imageID,
                    size: Size.square(size),
                  ),
                ),
                const SizedBox(height: _spacer),
                Padding(
                  padding: _labelPadding,
                  child: Text(
                    category.name,
                    maxLines: 1,
                    style: _nameStyle(context),
                  ),
                ),
                Padding(
                  padding: _labelPadding,
                  child: Text(
                    itemsText,
                    style: _itemStyle(context),
                  ),
                ),
              ],
            ),
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipesListScreen(category: category.name),
            ),
          ),
        );
      },
    );
  }
}
