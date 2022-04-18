import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/input/integer_text_form_field.dart';

class DurationFormField extends StatefulWidget {
  final String title;
  final RecipeState state;
  final Duration duration;
  final void Function(Duration value) onChanged;

  const DurationFormField(
      {Key key,
      @required this.state,
      @required this.duration,
      @required this.onChanged,
      @required this.title})
      : super(key: key);

  @override
  _DurationFormFieldState createState() => _DurationFormFieldState();
}

class _DurationFormFieldState extends State<DurationFormField> {
  Duration currentDuration;

  @override
  void initState() {
    super.initState();
    if (currentDuration == null) {
      currentDuration = widget.duration;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Text(translate('recipe.fields.time.hours')),
            ),
            Container(
              width: 70,
              child: IntegerTextFormField(
                enabled: !(widget.state is RecipeUpdateInProgress),
                initialValue:
                    widget.duration != null ? widget.duration.inHours : 0,
                decoration: InputDecoration(
                    hintText: translate('recipe.fields.time.hours')),
                onChanged: (value) {
                  currentDuration = _updateDuration(
                      currentDuration: currentDuration, hours: value);
                  widget.onChanged(currentDuration);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0, left: 12.0),
              child: Text(translate('recipe.fields.time.minutes')),
            ),
            Container(
              width: 50,
              child: IntegerTextFormField(
                enabled: !(widget.state is RecipeUpdateInProgress),
                initialValue: widget.duration != null
                    ? widget.duration.inMinutes % 60
                    : 0,
                maxValue: 60,
                decoration: InputDecoration(
                    hintText: translate('recipe.fields.time.minutes')),
                onChanged: (value) {
                  currentDuration = _updateDuration(
                      currentDuration: currentDuration, minutes: value);
                  widget.onChanged(currentDuration);
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  Duration _updateDuration(
      {@required Duration currentDuration, int hours, int minutes}) {
    if (hours != null) {
      int currentMinutes = 0;
      if (currentDuration != null) {
        currentMinutes = currentDuration.inMinutes % 60;
      }
      currentDuration = Duration(hours: hours, minutes: currentMinutes);
    }

    if (minutes != null) {
      int currentHours = 0;
      if (currentDuration != null) {
        currentHours = currentDuration.inHours;
      }
      currentDuration = Duration(hours: currentHours, minutes: minutes);
    }

    return currentDuration;
  }
}
