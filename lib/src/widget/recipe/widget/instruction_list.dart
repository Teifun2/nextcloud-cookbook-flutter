part of '../recipe_screen.dart';

class InstructionList extends StatelessWidget {
  final Recipe recipe;
  final TextStyle textStyle;

  const InstructionList(
    this.recipe,
    this.textStyle,
  );

  @override
  Widget build(BuildContext context) {
    final instructions = recipe.recipeInstructions;
    return ExpansionTile(
      title: Text(translate('recipe.fields.instructions')),
      initiallyExpanded: true,
      children: <Widget>[
        for (int i = 0; i < instructions.length; i++)
          _InstructionListTitem(instructions[i], i, textStyle)
      ],
    );
  }
}

class _InstructionListTitem extends StatefulWidget {
  final String instruction;
  final int index;
  final TextStyle textStyle;

  const _InstructionListTitem(this.instruction, this.index, this.textStyle);

  @override
  State<_InstructionListTitem> createState() => _InstructionListTitemState();
}

class _InstructionListTitemState extends State<_InstructionListTitem> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 5),
      child: GestureDetector(
        onTap: () => setState(() {
          selected = !selected;
        }),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 15, top: 2.5),
              decoration: ShapeDecoration(
                shape: const CircleBorder(
                  side: BorderSide(color: Colors.grey),
                ),
                color: selected
                    ? Colors.green
                    : Theme.of(context).colorScheme.background,
              ),
              child: selected
                  ? const Icon(Icons.check_outlined)
                  : Center(child: Text((widget.index + 1).toString())),
            ),
            Expanded(
              child: Text(
                widget.instruction,
                style: widget.textStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
