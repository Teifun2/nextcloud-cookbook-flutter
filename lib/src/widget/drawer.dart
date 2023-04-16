import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/authentication/authentication_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/my_settings_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe_import_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/timer_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/user_image.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const UserImage(),
          ),
          ListTile(
            trailing: Icon(
              Icons.alarm_add_outlined,
              semanticLabel: translate('timer.title'),
            ),
            title: Text(translate('timer.title')),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TimerScreen(),
                ),
              );
            },
          ),
          ListTile(
            trailing: Icon(
              Icons.cloud_download_outlined,
              semanticLabel: translate('categories.drawer.import'),
            ),
            title: Text(translate('categories.drawer.import')),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RecipeImportScreen(),
                ),
              );
            },
          ),
          ListTile(
            trailing: Icon(
              Icons.settings_outlined,
              semanticLabel: translate('categories.drawer.settings'),
            ),
            title: Text(translate('categories.drawer.settings')),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MySettingsScreen(),
                ),
              );
            },
          ),
          ListTile(
            trailing: Icon(
              Icons.exit_to_app_outlined,
              semanticLabel: translate('app_bar.logout'),
            ),
            title: Text(translate('app_bar.logout')),
            onTap: () {
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(const LoggedOut());
            },
          ),
        ],
      ),
    );
  }
}
