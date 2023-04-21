import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/models/timer.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/animated_time_progress_bar.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/recipe_image.dart';

class TimerListItem extends StatelessWidget {
  const TimerListItem({
    required this.animation,
    required this.item,
    this.onDismissed,
    this.dense = false,
    this.enabled = true,
    super.key,
  });

  final Animation<double> animation;
  final VoidCallback? onDismissed;
  final Timer item;
  final bool dense;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final image = ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: RecipeImage(
        id: item.recipeId,
        size: const Size.square(80),
      ),
    );
    final progressBar = AnimatedTimeProgressBar(
      timer: item,
    );

    Future<void> onPressed() async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeScreen(recipeId: item.recipeId),
        ),
      );
    }

    return SizeTransition(
      sizeFactor: animation,
      child: ListTile(
        leading: dense ? null : image,
        title: dense ? progressBar : Text(item.title),
        subtitle: dense ? null : progressBar,
        trailing: IconButton(
          icon: const Icon(Icons.cancel_outlined),
          tooltip: translate('timer.button.cancel'),
          onPressed: enabled ? onDismissed : null,
        ),
        onTap: (enabled && !dense) ? onPressed : null,
      ),
    );
  }
}
