import 'package:flutter/material.dart';
import 'package:nextcloud_cookbook_flutter/src/models/timer.dart';
import 'package:nextcloud_cookbook_flutter/src/services/services.dart';

typedef RemovedItemBuilder<T> = Widget Function(
  T item,
  BuildContext context,
  Animation<double> animation,
);

abstract class AnimatedListModel<E> extends Iterable<E> {
  AnimatedListModel({
    required this.listKey,
    required this.removedItemBuilder,
    Iterable<E>? initialItems,
  }) : _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<SliverAnimatedListState> listKey;
  final RemovedItemBuilder<E> removedItemBuilder;
  final List<E> _items;

  SliverAnimatedListState get _animatedList => listKey.currentState!;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList.insertItem(index);
  }

  E removeAt(int index) {
    final removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
        index,
        (context, animation) =>
            removedItemBuilder(removedItem, context, animation),
      );
    }
    return removedItem;
  }

  Future<void> removeAll() async {
    while (_items.isNotEmpty) {
      removeAt(0);
    }
  }

  void add(E item) {
    insert(_items.length, item);
  }

  void insertAll(int index, Iterable<E> items) {
    for (var i = 0; i < items.length; i++) {
      insert(index + i, items.elementAt(i));
    }
  }

  @override
  bool get isNotEmpty => _items.isNotEmpty;

  @override
  int get length => _items.length;

  E operator [](int index) => _items[index];

  @override
  Iterator<E> get iterator => _items.iterator;
}

class AnimatedTimerList extends AnimatedListModel<Timer> {
  AnimatedTimerList({
    required super.listKey,
    required super.removedItemBuilder,
  }) : super(initialItems: TimerList().timers);

  AnimatedTimerList.forId({
    required String recipeId,
    required super.listKey,
    required super.removedItemBuilder,
  }) : super(
          initialItems: TimerList()
              .timers
              .where((element) => element.recipeId == recipeId),
        );

  @override
  Timer removeAt(int index) {
    TimerList().remove(_items[index]);
    return super.removeAt(index);
  }

  @override
  void insert(int index, Timer item) {
    TimerList().add(item);
    super.insert(index, item);
  }
}
