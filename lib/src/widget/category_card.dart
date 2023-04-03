import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:nc_cookbook_api/nc_cookbook_api.dart';
import 'package:nextcloud_cookbook_flutter/src/util/setting_keys.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/recipe_image.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final String? imageID;

  const CategoryCard(
    this.category,
    this.imageID, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 7,
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: <Color>[Colors.black, Colors.transparent],
              ).createShader(bounds);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: RecipeImage(
                id: imageID,
                size: const Size.square(250),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              category.name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: Settings.getValue<double>(
                  SettingKeys.category_font_size.name,
                  defaultValue: 16,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepOrange,
                  border: Border.all(color: Colors.deepOrangeAccent, width: 2),
                ),
                child: Center(
                  child: Text(
                    category.recipeCount.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
