extension DurationExtension on Duration {
  String formatMinutes() {
    return "$inHours:${inMinutes.remainder(60).toString().padLeft(2, '0')}";
  }

  String formatSeconds() {
    return "${inHours.toString().padLeft(2, '0')}:${inMinutes.remainder(60).toString().padLeft(2, '0')}:${(inSeconds.remainder(60)).toString().padLeft(2, '0')}";
  }
}
