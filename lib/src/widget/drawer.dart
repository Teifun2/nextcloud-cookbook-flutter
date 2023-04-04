import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/authentication/authentication_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/my_settings_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe_import_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/timer_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/drawer_item.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/user_image.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: const UserImage(),
          ),
          DrawerItem(
            icon: Icons.alarm_add_outlined,
            title: translate('timer.title'),
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
          DrawerItem(
            icon: Icons.cloud_download_outlined,
            title: translate('categories.drawer.import'),
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
          DrawerItem(
            icon: Icons.settings_outlined,
            title: translate('categories.drawer.settings'),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MySettingsScreen(),
                ),
              );
            },
          ),
          DrawerItem(
            icon: Icons.exit_to_app_outlined,
            title: translate('app_bar.logout'),
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
