part of '../recipe_screen.dart';

class ToolList extends StatelessWidget {
  const ToolList({
    required this.recipe,
  });

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(translate('recipe.fields.tools')),
      children: <Widget>[
        for (final tool in recipe.tool)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "- ${tool.trim()}",
              ),
            ),
          ),
      ],
    );
  }
}
