import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/my_reorderable_list.dart'
    as my;

class ListFormField extends StatefulWidget {
  final String title;
  final RecipeState state;
  final List<String> list;
  final void Function(List<String> value) onChanged;

  const ListFormField({
    super.key,
    required this.state,
    required this.list,
    required this.title,
    required this.onChanged,
  });

  @override
  _ListFormFieldState createState() => _ListFormFieldState();
}

class _ListFormFieldState extends State<ListFormField> {
  late List<ListTile> currentList;

  @override
  void initState() {
    currentList = widget.list
        .map((item) => ListTile(title: Text(item), key: ValueKey(item)))
        .toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.0 * currentList.length,
      child: my.ReorderableListView(
        children: currentList,
        onReorder: _onReorder,
      ),
    );
  }

  _onReorder(int oldIndex, int newIndex) {
    ListTile tile = currentList.removeAt(oldIndex);
    currentList.insert(newIndex, tile);

    setState(() {
      widget.onChanged(currentList.map((tile) {
        Text title = tile.title as Text;
        log(title.data!);
        return title.data!;
      }).toList());
    });
  }
}
