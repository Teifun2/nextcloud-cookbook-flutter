import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/authentication/authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/categories/categories.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipes_short/recipes_short.dart';
import 'package:nextcloud_cookbook_flutter/src/models/category.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe_short.dart';
import 'package:nextcloud_cookbook_flutter/src/models/timer.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe_create_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe_import_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipes_list_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/api_version_warning.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/authentication_cached_network_image.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/category_card.dart';
import 'package:search_page/search_page.dart';

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreen createState() => _TimerScreen();
}

class _TimerScreen extends State<TimerScreen> {
  @override
  Widget build(BuildContext context) {

    /*BlocProvider.of<RecipesShortBloc>(context)
        .add(RecipesShortLoaded(category: "All"));

    return BlocBuilder<RecipesShortBloc, RecipesShortState>(
        builder: (context, recipesShortState) {
          if (recipesShortState is RecipesShortLoadSuccess) {
            return TimerListView();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });

     */
    return TimerListView();
  }
}

class TimerListView extends StatefulWidget {
  @override
  _TimerListView createState() => _TimerListView();
}

class _TimerListView extends State<TimerListView> {
  List<Timer> _list;
  bool _running = true;

  @override
  void initState() {
   this._timer();
    super.initState();
  }
  void _timer() {
    if (_running)
      Future.delayed(Duration(seconds: 60)).then((_) {
        setState(() {

        });
        this._timer();
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
          // TODO translate
          title: Text("Timer"),
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(
                Icons.clear_all,
                // TODO
                semanticLabel: translate('app_bar.refresh'),
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
      subtitle: timer.completed() > 0 ?
        Container(
          child: Column(
          children: [
            Row (
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(timer.remaining() + " h"),
                Text(timer.done.hour.toString() + ":" + timer.done.minute.toString().padLeft(2, "0")),
              ]
            ),
            LinearProgressIndicator(
              value: timer.completed(),
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