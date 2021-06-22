import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/models/timer.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/authentication_cached_network_image.dart';


class TimerScreen extends StatefulWidget {
  @override
  _TimerScreen createState() => _TimerScreen();
}

class _TimerScreen extends State<TimerScreen> {
  List<Timer> _list;
  bool _running = true;

  @override
  void initState() {
   this._timer();
    super.initState();
  }
  void _timer() {
    Future.delayed(Duration(seconds: 60)).then((_) {
      if (_running) {
        setState(() {});
        this._timer();
      }
    });
  }

  @override
  void dispose() {
    //controller.dispose();
    _running = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this._list = TimerList().timers;

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
        body: (() {
          return _buildTimerScreen(this._list);
        }()),
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
        separatorBuilder: (context, index) => Divider(
          color: Colors.black,
        ),
      ),
    );
  }

  ListTile _buildListItem(Timer timer) {
    return ListTile(
      leading: AuthenticationCachedNetworkImage(
        recipeId: timer.recipeId,
        full: false,
        width: 60,
        height: 60,
      ),
      title: Text(timer.title),
      subtitle: timer.progress() > 0 ?
        Container(
          child: Column(
          children: [
            Row (
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(timer.remaining()),
                Text(timer.endingTime()),
              ]
            ),
            LinearProgressIndicator(
              value: timer.progress(),
              semanticsLabel: timer.title,
            ),
          ]),
        )
        : Container(
            child: Text("Done")
      ),
      isThreeLine: true,
      trailing: IconButton(
        icon: Icon(Icons.cancel),
        onPressed: () {
          timer.cancel();
          setState((){
          });
        }
      ),
    onTap: ()
        {
        /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  //RecipeScreen(recipeId: recipeShort.recipeId),
            )
        );*/
      },
    );
  }
}