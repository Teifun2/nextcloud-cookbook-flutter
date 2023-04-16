import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ReordarableListFormField extends FormField<ListBuilder<String>> {
  ReordarableListFormField({
    super.key,
    required String title,
    ListBuilder<String>? initialValues,
    super.onSaved,
    super.validator,
    super.enabled,
    AutovalidateMode? autovalidateMode,
    InputDecoration decoration = const InputDecoration(),
    super.restorationId,
  }) : super(
          initialValue: initialValues,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          builder: (FormFieldState<ListBuilder<String>> state) {
            return UnmanagedRestorationScope(
              bucket: state.bucket,
              child: ReordarableListField(
                title: title,
                items: initialValues?.build().toList(),
                enabled: enabled,
                decoration: decoration,
              ),
            );
          },
        );
}

class ReordarableListField extends StatefulWidget {
  final String title;
  final List<String>? items;
  final bool enabled;
  final InputDecoration decoration;

  const ReordarableListField({
    super.key,
    required this.title,
    this.items,
    this.enabled = true,
    this.decoration = const InputDecoration(),
  });

  @override
  _ReordarableListFieldState createState() => _ReordarableListFieldState();
}

class _ReordarableListFieldState extends State<ReordarableListField> {
  late List<TextEditingController> _items;
  final focusNode = FocusNode(
    debugLabel: 'ReorderableListAddButton',
    skipTraversal: true,
  );

  @override
  void initState() {
    super.initState();

    _items = List.generate(
      widget.items?.length ?? 0,
      (index) => TextEditingController(text: widget.items![index]),
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void _reorderCallback(int oldIndex, int newIndex) {
    setState(() {
      final index = (newIndex >= _items.length) ? _items.length - 1 : newIndex;

      final item = _items.removeAt(oldIndex);
      _items.insert(index, item);
    });
  }

  Widget _buildItem(BuildContext context, int index) {
    return Item(
      key: UniqueKey(),
      controller: _items[index],
      index: index,
      focus: index == _items.length - 1,
      onDismissed: () {
        setState(() => _items.removeAt(index));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final title = Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        widget.title,
        style: theme.textTheme.titleMedium!.copyWith(
          color: theme.colorScheme.secondary,
        ),
      ),
    );

    final items = SliverPadding(
      padding: const EdgeInsets.only(top: 8.0),
      sliver: SliverReorderableList(
        onReorder: _reorderCallback,
        itemCount: _items.length,
        itemBuilder: _buildItem,
        prototypeItem: const Item.prototype(),
      ),
    );

    final addButton = OutlinedButton.icon(
      focusNode: focusNode,
      icon: const Icon(Icons.add_outlined),
      label: Text(
        translate("recipe_create.add_field"),
      ),
      onPressed: () {
        if (widget.enabled) {
          setState(() => _items.add(TextEditingController()));
        }
      },
    );

    return MultiSliver(
      children: [
        title,
        items,
        addButton,
      ],
    );
  }
}

class Item extends StatefulWidget {
  const Item({
    super.key,
    required VoidCallback this.onDismissed,
    required TextEditingController this.controller,
    required this.index,
    this.focus = false,
  });

  const Item.prototype()
      : onDismissed = null,
        controller = null,
        index = 0,
        focus = false;

  final VoidCallback? onDismissed;
  final TextEditingController? controller;
  final int index;
  final bool focus;

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  final focusNode = FocusNode(
    debugLabel: 'ReorderableListItemDeleteButton',
    skipTraversal: true,
  );

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textField = TextField(
      controller: widget.controller,
      maxLines: 10000,
      minLines: 1,
      autofocus: widget.focus,
      textInputAction: TextInputAction.next,
    );

    final dragHandle = ReorderableDragStartListener(
      index: widget.index,
      child: const Icon(Icons.reorder_outlined),
    );

    final deleteButton = IconButton(
      tooltip: translate("recipe_create.remove_field"),
      icon: Icon(
        Icons.delete,
        color: Theme.of(context).colorScheme.error,
      ),
      focusNode: focusNode,
      onPressed: widget.onDismissed,
    );

    return Material(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: textField,
            ),
          ),
          dragHandle,
          deleteButton,
        ],
      ),
    );
  }
}
