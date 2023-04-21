import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nextcloud_cookbook_flutter/src/services/services.dart';

class RecipeImage extends StatelessWidget {
  const RecipeImage({
    required this.size,
    required this.id,
    super.key,
  });
  final Size size;

  final String? id;

  @override
  Widget build(BuildContext context) {
    const boxFit = BoxFit.cover;
    final color = Colors.grey[400]!;

    return SizedBox.fromSize(
      size: size,
      child: FutureBuilder(
        // ignore: discarded_futures
        future: id != null ? DataRepository().fetchImage(id!, size) : null,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isSvg) {
              return ColoredBox(
                color: color,
                child: SvgPicture.memory(
                  snapshot.data!.data,
                  fit: boxFit,
                ),
              );
            } else {
              return Image.memory(
                snapshot.data!.data,
                fit: boxFit,
              );
            }
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return ColoredBox(
              color: color,
              child: SvgPicture.asset(
                'assets/icon.svg',
                fit: boxFit,
              ),
            );
          }

          return ColoredBox(
            color: color,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
