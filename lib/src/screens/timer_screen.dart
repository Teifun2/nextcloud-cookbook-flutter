import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/models/timer.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe/recipe_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/services/services.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/animated_time_progress_bar.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/recipe_image.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  _TimerScreen createState() => _TimerScreen();
}

class _TimerScreen extends State<TimerScreen> {
  late List<Timer> _list;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _list = TimerList().timers;

    return Scaffold(
      appBar: AppBar(
        title: Text(translate('timer.title')),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(
              Icons.clear_all,
              semanticLabel: translate('app_bar.clear_all'),
            ),
            onPressed: () {
              TimerList().clear();
              setState(() {});
            },
          ),
        ],
      ),
      body: () {
        return _buildTimerScreen(_list);
      }(),
    );
  }

  Widget _buildTimerScreen(List<Timer> data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _buildListItem(data[index]);
        },
        separatorBuilder: (context, index) => const Divider(
          color: Colors.black,
        ),
      ),
    );
  }

  ListTile _buildListItem(Timer timer) {
    return ListTile(
      key: UniqueKey(),
      leading: RecipeImage(
        id: timer.recipeId,
        size: const Size.square(60),
      ),
      title: Text(timer.title),
      subtitle: AnimatedTimeProgressBar(
        timer: timer,
      ),
      isThreeLine: true,
      trailing: IconButton(
        icon: const Icon(Icons.cancel),
        onPressed: () {
          TimerList().remove(timer);
          setState(() {});
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeScreen(recipeId: timer.recipeId),
          ),
        );
      },
    );
  }
}
