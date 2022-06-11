import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';

class IngredientList extends StatelessWidget {
  final Recipe _recipe;
  final TextStyle _textStyle;

  const IngredientList(this._recipe, this._textStyle);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(translate('recipe.fields.ingredients')),
          initiallyExpanded: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return this._recipe.recipeIngredient[index].startsWith('##')
                    ? Text(
                        this._recipe.recipeIngredient[index].replaceFirst(
                          RegExp(r'##\s*'),
                          '',
                        ),
                        style: this._textStyle.copyWith(
                          fontFeatures:[FontFeature.enable('smcp')],
                        ),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: this._textStyle.fontSize * 1.5,
                            height: this._textStyle.fontSize,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.circle,
                              size: this._textStyle.fontSize * 0.5,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              this._recipe.recipeIngredient[index],
                              style: this._textStyle,
                            ),
                          ),
                        ],
                      );
                },
                separatorBuilder: (c, i) => SizedBox(height: 5),
                itemCount: this._recipe.recipeIngredient.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
