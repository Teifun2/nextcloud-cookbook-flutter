import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

class ReorderableListFormField extends StatefulWidget {
  final String title;
  final List<String> items;

  ReorderableListFormField({Key key, this.title, this.items}) : super(key: key);

  @override
  _ReorderableListFormFieldState createState() =>
      _ReorderableListFormFieldState(items);
}

class ItemData {
  ItemData(this.title, this.key);

  final String title;

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
    return ExpansionTile(
      childrenPadding: EdgeInsets.zero,
      tilePadding: EdgeInsets.zero,
      title: Text(
        widget.title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      children: [
        ReorderableList(
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
                      return Item(
                        data: _items[index],
                        isFirst: index == 0,
                        isLast: index == _items.length - 1,
                        deleteItem: () {
                          setState(() {
                            _items.removeAt(index);
                          });
                        },
                      );
                    },
                    childCount: _items.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Item extends StatelessWidget {
  Item({this.data, this.isFirst, this.isLast, this.deleteItem});

  final ItemData data;
  final bool isFirst;
  final bool isLast;
  final Function deleteItem;

  Widget _buildChild(BuildContext context, ReorderableItemState state) {
    BoxDecoration decoration;

    if (state == ReorderableItemState.dragProxy ||
        state == ReorderableItemState.dragProxyFinished) {
      // slightly transparent background white dragging (just like on iOS)
      decoration = BoxDecoration(color: Color(0xD0FFFFFF));
    } else {
      bool placeholder = state == ReorderableItemState.placeholder;
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
    Widget dragHandle = ReorderableListener(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 7),
        color: Color(0x08000000),
        child: Center(
          child: Icon(Icons.reorder, color: Colors.grey),
        ),
      ),
    );

    Widget delete = Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 7),
      color: Color(0x08000000),
      child: Center(
        child: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: deleteItem,
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
            opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
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
                        maxLines: 10000,
                        minLines: 1,
                        initialValue: data.title,
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
    return ReorderableItem(
        key: data.key, //
        childBuilder: _buildChild);
  }
}
