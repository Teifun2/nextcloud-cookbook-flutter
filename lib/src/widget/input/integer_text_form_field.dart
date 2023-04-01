import 'package:flutter/material.dart';

class IntegerTextFormField extends StatefulWidget {
  final int initialValue;
  final bool? enabled;
  final InputDecoration? decoration;
  final void Function(int value)? onChanged;
  final void Function(int value)? onSaved;
  final int? minValue;
  final int? maxValue;

  const IntegerTextFormField({
    super.key,
    int? initialValue,
    this.enabled,
    this.decoration,
    this.onChanged,
    this.onSaved,
    this.minValue,
    this.maxValue,
  })  : initialValue = initialValue ?? 0,
        assert((minValue == null || maxValue == null) || minValue <= maxValue);

  @override
  State<StatefulWidget> createState() => _IntegerTextFormFieldState();
}

class _IntegerTextFormFieldState extends State<IntegerTextFormField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    final int curVal = _ensureMinMax(widget.initialValue);
    controller = TextEditingController(text: curVal.toString());

    controller.addListener(_updateController);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      controller: controller,
      decoration: widget.decoration,
      keyboardType: TextInputType.number,
    );
  }

  void _updateController() {
    final String value = controller.text;
    if (value.isEmpty) {
      widget.onChanged?.call(_ensureMinMax(0));
    } else {
      final parsedValue = _ensureMinMax(_parseValue(value));
      if (controller.text != parsedValue.toString()) {
        controller.value = TextEditingValue(
          text: parsedValue.toString(),
          selection: TextSelection.fromPosition(
            TextPosition(offset: parsedValue.toString().length),
          ),
        );
      }
      widget.onChanged?.call(parsedValue);
    }
  }

  int _ensureMinMax(int value) {
    final min = widget.minValue;
    final max = widget.maxValue;

    if (min != null && value < min) return min;
    if (max != null && value > max) return max;
    return value;
  }

  int _parseValue(String input) {
    final regexMatches = RegExp(r'(\d+)').allMatches(input);
    if (regexMatches.isEmpty) {
      return 0;
    } else {
      return int.parse(regexMatches.elementAt(0).group(0)!);
    }
  }
}
