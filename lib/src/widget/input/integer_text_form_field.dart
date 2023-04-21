import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class IntegerTextFormField extends StatelessWidget {
  IntegerTextFormField({
    super.key,
    int? initialValue,
    this.enabled,
    this.decoration,
    this.onSaved,
    this.onChanged,
    this.textInputAction,
    this.minValue,
    this.maxValue,
    this.textAlign = TextAlign.end,
  })  : assert(initialValue != null || minValue != null),
        initialValue = initialValue ?? minValue!,
        assert(minValue == null || initialValue! >= minValue),
        assert((minValue == null || maxValue == null) || minValue <= maxValue);
  final int initialValue;
  final bool? enabled;
  final InputDecoration? decoration;
  final ValueChanged<int>? onSaved;
  final ValueChanged<int>? onChanged;
  final TextInputAction? textInputAction;
  final int? minValue;
  final int? maxValue;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) => TextFormField(
        enabled: enabled,
        initialValue: initialValue.toString(),
        decoration: decoration,
        textAlign: textAlign,
        keyboardType: TextInputType.number,
        textInputAction: textInputAction,
        onSaved: (newValue) {
          if (newValue == null) {
            return;
          }

          onSaved?.call(int.parse(newValue));
        },
        onChanged: (value) {
          final int$ = int.tryParse(value);
          if (int$ != null) {
            onChanged?.call(int$);
          }
        },
        validator: (value) {
          if (value == null || !ensureMinMax(int.tryParse(value))) {
            return translate('form.validators.invalid_number');
          }

          return null;
        },
      );

  bool ensureMinMax(int? value) {
    if (value == null) {
      return false;
    }

    if (minValue != null && value < minValue!) {
      return false;
    }
    if (maxValue != null && value > maxValue!) {
      return false;
    }

    return true;
  }
}
