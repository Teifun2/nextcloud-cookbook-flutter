import 'dart:math' as math;

import 'package:flutter/rendering.dart';

class CategoryGridDelegate extends SliverGridDelegate {
  const CategoryGridDelegate({
    this.extent = 0.0,
  });

  final double extent;

  static const double maxCrossAxisExtent = 250;
  static const double mainAxisSpacing = 8;
  static const double crossAxisSpacing = 8;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    int crossAxisCount =
        (constraints.crossAxisExtent / (maxCrossAxisExtent + crossAxisSpacing))
            .ceil();
    // Ensure a minimum count of 1, can be zero and result in an infinite extent
    // below when the window size is 0.
    crossAxisCount = math.max(1, crossAxisCount);
    final double usableCrossAxisExtent = math.max(
      0.0,
      constraints.crossAxisExtent - crossAxisSpacing * (crossAxisCount - 1),
    );
    final double childCrossAxisExtent = usableCrossAxisExtent / crossAxisCount;
    final double childMainAxisExtent = childCrossAxisExtent + extent;

    return SliverGridRegularTileLayout(
      crossAxisCount: crossAxisCount,
      mainAxisStride: childMainAxisExtent + mainAxisSpacing,
      crossAxisStride: childCrossAxisExtent + crossAxisSpacing,
      childMainAxisExtent: childMainAxisExtent,
      childCrossAxisExtent: childCrossAxisExtent,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(CategoryGridDelegate oldDelegate) {
    return oldDelegate.extent != extent;
  }
}
