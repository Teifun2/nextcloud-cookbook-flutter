import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    required this.title,
    this.icon,
    this.onTap,
    super.key,
  });

  final String title;
  final IconData? icon;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final leading = icon != null
        ? Icon(
            icon,
            semanticLabel: title,
          )
        : null;

    return SizedBox(
      height: 56,
      child: ListTile(
        style: ListTileStyle.drawer,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(28),
          ),
        ),
        splashColor: Theme.of(context).colorScheme.secondaryContainer,
        leading: leading,
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}
