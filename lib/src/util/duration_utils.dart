import 'package:flutter_translate/flutter_translate.dart';

extension DurationExtension on Duration {
  String get translatedString {
    return "$inHours ${translate('recipe.fields.time.hours')} : ${inMinutes.remainder(60)} ${translate('recipe.fields.time.minutes')}";
  }

  String formatMinutes() {
    return "$inHours:${inMinutes.remainder(60).toString().padLeft(2, '0')}";
  }

  String formatSeconds() {
    return "${inHours.toString().padLeft(2, '0')}:${inMinutes.remainder(60).toString().padLeft(2, '0')}:${(inSeconds.remainder(60)).toString().padLeft(2, '0')}";
  }
}
