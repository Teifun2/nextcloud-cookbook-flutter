import 'package:flutter/material.dart';

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField({
    super.key,
    Widget? title,
    super.onSaved,
    super.validator,
    bool super.initialValue = false,
    AutovalidateMode autoValidateMode = AutovalidateMode.disabled,
  }) : super(
          autovalidateMode: autoValidateMode,
          builder: (state) => CheckboxListTile(
            dense: state.hasError,
            title: title,
            value: state.value,
            onChanged: state.didChange,
            subtitle: state.hasError
                ? Builder(
                    builder: (context) => Text(
                      state.errorText!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  )
                : null,
            controlAffinity: ListTileControlAffinity.leading,
          ),
        );
}
