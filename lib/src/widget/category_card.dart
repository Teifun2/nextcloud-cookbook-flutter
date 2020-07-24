import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nextcloud_cookbook_flutter/src/models/category.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/authentication_cached_network_image.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard(this.category);

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
              return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: <Color>[Colors.black, Colors.transparent])
                  .createShader(bounds);
            },
            child: (category.imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: AuthenticationCachedNetworkImage(
                      imagePath: category.imageUrl,
                      boxFit: BoxFit.cover,
                    ),
                  )
                : Center(child: CircularProgressIndicator())),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(
                  category.name,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.deepOrange,
                        border: Border.all(
                            color: Colors.deepOrangeAccent, width: 2),
                      ),
                      child: Center(
                          child: Text(
                        category.recipeCount.toString(),
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
