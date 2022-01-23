import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';

class InstructionList extends StatefulWidget {
  final Recipe _recipe;
  final TextStyle _textStyle;

  const InstructionList(this._recipe, this._textStyle);

  @override
  _InstructionListState createState() => _InstructionListState();
}

class _InstructionListState extends State<InstructionList> {
  List<bool> _instructionsDone;

  @override
  void initState() {
    _instructionsDone =
        List.filled(widget._recipe.recipeInstructions.length, false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(translate('recipe.fields.instructions')),
          initiallyExpanded: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _instructionsDone[index] = !_instructionsDone[index];
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.only(right: 15, top: 10),
                          child: _instructionsDone[index]
                              ? Icon(Icons.check)
                              : Center(child: Text("${index + 1}")),
                          decoration: ShapeDecoration(
                            shape: CircleBorder(
                                side: BorderSide(color: Colors.grey)),
                            color: _instructionsDone[index]
                                ? Colors.green
                                : Theme.of(context).backgroundColor,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            widget._recipe.recipeInstructions[index],
                            style: widget._textStyle,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (c, i) => SizedBox(height: 10),
                itemCount: widget._recipe.recipeInstructions.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
