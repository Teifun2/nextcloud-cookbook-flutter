import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart' as RL;
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe.dart';

class ReorderableListFormField extends StatefulWidget {
  final String title;
  final List<String> items;
  final RecipeState state;
  final Function(List<String> value) onSave;

  ReorderableListFormField(
      {Key key, this.title, this.items, this.state, this.onSave})
      : super(key: key);

  @override
  _ReorderableListFormFieldState createState() =>
      _ReorderableListFormFieldState(items);
}

class ItemData {
  ItemData(this.text, this.key);

  String text;

  // Each item in reorderable list needs stable and unique key
  final Key key;
}

class _ReorderableListFormFieldState extends State<ReorderableListFormField> {
  List<ItemData> _items;

  _ReorderableListFormFieldState(List<String> items) {
    _items = List();
    for (int i = 0; i < items.length; ++i) {
      _items.add(ItemData(items[i], ValueKey(i)));
    }
  }

  int _indexOfKey(Key key) {
    return _items.indexWhere((ItemData d) => d.key == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    final draggedItem = _items[draggingIndex];
    setState(() {
      _items.removeAt(draggingIndex);
      _items.insert(newPositionIndex, draggedItem);
    });
    return true;
  }

  void _reorderDone(Key item) {
    final draggedItem = _items[_indexOfKey(item)];
  }

  //
  // Reordering works by having ReorderableList widget in hierarchy
  // containing ReorderableItems widgets
  //

  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          childrenPadding: EdgeInsets.zero,
          tilePadding: EdgeInsets.zero,
          title: Row(
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                width: 1,
                child: TextFormField(
                  initialValue: "",
                  enabled: false,
                  onSaved: (_) {
                    widget.onSave(_items.map((e) => e.text).toList());
                  },
                ),
              ),
            ],
          ),
          children: [
            RL.ReorderableList(
              onReorder: this._reorderCallback,
              onReorderDone: this._reorderDone,
              child: CustomScrollView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                slivers: <Widget>[
                  SliverPadding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          if (index == _items.length) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                enableFeedback:
                                    !(widget.state is RecipeUpdateInProgress),
                                icon: Icon(Icons.add, color: Colors.black),
                                onPressed: () {
                                  setState(() {
                                    if (!(widget.state
                                        is RecipeUpdateInProgress)) {
                                      _items.add(ItemData(
                                          "", ValueKey(_items.length)));
                                    }
                                  });
                                },
                              ),
                            );
                          }
                          return Item(
                            key: UniqueKey(),
                            data: _items[index],
                            isFirst: index == 0,
                            isLast: index == _items.length - 1,
                            deleteItem: () {
                              setState(() {
                                _items.removeAt(index);
                              });
                            },
                            state: widget.state,
                            onChange: (String value) {
                              _items[index].text = value;
                            },
                          );
                        },
                        childCount: _items.length + 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Item extends StatefulWidget {
  Item(
      {Key key,
      this.data,
      this.isFirst,
      this.isLast,
      this.deleteItem,
      this.state,
      this.onChange})
      : super(key: key);

  final ItemData data;
  final bool isFirst;
  final bool isLast;
  final Function deleteItem;
  final Function(String value) onChange;
  final RecipeState state;

  @override
  State<StatefulWidget> createState() => _ItemState(
        data: data,
        isFirst: isFirst,
        isLast: isLast,
        deleteItem: deleteItem,
      );
}

class _ItemState extends State<Item> {
  _ItemState({
    this.data,
    this.isFirst,
    this.isLast,
    this.deleteItem,
  });

  final ItemData data;
  final bool isFirst;
  final bool isLast;
  final Function deleteItem;

  Widget _buildChild(BuildContext context, RL.ReorderableItemState state) {
    BoxDecoration decoration;

    if (state == RL.ReorderableItemState.dragProxy ||
        state == RL.ReorderableItemState.dragProxyFinished) {
      // slightly transparent background white dragging (just like on iOS)
      decoration = BoxDecoration(color: Color(0xD0FFFFFF));
    } else {
      bool placeholder = state == RL.ReorderableItemState.placeholder;
      decoration = BoxDecoration(
        border: Border(
          top: isFirst && !placeholder
              ? Divider.createBorderSide(context) //
              : BorderSide.none,
          bottom: isLast && placeholder
              ? BorderSide.none //
              : Divider.createBorderSide(context),
        ),
        color: placeholder ? null : Colors.white,
      );
    }

    // For iOS dragging mode, there will be drag handle on the right that triggers
    // reordering; For android mode it will be just an empty container
    Widget dragHandle = RL.ReorderableListener(
      canStart: () => !(widget.state is RecipeUpdateInProgress),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 7),
        color: Color(0x08000000),
        child: Center(
          child: Icon(Icons.reorder, color: Colors.grey),
        ),
      ),
    );

    Widget delete = Container(
      color: Color(0x08000000),
      child: Center(
        child: IconButton(
          enableFeedback: !(widget.state is RecipeUpdateInProgress),
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            if (!(widget.state is RecipeUpdateInProgress)) {
              deleteItem();
            }
          },
        ),
      ),
    );

    Widget content = Container(
      decoration: decoration,
      child: SafeArea(
          top: false,
          bottom: false,
          child: Opacity(
            // hide content for placeholder
            opacity: state == RL.ReorderableItemState.placeholder ? 0.0 : 1.0,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 10.0,
                      ),
                      child: TextFormField(
                        enabled: !(widget.state is RecipeUpdateInProgress),
                        maxLines: 10000,
                        minLines: 1,
                        initialValue: data.text,
                        onChanged: widget.onChange,
                      ),
                      // child: Text(
                      //   data.title,
                      //   style: Theme.of(context).textTheme.subtitle1,
                      // ),
                    ),
                  ),
                  // Triggers the reordering
                  dragHandle,
                  delete,
                ],
              ),
            ),
          )),
    );

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return RL.ReorderableItem(
        key: data.key, //
        childBuilder: _buildChild);
  }
}
