part of '../recipe_screen.dart';

class RoundedBoxItem extends StatelessWidget {
  const RoundedBoxItem({
    required this.name,
    required this.value,
    this.height,
    this.padding,
    super.key,
  });
  final String name;
  final String value;
  final double? height;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(10);
    final theme = Theme.of(context);

    return IntrinsicWidth(
      child: Column(
        children: <Widget>[
          Container(
            height: height,
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: radius),
              border: Border.all(color: theme.hintColor),
              color: theme.colorScheme.primary.withOpacity(0.2),
            ),
            child: Center(
              child: Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            height: height,
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(bottom: radius),
              border: Border.all(
                color: theme.hintColor.withOpacity(0.6),
              ),
            ),
            child: Center(
              child: Text(value),
            ),
          ),
        ],
      ),
    );
  }
}
