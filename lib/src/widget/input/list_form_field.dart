import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe_bloc.dart';
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
    super.initState();

    currentList = widget.list
        .map((item) => ListTile(title: Text(item), key: ValueKey(item)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.0 * currentList.length,
      child: my.ReorderableListView(
        onReorder: _onReorder,
        children: currentList,
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    final ListTile tile = currentList.removeAt(oldIndex);
    currentList.insert(newIndex, tile);

    setState(() {
      widget.onChanged(
        currentList.map((tile) {
          final Text title = tile.title! as Text;
          log(title.data!);
          return title.data!;
        }).toList(),
      );
    });
  }
}
