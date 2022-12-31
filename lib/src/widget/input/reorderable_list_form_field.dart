import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart' as RL;
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe.dart';

class ReorderableListFormField extends StatefulWidget {
  final String title;
  final List<String> items;
  final RecipeState state;
  final Function(List<String> value) onSave;

  const ReorderableListFormField({
    super.key,
    required this.title,
    required this.items,
    required this.state,
    required this.onSave,
  });

  @override
  _ReorderableListFormFieldState createState() =>
      _ReorderableListFormFieldState();
}

class ItemData {
  ItemData(this.text, this.key);

  String text;

  // Each item in reorderable list needs stable and unique key
  final Key key;
}

class _ReorderableListFormFieldState extends State<ReorderableListFormField> {
  final List<ItemData> _items = [];

  _ReorderableListFormFieldState();

  int _indexOfKey(Key key) {
    return _items.indexWhere((ItemData d) => d.key == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    final int draggingIndex = _indexOfKey(item);
    final int newPositionIndex = _indexOfKey(newPosition);

    final draggedItem = _items[draggingIndex];
    setState(() {
      _items.removeAt(draggingIndex);
      _items.insert(newPositionIndex, draggedItem);
    });
    return true;
  }

  @override
  void initState() {
    for (int i = 0; i < widget.items.length; ++i) {
      _items.add(ItemData(widget.items[i], ValueKey(i)));
    }
    super.initState();
  }

  //
  // Reordering works by having ReorderableList widget in hierarchy
  // containing ReorderableItems widgets
  //

  @override
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(
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
              onReorder: _reorderCallback,
              child: CustomScrollView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                slivers: <Widget>[
                  SliverPadding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom,),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          if (index == _items.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).hintColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  enableFeedback:
                                      widget.state is! RecipeUpdateInProgress,
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      if (widget.state
                                          is! RecipeUpdateInProgress) {
                                        _items.add(ItemData(
                                            "", ValueKey(_items.length),),);
                                      }
                                    });
                                  },
                                ),
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
                              // Mass import with newline separated list
                              if (value.contains("\n")) {
                                final newItems = List.of(value.split("\n"));
                                _items[index].text = newItems[0];

                                final newItemData = List.of(
                                        newItems.getRange(1, newItems.length),)
                                    .asMap()
                                    .entries
                                    .map((e) => ItemData(e.value,
                                        ValueKey(_items.length + e.key),),);
                                setState(() {
                                  _items.insertAll(index + 1, newItemData);
                                });
                              } else {
                                _items[index].text = value;
                              }
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
  const Item({
    super.key,
    required this.data,
    required this.isFirst,
    required this.isLast,
    required this.deleteItem,
    required this.state,
    required this.onChange,
  });

  final ItemData data;
  final bool isFirst;
  final bool isLast;
  final Function deleteItem;
  final Function(String value) onChange;
  final RecipeState state;

  @override
  State<StatefulWidget> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  _ItemState();

  Widget _buildChild(BuildContext context, RL.ReorderableItemState state) {
    BoxDecoration decoration;

    switch (state) {
      case RL.ReorderableItemState.dragProxy:
      case RL.ReorderableItemState.dragProxyFinished:
        // slightly transparent background white dragging (just like on iOS)
        decoration = BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),);
        break;
      default:
        final bool placeholder = state == RL.ReorderableItemState.placeholder;
        decoration = BoxDecoration(
          border: Border(
            top: widget.isFirst && !placeholder
                ? Divider.createBorderSide(context) //
                : BorderSide.none,
            bottom: widget.isLast && placeholder
                ? BorderSide.none //
                : Divider.createBorderSide(context),
          ),
          color: placeholder ? null : Theme.of(context).scaffoldBackgroundColor,
        );
    }

    // For iOS dragging mode, there will be drag handle on the right that triggers
    // reordering; For android mode it will be just an empty container
    final Widget dragHandle = RL.ReorderableListener(
      canStart: () => widget.state is! RecipeUpdateInProgress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        color: const Color(0x08000000),
        child: const Center(
          child: Icon(Icons.reorder),
        ),
      ),
    );

    final Widget delete = Container(
      color: const Color(0x08000000),
      child: Center(
        child: IconButton(
          enableFeedback: widget.state is! RecipeUpdateInProgress,
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            if (widget.state is! RecipeUpdateInProgress) {
              widget.deleteItem();
            }
          },
        ),
      ),
    );

    final Widget content = Container(
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
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 10.0,
                      ),
                      child: TextFormField(
                        enabled: widget.state is! RecipeUpdateInProgress,
                        maxLines: 10000,
                        minLines: 1,
                        initialValue: widget.data.text,
                        onChanged: widget.onChange,
                        autofocus: widget.data.text.isEmpty,
                      ),
                    ),
                  ),
                  // Triggers the reordering
                  dragHandle,
                  delete,
                ],
              ),
            ),
          ),),
    );

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return RL.ReorderableItem(
        key: widget.data.key, //
        childBuilder: _buildChild,);
  }
}
