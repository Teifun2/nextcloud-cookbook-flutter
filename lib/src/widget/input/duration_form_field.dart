import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/util/duration_utils.dart';

class DurationFormField extends StatefulWidget {
  final bool? enabled;
  final Duration? initialValue;
  final InputDecoration? decoration;
  final void Function(Duration? value)? onSaved;
  final TextAlign textAlign;
  final FocusNode? focusNode;

  const DurationFormField({
    super.key,
    this.enabled,
    this.initialValue,
    this.onSaved,
    this.decoration,
    this.focusNode,
    this.textAlign = TextAlign.end,
  });

  @override
  _DurationFormFieldState createState() => _DurationFormFieldState();
}

class _DurationFormFieldState extends State<DurationFormField> {
  final controller = TextEditingController();
  Duration? duration;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();

    setDuration(widget.initialValue);
    focusNode = widget.focusNode ?? FocusNode(debugLabel: 'DurationFormField');
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> onTap() => showDialog<Duration>(
        context: context,
        builder: (context) => DurationPickerDialog(
          initialTime: duration ?? Duration.zero,
          cancelText: translate('alert.clear'),
        ),
      ).then((selectedDuration) {
        setDuration(selectedDuration);
        focusNode.nextFocus();
      });

  void setDuration(Duration? duration) {
    if (duration != null && duration != Duration.zero) {
      controller.text = duration.translatedString;
      setState(() => this.duration = duration);
    } else if (duration == Duration.zero) {
      controller.clear();
      setState(() => this.duration = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      showCursor: false,
      enabled: widget.enabled,
      onTap: onTap,
      focusNode: focusNode,
      decoration: widget.decoration,
      textAlign: widget.textAlign,
      onSaved: (value) {
        if (value != null && value.isNotEmpty) {
          widget.onSaved?.call(duration);
        }
      },
    );
  }
}

const Duration _kDialogSizeAnimationDuration = Duration(milliseconds: 200);
const Duration _kVibrateCommitDelay = Duration(milliseconds: 100);

enum _DurationPickerMode { hour, minute }

const double _kDurationPickerHeaderControlHeight = 80.0;

const double _kDurationPickerWidthPortrait = 328.0;

const double _kDurationPickerHeightInput = 226.0;

const BorderRadius _kDefaultBorderRadius =
    BorderRadius.all(Radius.circular(4.0));
const ShapeBorder _kDefaultShape =
    RoundedRectangleBorder(borderRadius: _kDefaultBorderRadius);

/// A [RestorableValue] that knows how to save and restore [Duration].
///
/// {@macro flutter.widgets.RestorableNum}.
class RestorableDuration extends RestorableValue<Duration> {
  /// Creates a [RestorableDuration].
  ///
  /// {@macro flutter.widgets.RestorableNum.constructor}
  RestorableDuration(Duration defaultValue) : _defaultValue = defaultValue;

  final Duration _defaultValue;

  @override
  Duration createDefaultValue() => _defaultValue;

  @override
  void didUpdateValue(Duration? oldValue) {
    assert(debugIsSerializableForRestoration(value.inMinutes));
    notifyListeners();
  }

  @override
  Duration fromPrimitives(Object? data) {
    final List<Object?> timeData = data! as List<Object?>;
    return Duration(
      minutes: timeData[0]! as int,
      hours: value.inHours,
    );
  }

  @override
  Object? toPrimitives() => <int>[value.inMinutes.remainder(60), value.inHours];
}

/// A passive fragment showing a string value.
class _StringFragment extends StatelessWidget {
  const _StringFragment();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TimePickerThemeData durationPickerTheme = TimePickerTheme.of(context);
    final TextStyle hourMinuteStyle = durationPickerTheme.hourMinuteTextStyle ??
        theme.textTheme.displayMedium!;
    final Color textColor =
        durationPickerTheme.hourMinuteTextColor ?? theme.colorScheme.onSurface;

    return ExcludeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Center(
          child: Text(
            ":",
            style: hourMinuteStyle.apply(
              color: MaterialStateProperty.resolveAs(
                textColor,
                <MaterialState>{},
              ),
            ),
            textScaleFactor: 1.0,
          ),
        ),
      ),
    );
  }
}

class _DurationPickerInput extends StatefulWidget {
  const _DurationPickerInput({
    required this.initialSelectedTime,
    required this.helpText,
    required this.errorInvalidText,
    required this.hourLabelText,
    required this.minuteLabelText,
    required this.autofocusHour,
    required this.autofocusMinute,
    required this.onChanged,
    this.restorationId,
  });

  /// The time initially selected when the dialog is shown.
  final Duration initialSelectedTime;

  /// Optionally provide your own help text to the time picker.
  final String? helpText;

  /// Optionally provide your own validation error text.
  final String? errorInvalidText;

  /// Optionally provide your own hour label text.
  final String? hourLabelText;

  /// Optionally provide your own minute label text.
  final String? minuteLabelText;

  final bool? autofocusHour;

  final bool? autofocusMinute;

  final ValueChanged<Duration> onChanged;

  /// Restoration ID to save and restore the state of the time picker input
  /// widget.
  ///
  /// If it is non-null, the widget will persist and restore its state
  ///
  /// The state of this widget is persisted in a [RestorationBucket] claimed
  /// from the surrounding [RestorationScope] using the provided restoration ID.
  final String? restorationId;

  @override
  _DurationPickerInputState createState() => _DurationPickerInputState();
}

class _DurationPickerInputState extends State<_DurationPickerInput>
    with RestorationMixin {
  late final RestorableDuration _selectedTime =
      RestorableDuration(widget.initialSelectedTime);
  final RestorableBool hourHasError = RestorableBool(false);
  final RestorableBool minuteHasError = RestorableBool(false);

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedTime, 'selected_time');
    registerForRestoration(hourHasError, 'hour_has_error');
    registerForRestoration(minuteHasError, 'minute_has_error');
  }

  int? _parseHour(String? value) {
    if (value == null) {
      return null;
    }

    final int? newHour = int.tryParse(value);
    if (newHour == null) {
      return null;
    }

    if (newHour >= 0) {
      return newHour;
    }

    return null;
  }

  int? _parseMinute(String? value) {
    if (value == null) {
      return null;
    }

    final int? newMinute = int.tryParse(value);
    if (newMinute == null) {
      return null;
    }

    if (newMinute >= 0 && newMinute < 60) {
      return newMinute;
    }
    return null;
  }

  void _handleHourSavedSubmitted(String? value) {
    final int? newHour = _parseHour(value);
    if (newHour != null) {
      _selectedTime.value = Duration(
        hours: newHour,
        minutes: _selectedTime.value.inMinutes.remainder(60),
      );
      widget.onChanged(_selectedTime.value);
    }
  }

  void _handleHourChanged(String value) {
    final int? newHour = _parseHour(value);
    if (newHour != null && value.length == 2) {
      // If a valid hour is typed, move focus to the minute TextField.
      FocusScope.of(context).nextFocus();
    }
  }

  void _handleMinuteSavedSubmitted(String? value) {
    final int? newMinute = _parseMinute(value);
    if (newMinute != null) {
      _selectedTime.value = Duration(
        hours: _selectedTime.value.inHours,
        minutes: int.parse(value!),
      );
      widget.onChanged(_selectedTime.value);
    }
  }

  String? _validateHour(String? value) {
    final int? newHour = _parseHour(value);
    setState(() {
      hourHasError.value = newHour == null;
    });
    // This is used as the validator for the [TextFormField].
    // Returning an empty string allows the field to go into an error state.
    // Returning null means no error in the validation of the entered text.
    return newHour == null ? '' : null;
  }

  String? _validateMinute(String? value) {
    final int? newMinute = _parseMinute(value);
    setState(() {
      minuteHasError.value = newMinute == null;
    });
    // This is used as the validator for the [TextFormField].
    // Returning an empty string allows the field to go into an error state.
    // Returning null means no error in the validation of the entered text.
    return newMinute == null ? '' : null;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final ThemeData theme = Theme.of(context);
    final TextStyle hourMinuteStyle =
        TimePickerTheme.of(context).hourMinuteTextStyle ??
            theme.textTheme.displayMedium!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.helpText ??
                MaterialLocalizations.of(context).timePickerInputHelpText,
            style: TimePickerTheme.of(context).helpTextStyle ??
                theme.textTheme.labelSmall,
          ),
          const SizedBox(height: 16.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            // Hour/minutes should not change positions in RTL locales.
            textDirection: TextDirection.ltr,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 8.0),
                    _HourTextField(
                      restorationId: 'hour_text_field',
                      selectedTime: _selectedTime.value,
                      style: hourMinuteStyle,
                      autofocus: widget.autofocusHour,
                      validator: _validateHour,
                      onSavedSubmitted: _handleHourSavedSubmitted,
                      onChanged: _handleHourChanged,
                      hourLabelText: widget.hourLabelText,
                    ),
                    const SizedBox(height: 8.0),
                    if (!hourHasError.value && !minuteHasError.value)
                      ExcludeSemantics(
                        child: Text(
                          widget.hourLabelText ??
                              MaterialLocalizations.of(context)
                                  .timePickerHourLabel,
                          style: theme.textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8.0),
                height: _kDurationPickerHeaderControlHeight,
                child: const _StringFragment(),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 8.0),
                    _MinuteTextField(
                      restorationId: 'minute_text_field',
                      selectedTime: _selectedTime.value,
                      style: hourMinuteStyle,
                      autofocus: widget.autofocusMinute,
                      validator: _validateMinute,
                      onSavedSubmitted: _handleMinuteSavedSubmitted,
                      minuteLabelText: widget.minuteLabelText,
                    ),
                    const SizedBox(height: 8.0),
                    if (!hourHasError.value && !minuteHasError.value)
                      ExcludeSemantics(
                        child: Text(
                          widget.minuteLabelText ??
                              MaterialLocalizations.of(context)
                                  .timePickerMinuteLabel,
                          style: theme.textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (hourHasError.value || minuteHasError.value)
            Text(
              widget.errorInvalidText ??
                  MaterialLocalizations.of(context).invalidTimeLabel,
              style: theme.textTheme.bodyMedium!
                  .copyWith(color: theme.colorScheme.error),
            )
          else
            const SizedBox(height: 2.0),
        ],
      ),
    );
  }
}

class _HourTextField extends StatelessWidget {
  const _HourTextField({
    required this.selectedTime,
    required this.style,
    required this.autofocus,
    required this.validator,
    required this.onSavedSubmitted,
    required this.onChanged,
    required this.hourLabelText,
    this.restorationId,
  });

  final Duration selectedTime;
  final TextStyle style;
  final bool? autofocus;
  final FormFieldValidator<String> validator;
  final ValueChanged<String?> onSavedSubmitted;
  final ValueChanged<String> onChanged;
  final String? hourLabelText;
  final String? restorationId;

  @override
  Widget build(BuildContext context) {
    return _HourMinuteTextField(
      restorationId: restorationId,
      selectedTime: selectedTime,
      isHour: true,
      autofocus: autofocus,
      style: style,
      semanticHintText: hourLabelText ??
          MaterialLocalizations.of(context).timePickerHourLabel,
      validator: validator,
      onSavedSubmitted: onSavedSubmitted,
      onChanged: onChanged,
    );
  }
}

class _MinuteTextField extends StatelessWidget {
  const _MinuteTextField({
    required this.selectedTime,
    required this.style,
    required this.autofocus,
    required this.validator,
    required this.onSavedSubmitted,
    required this.minuteLabelText,
    this.restorationId,
  });

  final Duration selectedTime;
  final TextStyle style;
  final bool? autofocus;
  final FormFieldValidator<String> validator;
  final ValueChanged<String?> onSavedSubmitted;
  final String? minuteLabelText;
  final String? restorationId;

  @override
  Widget build(BuildContext context) {
    return _HourMinuteTextField(
      restorationId: restorationId,
      selectedTime: selectedTime,
      isHour: false,
      autofocus: autofocus,
      style: style,
      semanticHintText: minuteLabelText ??
          MaterialLocalizations.of(context).timePickerMinuteLabel,
      validator: validator,
      onSavedSubmitted: onSavedSubmitted,
    );
  }
}

class _HourMinuteTextField extends StatefulWidget {
  const _HourMinuteTextField({
    required this.selectedTime,
    required this.isHour,
    required this.autofocus,
    required this.style,
    required this.semanticHintText,
    required this.validator,
    required this.onSavedSubmitted,
    this.restorationId,
    this.onChanged,
  });

  final Duration selectedTime;
  final bool isHour;
  final bool? autofocus;
  final TextStyle style;
  final String semanticHintText;
  final FormFieldValidator<String> validator;
  final ValueChanged<String?> onSavedSubmitted;
  final ValueChanged<String>? onChanged;
  final String? restorationId;

  @override
  _HourMinuteTextFieldState createState() => _HourMinuteTextFieldState();
}

class _HourMinuteTextFieldState extends State<_HourMinuteTextField>
    with RestorationMixin {
  final RestorableTextEditingController controller =
      RestorableTextEditingController();
  final RestorableBool controllerHasBeenSet = RestorableBool(false);
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode()
      ..addListener(() {
        setState(() {}); // Rebuild.
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only set the text value if it has not been populated with a localized
    // version yet.
    if (!controllerHasBeenSet.value) {
      controllerHasBeenSet.value = true;
      controller.value.text = _formattedValue;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(controller, 'text_editing_controller');
    registerForRestoration(controllerHasBeenSet, 'has_controller_been_set');
  }

  String get _formattedValue {
    return !widget.isHour
        ? widget.selectedTime.inMinutes.remainder(60).toString().padLeft(2, '0')
        : widget.selectedTime.inHours.remainder(60).toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TimePickerThemeData durationPickerTheme = TimePickerTheme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final InputDecorationTheme? inputDecorationTheme =
        durationPickerTheme.inputDecorationTheme;
    InputDecoration inputDecoration;
    if (inputDecorationTheme != null) {
      inputDecoration =
          const InputDecoration().applyDefaults(inputDecorationTheme);
    } else {
      inputDecoration = InputDecoration(
        contentPadding: EdgeInsets.zero,
        filled: true,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.error, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.error, width: 2.0),
        ),
        hintStyle: widget.style
            .copyWith(color: colorScheme.onSurface.withOpacity(0.36)),
        // TODO(rami-a): Remove this logic once https://github.com/flutter/flutter/issues/54104 is fixed.
        errorStyle: const TextStyle(
          fontSize: 0.0,
          height: 0.0,
        ), // Prevent the error text from appearing.
      );
    }
    final Color unfocusedFillColor = durationPickerTheme.hourMinuteColor ??
        colorScheme.onSurface.withOpacity(0.12);
    // If screen reader is in use, make the hint text say hours/minutes.
    // Otherwise, remove the hint text when focused because the centered cursor
    // appears odd above the hint text.
    //
    // TODO(rami-a): Once https://github.com/flutter/flutter/issues/67571 is
    // resolved, remove the window check for semantics being enabled on web.
    final String? hintText = MediaQuery.of(context).accessibleNavigation ||
            WidgetsBinding.instance.window.semanticsEnabled
        ? widget.semanticHintText
        : (focusNode.hasFocus ? null : _formattedValue);
    inputDecoration = inputDecoration.copyWith(
      hintText: hintText,
      fillColor: focusNode.hasFocus
          ? Colors.transparent
          : inputDecorationTheme?.fillColor ?? unfocusedFillColor,
    );

    return SizedBox(
      height: _kDurationPickerHeaderControlHeight,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: UnmanagedRestorationScope(
          bucket: bucket,
          child: TextFormField(
            restorationId: 'hour_minute_text_form_field',
            autofocus: widget.autofocus ?? false,
            expands: true,
            maxLines: null,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(2),
            ],
            focusNode: focusNode,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: widget.style.copyWith(
              color: durationPickerTheme.hourMinuteTextColor ??
                  colorScheme.onSurface,
            ),
            controller: controller.value,
            decoration: inputDecoration,
            validator: widget.validator,
            onEditingComplete: () =>
                widget.onSavedSubmitted(controller.value.text),
            onSaved: widget.onSavedSubmitted,
            onFieldSubmitted: widget.onSavedSubmitted,
            onChanged: widget.onChanged,
          ),
        ),
      ),
    );
  }
}

/// A Material Design time picker designed to appear inside a popup dialog.
///
/// Pass this widget to [showDialog]. The value returned by [showDialog] is the
/// selected [Duration] if the user taps the "OK" button, or null if the user
/// taps the "CANCEL" button. The selected time is reported by calling
/// [Navigator.pop].
class DurationPickerDialog extends StatefulWidget {
  /// Creates a Material Design time picker.
  ///
  /// [initialTime] must not be null.
  const DurationPickerDialog({
    super.key,
    this.initialTime = Duration.zero,
    this.cancelText,
    this.confirmText,
    this.helpText,
    this.errorInvalidText,
    this.hourLabelText,
    this.minuteLabelText,
    this.restorationId,
  });

  /// The time initially selected when the dialog is shown.
  final Duration initialTime;

  /// Optionally provide your own text for the cancel button.
  ///
  /// If null, the button uses [MaterialLocalizations.cancelButtonLabel].
  final String? cancelText;

  /// Optionally provide your own text for the confirm button.
  ///
  /// If null, the button uses [MaterialLocalizations.okButtonLabel].
  final String? confirmText;

  /// Optionally provide your own help text to the header of the time picker.
  final String? helpText;

  /// Optionally provide your own validation error text.
  final String? errorInvalidText;

  /// Optionally provide your own hour label text.
  final String? hourLabelText;

  /// Optionally provide your own minute label text.
  final String? minuteLabelText;

  /// Restoration ID to save and restore the state of the [DurationPickerDialog].
  ///
  /// If it is non-null, the time picker will persist and restore the
  /// dialog's state.
  ///
  /// The state of this widget is persisted in a [RestorationBucket] claimed
  /// from the surrounding [RestorationScope] using the provided restoration ID.
  ///
  /// See also:
  ///
  ///  * [RestorationManager], which explains how state restoration works in
  ///    Flutter.
  final String? restorationId;

  @override
  State<DurationPickerDialog> createState() => _DurationPickerDialogState();
}

// A restorable [_RestorableDurationPickerEntryMode] value.
//
// This serializes each entry as a unique `int` value.
class _RestorableDurationPickerMode
    extends RestorableValue<_DurationPickerMode> {
  _RestorableDurationPickerMode(
    _DurationPickerMode defaultValue,
  ) : _defaultValue = defaultValue;

  final _DurationPickerMode _defaultValue;

  @override
  _DurationPickerMode createDefaultValue() => _defaultValue;

  @override
  void didUpdateValue(_DurationPickerMode? oldValue) {
    assert(debugIsSerializableForRestoration(value.index));
    notifyListeners();
  }

  @override
  _DurationPickerMode fromPrimitives(Object? data) =>
      _DurationPickerMode.values[data! as int];

  @override
  Object? toPrimitives() => value.index;
}

// A restorable [AutovalidateMode] value.
//
// This serializes each entry as a unique `int` value.
class _RestorableAutovalidateMode extends RestorableValue<AutovalidateMode> {
  _RestorableAutovalidateMode(
    AutovalidateMode defaultValue,
  ) : _defaultValue = defaultValue;

  final AutovalidateMode _defaultValue;

  @override
  AutovalidateMode createDefaultValue() => _defaultValue;

  @override
  void didUpdateValue(AutovalidateMode? oldValue) {
    assert(debugIsSerializableForRestoration(value.index));
    notifyListeners();
  }

  @override
  AutovalidateMode fromPrimitives(Object? data) =>
      AutovalidateMode.values[data! as int];

  @override
  Object? toPrimitives() => value.index;
}

class _RestorableDurationPickerModeN
    extends RestorableValue<_DurationPickerMode?> {
  _RestorableDurationPickerModeN(
    _DurationPickerMode? defaultValue,
  ) : _defaultValue = defaultValue;

  final _DurationPickerMode? _defaultValue;

  @override
  _DurationPickerMode? createDefaultValue() => _defaultValue;

  @override
  void didUpdateValue(_DurationPickerMode? oldValue) {
    assert(debugIsSerializableForRestoration(value?.index));
    notifyListeners();
  }

  @override
  _DurationPickerMode fromPrimitives(Object? data) =>
      _DurationPickerMode.values[data! as int];

  @override
  Object? toPrimitives() => value?.index;
}

class _DurationPickerDialogState extends State<DurationPickerDialog>
    with RestorationMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _RestorableDurationPickerMode _mode =
      _RestorableDurationPickerMode(_DurationPickerMode.hour);
  final _RestorableDurationPickerModeN _lastModeAnnounced =
      _RestorableDurationPickerModeN(null);
  final _RestorableAutovalidateMode _autovalidateMode =
      _RestorableAutovalidateMode(AutovalidateMode.disabled);
  final RestorableBoolN _autofocusHour = RestorableBoolN(null);
  final RestorableBoolN _autofocusMinute = RestorableBoolN(null);
  final RestorableBool _announcedInitialTime = RestorableBool(false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = MaterialLocalizations.of(context);
    _announceInitialTimeOnce();
    _announceModeOnce();
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_mode, 'mode');
    registerForRestoration(_lastModeAnnounced, 'last_mode_announced');
    registerForRestoration(_autovalidateMode, 'autovalidateMode');
    registerForRestoration(_autofocusHour, 'autofocus_hour');
    registerForRestoration(_autofocusMinute, 'autofocus_minute');
    registerForRestoration(_announcedInitialTime, 'announced_initial_time');
    registerForRestoration(_selectedTime, 'selected_time');
  }

  RestorableDuration get selectedTime => _selectedTime;
  late final RestorableDuration _selectedTime =
      RestorableDuration(widget.initialTime);

  Timer? _vibrateTimer;
  late MaterialLocalizations localizations;

  void _vibrate() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        _vibrateTimer?.cancel();
        _vibrateTimer = Timer(_kVibrateCommitDelay, () {
          HapticFeedback.vibrate();
          _vibrateTimer = null;
        });
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        break;
    }
  }

  void _announceModeOnce() {
    if (_lastModeAnnounced.value == _mode.value) {
      // Already announced it.
      return;
    }

    switch (_mode.value) {
      case _DurationPickerMode.hour:
        _announceToAccessibility(
          context,
          localizations.timePickerHourModeAnnouncement,
        );
        break;
      case _DurationPickerMode.minute:
        _announceToAccessibility(
          context,
          localizations.timePickerMinuteModeAnnouncement,
        );
        break;
    }
    _lastModeAnnounced.value = _mode.value;
  }

  void _announceInitialTimeOnce() {
    if (_announcedInitialTime.value) {
      return;
    }

    _announceToAccessibility(
      context,
      widget.initialTime.formatMinutes(),
    );
    _announcedInitialTime.value = true;
  }

  void _handleTimeChanged(Duration value) {
    _vibrate();
    setState(() {
      _selectedTime.value = value;
    });
  }

  void _handleCancel() {
    Navigator.pop(context, Duration.zero);
  }

  void _handleOk() {
    final FormState form = _formKey.currentState!;
    if (!form.validate()) {
      setState(() {
        _autovalidateMode.value = AutovalidateMode.always;
      });
      return;
    }
    form.save();

    Navigator.pop(context, _selectedTime.value);
  }

  Size _dialogSize(BuildContext context) {
    // Constrain the textScaleFactor to prevent layout issues. Since only some
    // parts of the time picker scale up with textScaleFactor, we cap the factor
    // to 1.1 as that provides enough space to reasonably fit all the content.
    final double textScaleFactor =
        math.min(MediaQuery.of(context).textScaleFactor, 1.1);

    return Size(
      _kDurationPickerWidthPortrait,
      _kDurationPickerHeightInput * textScaleFactor,
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final ThemeData theme = Theme.of(context);
    final ShapeBorder shape =
        TimePickerTheme.of(context).shape ?? _kDefaultShape;

    final Widget actions = Row(
      children: <Widget>[
        const SizedBox(width: 10.0),
        Expanded(
          child: Container(
            alignment: AlignmentDirectional.centerEnd,
            constraints: const BoxConstraints(minHeight: 52.0),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: OverflowBar(
              spacing: 8,
              overflowAlignment: OverflowBarAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: _handleCancel,
                  child: Text(
                    widget.cancelText ?? localizations.cancelButtonLabel,
                  ),
                ),
                TextButton(
                  onPressed: _handleOk,
                  child:
                      Text(widget.confirmText ?? localizations.okButtonLabel),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    final Widget picker = Form(
      key: _formKey,
      autovalidateMode: _autovalidateMode.value,
      child: SingleChildScrollView(
        restorationId: 'time_picker_scroll_view',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _DurationPickerInput(
              initialSelectedTime: _selectedTime.value,
              helpText: widget.helpText,
              errorInvalidText: widget.errorInvalidText,
              hourLabelText: widget.hourLabelText,
              minuteLabelText: widget.minuteLabelText,
              autofocusHour: _autofocusHour.value,
              autofocusMinute: _autofocusMinute.value,
              onChanged: _handleTimeChanged,
              restorationId: 'time_picker_input',
            ),
            actions,
          ],
        ),
      ),
    );

    final Size dialogSize = _dialogSize(context);
    return Dialog(
      shape: shape,
      backgroundColor: TimePickerTheme.of(context).backgroundColor ??
          theme.colorScheme.surface,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: AnimatedContainer(
        width: dialogSize.width,
        height: dialogSize.height,
        duration: _kDialogSizeAnimationDuration,
        curve: Curves.easeIn,
        child: picker,
      ),
    );
  }

  @override
  void dispose() {
    _vibrateTimer?.cancel();
    _vibrateTimer = null;
    super.dispose();
  }
}

void _announceToAccessibility(BuildContext context, String message) {
  SemanticsService.announce(message, Directionality.of(context));
}
