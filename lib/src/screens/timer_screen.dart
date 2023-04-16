import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/models/animated_list.dart';
import 'package:nextcloud_cookbook_flutter/src/models/timer.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/timer_list_item.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();
  late AnimatedTimerList _list;

  @override
  void initState() {
    super.initState();
    _list = AnimatedTimerList(
      listKey: _listKey,
      removedItemBuilder: _buildRemovedItem,
    );
  }

  Widget _buildItem(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    return TimerListItem(
      animation: animation,
      item: _list[index],
      onDismissed: () {
        _list.removeAt(index);
      },
    );
  }

  Widget _buildRemovedItem(
    Timer item,
    BuildContext context,
    Animation<double> animation,
  ) {
    return TimerListItem(
      animation: animation,
      item: item,
      enabled: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('timer.title')),
        actions: <Widget>[
          if (_list.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all_outlined),
              tooltip: translate('app_bar.clear_all'),
              onPressed: _list.removeAll,
            ),
        ],
      ),
      body: _list.isNotEmpty
          ? CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  sliver: SliverAnimatedList(
                    key: _listKey,
                    initialItemCount: _list.length,
                    itemBuilder: _buildItem,
                  ),
                ),
              ],
            )
          : Center(
              child: Text(translate('timer.empty_list')),
            ),
    );
  }
}
