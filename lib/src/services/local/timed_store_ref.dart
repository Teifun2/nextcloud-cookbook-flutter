import 'package:nextcloud_cookbook_flutter/src/models/json_serializable.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';

class TimedStoreRef<T extends JsonSerializable> {
  final T value;
  final DateTime dateTime;

  TimedStoreRef(this.value) : dateTime = DateTime.now();

  TimedStoreRef.fromJson(Map<String, dynamic> json, T Function(String) parse)
      : value = parse(json['v']),
        dateTime = DateTime.parse(json['t']);

  Map<String, dynamic> toJson() {
    return {
      'v': value.toJson(),
      't': dateTime.toIso8601String(),
    };
  }

  bool needsUpdate() {
    var internet = true; // Represents a check if offline TBD

    // Generally update locally stored data all hour if connectivity is given.
    return internet &&
        (value == null || dateTime.difference(DateTime.now()).inHours > 1);
  }
}
