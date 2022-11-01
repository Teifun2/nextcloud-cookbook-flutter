import 'package:nextcloud_cookbook_flutter/src/models/json_serializable.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/services/net/connectivity_provider.dart';

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
    // Update locally stored data all hour if connectivity is given.
    return ConnectivityProvider.instance.connected() &&
        (value == null || dateTime.difference(DateTime.now()).inHours > 1);
  }
}
