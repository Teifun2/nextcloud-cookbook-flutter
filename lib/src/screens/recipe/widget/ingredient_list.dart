import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nc_cookbook_api/nc_cookbook_api.dart';

class IngredientList extends StatefulWidget {
  final Recipe _recipe;
  final TextStyle _textStyle;

  const IngredientList(
    this._recipe,
    this._textStyle, {
    super.key,
  });

  @override
  _IngredientListState createState() => _IngredientListState();
}

class _IngredientListState extends State<IngredientList> {
  late List<bool> _ingredientsDone;

  @override
  void initState() {
    super.initState();

    _ingredientsDone =
        List.filled(widget._recipe.recipeIngredient.length, false);
  }

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
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return widget._recipe.recipeIngredient[index].startsWith('##')
                      ? Text(
                          widget._recipe.recipeIngredient[index].replaceFirst(
                            RegExp(r'##\s*'),
                            '',
                          ),
                          style: widget._textStyle.copyWith(
                            fontFeatures: [const FontFeature.enable('smcp')],
                          ),
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: widget._textStyle.fontSize! * 1.5,
                              height: widget._textStyle.fontSize,
                              alignment: Alignment.center,
                              child: _ingredientsDone[index]
                                  ? Icon(
                                      Icons.check_circle,
                                      size: widget._textStyle.fontSize,
                                      color: Colors.green,
                                    )
                                  : Icon(
                                      Icons.circle,
                                      size: widget._textStyle.fontSize! * 0.5,
                                    ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _ingredientsDone[index] =
                                        !_ingredientsDone[index];
                                  });
                                },
                                child: Text(
                                  widget._recipe.recipeIngredient[index],
                                  style: widget._textStyle,
                                ),
                              ),
                            ),
                          ],
                        );
                },
                separatorBuilder: (c, i) => const SizedBox(height: 5),
                itemCount: widget._recipe.recipeIngredient.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
